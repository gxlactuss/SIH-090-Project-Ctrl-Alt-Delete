import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/whole_word_text.dart';

class OnboardingStepLine extends StatelessWidget
    implements PreferredSizeWidget {
  const OnboardingStepLine({super.key, required this.step});

  final int step;

  @override
  Size get preferredSize => const Size.fromHeight(28);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = l10n.stepOfSteps(step, AppConstants.onboardingSteps);

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.gutter,
          0,
          AppTheme.gutter,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: step / AppConstants.onboardingSteps,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            WholeWordText(
              label,
              style: const TextStyle(
                fontSize: AppTheme.minTextSize,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
