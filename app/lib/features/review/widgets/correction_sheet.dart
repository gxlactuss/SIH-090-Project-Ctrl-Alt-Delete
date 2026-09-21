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

  bool _typing = false;

  final TextEditingController _text = TextEditingController();

  bool get _hasManualValue {
    if (_typing || widget.field.fallback == Correction.words) {
      return _text.text.trim().isNotEmpty;
    }
    return widget.field.fallback == Correction.chips
        ? _picked != null
        : _typed.isNotEmpty;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

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
    final written = _text.text.trim();
    final useWritten = _typing || widget.field.fallback == Correction.words;

    final Object? value = switch (widget.field.fallback) {
      Correction.number when useWritten =>
        ReviewController.valueFromSpeech(widget.field, written),
      Correction.number when widget.field == ListingField.price =>
        (int.tryParse(_typed) ?? 0) * 100,
      Correction.number => int.tryParse(_typed),
      Correction.chips => useWritten ? written : _picked,
      Correction.words => written,
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
                          review.heard == null
                              ? l10n.correctFailedOnce
                              : l10n.correctHeard(review.heard!),
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
                          typing: _typing || widget.field.fallback == Correction.words,
                          controller: _text,
                          onTextChanged: () => setState(() {}),
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
              BigActionButton(
                label: _manual ? l10n.correctUseVoice : l10n.correctUseKeypad,
                icon: _manual ? Icons.mic : Icons.keyboard,
                tone: ButtonTone.secondary,
                onPressed: review.isBusy
                    ? null
                    : () => setState(() {
                        _manual = !_manual;

                        if (_manual &&
                            widget.field.fallback == Correction.words) {
                          _typing = true;
                        }
                      }),
              ),

              if (_manual && widget.field.fallback != Correction.words) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: review.isBusy
                      ? null
                      : () => setState(() => _typing = !_typing),
                  icon: Icon(_typing ? Icons.dialpad : Icons.keyboard),
                  label: WholeWordText(
                    _typing
                        ? (widget.field.fallback == Correction.chips
                              ? l10n.correctPick
                              : l10n.correctUseKeypad)
                        : l10n.correctTypeHint,
                  ),
                ),
              ],
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
    required this.typing,
    required this.controller,
    required this.onTextChanged,
    required this.typed,
    required this.picked,
    required this.onDigit,
    required this.onBackspace,
    required this.onPick,
  });

  final ListingField field;
  final bool typing;
  final TextEditingController controller;
  final VoidCallback onTextChanged;
  final String typed;
  final String? picked;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (typing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            onChanged: (_) => onTextChanged(),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: field.fallback == Correction.number
                ? TextInputType.number
                : TextInputType.text,
            maxLines: field.fallback == Correction.words ? 3 : 1,
            minLines: 1,
            style: const TextStyle(fontSize: 24, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: l10n.correctTypeHint,
              hintStyle: const TextStyle(fontSize: 20, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              prefixText: field == ListingField.price ? '₹ ' : null,
              prefixStyle: const TextStyle(fontSize: 24, color: AppColors.ink),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: const BorderSide(
                  color: AppColors.terracotta,
                  width: 3,
                ),
              ),
            ),
          ),
        ],
      );
    }

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
                ? '-'
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
