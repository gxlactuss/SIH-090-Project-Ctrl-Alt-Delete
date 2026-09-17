import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/stage_switcher.dart';
import '../../../widgets/screen_header.dart';

class CaptureScaffold extends StatefulWidget {
  const CaptureScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.spokenLines,
    this.actions = const [],
    this.onClose,
    this.trailing,
    this.scrollable = true,
    this.padBody = true,
    this.banner,
  });

  final String title;
  final String? subtitle;

  final List<String?>? spokenLines;

  final Widget body;

  final List<Widget> actions;

  final VoidCallback? onClose;

  final Widget? trailing;

  final bool scrollable;

  final bool padBody;

  final Widget? banner;

  @override
  State<CaptureScaffold> createState() => _CaptureScaffoldState();
}

class _CaptureScaffoldState extends State<CaptureScaffold> {
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

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (progress != null) ...[progress, const SizedBox(height: 10)],
        ScreenHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          spokenLines: _spoken,
        ),
      ],
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.banner != null) ...[
          Padding(
            padding: widget.padBody
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: AppTheme.gutter),
            child: widget.banner!,
          ),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: widget.padBody
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: AppTheme.gutter),
          child: widget.scrollable
              ? header
              : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.2,
                  ),
                  child: SingleChildScrollView(child: header),
                ),
        ),
        const SizedBox(height: 14),
        widget.scrollable ? widget.body : Expanded(child: widget.body),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.onClose == null
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: widget.onClose,
              ),
        actions: [if (widget.trailing != null) widget.trailing!],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: widget.scrollable
                  ? SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        widget.padBody ? AppTheme.gutter : 0,
                        4,
                        widget.padBody ? AppTheme.gutter : 0,
                        20,
                      ),
                      child: body,
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(
                        widget.padBody ? AppTheme.gutter : 0,
                        4,
                        widget.padBody ? AppTheme.gutter : 0,
                        0,
                      ),
                      child: body,
                    ),
            ),
            if (widget.actions.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.gutter,
                    12,
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
