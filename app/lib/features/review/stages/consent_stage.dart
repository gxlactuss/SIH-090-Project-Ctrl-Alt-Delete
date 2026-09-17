import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../../onboarding/ondc_screen.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class ConsentStage extends StatefulWidget {
  const ConsentStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  State<ConsentStage> createState() => _ConsentStageState();
}

class _ConsentStageState extends State<ConsentStage> {
  late bool _photo = context.read<ReviewController>().listing.photoConsent;
  late bool _story = context.read<ReviewController>().listing.storyConsent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();

    return ReviewScaffold(
      title: l10n.consentTitle,
      spokenLines: [
        l10n.consentTitle,
        l10n.consentPhoto,
        l10n.consentPhotoExplain,
        l10n.consentStory,
        l10n.consentStoryExplain,
      ],
      busy: review.isBusy,
      onBack: widget.onBack,
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ConsentSwitch(
            label: l10n.consentPhoto,
            explain: l10n.consentPhotoExplain,
            value: _photo,
            onChanged: (value) => setState(() => _photo = value),
          ),
          const SizedBox(height: 14),
          _ConsentSwitch(
            label: l10n.consentStory,
            explain: l10n.consentStoryExplain,
            value: _story,
            onChanged: (value) => setState(() => _story = value),
          ),
          if (!_photo) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 26,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WholeWordText(
                    l10n.consentNeeded,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.35,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.consentPublish,
          icon: Icons.storefront,
          busy: review.isBusy,
          onPressed: !_photo || review.isBusy
              ? null
              : () async {
                  await OndcScreen.askBeforeFirstPublish(context);
                  if (!context.mounted) return;
                  review.goTo(ReviewStage.publishing);
                  review.publish(photoConsent: _photo, storyConsent: _story);
                },
          spokenLabel: '${l10n.consentPublish}. ${l10n.consentPhotoExplain}',
        ),
      ],
    );
  }
}

class _ConsentSwitch extends StatelessWidget {
  const _ConsentSwitch({
    required this.label,
    required this.explain,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String explain;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: '$label. $explain',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(!value);
        },
        onLongPress: () => context.read<SpeechService>().speakAll([
          label,
          explain,
        ], key: 'consent:$label'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: value ? AppColors.success : AppColors.border,
              width: value ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                value ? Icons.check_box : Icons.check_box_outline_blank,
                size: 36,
                color: value ? AppColors.success : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholeWordText(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    WholeWordText(
                      explain,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              SpeakButton.lines(lines: [label, explain], size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
