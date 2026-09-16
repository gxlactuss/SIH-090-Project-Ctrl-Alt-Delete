import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class SuggestionsStage extends StatelessWidget {
  const SuggestionsStage({
    super.key,
    required this.onClose,
    required this.onBack,
  });

  final VoidCallback onClose;
  final VoidCallback onBack;

  Future<void> _finish(BuildContext context) async {
    final review = context.read<ReviewController>();
    await review.submitSuggestions();
    review.next();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final suggestion = review.nextSuggestion;
    final total = review.suggestions.length;

    if (suggestion == null) {
      return ReviewScaffold(
        title: l10n.suggestDone,
        busy: review.isBusy,
        onBack: onBack,
        onClose: onClose,
        body: const SizedBox.shrink(),
        actions: [
          BigActionButton(
            label: l10n.readBackApprove,
            icon: Icons.check,
            busy: review.isBusy,
            onPressed: review.isBusy ? null : () => _finish(context),
          ),
        ],
      );
    }

    final answered = review.answeredSuggestions;

    return ReviewScaffold(
      title: l10n.suggestTitle,
      spokenLines: [l10n.suggestTitle, suggestion.spokenPrompt],
      busy: review.isBusy,
      onBack: onBack,
      onClose: onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressDots(total: total, done: answered),
          const SizedBox(height: 8),
          WholeWordText(
            l10n.suggestProgress(answered + 1, total),
            style: const TextStyle(fontSize: 16, color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WholeWordText(
                    suggestion.spokenPrompt,
                    style: const TextStyle(
                      fontSize: 23,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                SpeakButton(
                  text: suggestion.spokenPrompt,
                  utteranceKey: 'suggestion:${suggestion.id}',
                  size: 34,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.suggestYes,
          icon: Icons.check,
          onPressed: review.isBusy
              ? null
              : () => review.answerSuggestion(suggestion.id, true),
        ),
        BigActionButton(
          label: l10n.suggestNo,
          icon: Icons.close,
          tone: ButtonTone.secondary,
          onPressed: review.isBusy
              ? null
              : () => review.answerSuggestion(suggestion.id, false),
        ),
        TextButton(
          onPressed: review.isBusy
              ? null
              : () => review.skipSuggestion(suggestion.id),
          child: WholeWordText(l10n.suggestSkip),
        ),
      ],
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.total, required this.done});

  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          Container(
            width: i == done ? 18 : 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: i < done
                  ? AppColors.terracotta
                  : (i == done ? AppColors.marigold : AppColors.border),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
      ],
    );
  }
}
