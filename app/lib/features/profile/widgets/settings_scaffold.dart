import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/speak_button.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/screen_header.dart';

class SettingsScaffold extends StatefulWidget {
  const SettingsScaffold({
    super.key,
    required this.title,
    required this.rows,
    this.subtitle,
    this.spokenLines,
    this.actions = const [],
    this.busy = false,
  });

  final String title;
  final String? subtitle;
  final List<String?>? spokenLines;

  final List<Widget> rows;

  final List<Widget> actions;

  final bool busy;

  @override
  State<SettingsScaffold> createState() => _SettingsScaffoldState();
}

class _SettingsScaffoldState extends State<SettingsScaffold> {
  late SpeechService _speech;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _speech.speakIfAuto(_spoken, key: 'screen:${widget.title}');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = context.read<SpeechService>();
  }

  List<String?> get _spoken =>
      widget.spokenLines ?? [widget.title, widget.subtitle];

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: widget.busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(minHeight: 4),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.gutter,
                  0,
                  AppTheme.gutter,
                  24,
                ),
                children: [
                  ScreenHeader(
                    title: widget.title,
                    subtitle: widget.subtitle,
                    spokenLines: _spoken,
                    subtitleGap: 12,
                    subtitleStyle: const TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: widget.subtitle == null ? 12 : 18),
                  ...widget.rows,
                ],
              ),
            ),
            if (widget.actions.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.66,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.gutter,
                    10,
                    AppTheme.gutter,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < widget.actions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        widget.actions[i],
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.tone,
  });

  final IconData icon;
  final String label;

  final String? value;

  final VoidCallback onTap;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final colour = tone ?? AppColors.ink;

    return Semantics(
      button: true,
      label: value == null ? label : '$label. $value',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () => context.read<SpeechService>().speakAll([
          label,
          value,
        ], key: 'settings:$label'),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              Icon(icon, size: 28, color: colour),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WholeWordText(
                      label,
                      style: TextStyle(
                        fontSize: 19,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: colour,
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: 2),
                      WholeWordText(
                        value!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 28, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsToggle extends StatelessWidget {
  const SettingsToggle({
    super.key,
    required this.label,
    required this.explain,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String explain;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colour = enabled ? AppColors.ink : AppColors.muted;

    return Semantics(
      toggled: value,
      label: '$label. $explain',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: enabled ? () => onChanged(!value) : null,
        onLongPress: () => context.read<SpeechService>().speakAll([
          label,
          explain,
        ], key: 'toggle:$label'),
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: value && enabled ? AppColors.success : AppColors.border,
              width: value && enabled ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                value ? Icons.check_box : Icons.check_box_outline_blank,
                size: 34,
                color: value && enabled ? AppColors.success : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholeWordText(
                      label,
                      style: TextStyle(
                        fontSize: 19,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: colour,
                      ),
                    ),
                    const SizedBox(height: 4),
                    WholeWordText(
                      explain,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              SpeakButton.lines(lines: [label, explain], size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
