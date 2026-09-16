import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/image_decode.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/capture_controller.dart';
import '../widgets/capture_scaffold.dart';
import '../widgets/duplicate_banner.dart';

class CheckingStage extends StatelessWidget {
  const CheckingStage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final capture = context.watch<CaptureController>();
    final shot = capture.shot;

    return CaptureScaffold(
      title: l10n.shotReviewChecking,
      banner: capture.isDuplicate ? const DuplicateBanner() : null,
      onClose: onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (shot != null) ShotPreview(file: shot),
          const SizedBox(height: 16),
          const LinearProgressIndicator(minHeight: 6),
        ],
      ),
    );
  }
}

class ShotPreview extends StatelessWidget {
  const ShotPreview({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image.file(
          file,
          fit: BoxFit.contain,
          cacheWidth: decodeWidthFor(context, MediaQuery.sizeOf(context).width),
          color: AppColors.ink,
          colorBlendMode: BlendMode.dstOver,
          errorBuilder: (context, _, _) => Container(
            color: AppColors.ink.withValues(alpha: 0.86),
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image,
              size: 56,
              color: AppColors.marigold,
            ),
          ),
        ),
      ),
    );
  }
}
