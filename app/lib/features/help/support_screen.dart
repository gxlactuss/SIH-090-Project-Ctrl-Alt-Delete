import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../profile/widgets/settings_scaffold.dart';
import 'help_content.dart';
import '../../widgets/whole_word_text.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _open(BuildContext context, Uri uri) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final speech = context.read<SpeechService>();

    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (opened) return;

    await Clipboard.setData(const ClipboardData(text: Support.phone));
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.supportFailed(Support.phone))),
    );
    await speech.speak(
      l10n.supportFailed(Support.phone),
      key: 'support:failed',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const hasNumber = Support.phone != '';

    return SettingsScaffold(
      title: l10n.supportTitle,
      subtitle: l10n.supportBody,
      spokenLines: [
        l10n.supportTitle,
        l10n.supportBody,
        if (hasNumber) l10n.supportNumber(Support.phone),
        l10n.supportHours,
      ],
      rows: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasNumber)
                Row(
                  children: [
                    const Icon(
                      Icons.phone_in_talk_outlined,
                      size: 28,
                      color: AppColors.terracotta,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WholeWordText(
                        Support.phone,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    SpeakButton(
                      text: l10n.supportNumber(Support.phone),
                      size: 30,
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 24, color: AppColors.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WholeWordText(
                      l10n.supportHours,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      actions: [
        if (hasNumber)
          BigActionButton(
            label: l10n.supportCall,
            icon: Icons.call,
            onPressed: () =>
                _open(context, Uri.parse('tel:${Support.dialable}')),
            spokenLabel:
                '${l10n.supportCall}. ${l10n.supportNumber(Support.phone)}',
          ),
        if (hasNumber)
          BigActionButton(
            label: l10n.supportWhatsApp,
            icon: Icons.chat,
            tone: ButtonTone.secondary,
            onPressed: () => _open(
              context,
              Uri.parse(
                'https://wa.me/${Support.dialable.replaceAll('+', '')}',
              ),
            ),
          ),
      ],
    );
  }
}
