import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';
import 'whole_word_text.dart';

class AnimatedNumber extends StatelessWidget {
  const AnimatedNumber({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = AppMotion.slow,
  });

  final int value;
  final String Function(int value) format;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: format(value),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: value.toDouble()),
        duration: AppMotion.of(context, duration),
        curve: AppMotion.standard,
        builder: (context, current, _) =>
            WholeWordText(format(current.round()), style: style),
      ),
    );
  }
}

class SwapNumber extends StatelessWidget {
  const SwapNumber({super.key, required this.value, this.style});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.fast),
      switchInCurve: AppMotion.overshoot,
      switchOutCurve: AppMotion.exit,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: WholeWordText('$value', key: ValueKey(value), style: style),
    );
  }
}
