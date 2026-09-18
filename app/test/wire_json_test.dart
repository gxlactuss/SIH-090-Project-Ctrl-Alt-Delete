import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/models/listing_status.dart';
import 'package:kaarigar/data/remote/api_routes.dart';
import 'package:kaarigar/data/remote/http_api.dart';
import 'package:kaarigar/data/remote/wire_json.dart';

void main() {
  group('WireJson', () {
    test('renames keys both ways, at every depth, leaving values alone', () {
      const snake = {
        'image_urls': ['a_b.jpg'],
        'fact_sheet': {'price_in_paise': 100, 'is_one_of_a_kind': true},
        'suggestions': [
          {'spoken_prompt': 'keep_this_value'},
        ],
      };
      const camel = {
        'imageUrls': ['a_b.jpg'],
        'factSheet': {'priceInPaise': 100, 'isOneOfAKind': true},
        'suggestions': [
          {'spokenPrompt': 'keep_this_value'},
        ],
      };

      expect(WireJson.camel(snake), camel);
      expect(WireJson.snake(camel), snake);
      expect(WireJson.camel(camel), camel);
      expect(WireJson.snake(snake), snake);
    });

    test('a listing reads with its status and aliases resolved', () {
      final listing = WireJson.listing({
        'id': 'l1',
        'state': 'needs_attention',
        'follow_up_question': 'How tall is it?',
      });

      expect(listing['status'], 'needsAttention');
      expect(listing['followUpQuestion'], 'How tall is it?');
    });

    test('its own status name wins over an alias', () {
      final listing = WireJson.listing({'status': 'ready', 'state': 'queued'});

      expect(listing['status'], 'ready');
    });

    test('a list is found bare or wrapped', () {
      expect(WireJson.list([1]), [1]);
      expect(
        WireJson.list({
          'items': [1],
        }),
        [1],
      );
      expect(
        WireJson.list({
          'data': [1],
        }),
        [1],
      );
      expect(
        WireJson.list({
          'results': [1],
        }),
        [1],
      );
      expect(WireJson.list({'nothing': 1}), isNull);
      expect(WireJson.list('x'), isNull);
    });
  });

  group('ApiRoute', () {
    test('fills in the id, encoded', () {
      expect(ApiRoutes.publish.path('a b/c'), 'listings/a%20b%2Fc/publish');
      expect(ApiRoutes.listings.path(), 'listings');
      expect(
        ApiRoutes.approveSuggestion.path('l1', 'a/b'),
        'listings/l1/suggestions/a%2Fb/approval',
      );
    });

    test('a route that needs an id refuses to go without one', () {
      expect(() => ApiRoutes.listing.path(), throwsArgumentError);
      expect(() => ApiRoutes.approveSuggestion.path('l1'), throwsArgumentError);
    });
  });

  group('HttpApi against a snake_case server', () {
    late List<http.Request> seen;

    HttpApi api(Object? Function(http.Request) answer) {
      seen = [];
      return HttpApi(
        baseUrl: 'https://api.example.test/api/v1',
        client: MockClient((request) async {
          seen.add(request);
          return http.Response(jsonEncode(answer(request)), 200);
        }),
      );
    }

    test('reads a wrapped list of snake_case listings', () async {
      final client = api(
        (_) => {
          'items': [
            {
              'id': 'l1',
              'state': 'sold_out',
              'image_urls': ['https://cdn.example.test/1.jpg'],
              'suggested_price_in_paise': 50000,
              'fact_sheet': {'price_in_paise': 45000, 'hours_to_make': 4},
            },
          ],
        },
      );

      final listing = (await client.listings()).single;

      expect(listing.status, ListingStatus.soldOut);
      expect(listing.imageUrls, ['https://cdn.example.test/1.jpg']);
      expect(listing.suggestedPriceInPaise, 50000);
      expect(listing.factSheet.priceInPaise, 45000);
      expect(listing.factSheet.hoursToMake, 4);
    });

    test('reads sales spelt in camelCase too', () async {
      final client = api(
        (_) => [
          {
            'id': 's1',
            'listingId': 'l1',
            'listingTitle': 'Jug',
            'amountInPaise': 45000,
            'placedAt': '2026-09-17T10:00:00Z',
          },
        ],
      );

      final sale = (await client.sales()).single;

      expect(sale.listingId, 'l1');
      expect(sale.amountInPaise, 45000);
    });

    test('reads the minimum build in either spelling', () async {
      expect(await api((_) => {'minimum_build': 7}).minimumSupportedBuild(), 7);
      expect(await api((_) => {'minimumBuild': 8}).minimumSupportedBuild(), 8);
    });

    test('writes bodies in the spelling WireJson sets', () async {
      final client = api((_) => {'id': 'l1', 'status': 'published'});

      await client.publish(
        listingId: 'l1',
        photoConsent: true,
        storyConsent: false,
      );

      final consent = seen.singleWhere((r) => r.url.path.endsWith('/consent'));
      final body = jsonDecode(consent.body) as Map;
      final expected = {'photo': true, 'story': false};
      expect(body, WireJson.to(WireJson.jsonBodies, expected));
    });

    test('names multipart parts in the spelling WireJson sets', () async {
      final dir = Directory.systemTemp.createTempSync('wire_json_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final voice = File('${dir.path}/v.m4a')..writeAsBytesSync([1, 2, 3]);
      final client = api((_) => {'id': 'l1', 'status': 'ready'});

      await client.answerQuestion(
        listingId: 'l1',
        voiceReplyPath: voice.path,
        field: 'colour',
      );

      final body = utf8.decode(seen.last.bodyBytes, allowMalformed: true);
      final part = WireJson.name(WireJson.formFields, 'voiceReply');
      expect(body, contains('name="$part"'));
      expect(seen.last.url.path, '/api/v1/listings/l1/answer');
    });
  });
}
