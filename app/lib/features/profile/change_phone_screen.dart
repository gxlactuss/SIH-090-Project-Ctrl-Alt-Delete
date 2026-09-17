import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/number_pad.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

enum _Step { number, code }

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _auth = AuthRepository();

  _Step _step = _Step.number;
  String _digits = '';
  String _code = '';
  bool _busy = false;
  String? _error;

  bool get _isNumberComplete => _digits.length == AppConstants.phoneDigits;
  bool get _isCodeComplete => _code.length == AppConstants.otpDigits;

  void _append(String digit) {
    setState(() {
      _error = null;
      if (_step == _Step.number) {
        if (_digits.length < AppConstants.phoneDigits) _digits += digit;
      } else {
        if (_code.length < AppConstants.otpDigits) _code += digit;
      }
    });
  }

  void _backspace() {
    setState(() {
      _error = null;
      if (_step == _Step.number) {
        if (_digits.isNotEmpty) {
          _digits = _digits.substring(0, _digits.length - 1);
        }
      } else if (_code.isNotEmpty) {
        _code = _code.substring(0, _code.length - 1);
      }
    });
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    final outcome = await _auth.requestOtp(_digits);
    if (!mounted) return;

    setState(() {
      _busy = false;
      switch (outcome) {
        case OtpRequestOutcome.sent:
          _step = _Step.code;
        case OtpRequestOutcome.invalidNumber:
          _error = l10n.phoneInvalid;
        case OtpRequestOutcome.unknownNumber:
          _error = l10n.phoneUnknown(_auth.demoNumber ?? '');
        case OtpRequestOutcome.tooManyTries:
          _error = l10n.authTooManyTries;
        case OtpRequestOutcome.failed:
          _error = l10n.phoneSendFailed;
      }
    });
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _busy = true;
      _error = null;
    });

    final outcome = await _auth.verifyOtp(phone: _digits, code: _code);
    if (!mounted) return;

    if (outcome != OtpVerifyOutcome.verified) {
      setState(() {
        _busy = false;
        _error = _verifyError(l10n, outcome);
        _code = '';
        if (outcome == OtpVerifyOutcome.expired) _step = _Step.number;
      });
      return;
    }

    await state.updateProfile(phone: _digits);
    if (!mounted) return;

    navigator.pop();
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.changePhoneDone)),
    );
  }

  String _verifyError(AppLocalizations l10n, OtpVerifyOutcome outcome) =>
      switch (outcome) {
        OtpVerifyOutcome.expired => l10n.otpExpired,
        OtpVerifyOutcome.tooManyTries => l10n.authTooManyTries,
        OtpVerifyOutcome.failed => l10n.phoneSendFailed,
        _ => l10n.otpWrong,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = context.select((AppState s) => s.profile?.phone);
    final onNumber = _step == _Step.number;

    return SettingsScaffold(
      title: l10n.changePhoneTitle,
      subtitle: onNumber ? l10n.changePhoneBody : l10n.otpSentTo(_digits),
      busy: _busy,
      rows: [
        if (onNumber && current != null) ...[
          WholeWordText(
            l10n.changePhoneCurrent(current),
            style: const TextStyle(fontSize: 17, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: WholeWordText(
            onNumber
                ? (_digits.isEmpty ? '—' : _digits)
                : (_code.isEmpty ? '—' : _code),
            style: const TextStyle(
              fontSize: 34,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          WholeWordText(
            _error!,
            style: const TextStyle(fontSize: 17, color: AppColors.danger),
          ),
        ],
        const SizedBox(height: 16),
        NumberPad(onDigit: _append, onBackspace: _backspace, enabled: !_busy),
      ],
      actions: [
        BigActionButton(
          label: onNumber ? l10n.phoneSendCode : l10n.actionNext,
          icon: onNumber ? Icons.sms_outlined : Icons.check,
          busy: _busy,
          onPressed: _busy
              ? null
              : (onNumber
                    ? (_isNumberComplete ? _sendCode : null)
                    : (_isCodeComplete ? _verify : null)),
        ),
        if (!onNumber)
          BigActionButton(
            label: l10n.otpChangeNumber,
            icon: Icons.arrow_back,
            tone: ButtonTone.secondary,
            onPressed: _busy
                ? null
                : () => setState(() {
                    _step = _Step.number;
                    _code = '';
                    _error = null;
                  }),
          ),
      ],
    );
  }
}
