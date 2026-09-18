import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'speak_button.dart';
import 'whole_word_text.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.spokenLines,
    this.utteranceKey,
    this.titleStyle,
    this.subtitleStyle,
    this.subtitleGap = 6,
    this.speakerSize = 32,
  });

  final String title;
  final String? subtitle;

  final List<String?>? spokenLines;

  final String? utteranceKey;

  final TextStyle? titleStyle;

  final TextStyle? subtitleStyle;

  final double subtitleGap;

  final double speakerSize;

  static const TextStyle defaultSubtitleStyle = TextStyle(
    fontSize: 17,
    height: 1.35,
    color: AppColors.muted,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: WholeWordText(
                title,
                style: titleStyle ?? Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SpeakButton.lines(
              lines: spokenLines ?? [title, subtitle],
              utteranceKey: utteranceKey ?? 'screen:$title',
              size: speakerSize,
            ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: subtitleGap),
          WholeWordText(
            subtitle!,
            style: subtitleStyle ?? defaultSubtitleStyle,
          ),
        ],
      ],
    );
  }
}
