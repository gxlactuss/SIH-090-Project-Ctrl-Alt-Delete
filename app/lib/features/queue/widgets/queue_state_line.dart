
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/capture_item.dart';
import '../../../data/remote/upload_failure.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/queue_controller.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/app_image.dart';

class QueueStateLine extends StatelessWidget {
  const QueueStateLine({
    super.key,
    required this.state,
    required this.progress,
  });

  final QueueItemState state;

  final double progress;

  static String label(
    AppLocalizations l10n,
    QueueItemState state,
    double progress,
  ) =>
      switch (state) {
        QueueItemState.waiting => l10n.queueStateWaiting,
        QueueItemState.uploading =>
          l10n.queueStateUploading((progress * 100).round()),
        QueueItemState.processing => l10n.queueStateProcessing,
        QueueItemState.failed => l10n.queueStateFailed,
      };

  static IconData icon(QueueItemState state) => switch (state) {
        QueueItemState.waiting => Icons.schedule,
        QueueItemState.uploading => Icons.cloud_upload,
        QueueItemState.processing => Icons.hourglass_bottom,
        QueueItemState.failed => Icons.error_outline,
      };

  static Color colour(QueueItemState state) => switch (state) {
        QueueItemState.waiting => AppColors.muted,
        QueueItemState.uploading => AppColors.terracotta,
        QueueItemState.processing => AppColors.success,
        QueueItemState.failed => AppColors.danger,
      };

  static String failureMessage(AppLocalizations l10n, UploadFailure failure) =>
      switch (failure) {
        UploadFailure.network => l10n.failureNetwork,
        UploadFailure.server => l10n.failureServer,
        UploadFailure.missingFiles => l10n.failureMissingFiles,
        UploadFailure.rejected => l10n.failureRejected,
        UploadFailure.unknown => l10n.failureUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tone = colour(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon(state), size: 22, color: tone),
            const SizedBox(width: 6),
            Expanded(
              child: WholeWordText(
                label(l10n, state, progress),
                style: TextStyle(
                  fontSize: 17,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: tone,
                ),
              ),
            ),
          ],
        ),
        if (state == QueueItemState.uploading) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 8),
          ),
        ],
      ],
    );
  }
}

class QueueProgressBuilder extends StatelessWidget {
  const QueueProgressBuilder({
    super.key,
    required this.state,
    required this.builder,
  });

  final QueueItemState state;
  final Widget Function(double progress) builder;

  @override
  Widget build(BuildContext context) {
    if (state != QueueItemState.uploading) return builder(0);
    return ValueListenableBuilder<double>(
      valueListenable: context.read<QueueController>().progressListenable,
      builder: (context, progress, _) => builder(progress),
    );
  }
}

class CaptureThumbnail extends StatelessWidget {
  const CaptureThumbnail({
    super.key,
    required this.item,
    this.size = 76,
    this.photoIndex = 0,
  });

  final CaptureItem item;
  final double size;

  final int photoIndex;

  @override
  Widget build(BuildContext context) {
    final path = photoIndex < item.photoPaths.length
        ? item.photoPaths[photoIndex]
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: AppImage(
          path,
          decodeSize: size,
          fadeIn: false,
          fallback: const _Missing(),
        ),
      ),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        size: 28,
        color: AppColors.muted,
      ),
    );
  }
}
