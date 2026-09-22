import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/core/constants/review_constants.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/sale.dart';
import 'package:kirtikar/data/models/seller_profile.dart';
import 'package:kirtikar/data/models/suggestion.dart';
import 'package:kirtikar/data/remote/api_client.dart';
import 'package:kirtikar/data/repositories/listing_repository.dart';
import 'package:kirtikar/state/review_controller.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.current);

  Listing current;
  bool failNext = false;

  final List<Map<String, Object?>> patches = [];
  Map<String, bool>? lastDecisions;
  ({bool photo, bool story})? publishedWith;
  String? lastAnsweredField;

  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
    String? transcript,
  }) async {
    if (failNext) throw Exception('no network');
    lastAnsweredField = field;
    if (field == null) {
      return current = current.copyWith(
        status: ListingStatus.ready,
        clearFollowUpQuestion: true,
        factSheet: current.factSheet.copyWith(size: '12 inches'),
        description: 'A handmade piece.',
      );
    }
    final parsed = ListingField.values.firstWhere((f) => f.name == field);
    return current = current.copyWith(
      factSheet: current.factSheet.withField(parsed, 'heard by voice'),
    );
  }

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) async {
    if (failNext) throw Exception('no network');
    patches.add(changes);
    var sheet = current.factSheet;
    for (final entry in changes.entries) {
      final field = ListingField.values
          .where((f) => f.name == entry.key)
          .firstOrNull;
      if (field != null) sheet = sheet.withField(field, entry.value);
      if (entry.key == 'isOneOfAKind') {
        sheet = sheet.copyWith(isOneOfAKind: entry.value as bool?);
      }
    }
    return current = current.copyWith(factSheet: sheet);
  }

  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    lastDecisions = decisions;
    return current = current.copyWith(
      suggestions: [
        for (final s in current.suggestions)
          decisions.containsKey(s.id)
              ? s.copyWith(accepted: decisions[s.id])
              : s,
      ],
    );
  }

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    publishedWith = (photo: photoConsent, story: storyConsent);
    return current = current.copyWith(
      status: ListingStatus.published,
      photoConsent: photoConsent,
      storyConsent: storyConsent,
      previewUrl: 'https://example/p/$listingId',
    );
  }

  int republishes = 0;

  @override
  Future<Listing> republish(String listingId) async {
    if (failNext) throw Exception('no network');
    republishes++;
    return current = current.copyWith(
      status: current.stock <= 0
          ? ListingStatus.soldOut
          : ListingStatus.published,
      previewUrl: current.previewUrl ?? 'https://example/p/$listingId',
    );
  }

  @override
  Future<Listing> listing(String id) async => current;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      throw UnimplementedError();
  @override
  Future<List<Sale>> sales() => throw UnimplementedError();
}

void main() {
  Listing seed({
    ListingStatus status = ListingStatus.needsAttention,
    String? question = 'How big is it?',
    FactSheet sheet = const FactSheet(
      material: 'Clay',
      quantity: 1,
      hoursToMake: 6,
      materialCostInPaise: 12000,
    ),
    List<Suggestion> suggestions = const [],
  }) => Listing(
    id: 'l1',
    status: status,
    factSheet: sheet,
    followUpQuestion: question,
    suggestions: suggestions,
    imageUrls: const ['a.jpg', 'b.jpg', 'c.jpg'],
  );

  ({ReviewController review, _FakeApi api}) build(Listing listing) {
    final api = _FakeApi(listing);
    return (
      review: ReviewController(
        listings: ListingRepository(api: api),
        listing: listing,
      ),
      api: api,
    );
  }

  test('a listing with a missing fact opens on the question', () {
    final (:review, api: _) = build(seed());
    expect(review.stage, ReviewStage.needsAttention);
  });

  test('a listing with nothing missing opens on the read-back', () {
    final (:review, api: _) = build(
      seed(status: ListingStatus.ready, question: null),
    );
    expect(review.stage, ReviewStage.readBack);
  });

  test('answering the one question moves it into the read-back', () async {
    final (:review, :api) = build(seed());

    expect(await review.submitAnswer('/tmp/answer.m4a'), isTrue);

    expect(api.lastAnsweredField, isNull);
    expect(review.stage, ReviewStage.readBack);
    expect(review.listing.followUpQuestion, isNull);
    expect(review.factSheet.size, '12 inches');
  });

  test('a field nobody spoke about is not said, and never a guess', () {
    final (:review, api: _) = build(seed());

    expect(review.isSaid(ListingField.material), isTrue);
    expect(review.isSaid(ListingField.colour), isFalse);
    expect(review.factSheet.value(ListingField.colour), isNull);
  });

  test('correcting one field by voice patches that field alone', () async {
    final (:review, :api) = build(seed());

    await review.correctByVoice(ListingField.colour, '/tmp/colour.m4a');

    expect(api.lastAnsweredField, 'colour');
    expect(review.factSheet.colour, 'heard by voice');
    expect(review.factSheet.material, 'Clay');
    expect(review.factSheet.quantity, 1);
  });

  test('the manual fallback writes the same field the voice would', () async {
    final (:review, :api) = build(seed());

    await review.setField(ListingField.price, 45000);

    expect(api.patches.single, {'price': 45000});
    expect(review.factSheet.priceInPaise, 45000);
  });

  test('the price floor is the materials plus the hours', () {
    final (:review, api: _) = build(seed());

    expect(
      review.priceFloorInPaise,
      12000 + (6 * ReviewConstants.hourlyRateInPaise),
    );
    expect(review.isBelowFloor(review.priceFloorInPaise - 1), isTrue);
    expect(review.isBelowFloor(review.priceFloorInPaise), isFalse);
  });

  test('a server-computed floor wins over the one worked out here', () {
    final listing = seed().copyWith(priceFloorInPaise: 99000);
    final (:review, api: _) = build(listing);
    expect(review.priceFloorInPaise, 99000);
  });

  test('one of a kind forces the quantity to one', () async {
    final (:review, :api) = build(seed(question: null));

    await review.setOneOfAKind(true);

    expect(api.patches.single['isOneOfAKind'], isTrue);
    expect(api.patches.single['quantity'], 1);
    expect(review.factSheet.isOneOfAKind, isTrue);
  });

  test('only what was said yes to is sent, and a skip is not a no', () async {
    final (:review, :api) = build(
      seed(
        question: null,
        suggestions: const [
          Suggestion(id: 'a', spokenPrompt: 'add a?', textIfAccepted: 'A.'),
          Suggestion(id: 'b', spokenPrompt: 'add b?', textIfAccepted: 'B.'),
          Suggestion(id: 'c', spokenPrompt: 'add c?', textIfAccepted: 'C.'),
        ],
      ),
    );

    expect(review.nextSuggestion?.id, 'a');
    review.answerSuggestion('a', true);
    expect(review.nextSuggestion?.id, 'b');
    review.answerSuggestion('b', false);
    review.skipSuggestion('c');

    expect(review.nextSuggestion, isNull);
    await review.submitSuggestions();

    expect(api.lastDecisions, {'a': true, 'b': false});
  });

  test('the suggestion screen is skipped when there is nothing to suggest', () {
    final (:review, api: _) = build(seed(question: null));

    review.next();

    expect(review.stage, ReviewStage.price);
  });

  test('publishing sends both consents as they were given', () async {
    final (:review, :api) = build(seed(question: null));

    await review.publish(photoConsent: true, storyConsent: false);

    expect(api.publishedWith, (photo: true, story: false));
    expect(review.isPublished, isTrue);
    expect(review.listing.previewUrl, isNotNull);
  });

  test('a failed patch says so and does not pretend it saved', () async {
    final (:review, :api) = build(seed(question: null));
    api.failNext = true;

    expect(await review.setField(ListingField.price, 50000), isFalse);

    expect(review.error, isNotNull);
    expect(review.factSheet.priceInPaise, isNull);
    expect(review.isBusy, isFalse);
  });

  test('back walks the flow without landing on screens that do not apply', () {
    final (:review, api: _) = build(seed(question: null));

    review.goTo(ReviewStage.price);
    review.back();

    expect(review.stage, ReviewStage.readBack);
    review.back();
    expect(review.stage, ReviewStage.readBack);
  });

  test(
    'a listing that has been on sale opens as an edit, not as a publish',
    () {
      final (:review, api: _) = build(
        seed(status: ListingStatus.published, question: null),
      );

      expect(review.isEdit, isTrue);
      expect(review.stage, ReviewStage.readBack);
    },
  );

  test('an edit never asks for consent a second time', () {
    final (:review, api: _) = build(
      seed(status: ListingStatus.published, question: null),
    );

    review.goTo(ReviewStage.preview);
    review.next();

    expect(review.stage, ReviewStage.publishing);
  });

  test('an edit ends in a republish and never in a publish', () async {
    final (:review, :api) = build(
      seed(status: ListingStatus.published, question: null),
    );

    review.goTo(ReviewStage.preview);
    review.next();
    await Future<void>.delayed(Duration.zero);

    expect(api.republishes, 1);
    expect(api.publishedWith, isNull);
    expect(review.wentLive, isTrue);
    expect(review.listing.status, ListingStatus.published);
  });

  test('a first publish still publishes, and does not republish', () async {
    final (:review, :api) = build(
      seed(status: ListingStatus.ready, question: null),
    );

    expect(review.isEdit, isFalse);
    expect(
      await review.publish(photoConsent: true, storyConsent: false),
      isTrue,
    );

    expect(api.publishedWith, (photo: true, story: false));
    expect(api.republishes, 0);
  });

  test('editing something with nothing left in stock worked, even though it '
      'stays sold out', () async {
    final (:review, api: _) = build(
      seed(
        status: ListingStatus.soldOut,
        question: null,
        sheet: const FactSheet(material: 'Clay', quantity: 0),
      ),
    );

    expect(await review.republish(), isTrue);

    expect(review.listing.status, ListingStatus.soldOut);
    expect(review.wentLive, isTrue);
  });

  test('a republish that fails loses nothing and can be tried again', () async {
    final (:review, :api) = build(
      seed(status: ListingStatus.published, question: null),
    );
    api.failNext = true;

    expect(await review.republish(), isFalse);
    expect(review.error, isNotNull);
    expect(review.wentLive, isFalse);

    api.failNext = false;
    expect(await review.republish(), isTrue);
    expect(review.wentLive, isTrue);
  });
}
