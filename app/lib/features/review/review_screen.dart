import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../data/models/listing.dart';
import '../../data/remote/voice/voice_api.dart';
import '../../data/repositories/listing_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../core/di.dart';
import '../../services/analytics_service.dart';
import '../../services/recorder_service.dart';
import '../../state/app_state.dart';
import '../../state/catalog_controller.dart';
import '../../state/review_controller.dart';
import 'stages/consent_stage.dart';
import 'stages/needs_attention_stage.dart';
import 'stages/photos_stage.dart';
import 'stages/preview_stage.dart';
import 'stages/price_stage.dart';
import 'stages/publish_stage.dart';
import 'stages/read_back_stage.dart';
import 'stages/stock_stage.dart';
import 'stages/suggestions_stage.dart';
import '../../widgets/stage_switcher.dart';
import '../../widgets/confirm_dialog.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.listing, this.initialStage});

  final Listing listing;

  final ReviewStage? initialStage;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final RecorderService _recorder = RecorderService();
  late final ReviewController _review = ReviewController(
    listings: context.read<ListingRepository>(),
    listing: widget.listing,
    analytics: context.maybeRead<AnalyticsService>(),
    voice: context.maybeRead<VoiceApi>(),
    language: context.maybeRead<AppState>()?.language,
    initialStage: widget.initialStage,
  );

  CatalogController? _catalog;

  @override
  void initState() {
    super.initState();
    _review.addListener(_syncCatalog);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _catalog = context.maybeRead<CatalogController>();
  }

  void _syncCatalog() => _catalog?.replace(_review.listing);

  Future<void> _confirmLeave() async {
    final l10n = AppLocalizations.of(context);
    final editing = _review.isEdit;
    final title = editing ? l10n.editLeaveTitle : l10n.reviewLeaveTitle;
    final body = editing ? l10n.editLeaveBody : l10n.reviewLeaveBody;
    final confirm = editing ? l10n.editLeaveConfirm : l10n.reviewLeaveConfirm;

    final leave = await showSpokenConfirm(
      context,
      title: title,
      body: body,
      confirm: confirm,
      cancel: l10n.reviewLeaveCancel,
      tone: ConfirmTone.neutral,
      speechKey: 'review:leave',
    );

    if (leave && mounted) Navigator.of(context).pop();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _another() {
    final listing = _review.listing;
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.capture,
      arguments: listing.templateListingId ?? listing.id,
    );
  }

  @override
  void dispose() {
    _review.removeListener(_syncCatalog);
    _recorder.dispose();
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecorderService>.value(value: _recorder),
        ChangeNotifierProvider<ReviewController>.value(value: _review),
      ],
      child: Consumer<ReviewController>(
        builder: (context, review, _) {
          final publishing = review.stage == ReviewStage.publishing;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (publishing && review.isBusy) return;
              if (publishing) {
                _goHome();
                return;
              }
              _confirmLeave();
            },
            child: StageSwitcher(
              stage: review.stage,
              step: review.step,
              steps: review.stepCount,
              child: switch (review.stage) {
                ReviewStage.needsAttention => NeedsAttentionStage(
                  onClose: _confirmLeave,
                ),
                ReviewStage.readBack => ReadBackStage(
                  onClose: _confirmLeave,
                  onBack: review.listing.needsAttention ? review.back : null,
                ),
                ReviewStage.suggestions => SuggestionsStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.price => PriceStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.stock => StockStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.photos => PhotosStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.preview => PreviewStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.consent => ConsentStage(
                  onClose: _confirmLeave,
                  onBack: review.back,
                ),
                ReviewStage.publishing => PublishStage(
                  onDone: _goHome,
                  onAnother: _another,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
