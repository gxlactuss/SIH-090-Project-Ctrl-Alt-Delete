import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaarigar/data/models/app_language.dart';
import 'package:kaarigar/data/remote/voice/sarvam_voice_api.dart';
import 'package:kaarigar/data/remote/voice/voice_api.dart';
import 'package:kaarigar/services/spoken_audio_cache.dart';

void main() {
  final hindi = AppLanguage.byCode('hi');
  final english = AppLanguage.byCode('en');
  final odia = AppLanguage.byCode('or');

  http.Response reply(int status, Object body) => http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );

  Map<String, Object?> refusal(String code) => {
    'error': {'request_id': 'r', 'message': code, 'code': code},
  };

  Matcher failsWith(VoiceFailure failure) => throwsA(
    isA<VoiceException>().having((e) => e.failure, 'failure', failure),
  );

  group('requests have the shape Sarvam documents', () {
    test(
      'speak sends the key, the model and Sarvam\'s language code',
      () async {
        late http.Request sent;
        final api = SarvamVoiceApi(
          apiKey: 'test-key',
          client: MockClient((request) async {
            sent = request;
            return reply(200, {
              'request_id': 'r',
              'audios': [
                base64Encode([1, 2, 3]),
              ],
            });
          }),
        );

        final audio = await api.speak('ନମସ୍କାର', odia);

        expect(sent.url.toString(), 'https://api.sarvam.ai/text-to-speech');
        expect(sent.headers['api-subscription-key'], 'test-key');
        final body = jsonDecode(sent.body) as Map<String, Object?>;
        expect(body['text'], 'ନମସ୍କାର');
        expect(body['model'], 'bulbul:v3');
        expect(body['language_code'], 'od-IN');
        expect(audio, [1, 2, 3]);
      },
    );

    test(
      'transcribe uploads the recording with its model and language',
      () async {
        final dir = Directory.systemTemp.createTempSync('kaarigar-sarvam');
        addTearDown(() => dir.deleteSync(recursive: true));
        final clip = File('${dir.path}/clip.m4a')
          ..writeAsBytesSync(List.filled(4000, 7));

        late http.Request sent;
        final api = SarvamVoiceApi(
          apiKey: 'k',
          client: MockClient((request) async {
            sent = request;
            return reply(200, {
              'request_id': 'r',
              'transcript': ' मिट्टी का घड़ा ',
              'language_code': 'hi-IN',
            });
          }),
        );

        final transcript = await api.transcribe(clip.path, hindi);

        expect(sent.url.path, '/speech-to-text');
        final form = latin1.decode(sent.bodyBytes);
        expect(form, contains('name="model"\r\n\r\nsaaras:v3'));
        expect(form, contains('name="mode"\r\n\r\ntranscribe'));
        expect(form, contains('name="language_code"\r\n\r\nhi-IN'));
        expect(form, contains('name="file"'));
        expect(transcript.text, 'मिट्टी का घड़ा');
        expect(transcript.languageCode, 'hi-IN');
      },
    );

    test('translate names both languages', () async {
      late http.Request sent;
      final api = SarvamVoiceApi(
        apiKey: 'k',
        client: MockClient((request) async {
          sent = request;
          return reply(200, {
            'translated_text': 'Clay pot',
            'source_language_code': 'hi-IN',
          });
        }),
      );

      final translated = await api.translate(
        'मिट्टी का घड़ा',
        from: hindi,
        to: english,
      );

      final body = jsonDecode(sent.body) as Map<String, Object?>;
      expect(body['source_language_code'], 'hi-IN');
      expect(body['target_language_code'], 'en-IN');
      expect(translated, 'Clay pot');
    });
  });

  group('refusals', () {
    test('no credits left stops every later call before it is sent', () async {
      var requests = 0;
      final api = SarvamVoiceApi(
        apiKey: 'k',
        client: MockClient((_) async {
          requests++;
          return reply(429, refusal('insufficient_quota_error'));
        }),
      );

      await expectLater(
        api.speak('a', hindi),
        failsWith(VoiceFailure.outOfCredits),
      );
      expect(api.isAvailable, isFalse);

      await expectLater(
        api.speak('b', hindi),
        failsWith(VoiceFailure.unavailable),
      );
      expect(requests, 1);
    });

    test('a refused key turns the service off the same way', () async {
      final api = SarvamVoiceApi(
        apiKey: 'wrong',
        client: MockClient(
          (_) async => reply(403, refusal('invalid_api_key_error')),
        ),
      );

      await expectLater(
        api.speak('a', hindi),
        failsWith(VoiceFailure.unauthorized),
      );
      expect(api.isAvailable, isFalse);
    });

    test('too many requests is only a pause', () async {
      final api = SarvamVoiceApi(
        apiKey: 'k',
        client: MockClient(
          (_) async => reply(429, refusal('rate_limit_exceeded_error')),
        ),
      );

      await expectLater(
        api.speak('a', hindi),
        failsWith(VoiceFailure.rateLimited),
      );
      expect(api.isAvailable, isTrue);
    });

    test('no signal is a network failure, not a refusal', () async {
      final api = SarvamVoiceApi(
        apiKey: 'k',
        client: MockClient((_) async => throw const SocketException('offline')),
      );

      await expectLater(api.speak('a', hindi), failsWith(VoiceFailure.network));
      expect(api.isAvailable, isTrue);
    });
  });

  group('generated speech is paid for once', () {
    test('the second request for a sentence comes from disk', () async {
      final dir = Directory.systemTemp.createTempSync('kaarigar-spoken');
      addTearDown(() => dir.deleteSync(recursive: true));
      final cache = SpokenAudioCache(directory: () async => dir);

      var fetches = 0;
      Future<Uint8List> fetch() async {
        fetches++;
        return Uint8List.fromList([1, 2, 3]);
      }

      final first = await cache.resolve(
        voice: 'v1',
        languageCode: 'hi',
        text: 'नमस्ते',
        fetch: fetch,
      );
      final second = await cache.resolve(
        voice: 'v1',
        languageCode: 'hi',
        text: 'नमस्ते',
        fetch: fetch,
      );

      expect(second, first);
      expect(fetches, 1);
      expect(File(first).readAsBytesSync(), [1, 2, 3]);

      await cache.resolve(
        voice: 'v2',
        languageCode: 'hi',
        text: 'नमस्ते',
        fetch: fetch,
      );
      expect(fetches, 2);
    });
  });
}
