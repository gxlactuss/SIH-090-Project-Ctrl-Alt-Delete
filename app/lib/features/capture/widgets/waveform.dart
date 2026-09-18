import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';

class Waveform extends StatelessWidget {
  const Waveform({
    super.key,
    required this.level,
    required this.active,
    this.bars = 21,
  });

  final double level;

  final bool active;
  final int bars;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < bars; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.tick),
                width: 6,
                height: active ? _height(i) : 8,
                decoration: BoxDecoration(
                  color: active ? AppColors.terracotta : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _height(int index) {
    final centre = (bars - 1) / 2;
    final distance = (index - centre).abs() / centre;
    final shape = 1.0 - (distance * distance) * 0.75;
    return (8 + level * 66 * shape).clamp(8.0, 76.0);
  }
}
