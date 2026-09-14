import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import 'whole_word_text.dart';

class HoldToSpeakButton extends StatelessWidget {
  const HoldToSpeakButton({
    super.key,
    required this.label,
    required this.recording,
    required this.onStart,
    required this.onStop,
  });

  final String label;
  final bool recording;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTapDown: (_) => onStart(),
        onTapUp: (_) => onStop(),
        onTapCancel: onStop,
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: recording ? AppColors.danger : AppColors.terracotta,
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                recording ? Icons.stop : Icons.mic,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(width: 14),
              Flexible(
                child: WholeWordText(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
