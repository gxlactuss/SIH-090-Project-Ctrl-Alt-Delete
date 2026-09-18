import 'dart:io';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/image_decode.dart';
import '../../../core/utils/image_quality.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../widgets/capture_scaffold.dart';
import '../widgets/duplicate_banner.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../core/theme/app_motion.dart';

class PhotoSetStage extends StatelessWidget {
  const PhotoSetStage({super.key, required this.onClose});

  final VoidCallback onClose;

  static String reason(AppLocalizations l10n, ImageIssue issue) =>
      switch (issue) {
        ImageIssue.tooDark => l10n.photoIssueTooDark,
        ImageIssue.tooBright => l10n.photoIssueTooBright,
        ImageIssue.blurry => l10n.photoIssueBlurry,
        ImageIssue.noSubject => l10n.photoIssueNoSubject,
        ImageIssue.outOfFrame => l10n.photoIssueOutOfFrame,
        ImageIssue.unreadable => l10n.photoIssueUnreadable,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final capture = context.watch<CaptureController>();

    String? warningAt(int index) {
      final issue = capture.issueAt(index);
      return issue == null ? null : reason(l10n, issue);
    }

    return CaptureScaffold(
      title: l10n.photoSetTitle,
      banner: capture.isDuplicate ? const DuplicateBanner() : null,
      subtitle: l10n.photoSetBody,
      spokenLines: [
        l10n.photoSetTitle,
        l10n.photoSetBody,
        for (var i = 0; i < capture.photos.length; i++)
          if (warningAt(i) case final warning?)
            '${l10n.capturePhotoStep(i + 1, AppConstants.photosPerListing)}. '
                '$warning',
      ],
      onClose: onClose,
      body: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: capture.photos.length,
        onReorderItem: capture.movePhoto,
        proxyDecorator: (child, index, animation) => AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final t = AppMotion.inOut.transform(animation.value);
            return Transform.scale(
              scale: lerpDouble(1, 1.03, t),
              child: Material(
                color: Colors.transparent,
                elevation: lerpDouble(0, 8, t)!,
                shadowColor: AppColors.ink.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppTheme.radius),
                child: child,
              ),
            );
          },
          child: child,
        ),
        itemBuilder: (context, i) {
          final file = capture.photos[i];
          return ReorderableDelayedDragStartListener(
            key: ValueKey(file.path),
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PhotoRow(
                file: file,
                index: i,
                isMain: i == 0,
                warning: warningAt(i),
                onRetake: () => capture.retakePhotoAt(i),
                onEdit: () => capture.editPhotoAt(i),
              ),
            ),
          );
        },
      ),
      actions: [
        BigActionButton(
          label: l10n.photoSetConfirm,
          icon: Icons.check,
          onPressed: capture.hasAllPhotos ? capture.confirmPhotos : null,
        ),
      ],
    );
  }
}

class _PhotoRow extends StatelessWidget {
  const _PhotoRow({
    required this.file,
    required this.index,
    required this.isMain,
    required this.warning,
    required this.onRetake,
    required this.onEdit,
  });

  final File file;
  final int index;
  final bool isMain;

  final String? warning;

  final VoidCallback onRetake;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speech = context.read<SpeechService>();
    final warning = this.warning;

    final optionStyle = TextButton.styleFrom(
      backgroundColor: AppColors.warningTint,
      foregroundColor: AppColors.ink,
      alignment: AlignmentDirectional.centerStart,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isMain ? AppColors.terracotta : AppColors.border,
          width: isMain ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    cacheWidth: decodeWidthFor(context, 96),
                    errorBuilder: (context, _, _) => Container(
                      color: AppColors.cream,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 32,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isMain
                    ? Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 22,
                            color: AppColors.terracotta,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: WholeWordText(
                              l10n.photoSetMain,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.terracotta,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              ReorderableDragStartListener(
                index: index,
                child: const SizedBox.square(
                  dimension: AppTheme.minTapTarget,
                  child: Icon(
                    Icons.drag_indicator,
                    size: 34,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          if (warning != null)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.dangerTint,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    size: 24,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: WholeWordText(
                      warning,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onRetake,
            onLongPress: () => speech.speak(
              l10n.photoSetRetakeThis,
              key: 'photoset:retake$index',
            ),
            style: optionStyle,
            icon: const Icon(Icons.replay, size: 24),
            label: WholeWordText(l10n.photoSetRetakeThis),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onEdit,
            onLongPress: () =>
                speech.speak(l10n.photoEditOpen, key: 'photoset:edit$index'),
            style: optionStyle,
            icon: const Icon(Icons.crop_rotate, size: 24),
            label: WholeWordText(l10n.photoEditOpen),
          ),
        ],
      ),
    );
  }
}
