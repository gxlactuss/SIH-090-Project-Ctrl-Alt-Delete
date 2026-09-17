import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../services/speech_service.dart';
import 'whole_word_text.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBackspaceLong,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  final VoidCallback? onBackspaceLong;

  final bool enabled;

  static const TextStyle _digitStyle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    final digit = TextPainter(
      text: TextSpan(
        text: '0',
        style: DefaultTextStyle.of(context).style.merge(_digitStyle),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final keyHeight = math.max(52.0, digit.height + 8);
    digit.dispose();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Row(
            children: [
              for (final digit in row)
                Expanded(
                  child: _Key(digit: digit, pad: this, height: keyHeight),
                ),
            ],
          ),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            Expanded(
              child: _Key(digit: '0', pad: this, height: keyHeight),
            ),
            Expanded(
              child: _PadCell(
                height: keyHeight,
                onTap: enabled ? onBackspace : null,
                onLongPress: enabled ? onBackspaceLong : null,
                semanticsLabel: MaterialLocalizations.of(context)
                    .deleteButtonTooltip,
                child: const Icon(
                  Icons.backspace_outlined,
                  size: 32,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.digit, required this.pad, required this.height});

  final String digit;
  final NumberPad pad;
  final double height;

  @override
  Widget build(BuildContext context) {
    final speech = context.read<SpeechService>();
    return _PadCell(
      height: height,
      onTap: pad.enabled ? () => pad.onDigit(digit) : null,
      onLongPress: () => speech.speak(digit, key: 'digit:$digit'),
      semanticsLabel: digit,
      child: WholeWordText(digit, style: NumberPad._digitStyle),
    );
  }
}

class _PadCell extends StatelessWidget {
  const _PadCell({
    required this.child,
    required this.height,
    required this.onTap,
    required this.semanticsLabel,
    this.onLongPress,
  });

  final Widget child;

  final double height;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Container(
              height: height,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
