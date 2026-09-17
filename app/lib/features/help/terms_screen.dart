import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/speak_button.dart';
import '../profile/widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final summary = [
      l10n.termsSummary1,
      l10n.termsSummary2,
      l10n.termsSummary3,
      l10n.termsSummary4,
      l10n.termsSummary5,
    ];

    return SettingsScaffold(
      title: l10n.termsTitle,
      spokenLines: [l10n.termsSummaryTitle, ...summary],
      rows: [
        Row(
          children: [
            Expanded(
              child: WholeWordText(
                l10n.termsSummaryTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SpeakButton.lines(
              lines: [l10n.termsSummaryTitle, ...summary],
              utteranceKey: 'terms:summary',
              size: 32,
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final line in summary) ...[
          TermsPoint(text: line),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        WholeWordText(
          l10n.termsFullTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        WholeWordText(
          l10n.termsFullBody,
          style: const TextStyle(
            fontSize: 17,
            height: 1.45,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

class TermsPoint extends StatelessWidget {
  const TermsPoint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 26,
            color: AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WholeWordText(
              text,
              style: const TextStyle(
                fontSize: 18,
                height: 1.45,
                color: AppColors.ink,
              ),
            ),
          ),
          SpeakButton(text: text, size: 28),
        ],
      ),
    );
  }
}
