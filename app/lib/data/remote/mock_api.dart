import 'dart:io';

import '../../core/constants/app_constants.dart';
import '../models/fact_sheet.dart';
import '../../services/deep_link_service.dart';
import '../models/listing.dart';
import '../models/listing_status.dart';
import '../models/sale.dart';
import '../models/suggestion.dart';
import '../models/seller_profile.dart';
import 'api_client.dart';
import 'upload_failure.dart';

/// The whole app runs on this, offline, on one laptop.
///
/// Reads canned JSON from assets/mock/ and adds a small delay so the screens
/// behave the way they will against a real network. It is not a pretend
/// server: it checks that the files it was asked to upload are actually
/// there, and it fails the way the real one will, so the failure screens are
/// demoable rather than theoretical.
class MockApi implements ApiClient {
  MockApi({this.failUploads = false, this.uploadDuration = _defaultUpload});

  /// Makes every upload fail. Set from `--dart-define=failUploads=true` so
  /// 4.2 and the retry path can be shown on stage without pulling the SIM
  /// out of the phone.
  final bool failUploads;

  /// How long a "network" upload takes. The default is slow on purpose: a
  /// progress bar that fills instantly proves nothing about a screen whose
  /// whole job is to be watched for two minutes on a 2G connection.
  final Duration uploadDuration;

  static const Duration _defaultUpload = Duration(seconds: 4);

  /// What the mock has "published". Kept in memory so a capture uploaded in
  /// this session shows up as a listing in the same session.
  final List<Listing> _listings = [];

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    return draft;
  }

  @override
  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,
    String? templateListingId,
    String? description,
  }) async {
    // The files are checked first and locally: a capture whose photos were
    // cleared by the system is a permanent failure, and finding that out
    // before spending the upload is the point.
    // A duplicate carries no voice note, so an empty path here is expected
    // rather than a capture that lost one.
    for (final path in [
      ...photoPaths,
      if (voiceNotePath.isNotEmpty) voiceNotePath,
    ]) {
      if (!File(path).existsSync()) {
        throw const UploadException(UploadFailure.missingFiles);
      }
    }

    const steps = 20;
    final step = uploadDuration ~/ steps;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(step);
      onProgress?.call(i / steps);
      // Fails part way through, where a real network fails, rather than
      // politely at the start.
      if (failUploads && i == steps ~/ 2) {
        throw const UploadException(UploadFailure.server);
      }
    }

    // The server has it. What comes back is a listing that is still being
    // written up -- section 5 is what asks about it again.
    _listings.removeWhere((l) => l.id == captureId);

    // Loop 6: a duplicate starts from the fact sheet of the listing it was
    // copied from, with nothing left to ask, so it lands ready for approval
    // rather than back at the one question.
    final template = templateListingId == null
        ? null
        : _listings.where((l) => l.id == templateListingId).firstOrNull;
    if (template != null) {
      _listings.insert(
        0,
        Listing(
          // A new id: it is a second bowl, not the same bowl listed twice.
          id: captureId,
          status: ListingStatus.ready,
          factSheet: template.factSheet,
          title: template.title,
          description: template.description,
          // Everything except the photographs is reused, which is the whole
          // point of loop 6.
          imageUrls: photoPaths,
          suggestedPriceInPaise: template.suggestedPriceInPaise,
          priceFloorInPaise: template.priceFloorInPaise,
          templateListingId: templateListingId,
        ),
      );
      return;
    }

    _listings.insert(
      0,
      Listing(
        id: captureId,
        // The pipeline has heard the voice note and found one slot empty,
        // which is what 5.1 exists for. Colour and technique come back as
        // "not said", which is what 5.2 has to draw honestly.
        status: ListingStatus.needsAttention,
        followUpQuestion: _followUp,
        factSheet: const FactSheet(
          material: 'Clay',
          quantity: 1,
          hoursToMake: 6,
          materialCostInPaise: 12000,
        ),
        imageUrls: photoPaths,
        suggestedPriceInPaise: 60000,
        priceFloorInPaise: 48000,
      ),
    );
  }

  @override
  Future<Listing> listing(String id) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    for (final listing in _listings) {
      if (listing.id == id) return listing;
    }
    throw const UploadException(UploadFailure.rejected, 'no such listing');
  }

  @override
  Future<List<Listing>> listings() async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    return List.unmodifiable(_listings);
  }

  @override
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);
    return _store(
      current.copyWith(
        photoConsent: photoConsent,
        storyConsent: storyConsent,
        // Withdrawing the photographs withdraws the listing with them.
        status: photoConsent ? current.status : ListingStatus.unpublished,
      ),
    );
  }

  @override
  Future<Listing> republish(String listingId) async {
    // As slow as publishing, because it is the same trip to the marketplace
    // and 5.11 is showing progress for it either way.
    await Future<void>.delayed(const Duration(seconds: 3));
    final current = await listing(listingId);
    return _store(
      current.copyWith(
        // Loop 7 outranks loop 5: an edit that leaves nothing in stock goes
        // back to sold out, not on sale. Editing the price of a bowl that is
        // gone must not put it in front of a buyer again.
        status: current.stock <= 0
            ? ListingStatus.soldOut
            : ListingStatus.published,
        // The consents and the link are what republishing keeps. The seller
        // gave the first once, and has already shared the second.
        previewUrl: current.previewUrl ?? DeepLinks.shareUrl(listingId),
      ),
    );
  }

  @override
  Future<Listing> unpublish(String listingId) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);
    return _store(current.copyWith(status: ListingStatus.unpublished));
  }

  @override
  Future<Listing> relist(String listingId) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);
    // Relisting something with nothing left to sell would put a listing in
    // front of buyers that cannot be bought.
    if (current.stock <= 0) {
      return _store(current.copyWith(status: ListingStatus.soldOut));
    }
    return _store(current.copyWith(status: ListingStatus.published));
  }

  /// No invented orders: nothing has sold until a real marketplace says so.
  @override
  Future<List<Sale>> sales() async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    return const [];
  }

  // --- Dev only: the pipeline's finished answer ------------------------

  /// Stands in for the server coming back with a finished write-up: a
  /// cleaned-up photograph, a tidy title and a description, with every
  /// fact sheet slot filled. Only ever reached from a debug-build button.
  ///
  /// Replaces [listingId] when given, so a capture sitting in "processing"
  /// becomes the result, and makes a new listing otherwise.
  Listing simulatePolished({String? listingId}) {
    return _store(
      Listing(
        id: listingId ?? 'dev-${DateTime.now().millisecondsSinceEpoch}',
        status: ListingStatus.ready,
        title: 'Hand-thrown Blue Pottery Water Jug',
        description:
            'A two-litre water jug, thrown by hand on the wheel from local '
            'clay and finished in a deep blue glaze. It keeps water cool '
            'through the summer, and no two are exactly alike.',
        imageUrls: const ['assets/images/crafts/pottery.jpg'],
        factSheet: const FactSheet(
          material: 'Clay',
          size: '10 inches tall',
          colour: 'Blue',
          technique: 'Wheel thrown',
          quantity: 3,
          priceInPaise: 65000,
          hoursToMake: 6,
          materialCostInPaise: 12000,
        ),
        suggestedPriceInPaise: 65000,
        priceFloorInPaise: 48000,
      ),
    );
  }

  // --- Section 5, the review flow -------------------------------------
  //
  // A real listing's fact sheet is what a transcriber and a writer made of
  // the seller's own voice note, and nothing on this laptop can produce that.
  // What follows is a fixture: fixed words, with fixed gaps in fixed places,
  // so the review screens and all three of their loops can be walked. It is
  // clearly not the seller's own product, which is the point -- an invented
  // fact sheet that looked real would be the one thing this app must never
  // put in front of a seller.

  /// The one question 5.1 asks. Deliberately a slot that a real voice note
  /// often leaves empty.
  static const String _followUp = 'How big is it? Say it in inches or feet.';

  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);

    if (field == null) {
      // 5.1: the missing slot is filled and the write-up comes back, which is
      // what moves the listing from needsAttention to ready.
      return _store(
        current.copyWith(
          status: ListingStatus.ready,
          clearFollowUpQuestion: true,
          factSheet: current.factSheet.copyWith(size: '12 inches'),
          title: 'Handmade piece',
          description:
              'A handmade piece, made by hand in the maker\'s own workshop. '
              'Twelve inches across.',
          suggestions: _suggestions,
        ),
      );
    }

    // 5.3: one field, patched by voice. The transcriber is what turns the
    // recording into a value; here the value is canned per field.
    final parsed = ListingField.values.firstWhere((f) => f.name == field);
    return _store(
      current.copyWith(
        factSheet: current.factSheet.withField(parsed, switch (parsed) {
          ListingField.price => 45000,
          ListingField.quantity => 2,
          ListingField.colour => 'Blue',
          ListingField.size => '12 inches',
          ListingField.material => 'Clay',
          ListingField.technique => 'Wheel thrown',
        }),
      ),
    );
  }

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);

    var sheet = current.factSheet;
    for (final entry in changes.entries) {
      final field = ListingField.values
          .where((f) => f.name == entry.key)
          .firstOrNull;
      if (field != null) {
        sheet = sheet.withField(field, entry.value);
      } else if (entry.key == 'isOneOfAKind') {
        sheet = sheet.copyWith(isOneOfAKind: entry.value as bool?);
      }
    }

    // Loop 7: stock reaching zero delists on its own, and stock coming back
    // on a sold-out listing puts it back. The seller is told either way; they
    // are never asked to do the arithmetic.
    var status = current.status;
    if (current.status.wasPublished) {
      final stock = sheet.quantity ?? 0;
      if (stock <= 0) {
        status = ListingStatus.soldOut;
      } else if (current.status == ListingStatus.soldOut) {
        status = ListingStatus.published;
      }
    }

    return _store(
      current.copyWith(
        status: status,
        factSheet: sheet,
        imageUrls: (changes['imageUrls'] as List?)?.cast<String>(),
        title: changes['title'] as String?,
        description: changes['description'] as String?,
      ),
    );
  }

  @override
  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  }) async {
    // Slower than a patch: a real revision is a transcription and a rewrite.
    await Future<void>.delayed(const Duration(seconds: 2));
    final current = await listing(listingId);

    // Nothing here can hear the instruction, so the change is canned -- but
    // visible, so the screen can be seen to update.
    const addition = 'Packed carefully so it arrives safely.';
    final description = current.description ?? '';
    return _store(
      current.copyWith(
        description: description.contains(addition)
            ? description
            : '$description $addition'.trim(),
      ),
    );
  }

  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);

    final answered = [
      for (final suggestion in current.suggestions)
        decisions.containsKey(suggestion.id)
            ? suggestion.copyWith(accepted: decisions[suggestion.id])
            : suggestion,
    ];

    // Only what was said yes to reaches the description. No accept-all, ever.
    final accepted = answered.where((s) => s.accepted == true);
    final description = [
      current.description ?? '',
      for (final suggestion in accepted) suggestion.textIfAccepted,
    ].where((line) => line.isNotEmpty).join(' ');

    return _store(
      current.copyWith(suggestions: answered, description: description),
    );
  }

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    // Longer than a normal call: this is the one 5.11 shows progress for.
    await Future<void>.delayed(const Duration(seconds: 3));
    final current = await listing(listingId);
    return _store(
      current.copyWith(
        status: ListingStatus.published,
        photoConsent: photoConsent,
        storyConsent: storyConsent,
        previewUrl: DeepLinks.shareUrl(listingId),
      ),
    );
  }

  static List<Suggestion> get _suggestions => const [
        Suggestion(
          id: 'summer',
          spokenPrompt: 'Shall I add: good for summer?',
          textIfAccepted: 'Good for summer.',
        ),
        Suggestion(
          id: 'gift',
          spokenPrompt: 'Shall I add: makes a good gift?',
          textIfAccepted: 'Makes a good gift.',
        ),
        Suggestion(
          id: 'handwash',
          spokenPrompt: 'Shall I add: wash by hand only?',
          textIfAccepted: 'Wash by hand only.',
        ),
      ];

  Listing _store(Listing listing) {
    final index = _listings.indexWhere((l) => l.id == listing.id);
    if (index == -1) {
      _listings.insert(0, listing);
    } else {
      _listings[index] = listing;
    }
    return listing;
  }
}
