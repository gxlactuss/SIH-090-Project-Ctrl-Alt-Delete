import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../widgets/speak_button.dart';
import '../profile/widgets/settings_scaffold.dart';
import 'help_content.dart';
import '../../widgets/whole_word_text.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsScaffold(
      title: l10n.helpTitle,
      subtitle: l10n.helpBody,
      rows: [
        for (final topic in HelpTopic.values)
          _TopicRow(
            topic: topic,
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.helpTopic, arguments: topic.name),
          ),
        const SizedBox(height: 18),
        _PracticeCard(),
        const SizedBox(height: 18),
        SettingsRow(
          icon: Icons.help_outline,
          label: l10n.helpFaqEntry,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
        ),
        SettingsRow(
          icon: Icons.support_agent,
          label: l10n.helpSupportEntry,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.support),
        ),
        SettingsRow(
          icon: Icons.info_outline,
          label: l10n.helpAboutEntry,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
        ),
      ],
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.topic, required this.onTap});

  final HelpTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = topic.title(l10n);

    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () => context.read<SpeechService>().speakAll(
          topic.spoken(l10n),
          key: 'help:${topic.name}',
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              Icon(topic.icon, size: 30, color: AppColors.terracotta),
              const SizedBox(width: 14),
              Expanded(
                child: WholeWordText(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              SpeakButton.lines(
                lines: topic.spoken(l10n),
                utteranceKey: 'help:${topic.name}',
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: '${l10n.helpPractice}. ${l10n.helpPracticeBody}',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.practiceReplay),
        onLongPress: () => context.read<SpeechService>().speakAll([
          l10n.helpPractice,
          l10n.helpPracticeBody,
        ], key: 'help:practice'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warningTint,
            border: Border.all(color: AppColors.marigold, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              const Icon(Icons.school_outlined, size: 32, color: AppColors.ink),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholeWordText(
                      l10n.helpPractice,
                      style: const TextStyle(
                        fontSize: 19,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    WholeWordText(
                      l10n.helpPracticeBody,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              SpeakButton.lines(
                lines: [l10n.helpPractice, l10n.helpPracticeBody],
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
