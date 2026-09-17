import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/craft_type.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/tile_grid_metrics.dart';
import '../../widgets/whole_word_text.dart';
import '../onboarding/widgets/dictate_field.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/app_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _name = TextEditingController(
    text: context.read<AppState>().profile?.name ?? '',
  );
  late final _village = TextEditingController(
    text: context.read<AppState>().profile?.village ?? '',
  );
  late CraftType? _craft = context.read<AppState>().profile?.craft;
  late String? _photoPath = context.read<AppState>().profile?.photoPath;

  bool _saving = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _name.dispose();
    _village.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() => _photoPath = picked.path);
    } catch (_) {}
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    await state.updateProfile(
      name: _name.text.trim(),
      village: _village.text.trim(),
      craft: _craft,
      photoPath: _photoPath,
    );

    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.editProfileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language = context.select((AppState s) => s.language);

    return SettingsScaffold(
      title: l10n.editProfileTitle,
      busy: _saving,
      rows: [
        _PhotoField(
          path: _photoPath,
          onPick: _pickPhoto,
          onRemove: _photoPath == null
              ? null
              : () => setState(() => _photoPath = null),
        ),
        const SizedBox(height: 20),
        DictateField(
          controller: _name,
          label: l10n.profileNameLabel,
          hint: l10n.profileNameHint,
          language: language,
          errorText: _showErrors && _name.text.trim().isEmpty
              ? l10n.profileNameMissing
              : null,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 18),
        DictateField(
          controller: _village,
          label: l10n.profileVillageLabel,
          hint: l10n.editProfileVillageHint,
          language: language,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 22),
        WholeWordText(
          l10n.profileCraftLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        _CraftGrid(
          selected: _craft,
          onSelected: (craft) => setState(() => _craft = craft),
        ),
      ],
      actions: [
        BigActionButton(
          label: l10n.editProfileSave,
          icon: Icons.check,
          busy: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({
    required this.path,
    required this.onPick,
    required this.onRemove,
  });

  final String? path;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPhoto = path != null;
    final placeholder = Container(
      color: AppColors.terracotta.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 48, color: AppColors.terracotta),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: 92,
                height: 92,
                child: AppImage(
                  path,
                  decodeSize: 92,
                  fadeIn: false,
                  fallback: placeholder,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: onPick,
                    onLongPress: () => context.read<SpeechService>().speak(
                      l10n.editProfilePhotoWhy,
                      key: 'profile:photo',
                    ),
                    icon: const Icon(Icons.photo_camera, size: 24),
                    label: WholeWordText(
                      hasPhoto
                          ? l10n.editProfileChangePhoto
                          : l10n.editProfileAddPhoto,
                    ),
                  ),
                  if (onRemove != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                      ),
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline, size: 24),
                      label: WholeWordText(l10n.editProfileRemovePhoto),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        WholeWordText(
          l10n.editProfilePhotoWhy,
          style: const TextStyle(
            fontSize: 16,
            height: 1.35,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

class _CraftGrid extends StatelessWidget {
  const _CraftGrid({required this.selected, required this.onSelected});

  final CraftType? selected;
  final ValueChanged<CraftType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speech = context.read<SpeechService>();

    const spacing = 10.0;
    final metrics = TileGridMetrics.of(
      context,
      labels: [for (final craft in CraftType.values) craft.label(l10n)],
      width: MediaQuery.sizeOf(context).width - 2 * AppTheme.gutter,
      spacing: spacing,
      labelInset: 2 * 4 + 2 * 3,
      style: const TextStyle(
        fontSize: AppTheme.minTextSize,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
    final imageHeight = metrics.tileWidth * 0.8;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: metrics.columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: imageHeight + metrics.labelHeight + 2 * 6 + 2 * 3,
      ),
      itemCount: CraftType.values.length,
      itemBuilder: (context, index) {
        final craft = CraftType.values[index];
        final label = craft.label(l10n);
        final isSelected = craft == selected;

        return Semantics(
          button: true,
          selected: isSelected,
          label: label,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: () => onSelected(craft),
            onLongPress: () => speech.speak(label, key: 'craft:${craft.id}'),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.terracotta : AppColors.border,
                  width: isSelected ? 3 : 2,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radius - 2),
                      ),
                      child: Image.asset(
                        craft.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, _) => Container(
                          color: AppColors.cream,
                          alignment: Alignment.center,
                          child: Icon(
                            craft.icon,
                            size: 30,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: WholeWordText(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTheme.minTextSize,
                        height: 1.2,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
