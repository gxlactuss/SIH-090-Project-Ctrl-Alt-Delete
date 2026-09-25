import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';

enum OtpRequestOutcome { sent, invalidNumber, tooManyTries, failed }

enum OtpVerifyOutcome { verified, wrongCode, expired, tooManyTries, failed }

class AutoRead {
  const AutoRead(this.code);

  final String? code;
}

class AuthRepository {
  AuthRepository({FirebaseAuth? firebase}) : _injected = firebase;

  final FirebaseAuth? _injected;

  FirebaseAuth get _firebase => _injected ?? FirebaseAuth.instance;

  String? _verificationId;
  int? _resendToken;
  String? _codeFor;
  PhoneAuthCredential? _autoCredential;

  final ValueNotifier<AutoRead?> autoRead = ValueNotifier(null);

  bool get isSignedIn => _firebase.currentUser != null;

  Future<OtpRequestOutcome> requestOtp(String phone) async {
    final digits = _digitsOf(phone);
    if (digits.length != AppConstants.phoneDigits) {
      return OtpRequestOutcome.invalidNumber;
    }

    final firebase = _firebase;
    final done = Completer<OtpRequestOutcome>();
    void finish(OtpRequestOutcome outcome) {
      if (!done.isCompleted) done.complete(outcome);
    }

    final resendToken = digits == _codeFor ? _resendToken : null;
    _autoCredential = null;
    autoRead.value = null;

    try {
      await firebase.verifyPhoneNumber(
        phoneNumber: '+91$digits',
        forceResendingToken: resendToken,
        codeSent: (verificationId, token) {
          _verificationId = verificationId;
          _resendToken = token;
          _codeFor = digits;
          finish(OtpRequestOutcome.sent);
        },
        verificationCompleted: (credential) {
          _codeFor = digits;
          _autoCredential = credential;
          autoRead.value = AutoRead(credential.smsCode);
          finish(OtpRequestOutcome.sent);
        },
        verificationFailed: (e) => finish(_requestFailure(e)),
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException catch (e) {
      finish(_requestFailure(e));
    } catch (_) {
      finish(OtpRequestOutcome.failed);
    }

    return done.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () => OtpRequestOutcome.failed,
    );
  }

  Future<OtpVerifyOutcome> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final digits = _digitsOf(phone);
    final firebase = _firebase;

    if (digits != _codeFor) return OtpVerifyOutcome.expired;

    final auto = _autoCredential;
    final PhoneAuthCredential credential;
    if (auto != null && (code.isEmpty || code == auto.smsCode)) {
      credential = auto;
    } else if (_verificationId != null && code.isNotEmpty) {
      credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );
    } else {
      return OtpVerifyOutcome.wrongCode;
    }

    try {
      final user = firebase.currentUser;
      if (user != null && user.phoneNumber != '+91$digits') {
        await user.updatePhoneNumber(credential);
      } else {
        await firebase.signInWithCredential(credential);
      }
      return OtpVerifyOutcome.verified;
    } on FirebaseAuthException catch (e) {
      debugPrint('Phone verify failed: ${e.code} ${e.message}');
      return switch (e.code) {
        'invalid-verification-code' => OtpVerifyOutcome.wrongCode,
        'session-expired' ||
        'code-expired' ||
        'invalid-verification-id' => OtpVerifyOutcome.expired,
        'too-many-requests' => OtpVerifyOutcome.tooManyTries,
        _ => OtpVerifyOutcome.failed,
      };
    } catch (_) {
      return OtpVerifyOutcome.failed;
    }
  }

  Future<String?> idToken() async => _firebase.currentUser?.getIdToken();

  Future<void> signOut() async {
    _verificationId = null;
    _resendToken = null;
    _codeFor = null;
    _autoCredential = null;
    autoRead.value = null;
    await _firebase.signOut();
  }

  OtpRequestOutcome _requestFailure(FirebaseAuthException e) {
    debugPrint('Phone code request failed: ${e.code} ${e.message}');
    return switch (e.code) {
      'invalid-phone-number' => OtpRequestOutcome.invalidNumber,
      'too-many-requests' || 'quota-exceeded' => OtpRequestOutcome.tooManyTries,
      _ => OtpRequestOutcome.failed,
    };
  }

  String _digitsOf(String input) => input.replaceAll(RegExp(r'\D'), '');
}
