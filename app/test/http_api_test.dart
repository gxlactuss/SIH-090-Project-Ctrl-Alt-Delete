import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/models/fact_sheet.dart';
import 'package:kaarigar/data/models/listing.dart';
import 'package:kaarigar/data/models/listing_status.dart';
import 'package:kaarigar/data/models/suggestion.dart';
import 'package:kaarigar/data/remote/http_api.dart';
import 'package:kaarigar/data/remote/upload_failure.dart';

void main() {
  const listingJson = {
    'id': 'l1',
    'status': 'published',
    'title': 'Blue water jug',
    'factSheet': {'quantity': 2, 'priceInPaise': 45000},
  };

  HttpApi api(MockClientHandler handler, {Future<String?> Function()? token}) =>
      HttpApi(
        baseUrl: 'https://api.example.test/v1',
        client: MockClient(handler),
        authToken: token,
      );

  Matcher failsWith(UploadFailure failure) => throwsA(
    isA<UploadException>().having((e) => e.failure, 'failure', failure),
  );

  test('reads a listing from under the base path, with the token', () async {
    late http.Request seen;
    final client = api((request) async {
      seen = request;
      return http.Response(jsonEncode(listingJson), 200);
    }, token: () async => 'abc');

    final listing = await client.listing('l 1');

    expect(seen.method, 'GET');
    expect(seen.url.toString(), 'https://api.example.test/v1/listings/l%201');
    expect(seen.headers['authorization'], 'Bearer abc');
    expect(listing.status, ListingStatus.published);
    expect(listing.factSheet.priceInPaise, 45000);
  });

  test('relative media urls are resolved against the server', () async {
    final client = api((request) async {
      if (request.url.path.endsWith('/sales')) {
        return http.Response(
          jsonEncode([
            {
              'id': 's1',
              'placed_at': '2026-09-17T10:00:00Z',
              'image_url': '/media/s1.jpg',
            },
          ]),
          200,
        );
      }
      return http.Response(
        jsonEncode({
          ...listingJson,
          'image_urls': [
            '/media/l1/0.jpg',
            'media/l1/1.jpg',
            'https://cdn.example.test/l1/2.jpg',
          ],
          'preview_url': '/preview/l1',
        }),
        200,
      );
    });

    final listing = await client.listing('l1');
    expect(listing.imageUrls, [
      'https://api.example.test/media/l1/0.jpg',
      'https://api.example.test/v1/media/l1/1.jpg',
      'https://cdn.example.test/l1/2.jpg',
    ]);
    expect(listing.previewUrl, 'https://api.example.test/preview/l1');

    final sales = await client.sales();
    expect(sales.single.imageUrl, 'https://api.example.test/media/s1.jpg');
  });

  test('a listing comes back from json exactly as it went in', () {
    const listing = Listing(
      id: 'l2',
      status: ListingStatus.ready,
      title: 'Cotton shawl',
      description: 'Red border.',
      imageUrls: ['https://cdn.example.test/1.jpg'],
      followUpQuestion: 'How wide is it?',
      suggestedPriceInPaise: 120000,
      priceFloorInPaise: 90000,
      previewUrl: 'https://example.test/l2',
      photoConsent: true,
      views: 7,
      templateListingId: 'l1',
      factSheet: FactSheet(
        material: 'Cotton',
        colour: 'Red',
        quantity: 1,
        hoursToMake: 12.5,
        isOneOfAKind: true,
      ),
      suggestions: [
        Suggestion(
          id: 'gift',
          spokenPrompt: 'Shall I add: makes a good gift?',
          textIfAccepted: 'Makes a good gift.',
          accepted: true,
        ),
      ],
    );

    final back = Listing.fromJson(
      jsonDecode(jsonEncode(listing.toJson())) as Map<String, Object?>,
    );

    expect(back.toJson(), listing.toJson());
  });

  test('a status this build does not know is refused, not guessed', () {
    expect(
      () => Listing.fromJson({...listingJson, 'status': 'teleported'}),
      throwsFormatException,
    );
  });

  test('status codes map to reasons the queue understands', () {
    expect(HttpApi.failureFor(500), UploadFailure.server);
    expect(HttpApi.failureFor(503), UploadFailure.server);
    expect(HttpApi.failureFor(429), UploadFailure.server);
    expect(HttpApi.failureFor(408), UploadFailure.server);
    expect(HttpApi.failureFor(401), UploadFailure.server);
    expect(HttpApi.failureFor(413), UploadFailure.rejected);
    expect(HttpApi.failureFor(422), UploadFailure.rejected);
  });

  test('a refused call throws its reason', () async {
    final client = api((_) async => http.Response('no', 422));

    await expectLater(
      client.publish(listingId: 'l1', photoConsent: true, storyConsent: true),
      failsWith(UploadFailure.rejected),
    );
  });

  test('no network is a network failure', () async {
    final client = api((_) async => throw const SocketException('offline'));

    await expectLater(client.listings(), failsWith(UploadFailure.network));
  });

  test('an answer in the wrong shape is the server\'s fault', () async {
    final client = api((_) async => http.Response('{"id": 1}', 200));

    await expectLater(client.listing('l1'), failsWith(UploadFailure.server));
    await expectLater(client.listings(), failsWith(UploadFailure.server));
  });

  group('uploading a capture', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('http_api_test'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('sends every file once, with progress that ends at done', () async {
      final photo = File('${dir.path}/photo.jpg')
        ..writeAsBytesSync(List.filled(40000, 1));
      final voice = File('${dir.path}/voice.m4a')
        ..writeAsBytesSync(List.filled(20000, 2));

      final seen = <http.Request>[];
      final client = api((request) async {
        seen.add(request);
        return http.Response(
          jsonEncode({'id': 'server-1', 'client_item_id': 'c1'}),
          200,
        );
      });
      final progress = <double>[];

      await client.uploadCapture(
        captureId: 'c1',
        photoPaths: [photo.path],
        voiceNotePath: voice.path,
        onProgress: progress.add,
        description: 'A jug',
      );

      expect(
        [for (final r in seen) '${r.method} ${r.url.path}'],
        [
          'POST /v1/listings',
          'POST /v1/listings/server-1/media',
          'POST /v1/listings/server-1/media',
        ],
      );
      String part(http.Request request) =>
          utf8.decode(request.bodyBytes, allowMalformed: true);
      expect(part(seen[1]), contains('name="media_type"\r\n\r\nimage'));
      expect(part(seen[1]), contains('content-type: image/jpeg'));
      expect(part(seen[2]), contains('name="media_type"\r\n\r\naudio'));
      expect(part(seen[2]), contains('content-type: audio/mp4'));
      expect(seen[1].bodyBytes.length, greaterThan(40000));

      expect(progress, isNotEmpty);
      expect(progress.last, 1.0);
      for (var i = 1; i < progress.length; i++) {
        expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
      }
    });

    test('missing files fail before a byte is sent', () async {
      var called = false;
      final client = api((_) async {
        called = true;
        return http.Response('', 204);
      });

      await expectLater(
        client.uploadCapture(
          captureId: 'c1',
          photoPaths: ['${dir.path}/gone.jpg'],
          voiceNotePath: '',
        ),
        failsWith(UploadFailure.missingFiles),
      );
      expect(called, isFalse);
    });
  });

  test('deleting the account asks the server to erase this seller', () async {
    late http.Request seen;
    final client = api((request) async {
      seen = request;
      return http.Response('', 204);
    });

    await client.deleteAccount();

    expect(seen.method, 'DELETE');
    expect(seen.url.path, '/v1/seller');
  });

  test('the minimum build is read when given, and null when not', () async {
    expect(
      await api((_) async => http.Response('{"minimumBuild": 42}', 200))
          .minimumSupportedBuild(),
      42,
    );
    expect(
      await api((_) async => http.Response('{}', 200)).minimumSupportedBuild(),
      isNull,
    );
    expect(
      await api((_) async => http.Response('{"minimumBuild": "soon"}', 200))
          .minimumSupportedBuild(),
      isNull,
    );
  });
}
