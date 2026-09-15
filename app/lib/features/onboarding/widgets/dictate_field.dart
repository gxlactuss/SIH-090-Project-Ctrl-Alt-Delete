import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_language.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/dictation_service.dart';
import '../../../services/permission_service.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/whole_word_text.dart';

class DictateField extends StatefulWidget {
  const DictateField({
    super.key,
    required this.controller,
    required this.label,
    required this.language,
    this.hint,
    this.errorText,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final AppLanguage language;
  final String? hint;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  @override
  State<DictateField> createState() => _DictateFieldState();
}

class _DictateFieldState extends State<DictateField> {
  bool _mine = false;

  bool _sawListening = false;

  bool _heardSomething = false;

  DictationService? _dictation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dictation = context.read<DictationService>();
    if (identical(dictation, _dictation)) return;
    _dictation?.removeListener(_onDictationChanged);
    _dictation = dictation..addListener(_onDictationChanged);
  }

  void _onDictationChanged() {
    if (!mounted || !_mine) return;
    final listening = _dictation?.isListening ?? false;
    if (listening) {
      if (!_sawListening) setState(() => _sawListening = true);
    } else if (_sawListening) {
      final heardNothing = !_heardSomething;
      setState(() {
        _mine = false;
        _sawListening = false;
        _heardSomething = false;
      });
      if (heardNothing) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: WholeWordText(
              AppLocalizations.of(context).dictationNothingHeard,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _dictation?.removeListener(_onDictationChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DictationService>().init();
    });
  }

  Future<void> _toggle() async {
    final dictation = context.read<DictationService>();
    final speech = context.read<SpeechService>();
    final permissions = context.read<PermissionService>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    if (_mine) {
      await dictation.stop();
      if (!mounted) return;
      setState(() {
        _mine = false;
        _sawListening = false;
      });
      return;
    }

    if (!dictation.isAvailable) {
      final outcome = await permissions.request(AppPermission.microphone);
      if (!mounted) return;
      if (outcome == PermissionOutcome.granted) {
        await dictation.init(force: true);
      }
      if (!mounted) return;
      if (!dictation.isAvailable) {
        messenger.showSnackBar(
          SnackBar(content: WholeWordText(l10n.dictationUnavailable)),
        );
        return;
      }
    }

    await speech.stop();
    if (!mounted) return;
    setState(() {
      _mine = true;
      _sawListening = false;
      _heardSomething = false;
    });
    await dictation.start(
      language: widget.language,
      onResult: (text) {
        if (text.isEmpty) return;
        _heardSomething = true;
        widget.controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
        widget.onChanged?.call(text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dictation = context.watch<DictationService>();
    final listening = _mine;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WholeWordText(
          widget.label,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                textCapitalization: widget.textCapitalization,
                style: const TextStyle(fontSize: 21, color: AppColors.ink),
                decoration: InputDecoration(
                  hint: switch (listening
                      ? l10n.profileListening
                      : widget.hint) {
                    final String hint => WholeWordText(
                      hint,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                    ),
                    null => null,
                  },
                  errorText: widget.errorText,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: l10n.profileSpeakToFill,
              child: SizedBox(
                width: 68,
                height: 68,
                child: Material(
                  color: listening
                      ? AppColors.terracotta
                      : AppColors.warningTint,
                  borderRadius: BorderRadius.circular(34),
                  child: InkWell(
                    onTap: _toggle,
                    borderRadius: BorderRadius.circular(34),
                    child: Icon(
                      listening ? Icons.stop : Icons.mic,
                      size: 32,
                      color: listening
                          ? Colors.white
                          : dictation.isChecked && !dictation.isAvailable
                          ? AppColors.muted
                          : AppColors.terracotta,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
