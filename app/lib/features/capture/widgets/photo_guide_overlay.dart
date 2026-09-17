import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/whole_word_text.dart';

class PhotoGuideOverlay extends StatelessWidget {
  const PhotoGuideOverlay({
    super.key,
    required this.step,
    required this.prompt,
  });

  final String step;

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.marigold, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.ink.withValues(alpha: 0.55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  WholeWordText(
                    step,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.marigold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  WholeWordText(
                    prompt,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
