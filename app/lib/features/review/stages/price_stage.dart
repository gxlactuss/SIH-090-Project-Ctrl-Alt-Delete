import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/review_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/animated_number.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/fade_in.dart';
import '../widgets/correction_sheet.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/info_panel.dart';

class PriceStage extends StatefulWidget {
  const PriceStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  State<PriceStage> createState() => _PriceStageState();
}

class _PriceStageState extends State<PriceStage> {
  int? _price;

  static const int _step = 1000;

  int _current(ReviewController review) =>
      _price ?? review.factSheet.priceInPaise ?? review.suggestedPriceInPaise;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final review = context.watch<ReviewController>();

    final price = _current(review);
    final floor = review.priceFloorInPaise;
    final belowFloor = review.isBelowFloor(price);
    final ceiling = (floor * ReviewConstants.sliderCeilingMultiplier)
        .round()
        .clamp(_step * 2, 10000000);

    final floorLine = l10n.priceFloor(Money.rupees(floor, locale));
    final bandLine = l10n.priceBand(
      Money.rupees(review.bandLowInPaise, locale),
      Money.rupees(review.bandHighInPaise, locale),
    );

    return ReviewScaffold(
      title: l10n.priceTitle,
      subtitle: l10n.priceBody,
      spokenLines: [
        l10n.priceTitle,
        Money.rupees(price, locale),
        floorLine,
        bandLine,
        if (belowFloor) l10n.priceBelowFloor,
      ],
      busy: review.isBusy,
      onBack: widget.onBack,
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onLongPress: () => context.read<SpeechService>().speak(
              Money.rupees(price, locale),
              key: 'price:$price',
            ),
            child: AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              padding: const EdgeInsets.symmetric(vertical: 26),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(
                  color: belowFloor ? AppColors.danger : AppColors.surface,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: AnimatedNumber(
                value: price,
                format: (value) => Money.rupees(value, locale),
                duration: AppMotion.fast,
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Slider(
            value: price.toDouble().clamp(0, ceiling.toDouble()),
            max: ceiling.toDouble(),
            divisions: (ceiling / _step).round().clamp(1, 400),
            label: Money.rupees(price, locale),
            onChanged: review.isBusy
                ? null
                : (value) =>
                      setState(() => _price = (value / _step).round() * _step),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final change in const [-5000, -1000, 1000, 5000])
                _NudgeButton(
                  label:
                      '${change < 0 ? '−' : '+'}'
                      '${Money.rupees(change.abs(), locale)}',
                  onPressed: review.isBusy || price + change < 0
                      ? null
                      : () => setState(() => _price = price + change),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 6),
          _FloorPanel(text: floorLine, explain: l10n.priceFloorExplain),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.storefront, size: 24, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: WholeWordText(
                  bandLine,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.3,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.medium),
            curve: AppMotion.standard,
            alignment: Alignment.topCenter,
            child: !belowFloor
                ? const SizedBox(width: double.infinity)
                : FadeIn(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: GestureDetector(
                        onLongPress: () => context.read<SpeechService>().speak(
                          l10n.priceBelowFloor,
                          key: 'price:below',
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.dangerTint,
                            border: Border.all(
                              color: AppColors.danger,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                size: 28,
                                color: AppColors.danger,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: WholeWordText(
                                  l10n.priceBelowFloor,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.35,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.priceConfirm,
          icon: Icons.check,
          busy: review.isBusy,
          onPressed: review.isBusy
              ? null
              : () async {
                  final saved = await review.setField(
                    ListingField.price,
                    price,
                  );
                  if (saved) review.next();
                },
        ),
        BigActionButton(
          label: l10n.priceSayIt,
          icon: Icons.mic,
          tone: ButtonTone.secondary,
          onPressed: review.isBusy
              ? null
              : () async {
                  await CorrectionSheet.show(context, ListingField.price);
                  if (!context.mounted) return;
                  setState(() => _price = null);
                },
        ),
      ],
    );
  }
}

class _NudgeButton extends StatelessWidget {
  const _NudgeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      onLongPress: onPressed == null
          ? null
          : () => context.read<SpeechService>().speak(
              label,
              key: 'price:nudge:$label',
            ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(76, AppTheme.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        foregroundColor: AppColors.terracotta,
        side: const BorderSide(color: AppColors.terracotta, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
      ),
      child: WholeWordText(
        label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FloorPanel extends StatelessWidget {
  const _FloorPanel({required this.text, required this.explain});

  final String text;
  final String explain;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(title: text, text: explain);
  }
}
