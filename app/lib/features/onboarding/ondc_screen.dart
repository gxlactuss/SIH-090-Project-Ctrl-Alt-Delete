import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/ondc_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/demo_hint.dart';
import 'widgets/onboarding_scaffold.dart';
import 'widgets/qr_scan_page.dart';
import '../../widgets/confirm_dialog.dart';

class OndcScreen extends StatefulWidget {
  const OndcScreen({super.key});

  static Future<void> askBeforeFirstPublish(BuildContext context) async {
    final state = context.maybeRead<AppState>();
    if (state == null) return;
    if ((state.profile?.hasOndcAccount ?? false) || state.hasBeenAskedOndc) {
      return;
    }
    await state.markOndcAsked();
    if (!context.mounted) return;
    await Navigator.of(context).pushNamed(AppRoutes.ondc);
  }

  @override
  State<OndcScreen> createState() => _OndcScreenState();
}

class _OndcScreenState extends State<OndcScreen> {
  static const _ondc = OndcRepository();

  final _email = TextEditingController();
  final _sellerId = TextEditingController();

  bool _linking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().profile;
    _email.text = profile?.ondcEmail ?? '';
    _sellerId.text = profile?.ondcSellerId ?? '';
  }

  @override
  void dispose() {
    _email.dispose();
    _sellerId.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _email.text.trim().isNotEmpty && _sellerId.text.trim().isNotEmpty;

  Future<void> _scan() async {
    final scanned = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => const QrScanPage()));
    if (scanned == null || !mounted) return;
    setState(() {
      _sellerId.text = scanned.trim();
      _error = null;
    });
  }

  Future<void> _link() async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);

    setState(() {
      _linking = true;
      _error = null;
    });

    final outcome = await _ondc.link(
      email: _email.text,
      sellerId: _sellerId.text,
    );
    if (!mounted) return;
    setState(() => _linking = false);

    switch (outcome) {
      case OndcLinkOutcome.linked:
        await state.updateProfile(
          ondcSellerId: _sellerId.text.trim(),
          ondcEmail: _email.text.trim(),
        );
        navigator.pop(true);
      case OndcLinkOutcome.emailMalformed:
        setState(() => _error = l10n.ondcEmailMalformed);
      case OndcLinkOutcome.malformed:
        setState(() => _error = l10n.ondcMalformed);
      case OndcLinkOutcome.notFound:
        setState(() => _error = l10n.ondcFailed);
    }
  }

  Future<void> _skip() async {
    final l10n = AppLocalizations.of(context);
    final speech = context.read<SpeechService>();

    final proceed = await showSpokenConfirm(
      context,
      title: l10n.ondcNoAccount,
      body: l10n.ondcNoAccountExplain,
      confirm: l10n.actionNext,
      cancel: l10n.actionBack,
      tone: ConfirmTone.primary,
      speechKey: 'ondc:skip',
    );

    if (!proceed || !mounted) return;
    await speech.stop();
    if (!mounted) return;
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const ondc = _ondc;

    return OnboardingScaffold(
      title: l10n.ondcTitle,
      subtitle: l10n.ondcExplain,
      compact: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Field(
            label: l10n.ondcEmailLabel,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() => _error = null),
          ),
          const SizedBox(height: 22),
          _Field(
            label: l10n.ondcSellerIdLabel,
            controller: _sellerId,
            keyboardType: TextInputType.text,
            onChanged: (_) => setState(() => _error = null),
            trailing: IconButton(
              onPressed: _scan,
              tooltip: l10n.ondcScan,
              icon: const Icon(Icons.qr_code_scanner, size: 34),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.danger,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: WholeWordText(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 18,
                    ),
                  ),
                ),
                SpeakButton(text: _error!, utteranceKey: 'ondc:error'),
              ],
            ),
          ],
          const SizedBox(height: 18),
          DemoHint(
            values: {
              'Email': ondc.demoEmail ?? '',
              'Seller ID': ondc.demoSellerId ?? '',
            },
            onTap: () => setState(() {
              _email.text = ondc.demoEmail ?? '';
              _sellerId.text = ondc.demoSellerId ?? '';
              _error = null;
            }),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: _linking ? l10n.ondcLinking : l10n.ondcLink,
          icon: Icons.link,
          busy: _linking,
          onPressed: _canSubmit ? _link : null,
        ),
        BigActionButton(
          label: l10n.ondcNoAccount,
          icon: Icons.schedule,
          tone: ButtonTone.secondary,
          onPressed: _linking ? null : _skip,
          spokenLabel: '${l10n.ondcNoAccount}. ${l10n.ondcNoAccountExplain}',
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: WholeWordText(
                label,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            SpeakButton(text: label, size: 26),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: keyboardType,
                autocorrect: false,
                style: const TextStyle(fontSize: 21, color: AppColors.ink),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.warningTint,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: trailing,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
