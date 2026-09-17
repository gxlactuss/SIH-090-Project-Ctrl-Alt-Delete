import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../widgets/field_card.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/app_image.dart';

class PreviewStage extends StatelessWidget {
  const PreviewStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final review = context.watch<ReviewController>();
    final listing = review.listing;
    final sheet = listing.factSheet;

    final price = sheet.priceInPaise;
    final priceText = price == null ? null : Money.rupees(price, locale);
    final description = listing.description?.trim();

    final spoken = <String?>[
      listing.title,
      priceText,
      description?.isNotEmpty == true ? description : l10n.previewNoDescription,
      for (final field in review.fields)
        if (sheet.value(field) != null)
          '${field.label(l10n)}: '
              '${FieldCard.valueText(context, field, sheet)}',
    ];

    return ReviewScaffold(
      title: l10n.previewTitle,
      spokenLines: [l10n.previewTitle, ...spoken],
      busy: review.isBusy,
      onBack: onBack,
      onClose: onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (listing.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radius),
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: AppImage(
                        listing.imageUrls.first,
                        decodeSize: MediaQuery.sizeOf(context).width,
                        fallback: const ImageFallback(iconSize: 40),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (listing.title != null)
                        WholeWordText(
                          listing.title!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      if (priceText != null) ...[
                        const SizedBox(height: 6),
                        WholeWordText(
                          priceText,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.terracotta,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      WholeWordText(
                        description?.isNotEmpty == true
                            ? description!
                            : l10n.previewNoDescription,
                        style: const TextStyle(
                          fontSize: 19,
                          height: 1.45,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final field in review.fields)
                        if (sheet.value(field) != null &&
                            field != ListingField.price)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: WholeWordText(
                                    field.label(l10n),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: WholeWordText(
                                    FieldCard.valueText(context, field, sheet)!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: WholeWordText(
                  l10n.previewListenAll,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.terracotta,
                  ),
                ),
              ),
              SpeakButton.lines(
                lines: spoken,
                utteranceKey: 'preview:all',
                size: 36,
              ),
            ],
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: review.isEdit
              ? l10n.editRepublishConfirm
              : l10n.previewConfirm,
          icon: review.isEdit ? Icons.storefront : Icons.check,
          busy: review.isBusy,
          onPressed: review.isBusy ? null : review.next,
        ),
        BigActionButton(
          label: l10n.previewChange,
          icon: Icons.edit,
          tone: ButtonTone.secondary,
          onPressed: review.isBusy
              ? null
              : () => review.goTo(ReviewStage.readBack),
        ),
      ],
    );
  }
}
