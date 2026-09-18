import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static bool enabled = true;

  static const tick = Duration(milliseconds: 120);

  static const fast = Duration(milliseconds: 180);

  static const medium = Duration(milliseconds: 260);

  static const slow = Duration(milliseconds: 450);

  static const celebrate = Duration(milliseconds: 720);

  static const intro = Duration(milliseconds: 900);

  static const pulse = Duration(milliseconds: 900);

  static const breathe = Duration(milliseconds: 1400);

  static const Curve standard = Curves.easeOutCubic;

  static const Curve standardExit = Curves.easeInCubic;

  static const Curve enter = Curves.easeOut;

  static const Curve exit = Curves.easeIn;

  static const Curve inOut = Curves.easeInOut;

  static const Curve overshoot = Curves.easeOutBack;

  static bool reduced(BuildContext context) =>
      !enabled || (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
