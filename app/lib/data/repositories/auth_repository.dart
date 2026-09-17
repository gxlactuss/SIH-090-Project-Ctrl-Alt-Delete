import '../../core/constants/app_constants.dart';
import '../../core/dev/dev_accounts.dart';

/// What happened when we asked for a code.
enum OtpRequestOutcome {
  sent,

  /// Not ten digits. The screen should not even let this happen, but the
  /// repository does not trust the screen.
  invalidNumber,

  /// A well-formed number that this build has no account for. With no auth
  /// server behind the demo, that is every number but the test one.
  unknownNumber,
}

/// What happened when we checked the code.
enum OtpVerifyOutcome { verified, wrongCode }

/// Phone-number sign-in: 1.5 and 1.6.
///
/// There is no auth backend yet, so this is a local stand-in that keeps the
/// real shape -- a request, a wait, a verify, and a resend with a cooldown --
/// so that swapping in the server later touches this file and nothing else.
class AuthRepository {
  const AuthRepository();

  /// The number this build accepts, shown on 1.5 so nobody has to guess.
  String? get demoNumber => DevAccounts.enabled ? DevAccounts.phone : null;

  /// The code the fake SMS delivers, which 1.6 uses to imitate auto-read.
  String? get demoOtp => DevAccounts.enabled ? DevAccounts.otp : null;

  Future<OtpRequestOutcome> requestOtp(String phone) async {
    final digits = _digitsOf(phone);
    if (digits.length != AppConstants.phoneDigits) {
      return OtpRequestOutcome.invalidNumber;
    }

    await Future<void>.delayed(AppConstants.fakeNetworkDelay);

    if (DevAccounts.enabled && digits == DevAccounts.phone) {
      return OtpRequestOutcome.sent;
    }
    return OtpRequestOutcome.unknownNumber;
  }

  /// The "call me instead" fallback on 1.6. Same code, delivered by voice,
  /// for a seller who cannot read the SMS.
  Future<OtpRequestOutcome> requestOtpByCall(String phone) =>
      requestOtp(phone);

  Future<OtpVerifyOutcome> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);

    if (DevAccounts.enabled &&
        _digitsOf(phone) == DevAccounts.phone &&
        code == DevAccounts.otp) {
      return OtpVerifyOutcome.verified;
    }
    return OtpVerifyOutcome.wrongCode;
  }

  String _digitsOf(String input) => input.replaceAll(RegExp(r'\D'), '');
}
