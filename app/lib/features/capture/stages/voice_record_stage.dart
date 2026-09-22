import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/player_service.dart';
import '../../../services/recorder_service.dart';
import '../../../services/speech_service.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/hold_to_speak_button.dart';
import '../widgets/capture_scaffold.dart';
import '../widgets/waveform.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/info_panel.dart';

class VoiceRecordStage extends StatefulWidget {
  const VoiceRecordStage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<VoiceRecordStage> createState() => _VoiceRecordStageState();
}

List<String> _guidePoints(AppLocalizations l10n) => [
  l10n.voiceGuideWhat,
  l10n.voiceGuideColour,
  l10n.voiceGuideSize,
  l10n.voiceGuideTime,
  l10n.voiceGuideCost,
];

class _VoiceRecordStageState extends State<VoiceRecordStage> {
  String? _problem;

  bool _busy = false;

  bool _capped = false;

  bool _typing = false;

  late final TextEditingController _typed;

  @override
  void initState() {
    super.initState();
    _typed = TextEditingController(
      text: context.read<CaptureController>().typedDescription,
    );
  }

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _problem = null;
      _capped = false;
    });

    final l10n = AppLocalizations.of(context);
    final capture = context.read<CaptureController>();
    final player = context.read<PlayerService>();
    await context.read<SpeechService>().stop();
    await player.stop();
    final started = await capture.startRecording();

    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!started) _problem = l10n.voiceFailed;
    });
  }

  Future<void> _finishCapped() async {
    if (!mounted) return;
    final capture = context.read<CaptureController>();
    setState(() => _busy = true);
    await capture.stopRecording();
    if (!mounted) return;
    setState(() => _busy = false);
  }

  Future<void> _stop() async {
    final recorder = context.read<RecorderService>();
    if (!recorder.isRecording || _busy) return;

    final l10n = AppLocalizations.of(context);
    final capture = context.read<CaptureController>();
    final tooShort =
        recorder.elapsed.inSeconds < AppConstants.minVoiceNoteSeconds;

    setState(() => _busy = true);
    await capture.stopRecording();

    if (!mounted) return;
    if (tooShort) {
      await capture.recordAgain();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _problem = l10n.voiceTooShort;
      });
      return;
    }
    setState(() => _busy = false);
  }

  void _setTyping(bool typing) {
    context.read<SpeechService>().stop();
    setState(() {
      _typing = typing;
      _problem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recorder = context.watch<RecorderService>();
    final capture = context.watch<CaptureController>();
    final player = context.watch<PlayerService>();

    final take = recorder.isRecording ? null : capture.voiceNotePath;
    final playing = take != null && player.isPlaying && player.path == take;
    final live = recorder.isRecording || playing;

    final elapsed = recorder.elapsed.inSeconds;
    if (recorder.limitReached && !_capped) {
      _capped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _finishCapped());
    }

    final backToPhotos = BigActionButton(
      label: l10n.voiceBackToPhotos,
      icon: Icons.arrow_back,
      tone: ButtonTone.secondary,
      onPressed: recorder.isRecording || capture.isSaving
          ? null
          : capture.backToPhotos,
    );

    if (_typing) {
      return CaptureScaffold(
        title: l10n.voiceTypeTitle,
        subtitle: l10n.voiceBody,
        onClose: widget.onClose,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _typed,
              autofocus: true,
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 20,
                height: 1.4,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(hintText: l10n.voiceTypeHint),
            ),
            const SizedBox(height: 18),
            const _GuidePanel(),
          ],
        ),
        actions: [
          BigActionButton(
            label: l10n.voiceTypeSave,
            icon: Icons.check,
            busy: capture.isSaving,
            onPressed: _typed.text.trim().isEmpty || capture.isSaving
                ? null
                : () => capture.saveTyped(_typed.text),
          ),
          BigActionButton(
            label: l10n.voiceSpeakInstead,
            icon: Icons.mic,
            tone: ButtonTone.secondary,
            onPressed: capture.isSaving ? null : () => _setTyping(false),
          ),
          backToPhotos,
        ],
      );
    }

    return CaptureScaffold(
      title: l10n.voiceTitle,
      subtitle: l10n.voiceBody,
      spokenLines: [
        l10n.voiceTitle,
        l10n.voiceBody,
        l10n.voiceGuideTitle,
        ..._guidePoints(l10n),
      ],
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_problem != null) ...[
            _Problem(message: _problem!),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color: live ? AppColors.terracotta : AppColors.border,
                width: live ? 3 : 2,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              children: [
                Waveform(
                  level: recorder.isRecording
                      ? recorder.level
                      : (playing ? 0.8 : 0),
                  active: live,
                ),
                const SizedBox(height: 10),
                WholeWordText(
                  l10n.voiceElapsed(elapsed, AppConstants.maxVoiceNoteSeconds),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: recorder.isRecording
                        ? AppColors.terracotta
                        : AppColors.muted,
                  ),
                ),
                if (recorder.isRecording) ...[
                  const SizedBox(height: 4),
                  WholeWordText(
                    l10n.voiceRecording,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                    ),
                  ),
                ],
                if (take != null) ...[
                  const SizedBox(height: 14),
                  if (!player.isAvailable)
                    WholeWordText(
                      l10n.playbackUnavailable,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    )
                  else
                    BigActionButton(
                      label: playing ? l10n.playbackStop : l10n.playbackPlay,
                      icon: playing ? Icons.stop : Icons.play_arrow,
                      tone: ButtonTone.secondary,
                      onPressed: () => player.toggle(take),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _GuidePanel(),
        ],
      ),
      actions: [
        if (take != null)
          BigActionButton(
            label: l10n.playbackAccept,
            icon: Icons.check,
            busy: capture.isSaving,
            onPressed: capture.isSaving
                ? null
                : () async {
                    await player.stop();
                    await capture.save();
                  },
          ),
        HoldToSpeakButton(
          label: take != null ? l10n.playbackAgain : l10n.voiceHoldToSpeak,
          recording: recorder.isRecording,
          onStart: _start,
          onStop: _stop,
        ),
        BigActionButton(
          label: l10n.voiceTypeInstead,
          icon: Icons.keyboard,
          tone: ButtonTone.secondary,
          onPressed: recorder.isRecording ? null : () => _setTyping(true),
        ),
        backToPhotos,
      ],
    );
  }
}

class _GuidePanel extends StatelessWidget {
  const _GuidePanel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 24,
                color: AppColors.marigold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: WholeWordText(
                  l10n.voiceGuideTitle,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final point in _guidePoints(l10n)) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.terracotta,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: WholeWordText(
                      point,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Problem extends StatelessWidget {
  const _Problem({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.error_outline,
      text: message,
      tone: InfoTone.danger,
      bordered: true,
      speak: false,
      textStyle: const TextStyle(
        fontSize: 18,
        height: 1.35,
        color: AppColors.ink,
      ),
    );
  }
}
