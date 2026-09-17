import 'package:flutter/foundation.dart';

import '../core/constants/review_constants.dart';
import '../data/models/fact_sheet.dart';
import '../data/models/listing.dart';
import '../data/models/listing_status.dart';
import '../data/models/suggestion.dart';
import '../data/repositories/listing_repository.dart';
import '../services/analytics_service.dart';

enum ReviewStage {
  needsAttention,

  readBack,

  suggestions,

  price,

  stock,

  photos,

  preview,

  consent,

  publishing,
}

class ReviewController extends ChangeNotifier {
  ReviewController({
    required this._listings,
    required Listing listing,
    this._analytics,
    ReviewStage? initialStage,
  }) : _listing = listing,
       _isEdit = listing.status.wasPublished {
    _stage =
        initialStage ??
        (listing.needsAttention
            ? ReviewStage.needsAttention
            : ReviewStage.readBack);
  }

  final bool _isEdit;
  bool get isEdit => _isEdit;

  final ListingRepository _listings;

  final AnalyticsService? _analytics;

  Listing _listing;
  Listing get listing => _listing;

  late ReviewStage _stage;
  ReviewStage get stage => _stage;

  bool _busy = false;

  bool get isBusy => _busy;

  Object? _error;
  Object? get error => _error;

  bool get isPublished => _listing.status == ListingStatus.published;

  FactSheet get factSheet => _listing.factSheet;

  List<ListingField> get fields => ListingField.values;

  bool isSaid(ListingField field) => factSheet.value(field) != null;

  int get priceFloorInPaise {
    final fromServer = _listing.priceFloorInPaise;
    if (fromServer != null) return fromServer;

    final materials = factSheet.materialCostInPaise ?? 0;
    final hours = factSheet.hoursToMake ?? 0;
    return materials + (hours * ReviewConstants.hourlyRateInPaise).round();
  }

  int get suggestedPriceInPaise =>
      _listing.suggestedPriceInPaise ??
      (priceFloorInPaise * ReviewConstants.bandLowMultiplier).round();

  int get bandLowInPaise =>
      (priceFloorInPaise * ReviewConstants.bandLowMultiplier).round();

  int get bandHighInPaise =>
      (priceFloorInPaise * ReviewConstants.bandHighMultiplier).round();

  bool isBelowFloor(int priceInPaise) => priceInPaise < priceFloorInPaise;

  final Map<String, bool> _decisions = {};

  Map<String, bool> get decisions => Map.unmodifiable(_decisions);

  List<Suggestion> get suggestions => _listing.suggestions;

  int get answeredSuggestions => _listing.suggestions
      .where((s) => s.accepted != null || _decisions.containsKey(s.id))
      .length;

  void answerSuggestion(String id, bool accepted) {
    _decisions[id] = accepted;
    _analytics?.log(
      AnalyticsEvent.suggestionAnswered,
      properties: {'suggestion': id, 'accepted': accepted},
    );
    notifyListeners();
  }

  void skipSuggestion(String id) {
    _decisions.remove(id);
    _skipped.add(id);
    notifyListeners();
  }

  final Set<String> _skipped = {};

  bool isSkipped(String id) => _skipped.contains(id);

  Suggestion? get nextSuggestion {
    for (final suggestion in _listing.suggestions) {
      final decided = _decisions.containsKey(suggestion.id);
      if (suggestion.accepted == null &&
          !decided &&
          !isSkipped(suggestion.id)) {
        return suggestion;
      }
    }
    return null;
  }

  void goTo(ReviewStage stage) {
    if (_stage == stage) return;
    _stage = stage;
    _error = null;
    notifyListeners();
  }

  static const List<ReviewStage> _fullOrder = [
    ReviewStage.needsAttention,
    ReviewStage.readBack,
    ReviewStage.suggestions,
    ReviewStage.price,
    ReviewStage.stock,
    ReviewStage.photos,
    ReviewStage.preview,
    ReviewStage.consent,
    ReviewStage.publishing,
  ];

  static final List<ReviewStage> _editOrder = List.unmodifiable([
    for (final stage in _fullOrder)
      if (stage != ReviewStage.needsAttention && stage != ReviewStage.consent)
        stage,
  ]);

  List<ReviewStage> get _order => _isEdit ? _editOrder : _fullOrder;

  List<ReviewStage> get _steps => [
    for (final stage in _order)
      if (stage != ReviewStage.needsAttention &&
          stage != ReviewStage.publishing)
        stage,
  ];

  int get stepCount => _steps.length;

  int? get step {
    if (_stage == ReviewStage.needsAttention) return 1;
    final index = _steps.indexOf(_stage);
    return index < 0 ? null : index + 1;
  }

  void next() {
    final index = _order.indexOf(_stage);
    if (index == -1 || index + 1 >= _order.length) return;

    var nextStage = _order[index + 1];
    if (nextStage == ReviewStage.suggestions && nextSuggestion == null) {
      nextStage = ReviewStage.price;
    }
    goTo(nextStage);

    if (_isEdit && nextStage == ReviewStage.publishing) republish();
  }

  void back() {
    final index = _order.indexOf(_stage);
    if (index <= 0) return;
    var previous = _order[index - 1];
    if (previous == ReviewStage.suggestions && _listing.suggestions.isEmpty) {
      previous = ReviewStage.readBack;
    }
    if (previous == ReviewStage.needsAttention && !_listing.needsAttention) {
      previous = ReviewStage.readBack;
    }
    goTo(previous);
  }

  Future<bool> submitAnswer(String voiceReplyPath) => _call(
    () => _listings.answer(
      listingId: _listing.id,
      voiceReplyPath: voiceReplyPath,
    ),
    then: () {
      _analytics?.log(
        AnalyticsEvent.questionAsked,
        properties: {'listingId': _listing.id},
      );
      if (!_listing.needsAttention) _stage = ReviewStage.readBack;
    },
  );

  Future<bool> correctByVoice(ListingField field, String voiceReplyPath) =>
      _call(
        () => _listings.answer(
          listingId: _listing.id,
          voiceReplyPath: voiceReplyPath,
          field: field.name,
        ),
        then: () => _analytics?.log(
          AnalyticsEvent.fieldCorrected,
          properties: {'listingId': _listing.id, 'field': field.name},
        ),
      );

  Future<bool> setField(ListingField field, Object? value) => _call(
    () => _listings.patch(listingId: _listing.id, changes: {field.name: value}),
  );

  Future<bool> setOneOfAKind(bool value) => _call(
    () => _listings.patch(
      listingId: _listing.id,
      changes: {
        'isOneOfAKind': value,
        if (value) ListingField.quantity.name: 1,
      },
    ),
  );

  Future<bool> setPhotoOrder(List<String> imageUrls) => _call(
    () => _listings.patch(
      listingId: _listing.id,
      changes: {'imageUrls': imageUrls},
    ),
  );

  Future<bool> submitSuggestions() {
    if (_decisions.isEmpty) return Future.value(true);
    return _call(
      () => _listings.resolveSuggestions(
        listingId: _listing.id,
        decisions: Map.of(_decisions),
      ),
      then: _decisions.clear,
    );
  }

  Future<bool> publish({
    required bool photoConsent,
    required bool storyConsent,
  }) => _call(
    () => _listings.publish(
      listingId: _listing.id,
      photoConsent: photoConsent,
      storyConsent: storyConsent,
    ),
    then: () {
      _wentLive = true;
      _analytics?.listingPublished(_listing.id);
    },
  );

  Future<bool> republish() => _call(
    () => _listings.republish(_listing.id),
    then: () {
      _wentLive = true;
      _analytics?.log(
        AnalyticsEvent.listingRepublished,
        properties: {'listingId': _listing.id},
      );
    },
  );

  bool _wentLive = false;
  bool get wentLive => _wentLive;

  Future<bool> _call(
    Future<Listing> Function() call, {
    void Function()? then,
  }) async {
    _busy = true;
    _error = null;
    _wentLive = false;
    notifyListeners();

    try {
      _listing = await call();
      then?.call();
      return true;
    } catch (error) {
      _error = error;
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
