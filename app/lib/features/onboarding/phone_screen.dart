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
import 'widgets/demo_hint.dart';
import 'widgets/onboarding_scaffold.dart';
import '../../widgets/whole_word_text.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  String _digits = '';
  bool _sending = false;
  String? _error;

  bool get _isComplete => _digits.length == AppConstants.phoneDigits;

  void _append(String digit) {
    if (_digits.length >= AppConstants.phoneDigits) return;
    setState(() {
      _digits += digit;
      _error = null;
    });
  }

  void _backspace() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits = _digits.substring(0, _digits.length - 1);
      _error = null;
    });
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final onboarding = context.read<OnboardingController>();
    final auth = onboarding.auth;

    setState(() {
      _sending = true;
      _error = null;
    });

    final outcome = await auth.requestOtp(_digits);
    if (!mounted) return;
    setState(() => _sending = false);

    switch (outcome) {
      case OtpRequestOutcome.sent:
        onboarding.setPhone(_digits);
        Navigator.of(context).pushNamed(AppRoutes.otp);
      case OtpRequestOutcome.invalidNumber:
        setState(() => _error = l10n.phoneInvalid);
      case OtpRequestOutcome.unknownNumber:
        setState(() => _error = l10n.phoneUnknown(auth.demoNumber ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<OnboardingController>().auth;

    return OnboardingScaffold(
      step: 6,
      title: l10n.phoneTitle,
      spokenLines: [l10n.phoneTitle, l10n.phoneWhy],
      compact: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DigitDisplay(digits: _digits, error: _error),
          if (_error != null) ...[
            const SizedBox(height: 10),
            WholeWordText(
              _error!,
              style: const TextStyle(color: AppColors.danger, fontSize: 18),
            ),
          ],
          const SizedBox(height: 10),
          NumberPad(
            enabled: !_sending,
            onDigit: _append,
            onBackspace: _backspace,
            onBackspaceLong: () => setState(() {
              _digits = '';
              _error = null;
            }),
          ),
          const SizedBox(height: 10),
          DemoHint(
            values: {'Phone': auth.demoNumber ?? ''},
            onTap: () => setState(() {
              _digits = auth.demoNumber ?? '';
              _error = null;
            }),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.phoneSendCode,
          icon: Icons.sms,
          busy: _sending,
          onPressed: _isComplete ? _send : null,
          spokenLabel: '${l10n.phoneSendCode}. ${l10n.phoneWhy}',
        ),
      ],
    );
  }
}

class _DigitDisplay extends StatelessWidget {
  const _DigitDisplay({required this.digits, required this.error});

  final String digits;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final borderColor = error != null ? AppColors.danger : AppColors.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          const WholeWordText(
            '+91',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: WholeWordText(
                _spaced(digits),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _spaced(String value) {
    final filled = value.padRight(AppConstants.phoneDigits, '–').split('');
    filled.insert(5, ' ');
    return filled.join();
  }
}
