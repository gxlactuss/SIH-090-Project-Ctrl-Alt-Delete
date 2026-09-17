import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/stage_switcher.dart';
import '../../../widgets/screen_header.dart';

class ReviewScaffold extends StatefulWidget {
  const ReviewScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.spokenLines,
    this.actions = const [],
    this.onBack,
    this.onClose,
    this.busy = false,
  });

  final String title;
  final String? subtitle;
  final List<String?>? spokenLines;
  final Widget body;
  final List<Widget> actions;

  final VoidCallback? onBack;

  final VoidCallback? onClose;

  final bool busy;

  @override
  State<ReviewScaffold> createState() => _ReviewScaffoldState();
}

class _ReviewScaffoldState extends State<ReviewScaffold> {
  late SpeechService _speech;

  bool _inStages = false;

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
    _inStages = StageSwitcher.owns(context);
  }

  List<String?> get _spoken =>
      widget.spokenLines ?? [widget.title, widget.subtitle];

  @override
  void dispose() {
    if (!_inStages) _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = StageSwitcher.progressOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                onPressed: widget.onBack,
              ),
        actions: [
          if (widget.onClose != null)
            IconButton(
              icon: const Icon(Icons.close, size: 30),
              onPressed: widget.onClose,
            ),
        ],
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
            if (progress != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.gutter,
                  2,
                  AppTheme.gutter,
                  8,
                ),
                child: progress,
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.gutter,
                  4,
                  AppTheme.gutter,
                  20,
                ),
                children: [
                  ScreenHeader(
                    title: widget.title,
                    subtitle: widget.subtitle,
                    spokenLines: _spoken,
                  ),
                  const SizedBox(height: 18),
                  widget.body,
                ],
              ),
            ),
            if (widget.actions.isNotEmpty)
              Padding(
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
          ],
        ),
      ),
    );
  }
}
