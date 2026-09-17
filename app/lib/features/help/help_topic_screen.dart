import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import '../profile/widgets/settings_scaffold.dart';
import 'help_content.dart';

class HelpTopicScreen extends StatelessWidget {
  const HelpTopicScreen({super.key, required this.topic});

  final HelpTopic topic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = topic.steps(l10n);

    return SettingsScaffold(
      title: topic.title(l10n),
      subtitle: topic.body(l10n),
      spokenLines: topic.spoken(l10n),
      rows: [
        WholeWordText(
          l10n.helpSteps,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++) ...[
          _Step(number: i + 1, text: steps[i]),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
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
          Container(
            width: MediaQuery.textScalerOf(context).scale(34),
            height: MediaQuery.textScalerOf(context).scale(34),
            decoration: const BoxDecoration(
              color: AppColors.terracotta,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: WholeWordText(
              '$number',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WholeWordText(
              text,
              style: const TextStyle(
                fontSize: 18,
                height: 1.4,
                color: AppColors.ink,
              ),
            ),
          ),
          SpeakButton(text: text, utteranceKey: 'step:$number', size: 28),
        ],
      ),
    );
  }
}
