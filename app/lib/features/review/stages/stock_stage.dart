import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/animated_number.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class StockStage extends StatefulWidget {
  const StockStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  State<StockStage> createState() => _StockStageState();
}

class _StockStageState extends State<StockStage> {
  int? _quantity;
  bool? _oneOfAKind;

  int _current(ReviewController review) =>
      _quantity ?? review.factSheet.quantity ?? 1;

  bool _unique(ReviewController review) =>
      _oneOfAKind ?? review.factSheet.isOneOfAKind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final quantity = _current(review);
    final unique = _unique(review);

    return ReviewScaffold(
      title: l10n.stockTitle,
      subtitle: l10n.stockBody,
      spokenLines: [l10n.stockTitle, '$quantity', l10n.stockBody],
      busy: review.isBusy,
      onBack: widget.onBack,
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  label: l10n.stockLess,
                  onPressed: unique || quantity <= 1
                      ? null
                      : () => setState(() => _quantity = quantity - 1),
                ),
                SwapNumber(
                  value: quantity,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  label: l10n.stockMore,
                  onPressed: unique
                      ? null
                      : () => setState(() => _quantity = quantity + 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _UniqueToggle(
            value: unique,
            onChanged: (value) => setState(() {
              _oneOfAKind = value;
              if (value) _quantity = 1;
            }),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.stockConfirm,
          icon: Icons.check,
          busy: review.isBusy,
          onPressed: review.isBusy
              ? null
              : () async {
                  final saved = unique
                      ? await review.setOneOfAKind(true)
                      : await review.setField(ListingField.quantity, quantity);
                  if (saved) review.next();
                },
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 96,
        height: 96,
        child: Material(
          color: onPressed == null
              ? AppColors.border
              : AppColors.terracotta.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: onPressed == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  },
            onLongPress: () =>
                context.read<SpeechService>().speak(label, key: 'stock:$label'),
            child: Icon(
              icon,
              size: 46,
              color: onPressed == null ? AppColors.muted : AppColors.terracotta,
            ),
          ),
        ),
      ),
    );
  }
}

class _UniqueToggle extends StatelessWidget {
  const _UniqueToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => onChanged(!value),
      onLongPress: () => context.read<SpeechService>().speak(
        l10n.stockOneOfAKind,
        key: 'stock:unique',
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: value ? AppColors.terracotta : AppColors.border,
            width: value ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 34,
              color: value ? AppColors.terracotta : AppColors.muted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WholeWordText(
                l10n.stockOneOfAKind,
                style: const TextStyle(
                  fontSize: 19,
                  height: 1.3,
                  color: AppColors.ink,
                ),
              ),
            ),
            SpeakButton(text: l10n.stockOneOfAKind, size: 30),
          ],
        ),
      ),
    );
  }
}
