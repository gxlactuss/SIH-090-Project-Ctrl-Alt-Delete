import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/speech_service.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({
    super.key,
    required this.text,
    this.utteranceKey,
    this.size = 30,
    this.color,
  });

  const SpeakButton.lines({
    super.key,
    required List<String?> lines,
    this.utteranceKey,
    this.size = 30,
    this.color,
  }) : text = lines;

  final Object text;
  final String? utteranceKey;
  final double size;
  final Color? color;

  List<String?> get _lines =>
      text is String ? [text as String] : (text as List<String?>);

  @override
  Widget build(BuildContext context) {
    final id = utteranceKey ?? _lines.whereType<String>().join('|');

    final (available, isSpeaking) = context.select(
      (SpeechService s) => (s.isAvailable, s.speakingKey == id),
    );
    if (!available) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);

    return IconButton(
      onPressed: () => context.read<SpeechService>().speakAll(_lines, key: id),
      tooltip: isSpeaking ? l10n.actionStopListening : l10n.actionListen,
      icon: Icon(
        isSpeaking ? Icons.stop_circle : Icons.volume_up,
        size: size,
        color: color ?? (isSpeaking ? AppColors.terracotta : AppColors.muted),
      ),
      style: IconButton.styleFrom(
        backgroundColor: isSpeaking
            ? AppColors.terracotta.withValues(alpha: 0.12)
            : null,
      ),
    );
  }
}
