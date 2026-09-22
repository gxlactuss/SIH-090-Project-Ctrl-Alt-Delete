import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/data/models/listing.dart';
import 'package:kirtikar/data/models/listing_status.dart';
import 'package:kirtikar/data/remote/http_api.dart';
import 'package:kirtikar/data/remote/hybrid_api.dart';
import 'package:kirtikar/data/remote/mock_api.dart';

void main() {
  group('reading API_REAL_CALLS', () {
    test('unset means what the server answers today', () {
      expect(HybridApi.parse(''), HybridApi.serverReady);
    });

    test('all means every call goes to the server', () {
      expect(HybridApi.parse(' all '), isNull);
    });

    test('none keeps every call on the mock', () {
      expect(HybridApi.parse('none'), isEmpty);
    });

    test('a list picks exactly those calls', () {
      expect(HybridApi.parse('listings, uploadCapture,,listing'), {
        ApiCall.listings,
        ApiCall.uploadCapture,
        ApiCall.listing,
      });
    });

    test('a name that is not a call stops the build', () {
      expect(() => HybridApi.parse('listings,publsh'), throwsArgumentError);
    });

    test('every ApiClient call has a name to move it by', () {
      expect(ApiCall.values, hasLength(17));
    });
  });

  group('routing', () {
    late List<http.Request> seen;
    late MockApi mock;

    HybridApi hybrid(Set<ApiCall> onServer) {
      seen = [];
      mock = MockApi(uploadDuration: Duration.zero);
      return HybridApi(
        server: HttpApi(
          baseUrl: 'https://api.example.test/api/v1',
          client: MockClient((request) async {
            seen.add(request);
            return http.Response(
              jsonEncode([
                {
                  'id': 'server-1',
                  'status': 'ready',
                  'title': 'Clay lamp',
                  'factSheet': {'quantity': 3},
                },
              ]),
              200,
            );
          }),
        ),
        mock: mock,
        onServer: onServer,
      );
    }

    test('a listed call reaches the server', () async {
      final api = hybrid({ApiCall.listings});

      final listings = await api.listings();

      expect(seen.single.url.path, '/api/v1/listings');
      expect(listings.single.id, 'server-1');
    });

    test('an unlisted call never touches the network', () async {
      final api = hybrid({ApiCall.listings});

      expect(await api.sales(), isEmpty);
      expect(await api.minimumSupportedBuild(), isNull);
      expect(seen, isEmpty);
    });

    test(
      'a listing from the server can be published through the mock',
      () async {
        final api = hybrid({ApiCall.listings});
        await api.listings();

        final published = await api.publish(
          listingId: 'server-1',
          photoConsent: true,
          storyConsent: true,
        );

        expect(seen, hasLength(1));
        expect(published.status, ListingStatus.published);
        expect(published.title, 'Clay lamp');
      },
    );

    test('an upload left on the mock stays on the mock', () async {
      final api = hybrid({ApiCall.listings});
      final dir = Directory.systemTemp.createTempSync('hybrid_api_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final photo = File('${dir.path}/p.jpg')..writeAsBytesSync([1, 2, 3]);

      await api.uploadCapture(
        captureId: 'c1',
        photoPaths: [photo.path],
        voiceNotePath: '',
        description: 'A lamp',
      );

      expect(seen, isEmpty);
      expect((await mock.listing('c1')).status, ListingStatus.needsAttention);
    });

    test('an upload sent to the server carries on through the mock', () async {
      seen = [];
      mock = MockApi(uploadDuration: Duration.zero);
      final api = HybridApi(
        server: HttpApi(
          baseUrl: 'https://api.example.test/api/v1',
          client: MockClient((request) async {
            seen.add(request);
            return http.Response(
              jsonEncode({'id': 'uuid-1', 'client_item_id': 'server-1'}),
              200,
            );
          }),
        ),
        mock: mock,
        onServer: {ApiCall.uploadCapture},
      );
      final dir = Directory.systemTemp.createTempSync('hybrid_api_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final photo = File('${dir.path}/p.jpg')..writeAsBytesSync([1, 2, 3]);

      await api.uploadCapture(
        captureId: 'server-1',
        photoPaths: [photo.path],
        voiceNotePath: '',
        description: 'A lamp',
      );

      expect(
        [for (final r in seen) '${r.method} ${r.url.path}'],
        ['POST /api/v1/listings', 'POST /api/v1/listings/uuid-1/media'],
      );
      expect(mock.stored('server-1'), isNotNull);
    });

    test('a server listing with no write-up keeps the phone\'s copy', () async {
      seen = [];
      mock = MockApi(uploadDuration: Duration.zero);
      final api = HybridApi(
        server: HttpApi(
          baseUrl: 'https://api.example.test/api/v1',
          client: MockClient((request) async {
            seen.add(request);
            return http.Response(
              jsonEncode({
                'items': [
                  {'id': 'uuid-9', 'client_item_id': 'c9', 'state': 'queued'},
                ],
              }),
              200,
            );
          }),
        ),
        mock: mock,
        onServer: HybridApi.serverReady,
      );
      mock.adopt(
        const Listing(
          id: 'c9',
          status: ListingStatus.ready,
          title: 'Clay lamp',
          factSheet: FactSheet(),
        ),
      );

      final listing = (await api.listings()).single;

      expect(listing.id, 'c9');
      expect(listing.status, ListingStatus.ready);
      expect(listing.title, 'Clay lamp');
    });

    test('deleting the account empties the mock as well', () async {
      final api = hybrid({ApiCall.listings});
      await api.listings();

      await api.deleteAccount();

      expect(await mock.listings(), isEmpty);
    });
  });
}
