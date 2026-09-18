import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';

class FadeIn extends StatelessWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.duration = AppMotion.medium,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AppMotion.of(context, duration),
      curve: AppMotion.enter,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}

Widget imageFadeIn(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) {
  if (wasSynchronouslyLoaded) return child;
  return AnimatedOpacity(
    opacity: frame == null ? 0 : 1,
    duration: AppMotion.of(context, AppMotion.medium),
    curve: AppMotion.enter,
    child: child,
  );
}
