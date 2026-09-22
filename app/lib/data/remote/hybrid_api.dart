import '../models/listing.dart';
import '../models/sale.dart';
import '../models/seller_profile.dart';
import 'api_client.dart';
import 'mock_api.dart';

enum ApiCall {
  createProfile,
  uploadCapture,
  listing,
  listings,
  answerQuestion,
  patchListing,
  reviseListing,
  resolveSuggestions,
  publish,
  setConsent,
  republish,
  unpublish,
  relist,
  sales,
  deleteListing,
  deleteAccount,
  minimumSupportedBuild,
}

class HybridApi implements ApiClient {
  HybridApi({required this.server, required this.mock, required this.onServer});

  final ApiClient server;
  final MockApi mock;
  final Set<ApiCall> onServer;

  static const Set<ApiCall> serverReady = {
    ApiCall.createProfile,
    ApiCall.uploadCapture,
    ApiCall.listing,
    ApiCall.listings,
  };

  bool usesServer(ApiCall call) => onServer.contains(call);

  static Set<ApiCall>? parse(String value) {
    final names = value
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    if (names.isEmpty) return serverReady;
    if (names.length == 1 && names.single == 'all') return null;
    if (names.length == 1 && names.single == 'none') return {};

    final byName = {for (final call in ApiCall.values) call.name: call};
    final unknown = names.where((name) => !byName.containsKey(name)).toList();
    if (unknown.isNotEmpty) {
      throw ArgumentError.value(
        value,
        'API_REAL_CALLS',
        'unknown calls ${unknown.join(', ')}; expected all, none, or any of '
            '${ApiCall.values.map((call) => call.name).join(', ')}',
      );
    }
    return {for (final name in names) byName[name]!};
  }

  Future<Listing> _one(ApiCall call, Future<Listing> Function(ApiClient) run) {
    if (!usesServer(call)) return run(mock);
    return run(server).then(_keep);
  }

  Listing _keep(Listing fromServer) {
    final local = mock.stored(fromServer.id);
    final bare = fromServer.title == null && fromServer.imageUrls.isEmpty;
    if (bare && local != null) return local;
    return mock.adopt(fromServer);
  }

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) =>
      (usesServer(ApiCall.createProfile) ? server : mock).createProfile(draft);

  @override
  Future<void> uploadCapture({
    required String captureId,
    required List<String> photoPaths,
    required String voiceNotePath,
    void Function(double progress)? onProgress,
    String? templateListingId,
    String? description,
  }) async {
    if (usesServer(ApiCall.uploadCapture)) {
      await server.uploadCapture(
        captureId: captureId,
        photoPaths: photoPaths,
        voiceNotePath: voiceNotePath,
        onProgress: onProgress,
        templateListingId: templateListingId,
        description: description,
      );
      onProgress = null;
    }
    await mock.uploadCapture(
      captureId: captureId,
      photoPaths: photoPaths,
      voiceNotePath: voiceNotePath,
      onProgress: onProgress,
      templateListingId: templateListingId,
      description: description,
    );
  }

  @override
  Future<Listing> listing(String id) =>
      _one(ApiCall.listing, (api) => api.listing(id));

  @override
  Future<List<Listing>> listings() async {
    if (!usesServer(ApiCall.listings)) return mock.listings();
    final listings = await server.listings();
    return [for (final listing in listings.reversed) _keep(listing)].reversed
        .toList();
  }

  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
    String? transcript,
  }) => _one(
    ApiCall.answerQuestion,
    (api) => api.answerQuestion(
      listingId: listingId,
      voiceReplyPath: voiceReplyPath,
      field: field,
      transcript: transcript,
    ),
  );

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) => _one(
    ApiCall.patchListing,
    (api) => api.patchListing(listingId: listingId, changes: changes),
  );

  @override
  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  }) => _one(
    ApiCall.reviseListing,
    (api) => api.reviseListing(
      listingId: listingId,
      voiceInstructionPath: voiceInstructionPath,
    ),
  );

  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) => _one(
    ApiCall.resolveSuggestions,
    (api) => api.resolveSuggestions(listingId: listingId, decisions: decisions),
  );

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) => _one(
    ApiCall.publish,
    (api) => api.publish(
      listingId: listingId,
      photoConsent: photoConsent,
      storyConsent: storyConsent,
    ),
  );

  @override
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) => _one(
    ApiCall.setConsent,
    (api) => api.setConsent(
      listingId: listingId,
      photoConsent: photoConsent,
      storyConsent: storyConsent,
    ),
  );

  @override
  Future<Listing> republish(String listingId) =>
      _one(ApiCall.republish, (api) => api.republish(listingId));

  @override
  Future<Listing> unpublish(String listingId) =>
      _one(ApiCall.unpublish, (api) => api.unpublish(listingId));

  @override
  Future<Listing> relist(String listingId) =>
      _one(ApiCall.relist, (api) => api.relist(listingId));

  @override
  Future<List<Sale>> sales() =>
      (usesServer(ApiCall.sales) ? server : mock).sales();

  @override
  Future<void> deleteListing(String listingId) async {
    if (usesServer(ApiCall.deleteListing)) {
      await server.deleteListing(listingId);
    }
    await mock.deleteListing(listingId);
  }

  @override
  Future<void> deleteAccount() async {
    if (usesServer(ApiCall.deleteAccount)) await server.deleteAccount();
    await mock.deleteAccount();
  }

  @override
  Future<int?> minimumSupportedBuild() =>
      (usesServer(ApiCall.minimumSupportedBuild) ? server : mock)
          .minimumSupportedBuild();
}
