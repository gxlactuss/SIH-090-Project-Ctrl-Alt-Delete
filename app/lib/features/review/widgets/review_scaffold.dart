import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/catalog_controller.dart';
import '../../../state/discard_listing.dart';
import '../../../state/queue_controller.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/confirm_dialog.dart';
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

Future<void> _confirmCancel(
  BuildContext context,
  ReviewController review,
) async {
  final l10n = AppLocalizations.of(context);

  final confirmed = await showSpokenConfirm(
    context,
    title: l10n.listingCancelTitle,
    body: l10n.listingCancelBody,
    confirm: l10n.listingCancelConfirm,
    cancel: l10n.listingCancelKeep,
    tone: ConfirmTone.delete,
    speechKey: 'review:cancelListing',
  );
  if (!confirmed || !context.mounted) return;

  final navigator = Navigator.of(context);
  final queue = context.read<QueueController?>();
  final catalog = context.read<CatalogController?>();
  final listingId = review.listing.id;

  await dropQueuedCapture(queue, listingId);
  await review.cancelListing();
  catalog?.forget(listingId);

  navigator.popUntil((route) => route.isFirst);
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
    final review = context.watch<ReviewController?>();

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
          if (review != null &&
              review.stage != ReviewStage.publishing &&
              !review.isPublished)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 30),
              color: AppColors.delete,
              tooltip: AppLocalizations.of(context).listingCancelAction,
              onPressed: widget.busy || review.isBusy
                  ? null
                  : () => _confirmCancel(context, review),
            ),
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
