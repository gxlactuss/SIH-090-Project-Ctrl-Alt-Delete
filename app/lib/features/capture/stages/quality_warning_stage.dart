import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_quality.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../widgets/capture_scaffold.dart';
import 'checking_stage.dart';
import '../../../widgets/info_panel.dart';

class QualityWarningStage extends StatelessWidget {
  const QualityWarningStage({super.key, required this.onClose});

  final VoidCallback onClose;

  static String advice(AppLocalizations l10n, ImageIssue? issue) =>
      switch (issue) {
        ImageIssue.tooDark => l10n.qualityTooDark,
        ImageIssue.tooBright => l10n.qualityTooBright,
        ImageIssue.blurry => l10n.qualityBlurry,
        ImageIssue.noSubject => l10n.qualityNoSubject,
        ImageIssue.outOfFrame => l10n.qualityOutOfFrame,
        ImageIssue.unreadable => l10n.qualityUnreadable,
        null => l10n.qualityBlurry,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final capture = context.watch<CaptureController>();
    final shot = capture.shot;
    final issue = capture.quality?.issue;
    final message = advice(l10n, issue);

    final canKeepAnyway = issue != ImageIssue.unreadable;

    return CaptureScaffold(
      title: l10n.qualityWarningTitle,
      spokenLines: [l10n.qualityWarningTitle, message],
      onClose: onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoPanel(
            icon: Icons.lightbulb_outline,
            text: message,
            bordered: true,
            textStyle: const TextStyle(
              fontSize: 20,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          if (shot != null) ShotPreview(file: shot),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.shotReviewRetake,
          icon: Icons.replay,
          onPressed: capture.retakeShot,
          spokenLabel: '${l10n.shotReviewRetake}. $message',
        ),
        if (canKeepAnyway)
          BigActionButton(
            label: l10n.qualityKeepAnyway,
            icon: Icons.check,
            tone: ButtonTone.secondary,
            onPressed: capture.keepShot,
          ),
      ],
    );
  }
}
