import '../models/listing.dart';
import '../models/sale.dart';
import '../models/seller_profile.dart';

abstract interface class ApiClient {
  Future<SellerProfile> createProfile(SellerProfile draft);

  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,

    String? templateListingId,

    String? description,
  });

  Future<Listing> listing(String id);

  Future<List<Listing>> listings();

  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
  });

  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  });

  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  });

  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  });

  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  });

  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  });

  Future<Listing> republish(String listingId);

  Future<Listing> unpublish(String listingId);

  Future<Listing> relist(String listingId);

  Future<List<Sale>> sales();

  Future<void> deleteAccount();

  Future<int?> minimumSupportedBuild();
}
