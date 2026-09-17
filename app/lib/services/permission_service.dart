import 'package:permission_handler/permission_handler.dart';

/// The three permissions the app asks for, and nothing else.
///
/// The order is the order of the primer on 1.4, which is also the order they
/// become necessary: you photograph before you speak, and you speak before
/// anything can sell.
enum AppPermission { camera, microphone, notifications }

/// What we do with an answer. Denied is recoverable by asking again; blocked
/// means Android will not show the dialog any more and the only way out is
/// the settings deep link on 10.5.
enum PermissionOutcome { granted, denied, blocked }

/// Wraps package:permission_handler so no screen imports it directly.
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
      // No platform implementation -- the desktop the app is developed on.
      // Treat it as granted so the flow stays walkable.
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

  /// The deep link out to the Android app settings page, for 10.5.
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
