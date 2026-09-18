import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kirtikar/data/models/craft_type.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/models/seller_profile.dart';
import 'package:kirtikar/data/remote/api_problem.dart';
import 'package:kirtikar/data/remote/backend_session.dart';
import 'package:kirtikar/data/remote/http_api.dart';
import 'package:kirtikar/data/remote/server_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const base = 'https://api.example.test/api/v1';

  String fixture(String name) =>
      File('test/fixtures/api/$name.json').readAsStringSync();

  HttpApi serving(String name, {int status = 200, List<http.Request>? seen}) =>
      HttpApi(
        baseUrl: base,
        client: MockClient((request) async {
          seen?.add(request);
          return http.Response.bytes(utf8.encode(fixture(name)), status);
        }),
      );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('GET listings/{id}', () async {
    final seen = <http.Request>[];
    final listing = await serving('listing', seen: seen).listing('6f1c');

    expect(seen.last.url.path, '/api/v1/listings/6f1c');
    expect(listing.status, ListingStatus.needsAttention);
    expect(listing.followUpQuestion, 'How many litres does it hold?');
    expect(listing.factSheet.priceInPaise, 45000);
    expect(listing.factSheet.hoursToMake, 3.5);
    expect(
      listing.imageUrls.first,
      startsWith('https://api.example.test/media/'),
    );
    expect(listing.suggestions.single.accepted, isNull);
  });

  test('GET listings', () async {
    final listings = await serving('listings').listings();

    expect(listings.map((l) => l.status), [
      ListingStatus.processing,
      ListingStatus.published,
    ]);
    expect(listings.last.stock, 5);
    expect(listings.last.imageUrls.single, 'https://cdn.example.com/l2/0.jpg');
  });

  test('GET sales', () async {
    final sale = (await serving('sales').sales()).single;

    expect(sale.amountInPaise, 60000);
    expect(sale.packByDate, DateTime.utc(2026, 9, 19, 18));
    expect(sale.imageUrl, startsWith('https://api.example.test/media/'));
  });

  test('PUT seller', () async {
    final seen = <http.Request>[];
    final profile = await serving('seller', seen: seen).createProfile(
      const SellerProfile(
        id: 'seller-1',
        name: 'Sunita Devi',
        languageCode: 'hi',
        craft: CraftType.pottery,
        village: 'Khurja',
      ),
    );

    expect(seen.single.method, 'PUT');
    expect(seen.single.url.path, '/api/v1/seller');
    expect(jsonDecode(seen.single.body), {
      'name': 'Sunita Devi',
      'language': 'hi',
    });
    expect(profile.id, 'seller-1');
    expect(profile.craft, CraftType.pottery);
    expect(profile.village, 'Khurja');
    expect(profile.phone, '+919876543210');
  });

  test('POST listings, then POST listings/{id}/media per file', () async {
    final dir = Directory.systemTemp.createTempSync('api_contract_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final photo = File('${dir.path}/photo_1.jpg')..writeAsBytesSync([1, 2]);
    final voice = File('${dir.path}/voice.m4a')..writeAsBytesSync([3, 4]);

    final seen = <http.BaseRequest>[];
    final api = HttpApi(
      baseUrl: base,
      client: MockClient.streaming((request, body) async {
        seen.add(request);
        final bytes = await body.toBytes();
        if (request.url.path.endsWith('/media')) {
          expect(
            utf8.decode(bytes, allowMalformed: true),
            contains('name="media_type"'),
          );
          return http.StreamedResponse(
            Stream.value(utf8.encode(fixture('media_uploaded'))),
            200,
          );
        }
        expect(jsonDecode(utf8.decode(bytes)), {
          'client_item_id': 'c0ffee00-1234-4abc-9def-001122334455',
        });
        return http.StreamedResponse(
          Stream.value(utf8.encode(fixture('listing_created'))),
          200,
        );
      }),
    );

    await api.uploadCapture(
      captureId: 'c0ffee00-1234-4abc-9def-001122334455',
      photoPaths: [photo.path],
      voiceNotePath: voice.path,
    );

    expect(
      [for (final r in seen) '${r.method} ${r.url.path}'],
      [
        'POST /api/v1/listings',
        'POST /api/v1/listings/9a7b6c5d-4e3f-4a2b-8c1d-0e9f8a7b6c5d/media',
        'POST /api/v1/listings/9a7b6c5d-4e3f-4a2b-8c1d-0e9f8a7b6c5d/media',
      ],
    );
  });

  test('a listing is known by the capture id, and called by its own', () async {
    final seen = <http.Request>[];
    final api = HttpApi(
      baseUrl: base,
      client: MockClient((request) async {
        seen.add(request);
        final path = request.url.path;
        if (path.endsWith('/listings')) {
          return http.Response(
            jsonEncode({
              'items': [jsonDecode(fixture('listing_created'))],
            }),
            200,
          );
        }
        if (path.endsWith('/consent')) {
          expect(jsonDecode(request.body), {'photo': true, 'story': false});
          return http.Response('{}', 200);
        }
        if (path.endsWith('/publish')) return http.Response('{}', 200);
        return http.Response(fixture('listing_created'), 200);
      }),
    );

    final listing = (await api.listings()).single;
    expect(listing.id, 'c0ffee00-1234-4abc-9def-001122334455');
    expect(listing.status, ListingStatus.queued);

    await api.publish(
      listingId: listing.id,
      photoConsent: true,
      storyConsent: false,
    );
    const server = '/api/v1/listings/9a7b6c5d-4e3f-4a2b-8c1d-0e9f8a7b6c5d';
    expect(
      [for (final r in seen.skip(1)) '${r.method} ${r.url.path}'],
      ['POST $server/consent', 'POST $server/publish', 'GET $server'],
    );
  });

  test('POST auth/firebase', () async {
    final seen = <http.Request>[];
    final session = BackendSession(
      baseUrl: base,
      firebaseIdToken: () async => 'firebase-id-token',
      client: MockClient((request) async {
        seen.add(request);
        return http.Response(fixture('auth_exchange'), 200);
      }),
    );

    expect(await session.token(), startsWith('eyJ'));
    expect(jsonDecode(seen.single.body), {'id_token': 'firebase-id-token'});
  });

  test('GET app/version', () async {
    expect(await serving('app_version').minimumSupportedBuild(), 12);
  });

  test('GET /health', () async {
    final result = await ServerCheck(
      baseUrl: base,
      client: MockClient((_) async => http.Response(fixture('health'), 200)),
    ).run();

    expect(result.reachable, isTrue);
    expect(result.lines.single, contains('kirtikar-backend 0.1.0'));
  });

  test(
    'POST listings/{id}/suggestions/{sid}/approval keeps ids as sent',
    () async {
      final seen = <http.Request>[];
      await serving('listing', seen: seen).resolveSuggestions(
        listingId: 'l1',
        decisions: {'good_for_GIFTING': true, 'summer': false},
      );

      final approvals = seen.where((r) => r.url.path.endsWith('/approval'));
      expect(
        [for (final r in approvals) r.url.path],
        [
          '/api/v1/listings/l1/suggestions/good_for_GIFTING/approval',
          '/api/v1/listings/l1/suggestions/summer/approval',
        ],
      );
      expect(
        [for (final r in approvals) jsonDecode(r.body)],
        [
          {'approved': true},
          {'approved': false},
        ],
      );
    },
  );

  test('a 422 is a problem with what was sent', () async {
    Object? caught;
    try {
      await serving(
        'error_422',
        status: 422,
      ).patchListing(listingId: 'l1', changes: {'quantity': -1});
    } catch (error) {
      caught = error;
    }
    expect(ApiProblem.of(caught), ApiProblem.invalid);
  });
}
