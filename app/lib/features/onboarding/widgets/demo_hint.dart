import 'package:flutter/material.dart';

import '../../../core/dev/dev_accounts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/whole_word_text.dart';

class DemoHint extends StatelessWidget {
  const DemoHint({super.key, required this.values, this.onTap});

  final Map<String, String> values;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!DevAccounts.enabled || values.isEmpty) return const SizedBox.shrink();

    return Semantics(
      excludeSemantics: true,
      child: Material(
        color: AppColors.warningTint,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.science_outlined,
                  size: 20,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: WholeWordText(
                    'Demo: ${values.values.join('  ·  ')}',
                    style: const TextStyle(
                      fontSize: AppTheme.minTextSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.touch_app_outlined,
                    size: 20,
                    color: AppColors.muted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
