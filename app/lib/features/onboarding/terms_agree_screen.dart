import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/whole_word_text.dart';
import '../help/terms_screen.dart';
import 'widgets/onboarding_scaffold.dart';

class TermsAgreeScreen extends StatefulWidget {
  const TermsAgreeScreen({super.key});

  @override
  State<TermsAgreeScreen> createState() => _TermsAgreeScreenState();
}

class _TermsAgreeScreenState extends State<TermsAgreeScreen> {
  bool _agreed = false;
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    await context.read<AppState>().acceptTerms();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.permissions);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = [
      l10n.termsSummary1,
      l10n.termsSummary2,
      l10n.termsSummary3,
      l10n.termsSummary4,
      l10n.termsSummary5,
    ];

    return OnboardingScaffold(
      step: 4,
      title: l10n.termsAgreeTitle,
      subtitle: l10n.termsAgreeBody,
      spokenLines: [
        l10n.termsAgreeTitle,
        l10n.termsAgreeBody,
        ...summary,
        l10n.termsAgreeCheck,
      ],
      compact: true,
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final line in summary) ...[
            TermsPoint(text: line),
            const SizedBox(height: 10),
          ],
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.terms),
              icon: const Icon(Icons.description_outlined, size: 26),
              label: WholeWordText(l10n.termsOpenFull),
            ),
          ),
        ],
      ),
      actions: [
        Material(
          color: _agreed ? AppColors.successTint : AppColors.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: _agreed ? AppColors.success : AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: CheckboxListTile(
            key: const Key('terms-agree-check'),
            value: _agreed,
            onChanged: _saving
                ? null
                : (value) => setState(() => _agreed = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: WholeWordText(
              l10n.termsAgreeCheck,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        BigActionButton(
          label: l10n.termsAgreeContinue,
          icon: Icons.arrow_forward,
          busy: _saving,
          spokenLabel: _agreed ? null : l10n.termsAgreeNeeded,
          onPressed: _agreed ? _continue : null,
        ),
      ],
    );
  }
}
