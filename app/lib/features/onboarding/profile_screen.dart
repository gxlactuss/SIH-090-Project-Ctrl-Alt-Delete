import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/craft_type.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/onboarding_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/tile_grid_metrics.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/dictate_field.dart';
import 'widgets/onboarding_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();

  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final onboarding = context.read<OnboardingController>();
    _name.text = onboarding.name;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _continue() {
    final onboarding = context.read<OnboardingController>();
    onboarding.setName(_name.text);

    final valid = _name.text.trim().isNotEmpty && onboarding.craft != null;

    if (!valid) {
      setState(() => _showErrors = true);
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.ondc);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboarding = context.watch<OnboardingController>();

    return OnboardingScaffold(
      step: 8,
      title: l10n.profileTitle,
      spokenLines: [
        l10n.profileTitle,
        l10n.profileNameLabel,
        l10n.profileCraftLabel,
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DictateField(
            controller: _name,
            label: l10n.profileNameLabel,
            hint: l10n.profileNameHint,
            language: onboarding.language,
            errorText: _showErrors && _name.text.trim().isEmpty
                ? l10n.profileNameMissing
                : null,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 28),
          WholeWordText(
            l10n.profileCraftLabel,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          if (_showErrors && onboarding.craft == null) ...[
            const SizedBox(height: 6),
            WholeWordText(
              l10n.profileCraftMissing,
              style: const TextStyle(color: AppColors.danger, fontSize: 17),
            ),
          ],
          const SizedBox(height: 12),
          _CraftGrid(
            selected: onboarding.craft,
            onSelected: (craft) {
              onboarding.setCraft(craft);
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.actionNext,
          icon: Icons.arrow_forward,
          onPressed: _continue,
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

    const spacing = 12.0;
    final metrics = TileGridMetrics.of(
      context,
      labels: [for (final craft in CraftType.values) craft.label(l10n)],
      width: MediaQuery.sizeOf(context).width - 2 * AppTheme.gutter,
      spacing: spacing,
      labelInset: 2 * 6 + 2 * 4,
      style: const TextStyle(
        fontSize: AppTheme.minTextSize,
        fontWeight: FontWeight.w700,
      ),
    );
    final labelBlock = metrics.labelHeight + 4 + 8;
    final squareish = metrics.tileWidth / 0.92;
    final withPhoto = labelBlock + metrics.tileWidth * 0.5;
    final extent = squareish > withPhoto ? squareish : withPhoto;
    final darkFrom = ((extent - labelBlock) / extent).clamp(0.0, 0.6);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: metrics.columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        mainAxisExtent: extent,
      ),
      itemCount: CraftType.values.length,
      itemBuilder: (context, i) {
        final craft = CraftType.values[i];
        final label = craft.label(l10n);
        final isSelected = craft == selected;

        return Semantics(
          button: true,
          selected: isSelected,
          label: label,
          excludeSemantics: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Material(
              color: AppColors.surface,
              child: InkWell(
                onTap: () => onSelected(craft),
                onLongPress: () =>
                    speech.speak(label, key: 'craft:${craft.id}'),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      craft.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Center(
                        child: Icon(
                          craft.icon,
                          size: 38,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color(0x00000000),
                            Color(0x40000000),
                            Color(0xD9000000),
                          ],
                          stops: [
                            (darkFrom - 0.25).clamp(0.0, 0.35),
                            darkFrom,
                            1,
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
                        child: WholeWordText(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: AppTheme.minTextSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 4, color: Color(0xCC000000)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.terracotta,
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.terracotta
                                : AppColors.border,
                            width: isSelected ? 4 : 2,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radius),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
