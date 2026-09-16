import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/camera_service.dart';
import '../../../services/permission_service.dart';
import '../../../services/speech_service.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../widgets/capture_scaffold.dart';
import '../widgets/duplicate_banner.dart';
import '../widgets/photo_guide_overlay.dart';
import '../../../widgets/whole_word_text.dart';

class CameraStage extends StatefulWidget {
  const CameraStage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<CameraStage> createState() => _CameraStageState();
}

class _CameraStageState extends State<CameraStage> {
  bool _shooting = false;
  bool _picking = false;

  String _prompt(AppLocalizations l10n, int slot) => switch (slot) {
        0 => l10n.capturePhotoWhole,
        1 => l10n.capturePhotoDetail,
        _ => l10n.capturePhotoScale,
      };

  Future<void> _shoot() async {
    if (_shooting || _picking) return;
    HapticFeedback.mediumImpact();
    setState(() => _shooting = true);

    final camera = context.read<CameraService>();
    final capture = context.read<CaptureController>();
    final file = await camera.takePicture();

    if (!mounted) return;
    setState(() => _shooting = false);
    if (file == null) return;

    await camera.stop();
    await capture.reviewShot(file);
  }

  Future<void> _pickFromGallery() async {
    if (_shooting || _picking) return;
    setState(() => _picking = true);

    final camera = context.read<CameraService>();
    final capture = context.read<CaptureController>();
    final file = await camera.pickFromGallery();

    if (!mounted) return;
    setState(() => _picking = false);
    if (file == null) return;

    await capture.reviewShot(file);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final camera = context.watch<CameraService>();
    final capture = context.watch<CaptureController>();

    final slot = capture.slot;
    final prompt = _prompt(l10n, slot);
    final step = l10n.capturePhotoStep(slot + 1, AppConstants.photosPerListing);

    return CaptureScaffold(
      title: l10n.captureTitle,
      banner: capture.isDuplicate ? const DuplicateBanner() : null,
      subtitle: prompt,
      spokenLines: [step, prompt],
      onClose: widget.onClose,
      scrollable: false,
      trailing: camera.hasTorch
          ? IconButton(
              icon: Icon(
                camera.isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                size: 30,
              ),
              tooltip:
                  camera.isTorchOn ? l10n.captureTorchOff : l10n.captureTorchOn,
              onPressed: camera.toggleTorch,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: _Preview(camera: camera, step: step, prompt: prompt),
        ),
      ),
      actions: [
        BigActionButton(
          label: l10n.captureTakePhoto,
          icon: Icons.photo_camera,
          busy: _shooting,
          onPressed: camera.isReady && !_picking ? _shoot : null,
          spokenLabel: '${l10n.captureTakePhoto}. $prompt',
        ),
        BigActionButton(
          label: l10n.captureFromGallery,
          icon: Icons.photo_library,
          tone: ButtonTone.secondary,
          busy: _picking,
          onPressed:
              _shooting || camera.isInitialising ? null : _pickFromGallery,
          spokenLabel: '${l10n.captureFromGallery}. $prompt',
        ),
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.camera,
    required this.step,
    required this.prompt,
  });

  final CameraService camera;
  final String step;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    if (camera.hasFailed) {
      return _CameraFailed(camera: camera);
    }

    final controller = camera.controller;
    if (controller == null || !camera.isReady) {
      return Container(
        color: AppColors.ink.withValues(alpha: 0.86),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppColors.marigold),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? 1,
            height: controller.value.previewSize?.width ?? 1,
            child: CameraPreview(controller),
          ),
        ),
        PhotoGuideOverlay(step: step, prompt: prompt),
      ],
    );
  }
}

class _CameraFailed extends StatelessWidget {
  const _CameraFailed({required this.camera});

  final CameraService camera;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final denied = camera.isPermissionDenied;
    final explanation =
        denied ? l10n.captureCameraPermission : l10n.captureCameraFailed;

    return Container(
      color: AppColors.ink.withValues(alpha: 0.9),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          const Icon(Icons.no_photography, size: 56, color: AppColors.marigold),
          const SizedBox(height: 16),
          WholeWordText(
            l10n.captureCameraFailed,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          WholeWordText(
            explanation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.35,
              color: AppColors.cream,
            ),
          ),
          const SizedBox(height: 18),
          IconButton(
            icon: const Icon(Icons.volume_up, size: 32, color: Colors.white),
            onPressed: () => context
                .read<SpeechService>()
                .speakAll([l10n.captureCameraFailed, explanation],
                    key: 'camera:failed'),
          ),
          const SizedBox(height: 6),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.marigold, width: 2),
            ),
            onPressed: denied
                ? () => context.read<PermissionService>().openSettings()
                : camera.start,
            child: WholeWordText(
              denied ? l10n.captureOpenSettings : l10n.captureCameraRetry,
            ),
          ),
        ],
      ),
    );
  }
}
