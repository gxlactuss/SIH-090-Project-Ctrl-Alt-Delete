import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/listing.dart';
import '../models/sale.dart';
import '../models/seller_profile.dart';
import 'api_client.dart';
import 'api_routes.dart';
import 'upload_failure.dart';
import 'wire_json.dart';

class HttpApi implements ApiClient {
  HttpApi({
    required String baseUrl,
    http.Client? client,
    this.authToken,
    this.onUnauthorised,
    this.timeout = const Duration(seconds: 20),
    this.uploadTimeout = const Duration(minutes: 10),
  }) : _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
       _client = client ?? http.Client();

  final Uri _base;
  final http.Client _client;

  final Future<String?> Function()? authToken;

  final Future<void> Function()? onUnauthorised;

  final Duration timeout;

  final Duration uploadTimeout;

  final Map<String, String> _serverIds = {};

  @override
  Future<SellerProfile> createProfile(SellerProfile draft) async {
    final body = await _json(
      ApiRoutes.updateSeller,
      body: {
        'name': draft.name,
        'language': draft.languageCode,

        if (draft.craftStory != null) 'craftStory': draft.craftStory,
      },
    );
    return _parse(body, (json) {
      final seller = _snake(json);
      return draft.copyWith(
        phone: draft.phone ?? seller['phone_number'] as String?,
      );
    });
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

    final created = await _json(
      ApiRoutes.createListing,
      body: {
        'client_item_id': captureId,

        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),

        if (photoPaths.isNotEmpty) 'photo_count': photoPaths.length,
      },
    );
    final serverId = _parse(created, _remember);

    final parts = [
      for (final path in photoPaths) (path, 'image'),
      if (voiceNotePath.isNotEmpty) (voiceNotePath, 'audio'),
    ];
    final sizes = [for (final (path, _) in parts) File(path).lengthSync()];
    final total = sizes.fold<int>(0, (sum, size) => sum + size);
    var done = 0;
    for (final (index, (path, kind)) in parts.indexed) {
      final size = sizes[index];
      final before = done;
      await _multipart(
        ApiRoutes.uploadMedia,
        id: serverId,
        files: {
          'file': [path],
        },
        fields: {'mediaType': kind},
        onProgress: onProgress == null || total == 0
            ? null
            : (part) => onProgress((before + part * size) / total),
        limit: uploadTimeout,
      );
      done += size;
    }
    onProgress?.call(1);
  }

  @override
  Future<Listing> listing(String id) async =>
      _listing(await _json(ApiRoutes.listing, id: await _serverId(id)));

  @override
  Future<List<Listing>> listings() async =>
      _parseList(await _json(ApiRoutes.listings), _readListing);

  @override
  Future<Listing> answerQuestion({
    required String listingId,
    required String voiceReplyPath,
    String? field,
    String? transcript,
  }) async => _listing(
    await _multipart(
      ApiRoutes.answerQuestion,
      id: await _serverId(listingId),
      files: {
        'voiceReply': [voiceReplyPath],
      },
      fields: {'field': ?field, 'transcript': ?transcript},
    ),
  );

  @override
  Future<Listing> patchListing({
    required String listingId,
    required Map<String, Object?> changes,
  }) async => _listing(
    await _json(
      ApiRoutes.patchListing,
      id: await _serverId(listingId),
      body: changes,
    ),
  );

  @override
  Future<Listing> reviseListing({
    required String listingId,
    required String voiceInstructionPath,
  }) async => _listing(
    await _multipart(
      ApiRoutes.reviseListing,
      id: await _serverId(listingId),
      files: {
        'voiceInstruction': [voiceInstructionPath],
      },
    ),
  );

  @override
  Future<Listing> resolveSuggestions({
    required String listingId,
    required Map<String, bool> decisions,
  }) async {
    final serverId = await _serverId(listingId);
    for (final MapEntry(:key, :value) in decisions.entries) {
      await _json(
        ApiRoutes.approveSuggestion,
        id: serverId,
        sub: key,
        body: {'approved': value},
      );
    }
    return listing(listingId);
  }

  @override
  Future<Listing> publish({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    final serverId = await _serverId(listingId);
    await _consent(serverId, photoConsent, storyConsent);
    await _json(ApiRoutes.publish, id: serverId);
    return listing(listingId);
  }

  @override
  Future<Listing> setConsent({
    required String listingId,
    required bool photoConsent,
    required bool storyConsent,
  }) async {
    await _consent(await _serverId(listingId), photoConsent, storyConsent);
    return listing(listingId);
  }

  Future<void> _consent(String serverId, bool photo, bool story) => _json(
    ApiRoutes.setConsent,
    id: serverId,
    body: {'photo': photo, 'story': story},
  );

  @override
  Future<Listing> republish(String listingId) async => _listing(
    await _json(ApiRoutes.republish, id: await _serverId(listingId)),
  );

  @override
  Future<Listing> unpublish(String listingId) async => _listing(
    await _json(ApiRoutes.unpublish, id: await _serverId(listingId)),
  );

  @override
  Future<Listing> relist(String listingId) async =>
      _listing(await _json(ApiRoutes.relist, id: await _serverId(listingId)));

  @override
  Future<List<Sale>> sales() async =>
      _parseList(await _json(ApiRoutes.sales), (json) {
        final sale = _snake(json);
        return Sale.fromJson({...sale, 'image_url': _media(sale['image_url'])});
      });

  @override
  Future<void> deleteListing(String listingId) async {
    await _json(ApiRoutes.deleteListing, id: await _serverId(listingId));
  }

  @override
  Future<void> deleteAccount() async {
    await _json(ApiRoutes.deleteAccount);
  }

  @override
  Future<int?> minimumSupportedBuild() async {
    final body = WireJson.camel(await _json(ApiRoutes.minimumSupportedBuild));
    if (body is! Map) return null;
    final minimum = body['minimumBuild'];
    return minimum is num ? minimum.toInt() : null;
  }

  static UploadFailure failureFor(int statusCode) => switch (statusCode) {
    401 || 408 || 429 => UploadFailure.server,
    >= 500 => UploadFailure.server,
    >= 400 => UploadFailure.rejected,
    _ => UploadFailure.unknown,
  };

  static MediaType? contentTypeFor(String path) {
    final dot = path.lastIndexOf('.');
    final extension = dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      'heic' => MediaType('image', 'heic'),
      'm4a' || 'mp4' => MediaType('audio', 'mp4'),
      'aac' => MediaType('audio', 'aac'),
      'mp3' => MediaType('audio', 'mpeg'),
      'wav' => MediaType('audio', 'wav'),
      'ogg' => MediaType('audio', 'ogg'),
      'webm' => MediaType('audio', 'webm'),
      _ => null,
    };
  }

  Uri _uri(String path) => _base.resolve(path);

  String _remember(Map<String, dynamic> json) {
    final map = _snake(json);
    final serverId = map['id'] as String;
    final captureId = map['client_item_id'];
    if (captureId is String) _serverIds[captureId] = serverId;
    return serverId;
  }

  Future<String> _serverId(String listingId) async {
    final known = _serverIds[listingId];
    if (known != null) return known;
    try {
      await listings();
    } on UploadException {
      return listingId;
    }
    return _serverIds[listingId] ?? listingId;
  }

  Future<Object?> _json(
    ApiRoute route, {
    String? id,
    String? sub,
    Object? body,
  }) {
    return _guard(
      () => _retryUnauthorised(() async {
        final request = http.Request(route.method, _uri(route.path(id, sub)))
          ..headers['accept'] = 'application/json';
        if (body != null) {
          request.headers['content-type'] = 'application/json; charset=utf-8';
          request.body = jsonEncode(WireJson.to(WireJson.jsonBodies, body));
        }
        await _authorise(request.headers);
        return _decode(await _send(request, timeout));
      }),
    );
  }

  Future<Object?> _multipart(
    ApiRoute route, {
    String? id,
    required Map<String, List<String>> files,
    Map<String, String> fields = const {},
    Map<String, String> headers = const {},
    void Function(double progress)? onProgress,
    Duration? limit,
  }) {
    return _guard(
      () => _retryUnauthorised(() async {
        final method = route.method;
        final request = http.MultipartRequest(method, _uri(route.path(id)))
          ..headers['accept'] = 'application/json'
          ..headers.addAll(headers)
          ..fields.addAll({
            for (final MapEntry(:key, :value) in fields.entries)
              WireJson.name(WireJson.formFields, key): value,
          });
        for (final MapEntry(key: name, value: paths) in files.entries) {
          final wireName = WireJson.name(WireJson.formFields, name);
          for (final path in paths) {
            request.files.add(
              await http.MultipartFile.fromPath(
                wireName,
                path,
                contentType: contentTypeFor(path),
              ),
            );
          }
        }
        await _authorise(request.headers);

        if (onProgress == null) {
          return _decode(await _send(request, limit ?? timeout));
        }

        final total = request.contentLength;
        final body = request.finalize();
        final counted = http.StreamedRequest(method, request.url)
          ..headers.addAll(request.headers)
          ..contentLength = total;
        var sent = 0;
        body.listen(
          (chunk) {
            counted.sink.add(chunk);
            sent += chunk.length;
            if (total > 0) onProgress(sent / total);
          },
          onError: counted.sink.addError,
          onDone: counted.sink.close,
          cancelOnError: true,
        );
        return _decode(await _send(counted, limit ?? timeout));
      }),
    );
  }

  Future<http.Response> _send(http.BaseRequest request, Duration limit) =>
      _client.send(request).then(http.Response.fromStream).timeout(limit);

  Future<void> _authorise(Map<String, String> headers) async {
    final token = await authToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['authorization'] = 'Bearer $token';
    }
  }

  Object? _decode(http.Response response) {
    final code = response.statusCode;
    if (code == HttpStatus.unauthorized) throw const _Unauthorised();
    if (code < 200 || code >= 300) {
      throw UploadException(failureFor(code), 'HTTP $code', code);
    }
    if (response.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException catch (error) {
      throw UploadException(UploadFailure.server, error);
    }
  }

  Future<T> _retryUnauthorised<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on _Unauthorised {
      final refresh = onUnauthorised;
      if (refresh == null) throw _unauthorised;
      await refresh();
      try {
        return await call();
      } on _Unauthorised {
        throw _unauthorised;
      }
    }
  }

  static final _unauthorised = UploadException(
    failureFor(HttpStatus.unauthorized),
    'HTTP ${HttpStatus.unauthorized}',
    HttpStatus.unauthorized,
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on UploadException {
      rethrow;
    } on TimeoutException catch (error) {
      throw UploadException(UploadFailure.network, error);
    } on SocketException catch (error) {
      throw UploadException(UploadFailure.network, error);
    } on http.ClientException catch (error) {
      throw UploadException(UploadFailure.network, error);
    } on FileSystemException catch (error) {
      throw UploadException(UploadFailure.missingFiles, error);
    }
  }

  Listing _listing(Object? body) => _parse(body, _readListing);

  Listing _readListing(Map<String, dynamic> json) {
    final map = WireJson.listing(json);
    final captureId = map.remove('clientItemId');
    if (captureId is String && map['id'] is String) {
      _serverIds[captureId] = map['id'] as String;
      map['id'] = captureId;
    }
    final images = map['imageUrls'];
    return Listing.fromJson({
      ...map,
      if (images is List) 'imageUrls': [for (final url in images) _media(url)],
      'previewUrl': _media(map['previewUrl']),
    });
  }

  Object? _media(Object? url) {
    if (url is! String || url.isEmpty) return url;
    final parsed = Uri.tryParse(url);
    if (parsed == null || parsed.hasScheme) return url;
    return _base.resolve(url).toString();
  }

  static Map<String, dynamic> _snake(Map<String, dynamic> json) =>
      (WireJson.snake(json) as Map).cast<String, dynamic>();

  T _parse<T>(Object? body, T Function(Map<String, dynamic> json) read) {
    try {
      return read((body as Map).cast<String, dynamic>());
    } catch (error) {
      throw UploadException(UploadFailure.server, error);
    }
  }

  List<T> _parseList<T>(
    Object? body,
    T Function(Map<String, dynamic> json) read,
  ) {
    final items = WireJson.list(body);
    if (items == null) {
      throw UploadException(UploadFailure.server, 'expected a list');
    }
    return [for (final item in items) _parse(item, read)];
  }
}

class _Unauthorised implements Exception {
  const _Unauthorised();
}
