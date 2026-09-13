import '../models/listing.dart';
import '../models/sale.dart';
import '../models/seller_profile.dart';

/// Everything the app needs from the backend, and nothing more.
///
/// Two implementations exist: [MockApi] backed by JSON files in assets, and
/// [HttpApi] backed by the real server. The UI must never know which one it
/// is talking to.
abstract interface class ApiClient {
  Future<SellerProfile> createProfile(SellerProfile draft);

  /// Uploads one captured item. The id comes from the device, so calling this
  /// twice with the same id must be safe.
  ///
  /// [onProgress] is called with 0 to 1 as the bytes go out. The seller is
  /// watching a percentage on a connection where the upload takes minutes,
  /// and a bar that does not move reads as a hung app.
  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,

    /// Loop 6. When set, the new listing starts from that listing's fact
    /// sheet and only the photographs are taken from this capture -- which
    /// is what lets a seller list the second of five identical bowls without
    /// describing it again.
    String? templateListingId,

    /// What the seller typed on 3.5 instead of speaking. Set exactly when
    /// [voiceNotePath] is empty on a capture that is not a duplicate.
    String? description,
  });

  Future<Listing> listing(String id);

  Future<List<Listing>> listings();

  /// Answers the one follow-up question of 5.1, or patches a single field by
  /// voice on 5.3. [field] is null for the follow-up question, which is about
  /// the listing as a whole rather than about one slot.
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
  });

  /// Writes the values the seller typed or picked: 5.4's fallback, 5.6's
  /// price, 5.7's stock, and 5.8's photo order.
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  });

  /// "Say the changes": a spoken instruction about the whole write-up
  /// ("make the title shorter", "say it is for gifting"), which the writer
  /// applies to the title and description and sends back.
  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  });

  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  });

  /// 5.10 records two consents, not one: the photograph and the craft story
  /// are separate permissions and either can be refused.
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  });

  /// 8.9. Consent is recorded per listing and withdrawable afterwards, so
  /// this is the same call publishing makes, on a listing that is already up.
  ///
  /// Withdrawing the photo consent takes the listing down: there is no
  /// listing on a marketplace without an image of the thing being sold.
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  });

  /// 6.3, loop 5. A listing that has already been through the whole flow is
  /// edited and then *republished*, which is a different call from [publish]
  /// and not an accident of naming: the consents were given once and are not
  /// asked for again, the preview link the seller has already shared has to
  /// survive, and the marketplace is updating a listing it already knows
  /// rather than being handed a new one.
  ///
  /// This is the line the spec draws through the seven loops: 1 to 4 happen
  /// before anything is public and end in [publish]; 5 to 7 happen after and
  /// end here.
  Future<Listing> republish(String listingId);

  /// 6.5. Comes off the marketplace but stays on the phone, so 6.2 can put
  /// it back with one press.
  Future<Listing> unpublish(String listingId);

  /// Back on sale -- from 6.2, and from the relist button that loop 7 leaves
  /// behind when stock reached zero.
  Future<Listing> relist(String listingId);

  Future<List<Sale>> sales();
}
