import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CameraService extends ChangeNotifier with WidgetsBindingObserver {
  CameraService();

  CameraController? _controller;

  CameraController? get controller => _controller;

  bool _initialising = false;
  bool get isInitialising => _initialising;

  bool get isReady => _controller?.value.isInitialized ?? false;

  Object? _error;
  Object? get error => _error;
  bool get hasFailed => _error != null;

  bool _permissionDenied = false;
  bool get isPermissionDenied => _permissionDenied;

  bool _torchOn = false;
  bool get isTorchOn => _torchOn;

  bool get hasTorch => isReady && _hasFlash;
  bool _hasFlash = false;

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
      _permissionDenied =
          error is CameraException &&
          error.code.toLowerCase().contains('accessdenied');
      await _disposeController();
    } finally {
      _initialising = false;
      notifyListeners();
    }
  }

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

  Future<File?> pickFromGallery() async {
    await stop();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (picked != null) return File(picked.path);
    } catch (_) {}
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
      _hasFlash = false;
    }
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _disposeController().then((_) => notifyListeners());
    } else if (state == AppLifecycleState.resumed) {
      start();
    }
  }

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
    } catch (_) {}
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
