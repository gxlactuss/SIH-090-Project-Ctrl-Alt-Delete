import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/listing_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/storage_service.dart';
import '../../state/queue_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/settings_scaffold.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key, this.storage});

  final StorageService? storage;

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  late final StorageService _storage = widget.storage ?? StorageService();

  int? _bytes;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _measure();
  }

  Future<void> _measure() async {
    final bytes = await _storage.capturedBytes();
    if (mounted) setState(() => _bytes = bytes);
  }

  Future<void> _clear() async {
    final l10n = AppLocalizations.of(context);
    final queue = context.read<QueueController>();
    final listings = context.read<ListingRepository>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _clearing = true);

    final keep = {
      for (final item in queue.items)
        if (item.isPending) item.id,
    };
    final freed = await _storage.clearUploaded(keepIds: keep);
    await listings.clearCache();

    if (!mounted) return;
    setState(() => _clearing = false);
    await _measure();
    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: WholeWordText(
          freed == 0
              ? l10n.storageNothingToClear
              : l10n.storageCleared(StorageService.formatBytes(freed)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = context.select((QueueController q) => q.pendingCount);
    final size = _bytes == null ? '…' : StorageService.formatBytes(_bytes!);

    return SettingsScaffold(
      title: l10n.storageTitle,
      busy: _bytes == null || _clearing,
      spokenLines: [
        l10n.storageTitle,
        '${l10n.storagePhotos}: $size',
        l10n.storageWaiting(pending),
      ],
      rows: [
        _Row(
          icon: Icons.photo_library_outlined,
          label: l10n.storagePhotos,
          value: size,
        ),
        _Row(
          icon: Icons.cloud_upload_outlined,
          label: l10n.storageWaiting(pending),
          value: null,
          tone: pending > 0 ? AppColors.terracotta : AppColors.muted,
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 24, color: AppColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: WholeWordText(
                l10n.storageClearWhy,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: AppColors.muted,
                ),
              ),
            ),
            SpeakButton(text: l10n.storageClearWhy, size: 28),
          ],
        ),
      ],
      actions: [
        BigActionButton(
          label: l10n.storageClear,
          icon: Icons.cleaning_services_outlined,
          busy: _clearing,
          onPressed: _clearing ? null : _clear,
          spokenLabel: '${l10n.storageClear}. ${l10n.storageClearWhy}',
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.tone,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: tone ?? AppColors.muted),
          const SizedBox(width: 14),
          Expanded(
            child: WholeWordText(
              label,
              style: TextStyle(
                fontSize: 18,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: tone ?? AppColors.ink,
              ),
            ),
          ),
          if (value != null)
            WholeWordText(
              value!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
        ],
      ),
    );
  }
}
