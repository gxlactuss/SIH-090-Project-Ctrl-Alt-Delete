import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/onboarding_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/number_pad.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/onboarding_scaffold.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  bool _verifying = false;
  bool _autoRead = false;
  String? _error;
  String? _notice;

  Timer? _ticker;
  Timer? _autoReadTimer;
  int _secondsLeft = AppConstants.otpResendSeconds;

  bool get _isComplete => _code.length == AppConstants.otpDigits;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _armAutoRead();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _autoReadTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _ticker?.cancel();
    setState(() => _secondsLeft = AppConstants.otpResendSeconds);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  void _armAutoRead() {
    final auth = context.read<OnboardingController>().auth;
    final code = auth.demoOtp;
    if (code == null) return;

    _autoReadTimer = Timer(AppConstants.otpAutoReadDelay, () {
      if (!mounted || _code.isNotEmpty) return;
      setState(() {
        _code = code;
        _autoRead = true;
        _error = null;
      });
      _verify();
    });
  }

  void _append(String digit) {
    if (_code.length >= AppConstants.otpDigits) return;
    setState(() {
      _code += digit;
      _autoRead = false;
      _error = null;
    });
    if (_code.length == AppConstants.otpDigits) _verify();
  }

  void _backspace() {
    if (_code.isEmpty) return;
    setState(() {
      _code = _code.substring(0, _code.length - 1);
      _autoRead = false;
      _error = null;
    });
  }

  Future<void> _verify() async {
    if (_verifying || !_isComplete) return;
    final l10n = AppLocalizations.of(context);
    final onboarding = context.read<OnboardingController>();

    setState(() {
      _verifying = true;
      _error = null;
    });

    final outcome = await onboarding.auth.verifyOtp(
      phone: onboarding.phone,
      code: _code,
    );
    if (!mounted) return;
    setState(() => _verifying = false);

    switch (outcome) {
      case OtpVerifyOutcome.verified:
        Navigator.of(context).pushNamed(AppRoutes.profile);
      case OtpVerifyOutcome.wrongCode:
        setState(() {
          _error = l10n.otpWrong;
          _code = '';
          _autoRead = false;
        });
    }
  }

  Future<void> _resend({required bool byCall}) async {
    final l10n = AppLocalizations.of(context);
    final onboarding = context.read<OnboardingController>();

    setState(() {
      _notice = null;
      _error = null;
    });

    final outcome = byCall
        ? await onboarding.auth.requestOtpByCall(onboarding.phone)
        : await onboarding.auth.requestOtp(onboarding.phone);
    if (!mounted) return;

    if (outcome == OtpRequestOutcome.sent) {
      _startResendTimer();
      if (byCall) setState(() => _notice = l10n.otpCalling);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboarding = context.watch<OnboardingController>();
    final canResend = _secondsLeft <= 0;

    return OnboardingScaffold(
      step: 7,
      title: l10n.otpTitle,
      subtitle: l10n.otpSentTo(onboarding.phone),
      compact: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OtpBoxes(code: _code, hasError: _error != null),
          const SizedBox(height: 14),
          if (_autoRead)
            _Notice(
              icon: Icons.mark_email_read_outlined,
              text: l10n.otpAutoRead,
              color: AppColors.success,
            ),
          if (_error != null)
            _Notice(
              icon: Icons.error_outline,
              text: _error!,
              color: AppColors.danger,
            ),
          if (_notice != null)
            _Notice(
              icon: Icons.phone_in_talk,
              text: _notice!,
              color: AppColors.success,
            ),
          const SizedBox(height: 10),
          NumberPad(
            enabled: !_verifying,
            onDigit: _append,
            onBackspace: _backspace,
            onBackspaceLong: () => setState(() {
              _code = '';
              _autoRead = false;
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextButton(
                  onPressed: canResend ? () => _resend(byCall: false) : null,
                  child: WholeWordText(
                    canResend ? l10n.otpResend : l10n.otpResendIn(_secondsLeft),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: WholeWordText(
                    l10n.otpChangeNumber,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.actionNext,
          icon: Icons.check,
          busy: _verifying,
          onPressed: _isComplete ? _verify : null,
        ),
        BigActionButton(
          label: l10n.otpCallMe,
          icon: Icons.phone_in_talk,
          tone: ButtonTone.secondary,
          onPressed: () => _resend(byCall: true),
        ),
      ],
    );
  }
}

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({required this.code, required this.hasError});

  final String code;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < AppConstants.otpDigits; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AspectRatio(
                aspectRatio: 0.82,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(
                      color: hasError
                          ? AppColors.danger
                          : i == code.length
                          ? AppColors.terracotta
                          : AppColors.border,
                      width: i == code.length && !hasError ? 3 : 2,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: WholeWordText(
                      i < code.length ? code[i] : '',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: WholeWordText(
              text,
              style: TextStyle(fontSize: 17, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
