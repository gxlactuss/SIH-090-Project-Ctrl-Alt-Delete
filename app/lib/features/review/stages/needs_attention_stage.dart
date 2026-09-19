import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/listing_status.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/recorder_service.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/hold_to_speak_button.dart';
import '../../../widgets/speak_button.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class NeedsAttentionStage extends StatefulWidget {
  const NeedsAttentionStage({
    super.key,
    required this.onClose,
    required this.onReprocessing,
  });

  final VoidCallback onClose;

  final VoidCallback onReprocessing;

  @override
  State<NeedsAttentionStage> createState() => _NeedsAttentionStageState();
}

class _NeedsAttentionStageState extends State<NeedsAttentionStage> {
  String? _problem;

  bool _sendingPhotos = false;

  Future<void> _start() async {
    final recorder = context.read<RecorderService>();
    final id = context.read<ReviewController>().listing.id;
    final l10n = AppLocalizations.of(context);
    await context.read<SpeechService>().stop();
    if (!mounted) return;
    setState(() => _problem = null);
    final started = await recorder.start(
      '${Directory.systemTemp.path}/answer_$id.m4a',
    );
    if (!started && mounted) setState(() => _problem = l10n.attentionFailed);
  }

  Future<void> _stop() async {
    final l10n = AppLocalizations.of(context);
    final recorder = context.read<RecorderService>();
    final review = context.read<ReviewController>();

    if (!recorder.isRecording) return;
    final path = await recorder.stop();
    if (path == null) {
      if (mounted) setState(() => _problem = l10n.attentionFailed);
      return;
    }

    final sent = await review.submitAnswer(path);
    await recorder.deleteFile(path);
    if (!mounted) return;
    if (!sent) setState(() => _problem = l10n.attentionFailed);
  }

  Future<void> _retakePhotos() async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final review = context.read<ReviewController>();
    await context.read<SpeechService>().stop();
    if (!mounted) return;
    setState(() => _problem = null);

    final paths = await navigator.pushNamed<List<String>>(
      AppRoutes.retakePhotos,
    );
    if (!mounted || paths == null || paths.isEmpty) return;

    setState(() => _sendingPhotos = true);
    final sent = await review.submitPhotos(paths);
    if (!mounted) return;
    setState(() => _sendingPhotos = false);
    if (!sent) {
      setState(() => _problem = l10n.attentionRetakeFailed);
      return;
    }

    if (review.listing.status.isWorking) widget.onReprocessing();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final recorder = context.watch<RecorderService>();
    final question = review.listing.followUpQuestion ?? '';
    final photosFirst = review.listing.asksForPhotos;

    final answerByVoice = HoldToSpeakButton(
      label: l10n.attentionHoldToAnswer,
      recording: recorder.isRecording,
      onStart: _start,
      onStop: _stop,
    );

    final retake = BigActionButton(
      label: l10n.attentionRetakePhotos,
      icon: Icons.photo_camera,
      tone: photosFirst ? ButtonTone.primary : ButtonTone.secondary,
      busy: _sendingPhotos,
      onPressed: review.isBusy ? null : _retakePhotos,
    );

    return ReviewScaffold(
      title: l10n.attentionTitle,
      subtitle: l10n.attentionBody,
      spokenLines: [l10n.attentionTitle, question],
      busy: review.isBusy,
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.warningTint,
              border: Border.all(color: AppColors.marigold, width: 3),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WholeWordText(
                    question,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                SpeakButton(text: question, size: 34),
              ],
            ),
          ),
          if (_problem != null) ...[
            const SizedBox(height: 14),
            WholeWordText(
              _problem!,
              style: const TextStyle(fontSize: 18, color: AppColors.danger),
            ),
          ],
          if (review.isBusy) ...[
            const SizedBox(height: 18),
            WholeWordText(
              _sendingPhotos
                  ? l10n.attentionRetakeSending
                  : l10n.attentionAnswering,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: AppColors.muted),
            ),
          ],
        ],
      ),
      actions: photosFirst ? [retake, answerByVoice] : [answerByVoice, retake],
    );
  }
}
