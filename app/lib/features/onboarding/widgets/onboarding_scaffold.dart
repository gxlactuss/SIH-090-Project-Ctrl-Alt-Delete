import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import 'step_line.dart';
import '../../../widgets/screen_header.dart';

class OnboardingScaffold extends StatefulWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.body,
    this.step,
    this.subtitle,
    this.spokenLines,
    this.actions = const [],
    this.showBack = true,
    this.onBack,
    this.trailing,
    this.scrollable = true,
    this.compact = false,
  });

  final int? step;

  final String title;
  final String? subtitle;

  final List<String?>? spokenLines;

  final Widget body;

  final List<Widget> actions;

  final bool showBack;
  final VoidCallback? onBack;

  final Widget? trailing;

  final bool scrollable;

  final bool compact;

  @override
  State<OnboardingScaffold> createState() => _OnboardingScaffoldState();
}

class _OnboardingScaffoldState extends State<OnboardingScaffold> {
  late SpeechService _speech;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _readAloudOnOpen());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = context.read<SpeechService>();
  }

  void _readAloudOnOpen() {
    if (!mounted) return;
    _speech.speakIfAuto(_spoken, key: 'screen:${widget.title}');
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final step = widget.step;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          spokenLines: _spoken,
          titleStyle: widget.compact
              ? theme.textTheme.headlineSmall
              : theme.textTheme.headlineMedium,
          subtitleStyle: widget.compact
              ? const TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: AppColors.muted,
                )
              : theme.textTheme.bodyLarge?.copyWith(color: AppColors.muted),
          subtitleGap: widget.compact ? 4 : 10,
          speakerSize: 34,
        ),
      ],
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        SizedBox(height: widget.compact ? 14 : 24),
        widget.body,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: widget.showBack && Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                tooltip: l10n.actionBack,
                onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [if (widget.trailing != null) widget.trailing!],
        bottom: step == null ? null : OnboardingStepLine(step: step),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: widget.scrollable
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.gutter,
                        8,
                        AppTheme.gutter,
                        24,
                      ),
                      child: body,
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.gutter,
                        8,
                        AppTheme.gutter,
                        0,
                      ),
                      child: body,
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
                    12,
                    AppTheme.gutter,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < widget.actions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
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
