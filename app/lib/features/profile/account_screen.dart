import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/di.dart';
import '../../data/remote/api_client.dart';
import '../../data/remote/backend_session.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/listing_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/catalog_controller.dart';
import '../../state/queue_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/info_panel.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/api_problem_text.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _busy = false;

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.accountSignOutTitle,
      body: l10n.accountSignOutBody,
      confirm: l10n.accountSignOutConfirm,
      cancel: l10n.accountSignOutCancel,
    );
    if (!confirmed || !mounted) return;
    await _wipe();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.accountDeleteTitle,
      body: l10n.accountDeleteBody,
      confirm: l10n.accountDeleteConfirm,
      cancel: l10n.accountDeleteCancel,
    );
    if (!confirmed || !mounted) return;

    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);

    try {
      await api.deleteAccount();
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(content: WholeWordText(errorMessage(error, l10n))),
      );
      return;
    }

    if (!mounted) return;
    await _wipe();
  }

  Future<void> _wipe() async {
    final state = context.read<AppState>();
    final queue = context.read<QueueController>();
    final catalog = context.read<CatalogController>();
    final listings = context.read<ListingRepository>();
    final session = context.maybeRead<BackendSession>();
    final navigator = Navigator.of(context);

    setState(() => _busy = true);

    for (final item in queue.items) {
      await queue.remove(item.id);
    }
    catalog.clear();
    await listings.clearCache();
    await session?.clear();
    await AuthRepository().signOut();
    await state.signOut();

    if (!mounted) return;
    navigator.pushNamedAndRemoveUntil(AppRoutes.splash, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = context.select((QueueController q) => q.pendingCount);

    return SettingsScaffold(
      title: l10n.accountTitle,
      busy: _busy,
      rows: [
        if (pending > 0)
          InfoPanel(
            icon: Icons.warning_amber,
            text: l10n.storageWaiting(pending),
            emphasized: true,
            margin: const EdgeInsets.only(bottom: 16),
          ),
      ],
      actions: [
        BigActionButton(
          label: l10n.accountSignOut,
          icon: Icons.logout,
          tone: ButtonTone.secondary,
          busy: _busy,
          onPressed: _busy ? null : _signOut,
          spokenLabel: '${l10n.accountSignOut}. ${l10n.accountSignOutBody}',
        ),
        _HoldToDelete(
          label: l10n.accountDelete,
          hint: l10n.accountDeleteHold,
          enabled: !_busy,
          onHeld: _delete,
        ),
      ],
    );
  }
}

class _HoldToDelete extends StatelessWidget {
  const _HoldToDelete({
    required this.label,
    required this.hint,
    required this.enabled,
    required this.onHeld,
  });

  final String label;
  final String hint;
  final bool enabled;
  final VoidCallback onHeld;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: '$label. $hint',
          child: GestureDetector(
            onLongPress: enabled ? onHeld : null,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppTheme.minTapTarget,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.danger, width: 2),
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_forever,
                    size: 28,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: WholeWordText(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        WholeWordText(
          hint,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppTheme.minTextSize,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
