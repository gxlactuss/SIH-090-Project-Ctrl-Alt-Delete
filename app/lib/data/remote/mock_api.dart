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

class MockApi implements ApiClient {
  MockApi({
    this.failUploads = false,
    this.uploadDuration = _defaultUpload,
    this.craftStory,
  });

  final bool failUploads;

  final Duration uploadDuration;

  final String? Function()? craftStory;

  static const Duration _defaultUpload = Duration(seconds: 4);

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
      if (failUploads && i == steps ~/ 2) {
        throw const UploadException(UploadFailure.server);
      }
    }

    _listings.removeWhere((l) => l.id == captureId);

    final template = templateListingId == null
        ? null
        : _listings.where((l) => l.id == templateListingId).firstOrNull;
    if (template != null) {
      _listings.insert(
        0,
        Listing(
          id: captureId,
          status: ListingStatus.ready,
          factSheet: template.factSheet,
          title: template.title,
          description: template.description,
          imageUrls: photoPaths,
          suggestedPriceInPaise: template.suggestedPriceInPaise,
          priceFloorInPaise: template.priceFloorInPaise,
          templateListingId: templateListingId,
        ),
      );
      return;
    }

    final said = description?.trim();
    _listings.insert(
      0,
      said == null || said.isEmpty
          ? Listing(
              id: captureId,
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
            )
          : Listing(
              id: captureId,
              status: ListingStatus.needsAttention,
              followUpQuestion: _followUp,
              description: _withStoryTouch(said, craftStory?.call()),
              factSheet: FactSheet(quantity: 1, material: _materialFrom(said)),
              imageUrls: photoPaths,
              suggestedPriceInPaise: 60000,
              priceFloorInPaise: 48000,
            ),
    );
  }

  static String _withStoryTouch(String said, String? story) {
    final trimmed = story?.trim() ?? '';
    if (trimmed.isEmpty) return said;

    final end = trimmed.indexOf(RegExp(r'[.!?।]'));
    var clause = (end == -1 ? trimmed : trimmed.substring(0, end)).trim();
    if (clause.isEmpty) return said;
    if (clause.length > 140) {
      clause = '${clause.substring(0, 140).trimRight()}…';
    }

    if (said.toLowerCase().contains(clause.toLowerCase())) return said;

    final ending = RegExp(r'[.!?।]\$').hasMatch(said) ? '' : '.';
    return '$said$ending $clause.';
  }

  static String? _materialFrom(String said) {
    const materials = {
      'clay': 'Clay',
      'मिट्टी': 'मिट्टी',
      'माटी': 'माटी',
      'wood': 'Wood',
      'लकड़ी': 'लकड़ी',
      'brass': 'Brass',
      'पीतल': 'पीतल',
      'silver': 'Silver',
      'चाँदी': 'चाँदी',
      'cotton': 'Cotton',
      'कपास': 'कपास',
      'सूत': 'सूत',
      'silk': 'Silk',
      'रेशम': 'रेशम',
      'bamboo': 'Bamboo',
      'बाँस': 'बाँस',
      'leather': 'Leather',
      'चमड़ा': 'चमड़ा',
    };
    final haystack = said.toLowerCase();
    for (final entry in materials.entries) {
      if (haystack.contains(entry.key)) return entry.value;
    }
    return null;
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
        status: photoConsent ? current.status : ListingStatus.unpublished,
      ),
    );
  }

  @override
  Future<Listing> republish(String listingId) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    final current = await listing(listingId);
    return _store(
      current.copyWith(
        status: current.stock <= 0
            ? ListingStatus.soldOut
            : ListingStatus.published,
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
    if (current.stock <= 0) {
      return _store(current.copyWith(status: ListingStatus.soldOut));
    }
    return _store(current.copyWith(status: ListingStatus.published));
  }

  @override
  Future<List<Sale>> sales() async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    return const [];
  }

  @override
  Future<void> deleteListing(String listingId) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    _listings.removeWhere((l) => l.id == listingId);
  }

  @override
  Future<void> deleteAccount() async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    _listings.clear();
  }

  @override
  Future<int?> minimumSupportedBuild() async => null;

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

  static const String _followUp = 'How big is it? Say it in inches or feet.';

  @override
  Future<Listing> retakePhotos({
    required String listingId,
    required List<String> photoPaths,
    void Function(double progress)? onProgress,
  }) async {
    for (final path in photoPaths) {
      if (!File(path).existsSync()) {
        throw const UploadException(UploadFailure.missingFiles);
      }
    }

    const steps = 10;
    final step = uploadDuration ~/ steps;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(step);
      onProgress?.call(i / steps);
    }

    final current = await listing(listingId);
    return _store(
      current.copyWith(
        status: ListingStatus.ready,
        imageUrls: photoPaths,
        clearFollowUpQuestion: true,
      ),
    );
  }

  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
    String? transcript,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);
    final current = await listing(listingId);
    final said = transcript?.trim();

    if (field == null) {
      if (said != null && said.isNotEmpty) {
        final existing = current.description?.trim() ?? '';
        return _store(
          current.copyWith(
            status: ListingStatus.ready,
            clearFollowUpQuestion: true,
            description: existing.isEmpty ? said : '$existing $said',
            suggestions: _suggestions,
          ),
        );
      }
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

    if (said != null && said.isNotEmpty) {
      final parsed = ListingField.values.firstWhere((f) => f.name == field);
      final value = SpokenFieldValue.parse(parsed, said);
      if (value != null) {
        return _store(
          current.copyWith(
            factSheet: current.factSheet.withField(parsed, value),
          ),
        );
      }
    }

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
          ListingField.origin => 'Jaipur',
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
    await Future<void>.delayed(const Duration(seconds: 2));
    final current = await listing(listingId);

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

  Listing adopt(Listing listing) => _store(listing);

  Listing? stored(String id) => _listings.where((l) => l.id == id).firstOrNull;

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
