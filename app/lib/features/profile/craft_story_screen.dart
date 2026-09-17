import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/dictation_service.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/hold_to_speak_button.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/info_panel.dart';

class CraftStoryScreen extends StatefulWidget {
  const CraftStoryScreen({super.key});

  @override
  State<CraftStoryScreen> createState() => _CraftStoryScreenState();
}

class _CraftStoryScreenState extends State<CraftStoryScreen> {
  late final _story = TextEditingController(
    text: context.read<AppState>().profile?.craftStory ?? '',
  );

  String _beforeDictation = '';
  bool _saving = false;

  @override
  void dispose() {
    _story.dispose();
    super.dispose();
  }

  Future<void> _startDictation() async {
    final dictation = context.read<DictationService>();
    final language = context.read<AppState>().language;
    await context.read<SpeechService>().stop();

    _beforeDictation = _story.text.trimRight();
    await dictation.start(
      language: language,
      onResult: (text) {
        final addition = text.trim();
        if (addition.isEmpty) return;
        setState(() {
          _story.text = _beforeDictation.isEmpty
              ? addition
              : '$_beforeDictation $addition';
          _story.selection = TextSelection.collapsed(
            offset: _story.text.length,
          );
        });
      },
    );
  }

  Future<void> _stopDictation() async {
    await context.read<DictationService>().stop();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    await state.updateProfile(craftStory: _story.text.trim());

    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.editProfileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dictation = context.watch<DictationService>();

    return SettingsScaffold(
      title: l10n.storyTitle,
      subtitle: l10n.storyBody,
      spokenLines: [l10n.storyTitle, l10n.storyBody, l10n.storyExample],
      busy: _saving,
      rows: [
        InfoPanel(
          icon: Icons.lightbulb_outline,
          text: l10n.storyExample,
          dense: true,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _story,
          maxLines: 8,
          minLines: 5,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 19, height: 1.45),
          decoration: InputDecoration(
            hint: WholeWordText(
              l10n.storyEmpty,
              style: Theme.of(context).inputDecorationTheme.hintStyle,
            ),
            helper: WholeWordText(
              l10n.storyEditHint,
              style: const TextStyle(
                fontSize: AppTheme.minTextSize,
                color: AppColors.muted,
              ),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (dictation.isChecked && !dictation.isAvailable) ...[
          const SizedBox(height: 12),
          WholeWordText(
            l10n.dictationUnavailable,
            style: const TextStyle(fontSize: 16, color: AppColors.danger),
          ),
        ],
      ],
      actions: [
        HoldToSpeakButton(
          label: dictation.isListening
              ? l10n.profileListening
              : l10n.storyHoldToSpeak,
          recording: dictation.isListening,
          onStart: _startDictation,
          onStop: _stopDictation,
        ),
        BigActionButton(
          label: l10n.editProfileSave,
          icon: Icons.check,
          tone: ButtonTone.secondary,
          busy: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}
