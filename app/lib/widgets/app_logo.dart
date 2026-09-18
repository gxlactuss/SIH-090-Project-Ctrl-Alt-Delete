import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 132, this.voice = 1});

  final double size;

  final double voice;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _LogoPainter(voice: voice.clamp(0.0, 1.0)),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.voice});

  final double voice;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    canvas.drawCircle(
      const Offset(50, 50),
      50,
      Paint()..color = AppColors.terracotta,
    );

    final clay = Paint()..color = AppColors.cream;

    final body = Path()
      ..moveTo(42, 40)
      ..cubicTo(42, 47, 24, 50, 24, 64)
      ..cubicTo(24, 76, 36, 82, 50, 82)
      ..cubicTo(64, 82, 76, 76, 76, 64)
      ..cubicTo(76, 50, 58, 47, 58, 40)
      ..close();
    canvas.drawPath(body, clay);

    canvas.drawRRect(
      RRect.fromLTRBR(36, 34, 64, 41, const Radius.circular(3)),
      clay,
    );

    final band = Path()
      ..moveTo(27, 59)
      ..quadraticBezierTo(50, 67, 73, 59);
    canvas.drawPath(
      band,
      Paint()
        ..color = AppColors.marigold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round,
    );
    final dot = Paint()..color = AppColors.marigold;
    for (final x in const [39.0, 50.0, 61.0]) {
      canvas.drawCircle(Offset(x, x == 50 ? 72.5 : 71), 1.9, dot);
    }

    for (var i = 0; i < 2; i++) {
      final shown = (voice * 2 - i).clamp(0.0, 1.0);
      if (shown == 0) continue;
      final radius = 9.0 + 8.0 * i;
      final sweep = math.pi * 0.56 * shown;
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(50, 31), radius: radius),
        -math.pi / 2 - sweep / 2,
        sweep,
        false,
        Paint()
          ..color = AppColors.cream.withValues(alpha: shown)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.4
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => oldDelegate.voice != voice;
}
