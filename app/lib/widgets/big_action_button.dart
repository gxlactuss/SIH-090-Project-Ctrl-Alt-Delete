import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../services/speech_service.dart';
import 'whole_word_text.dart';

enum ButtonTone { primary, secondary, danger, delete }

class BigActionButton extends StatelessWidget {
  const BigActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tone = ButtonTone.primary,
    this.spokenLabel,
    this.busy = false,
  });

  final String label;
  final IconData icon;

  final VoidCallback? onPressed;

  final ButtonTone tone;

  final String? spokenLabel;

  final bool busy;

  static final _forwardIcons = {
    Icons.check,
    Icons.arrow_forward,
    Icons.play_arrow,
  };

  static final _goStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? null
          : states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)
          ? AppColors.successPressed
          : AppColors.success,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final speech = context.read<SpeechService>();
    final spoken = spokenLabel ?? label;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (busy)
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 3),
          )
        else
          Icon(icon, size: 30),
        const SizedBox(width: 14),
        Flexible(child: WholeWordText(label, textAlign: TextAlign.center)),
      ],
    );

    final Widget button = switch (tone) {
      ButtonTone.primary when _forwardIcons.contains(icon) => FilledButton(
        onPressed: busy ? null : onPressed,
        style: _goStyle,
        child: child,
      ),
      ButtonTone.primary => FilledButton(
        onPressed: busy ? null : onPressed,
        child: child,
      ),
      ButtonTone.secondary => OutlinedButton(
        onPressed: busy ? null : onPressed,
        child: child,
      ),
      ButtonTone.danger => FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.danger,
          minimumSize: const Size.fromHeight(AppTheme.minTapTarget),
        ),
        child: child,
      ),
      ButtonTone.delete => FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.delete,
          foregroundColor: Colors.white,
          overlayColor: AppColors.deletePressed,
          minimumSize: const Size.fromHeight(AppTheme.minTapTarget),
        ),
        child: child,
      ),
    };

    return Semantics(
      button: true,
      label: spoken,
      child: GestureDetector(
        onLongPress: () => speech.speak(spoken, key: 'button:$spoken'),
        child: button,
      ),
    );
  }
}
