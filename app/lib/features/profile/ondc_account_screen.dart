import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/confirm_dialog.dart';

class OndcAccountScreen extends StatelessWidget {
  const OndcAccountScreen({super.key});

  Future<void> _unlink(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.ondcUnlinkTitle,
      body: l10n.ondcUnlinkBody,
      confirm: l10n.ondcUnlinkConfirm,
      cancel: l10n.ondcUnlinkCancel,
      speechKey: 'ondc:unlink',
    );

    if (!confirmed) return;
    await state.updateProfile(clearOndc: true);
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.ondcUnlinkDone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = context.select((AppState s) => s.profile);
    final linked = profile?.hasOndcAccount ?? false;

    return SettingsScaffold(
      title: l10n.ondcAccountTitle,
      spokenLines: [
        l10n.ondcAccountTitle,
        linked ? l10n.ondcAccountLinked : l10n.ondcAccountNone,
        if (!linked) l10n.ondcAccountNoneBody,
      ],
      rows: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: linked ? AppColors.success : AppColors.marigold,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    linked ? Icons.check_circle : Icons.info_outline,
                    size: 30,
                    color: linked ? AppColors.success : AppColors.marigold,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WholeWordText(
                      linked ? l10n.ondcAccountLinked : l10n.ondcAccountNone,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  SpeakButton(
                    text: linked
                        ? l10n.ondcAccountLinked
                        : l10n.ondcAccountNone,
                    size: 30,
                  ),
                ],
              ),
              if (linked) ...[
                const SizedBox(height: 14),
                _Field(
                  label: l10n.ondcSellerIdLabel,
                  value: profile!.ondcSellerId!,
                ),
                if (profile.ondcEmail != null) ...[
                  const SizedBox(height: 10),
                  _Field(label: l10n.ondcEmailLabel, value: profile.ondcEmail!),
                ],
              ] else ...[
                const SizedBox(height: 10),
                WholeWordText(
                  l10n.ondcAccountNoneBody,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
      actions: [
        if (linked)
          BigActionButton(
            label: l10n.ondcAccountUnlink,
            icon: Icons.link_off,
            tone: ButtonTone.danger,
            onPressed: () => _unlink(context),
            spokenLabel: '${l10n.ondcAccountUnlink}. ${l10n.ondcUnlinkBody}',
          )
        else
          BigActionButton(
            label: l10n.ondcAccountLink,
            icon: Icons.link,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.ondc),
          ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: WholeWordText(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.muted),
            ),
          ),
          Expanded(
            child: WholeWordText(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
