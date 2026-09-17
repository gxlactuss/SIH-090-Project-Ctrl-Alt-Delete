import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../widgets/correction_sheet.dart';
import '../widgets/field_card.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class ReadBackStage extends StatelessWidget {
  const ReadBackStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final listing = review.listing;
    final description = listing.description?.trim();

    final spoken = <String?>[
      l10n.readBackTitle,
      description,
      for (final field in review.fields)
        '${field.label(l10n)}: '
            '${FieldCard.valueText(context, field, listing.factSheet) ?? l10n.notSaid}',
    ];

    return ReviewScaffold(
      title: l10n.readBackTitle,
      spokenLines: spoken,
      busy: review.isBusy,
      onBack: onBack,
      onClose: onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WholeWordText(
                  description?.isNotEmpty == true
                      ? description!
                      : l10n.previewNoDescription,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.45,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: WholeWordText(
                        l10n.readBackListen,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                    SpeakButton.lines(
                      lines: spoken,
                      utteranceKey: 'readback:all',
                      size: 34,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          WholeWordText(
            l10n.readBackFields,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onLongPress: () => context.read<SpeechService>().speak(
              l10n.readBackCorrect,
              key: 'readback:correct',
            ),
            child: WholeWordText(
              l10n.readBackCorrect,
              style: const TextStyle(fontSize: 16, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 12),
          for (final field in review.fields) ...[
            FieldCard(
              field: field,
              factSheet: listing.factSheet,
              onTap: () => CorrectionSheet.show(context, field),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.readBackApprove,
          icon: Icons.check,
          busy: review.isBusy,
          onPressed: review.isBusy ? null : review.next,
        ),
      ],
    );
  }
}
