import 'package:flutter/material.dart';

import 'speak_button.dart';
import 'whole_word_text.dart';

class SpokenText extends StatelessWidget {
  const SpokenText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.speakerSize = 30,
    this.extraSpokenLines = const [],
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double speakerSize;

  final List<String?> extraSpokenLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: WholeWordText(text, style: style, textAlign: textAlign),
          ),
        ),
        SpeakButton.lines(
          lines: [text, ...extraSpokenLines],
          size: speakerSize,
        ),
      ],
    );
  }
}
