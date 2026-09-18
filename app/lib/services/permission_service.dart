import 'package:permission_handler/permission_handler.dart';

enum AppPermission { camera, microphone, notifications }

enum PermissionOutcome { granted, denied, blocked }

class PermissionService {
  const PermissionService();

  Permission _handle(AppPermission permission) => switch (permission) {
    AppPermission.camera => Permission.camera,
    AppPermission.microphone => Permission.microphone,
    AppPermission.notifications => Permission.notification,
  };

  Future<PermissionOutcome> request(AppPermission permission) async {
    try {
      return _outcome(await _handle(permission).request());
    } catch (_) {
      return PermissionOutcome.granted;
    }
  }

  Future<PermissionOutcome> check(AppPermission permission) async {
    try {
      return _outcome(await _handle(permission).status);
    } catch (_) {
      return PermissionOutcome.granted;
    }
  }

  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (_) {
      return false;
    }
  }

  PermissionOutcome _outcome(PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return PermissionOutcome.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return PermissionOutcome.blocked;
    }
    return PermissionOutcome.denied;
  }
}
