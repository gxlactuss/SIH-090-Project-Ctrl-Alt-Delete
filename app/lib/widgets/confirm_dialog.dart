import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../services/speech_service.dart';
import 'speak_button.dart';
import 'whole_word_text.dart';

enum ConfirmTone { danger, neutral, primary }

Future<bool> showSpokenConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
  required String cancel,
  ConfirmTone tone = ConfirmTone.danger,
  String? speechKey,
}) async {
  final speech = context.read<SpeechService>();
  final key = speechKey ?? 'confirm:$title';

  await speech.stop();
  await speech.speakIfAuto([title, body], key: key);

  if (!context.mounted) return false;
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) {
      void answerWith(bool value) => Navigator.of(context).pop(value);

      final Widget yes = switch (tone) {
        ConfirmTone.primary => FilledButton(
          onPressed: () => answerWith(true),
          child: WholeWordText(confirm),
        ),
        ConfirmTone.danger => TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          onPressed: () => answerWith(true),
          child: WholeWordText(confirm),
        ),
        ConfirmTone.neutral => TextButton(
          onPressed: () => answerWith(true),
          child: WholeWordText(confirm),
        ),
      };

      return AlertDialog(
        scrollable: true,
        backgroundColor: AppColors.surface,
        title: WholeWordText(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WholeWordText(
              body,
              style: const TextStyle(fontSize: 18, height: 1.35),
            ),
            const SizedBox(height: 8),
            SpeakButton.lines(
              lines: [title, body],
              utteranceKey: key,
              size: 30,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => answerWith(false),
            child: WholeWordText(cancel),
          ),
          yes,
        ],
      );
    },
  );
  return answer ?? false;
}
