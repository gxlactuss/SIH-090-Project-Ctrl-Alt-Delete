import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, this.storeUrl});

  final String? storeUrl;

  Future<void> _open(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final speech = context.read<SpeechService>();
    final url = storeUrl;

    var opened = false;
    if (url != null) {
      try {
        opened = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        opened = false;
      }
    }
    if (opened) return;

    messenger.showSnackBar(SnackBar(content: WholeWordText(l10n.updateFailed)));
    await speech.speak(l10n.updateFailed, key: 'update:failed');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.gutter),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: AppColors.warningTint,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.system_update,
                        size: 58,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 26),
                    WholeWordText(
                      l10n.updateTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    WholeWordText(
                      l10n.updateBody,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.45,
                        color: AppColors.muted,
                      ),
                    ),
                    SpeakButton.lines(
                      lines: [l10n.updateTitle, l10n.updateBody],
                      utteranceKey: 'screen:update',
                      size: 34,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: BigActionButton(
                        label: l10n.updateAction,
                        icon: Icons.download,
                        onPressed: () => _open(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
