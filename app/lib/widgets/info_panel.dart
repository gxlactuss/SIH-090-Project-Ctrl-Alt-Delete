import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import 'speak_button.dart';
import 'whole_word_text.dart';

enum InfoTone {
  warning(AppColors.warningTint, AppColors.marigold, AppColors.ink),

  danger(AppColors.dangerTint, AppColors.danger, AppColors.danger),

  success(AppColors.successTint, AppColors.success, AppColors.success);

  const InfoTone(this.background, this.border, this.iconColor);

  final Color background;
  final Color border;
  final Color iconColor;
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({
    super.key,
    required this.text,
    this.title,
    this.icon,
    this.tone = InfoTone.warning,
    this.bordered = false,
    this.dense = false,
    this.emphasized = false,
    this.speak = true,
    this.spokenLines,
    this.textStyle,
    this.margin,
  });

  final String text;

  final String? title;

  final IconData? icon;

  final InfoTone tone;

  final bool bordered;

  final bool dense;

  final bool emphasized;

  final bool speak;

  final List<String?>? spokenLines;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final bodySize = dense ? 16.0 : 17.0;
    final bodyStyle =
        textStyle ??
        TextStyle(
          fontSize: emphasized && title == null ? 18 : bodySize,
          height: 1.35,
          fontWeight: emphasized && title == null
              ? FontWeight.w600
              : FontWeight.normal,
          color: AppColors.ink,
        );

    return Container(
      margin: margin,
      padding: EdgeInsets.all(dense ? 12 : 16),
      decoration: BoxDecoration(
        color: tone.background,
        border: bordered ? Border.all(color: tone.border, width: 2) : null,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: dense ? 24 : 28, color: tone.iconColor),
            ),
            SizedBox(width: dense ? 10 : 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  WholeWordText(
                    title!,
                    style: TextStyle(
                      fontSize: dense ? 17 : 19,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                WholeWordText(text, style: bodyStyle),
              ],
            ),
          ),
          if (speak)
            SpeakButton.lines(
              lines: spokenLines ?? [title, text],
              size: dense ? 28 : 30,
            ),
        ],
      ),
    );
  }
}
