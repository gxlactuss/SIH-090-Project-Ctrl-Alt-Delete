import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

/// Wraps package:camera so the capture screen deals in "take the next photo"
/// rather than in controllers and lifecycles.
///
/// Nothing here throws at the UI. A phone whose camera is busy, missing or
/// refused leaves this in an unavailable state with a reason, and 3.1 shows
/// that instead of a preview -- a black rectangle with no explanation is the
/// worst thing this screen could do.
///
/// Every method is overridable so a widget test can subclass it: there is no
/// camera under `flutter test`, and the flow still has to be walkable.
class CameraService extends ChangeNotifier with WidgetsBindingObserver {
  CameraService();

  CameraController? _controller;

  /// Exposed only so 3.1 can build a [CameraPreview]. Null until ready.
  CameraController? get controller => _controller;

  bool _initialising = false;
  bool get isInitialising => _initialising;

  bool get isReady => _controller?.value.isInitialized ?? false;

  /// Set when the camera cannot be opened. The screen shows it and offers
  /// the settings deep link when it is a permission problem.
  Object? _error;
  Object? get error => _error;
  bool get hasFailed => _error != null;

  /// True when the phone refused because of permissions rather than because
  /// the hardware is busy -- a different screen, and a different way out.
  bool _permissionDenied = false;
  bool get isPermissionDenied => _permissionDenied;

  bool _torchOn = false;
  bool get isTorchOn => _torchOn;

  /// Whether this phone has a torch to toggle at all. Front-facing-only and
  /// budget devices often do not, and a dead button is worse than no button.
  bool get hasTorch => isReady && _hasFlash;
  bool _hasFlash = false;

  /// Opens the back camera. Safe to call again: a second call while one is
  /// in flight is ignored, and a call when already open is a no-op.
  Future<void> start() async {
    if (isReady || _initialising) return;
    _initialising = true;
    _error = null;
    _permissionDenied = false;
    notifyListeners();

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw CameraException('NoCamera', 'No camera');

      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Medium, not max: the pipeline wants a photograph of a shawl, not a
      // 12 megapixel file that takes a minute to upload on 2G and will not
      // fit in the memory of the phone that took it.
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      _controller = controller;
      _hasFlash = back.lensDirection == CameraLensDirection.back;
      _torchOn = false;
      WidgetsBinding.instance.addObserver(this);
    } catch (error) {
      _error = error;
      _permissionDenied = error is CameraException &&
          error.code.toLowerCase().contains('accessdenied');
      await _disposeController();
    } finally {
      _initialising = false;
      notifyListeners();
    }
  }

  /// Takes one photo and returns where it landed, or null if the shutter
  /// failed. The caller decides what to say about null; this only reports.
  Future<File?> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;
    if (controller.value.isTakingPicture) return null;

    try {
      final shot = await controller.takePicture();
      return File(shot.path);
    } catch (error) {
      _error = error;
      notifyListeners();
      return null;
    }
  }

  /// A photo the seller already has, from the phone's gallery, or null if
  /// they backed out. For the bowl photographed yesterday in good light, and
  /// for the phone whose camera will not open at all.
  ///
  /// The preview is released first and reopened only if nothing was picked:
  /// the picker is another app on top of this one, and Android kills a
  /// backgrounded app that is holding a camera first.
  ///
  /// The file handed back is the picker's own copy in this app's cache, never
  /// the original, so the capture flow deleting it touches nothing in the
  /// seller's gallery.
  Future<File?> pickFromGallery() async {
    await stop();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // A gallery holds 12 megapixel originals, and some phones save HEIC,
        // which the quality check cannot read. A quality setting makes the
        // picker re-encode to a JPEG no bigger than a listing photo needs.
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (picked != null) return File(picked.path);
    } catch (_) {
      // No gallery app, or a refused permission. Not the camera's failure,
      // so it is not reported as one: the seller is back on 3.1 as they were.
    }
    await start();
    return null;
  }

  Future<void> toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final next = !_torchOn;
    try {
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      _torchOn = next;
    } catch (_) {
      // Some phones report a flash they will not let an app drive. Leaving
      // the toggle where it was is the honest answer.
      _hasFlash = false;
    }
    notifyListeners();
  }

  /// The camera holds a hardware resource that Android takes away when the
  /// app goes to the background. Handing it back and re-opening on resume is
  /// the difference between a preview and a frozen frame.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _disposeController().then((_) => notifyListeners());
    } else if (state == AppLifecycleState.resumed) {
      start();
    }
  }

  /// Called when 3.1 is left, so the camera is not held open behind the rest
  /// of the flow -- on a 2 GB phone that is the difference between the voice
  /// recorder starting and the app being killed.
  Future<void> stop() async {
    await _disposeController();
    notifyListeners();
  }

  Future<void> _disposeController() async {
    final controller = _controller;
    _controller = null;
    _torchOn = false;
    if (controller == null) return;
    WidgetsBinding.instance.removeObserver(this);
    try {
      await controller.dispose();
    } catch (_) {
      // Disposing a camera that is already gone is not worth an error.
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
