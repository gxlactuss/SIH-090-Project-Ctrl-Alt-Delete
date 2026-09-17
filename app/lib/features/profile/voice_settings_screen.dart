import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/info_panel.dart';

class VoiceSettingsScreen extends StatelessWidget {
  const VoiceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final speech = context.watch<SpeechService>();

    return SettingsScaffold(
      title: l10n.voiceSettingsTitle,
      rows: [
        if (!speech.isAvailable) ...[
          InfoPanel(
            icon: Icons.volume_off,
            text: l10n.voiceUnavailable,
            speak: false,
          ),
          const SizedBox(height: 18),
        ],
        _SliderRow(
          label: l10n.voiceSpeed,
          low: l10n.voiceSpeedSlow,
          high: l10n.voiceSpeedFast,
          icon: Icons.speed,
          value: speech.speed,
          min: 0.4,
          max: 1.4,
          onChanged: state.setSpeechSpeed,
          onSettled: () => speech.speak(l10n.voiceSample, key: 'voice:sample'),
        ),
        const SizedBox(height: 24),
        SettingsToggle(
          label: l10n.voiceAutoRead,
          explain: l10n.voiceAutoReadWhy,
          value: speech.autoReadScreens,
          onChanged: state.setAutoReadScreens,
        ),
      ],
      actions: [
        BigActionButton(
          label: l10n.voiceTry,
          icon: Icons.volume_up,
          onPressed: speech.isAvailable
              ? () => speech.speak(l10n.voiceSample, key: 'voice:sample')
              : null,
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.low,
    required this.high,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onSettled,
  });

  final String label;
  final String low;
  final String high;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final VoidCallback onSettled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 26, color: AppColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: WholeWordText(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: 10,
          onChanged: onChanged,
          onChangeEnd: (_) => onSettled(),
        ),
        if (low.isNotEmpty || high.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WholeWordText(
                    low,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: WholeWordText(
                    high,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
