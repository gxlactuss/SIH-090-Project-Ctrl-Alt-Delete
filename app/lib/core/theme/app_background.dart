import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cream,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(painter: _CurlPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class PatternedPageTransitionsBuilder extends PageTransitionsBuilder {
  const PatternedPageTransitionsBuilder();

  static const _platform = PageTransitionsTheme();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _platform.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      AppBackground(child: child),
    );
  }
}

class _CurlPainter extends CustomPainter {
  const _CurlPainter();

  static const _designWidth = 943.0;

  static const _curl = AppColors.marigold;

  @override
  void paint(Canvas canvas, Size size) {
    final k = math.min(size.width, 600) / _designWidth;

    final rings = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, 2.5 * k)
      ..color = AppColors.border.withValues(alpha: 0.45);
    final centre = size.center(Offset.zero);
    for (final r in const [175.0, 112.0, 50.0]) {
      canvas.drawCircle(centre, r * k, rings);
    }

    canvas.save();
    canvas.scale(k);
    _corner(canvas, k);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(math.pi);
    canvas.scale(k);
    _corner(canvas, k);
    canvas.restore();
  }

  void _corner(Canvas canvas, double k) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(4, 1.5 / k)
      ..color = _curl.withValues(alpha: 0.38);
    final thin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(2.5, 1 / k)
      ..color = _curl.withValues(alpha: 0.26);
    final fill = Paint()..color = _curl.withValues(alpha: 0.2);

    canvas.drawPath(
      Path()
        ..moveTo(-10, 20)
        ..cubicTo(90, -15, 200, 40, 205, 150)
        ..cubicTo(210, 240, 130, 275, 90, 260)
        ..cubicTo(30, 245, 5, 190, 25, 150)
        ..cubicTo(45, 105, 110, 100, 122, 145)
        ..cubicTo(128, 165, 120, 178, 112, 190),
      stroke,
    );

    canvas.drawPath(
      Path()
        ..moveTo(222, 95)
        ..cubicTo(195, 80, 165, 100, 172, 140)
        ..cubicTo(180, 190, 250, 205, 295, 180)
        ..cubicTo(335, 155, 340, 80, 310, 40)
        ..cubicTo(290, 15, 265, 0, 250, -5),
      stroke,
    );

    canvas.drawPath(
      Path()
        ..moveTo(95, 10)
        ..cubicTo(125, 40, 142, 80, 137, 130),
      thin,
    );

    canvas.drawCircle(const Offset(48, 22), 40, thin);
    canvas.drawCircle(const Offset(48, 22), 22, thin);
    canvas.drawCircle(const Offset(112, 132), 15, fill);

    for (final dot in const [Offset(3, 295), Offset(37, 320), Offset(74, 295)]) {
      canvas.drawCircle(dot, 7, fill);
    }
  }

  @override
  bool shouldRepaint(_CurlPainter oldDelegate) => false;
}
