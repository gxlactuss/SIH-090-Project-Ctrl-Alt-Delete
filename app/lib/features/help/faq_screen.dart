import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../widgets/fade_in.dart';
import '../../widgets/speak_button.dart';
import '../profile/widgets/settings_scaffold.dart';
import 'help_content.dart';
import '../../widgets/whole_word_text.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questions = faqs(l10n);

    return SettingsScaffold(
      title: l10n.faqTitle,
      spokenLines: [
        l10n.faqTitle,
        for (final entry in questions) entry.question,
      ],
      rows: [
        for (var i = 0; i < questions.length; i++) ...[
          _Question(
            question: questions[i].question,
            answer: questions[i].answer,
            open: _open == i,
            onTap: () => setState(() => _open = _open == i ? null : i),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _Question extends StatelessWidget {
  const _Question({
    required this.question,
    required this.answer,
    required this.open,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      expanded: open,
      label: question,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () => context.read<SpeechService>().speakAll([
          question,
          answer,
        ], key: 'faq:$question'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: open ? AppColors.terracotta : AppColors.border,
              width: open ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: AnimatedSize(
            duration: AppMotion.of(context, AppMotion.medium),
            curve: AppMotion.standard,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      open ? Icons.expand_less : Icons.expand_more,
                      size: 28,
                      color: open ? AppColors.terracotta : AppColors.muted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: WholeWordText(
                        question,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                          color: open ? AppColors.terracotta : AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
                if (open) ...[
                  const SizedBox(height: 10),
                  FadeIn(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WholeWordText(
                            answer,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.45,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        SpeakButton.lines(
                          lines: [question, answer],
                          utteranceKey: 'faq:$question',
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
