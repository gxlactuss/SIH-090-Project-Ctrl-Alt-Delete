import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/recorder_service.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/hold_to_speak_button.dart';
import '../../../widgets/number_pad.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/screen_header.dart';

class CorrectionSheet extends StatefulWidget {
  const CorrectionSheet({super.key, required this.field});

  final ListingField field;

  static Future<void> show(BuildContext context, ListingField field) {
    final review = context.read<ReviewController>();
    final recorder = context.read<RecorderService>();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) => MultiProvider(
        providers: [
          ChangeNotifierProvider<ReviewController>.value(value: review),
          ChangeNotifierProvider<RecorderService>.value(value: recorder),
        ],
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: CorrectionSheet(field: field),
        ),
      ),
    );
  }

  @override
  State<CorrectionSheet> createState() => _CorrectionSheetState();
}

class _CorrectionSheetState extends State<CorrectionSheet> {
  bool _manual = false;
  bool _failedOnce = false;

  String _typed = '';

  String? _picked;

  bool get _hasManualValue => widget.field.fallback == Correction.chips
      ? _picked != null
      : _typed.isNotEmpty;

  Future<void> _record() async {
    final recorder = context.read<RecorderService>();
    final id = context.read<ReviewController>().listing.id;
    await context.read<SpeechService>().stop();
    await recorder.start('${Directory.systemTemp.path}/correction_$id.m4a');
  }

  Future<void> _stopAndSend() async {
    final recorder = context.read<RecorderService>();
    final review = context.read<ReviewController>();
    final path = await recorder.stop();

    if (path == null) {
      if (!mounted) return;
      setState(() {
        _failedOnce = true;
        _manual = widget.field.fallback != Correction.words;
      });
      return;
    }

    final saved = await review.correctByVoice(widget.field, path);
    await recorder.deleteFile(path);
    if (!mounted) return;

    if (saved) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _failedOnce = true;
      _manual = widget.field.fallback != Correction.words;
    });
  }

  Future<void> _saveManual() async {
    final review = context.read<ReviewController>();
    final Object? value = switch (widget.field.fallback) {
      Correction.number when widget.field == ListingField.price =>
        (int.tryParse(_typed) ?? 0) * 100,
      Correction.number => int.tryParse(_typed),
      Correction.chips => _picked,
      Correction.words => _typed,
    };
    if (value == null) return;

    final saved = await review.setField(widget.field, value);
    if (!mounted) return;
    if (saved) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final recorder = context.watch<RecorderService>();
    final title = l10n.correctTitle(widget.field.label(l10n).toLowerCase());

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ScreenHeader(title: title, spokenLines: [title]),
                      if (_failedOnce) ...[
                        const SizedBox(height: 10),
                        WholeWordText(
                          l10n.correctFailedOnce,
                          style: const TextStyle(
                            fontSize: 17,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      if (_manual)
                        _Fallback(
                          field: widget.field,
                          typed: _typed,
                          picked: _picked,
                          onDigit: (d) => setState(() => _typed += d),
                          onBackspace: () => setState(() {
                            if (_typed.isNotEmpty) {
                              _typed = _typed.substring(0, _typed.length - 1);
                            }
                          }),
                          onPick: (value) => setState(() => _picked = value),
                        )
                      else
                        _VoiceInput(recording: recorder.isRecording),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (_manual)
                BigActionButton(
                  label: l10n.correctSave,
                  icon: Icons.check,
                  busy: review.isBusy,
                  onPressed: _hasManualValue && !review.isBusy
                      ? _saveManual
                      : null,
                )
              else
                HoldToSpeakButton(
                  label: l10n.correctHoldToSpeak,
                  recording: recorder.isRecording,
                  onStart: _record,
                  onStop: _stopAndSend,
                ),
              const SizedBox(height: 10),
              if (widget.field.fallback != Correction.words)
                BigActionButton(
                  label: _manual ? l10n.correctUseVoice : l10n.correctUseKeypad,
                  icon: _manual ? Icons.mic : Icons.dialpad,
                  tone: ButtonTone.secondary,
                  onPressed: review.isBusy
                      ? null
                      : () => setState(() => _manual = !_manual),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: review.isBusy
                    ? null
                    : () => Navigator.of(context).pop(),
                child: WholeWordText(l10n.correctCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceInput extends StatelessWidget {
  const _VoiceInput({required this.recording});

  final bool recording;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: recording ? AppColors.terracotta : AppColors.border,
          width: recording ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        children: [
          Icon(
            recording ? Icons.graphic_eq : Icons.mic_none,
            size: 52,
            color: recording ? AppColors.terracotta : AppColors.muted,
          ),
          if (recording) ...[
            const SizedBox(height: 10),
            WholeWordText(
              l10n.correctListening,
              style: const TextStyle(fontSize: 18, color: AppColors.terracotta),
            ),
          ],
        ],
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({
    required this.field,
    required this.typed,
    required this.picked,
    required this.onDigit,
    required this.onBackspace,
    required this.onPick,
  });

  final ListingField field;
  final String typed;
  final String? picked;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (field.fallback == Correction.chips) {
      final options = field.chips(l10n);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WholeWordText(
            l10n.correctPick,
            style: const TextStyle(fontSize: 17, color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final option in options)
                _Chip(
                  label: option,
                  selected: option == picked,
                  onTap: () => onPick(option),
                ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 68,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: WholeWordText(
            typed.isEmpty
                ? '—'
                : (field == ListingField.price ? '₹$typed' : typed),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 12),
        NumberPad(onDigit: onDigit, onBackspace: onBackspace),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        onLongPress: () =>
            context.read<SpeechService>().speak(label, key: 'chip:$label'),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.terracotta.withValues(alpha: 0.16)
                : AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.terracotta : AppColors.border,
              width: selected ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 22, color: AppColors.terracotta),
                const SizedBox(width: 8),
              ],
              WholeWordText(
                label,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
