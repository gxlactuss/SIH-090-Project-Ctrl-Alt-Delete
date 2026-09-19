import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/models/app_language.dart';
import 'package:kirtikar/data/remote/mock_api.dart';
import 'package:kirtikar/data/remote/voice/voice_api.dart';

class _FakeVoice implements VoiceApi {
  _FakeVoice(this.text, {this.available = true, this.blowUp = false});

  final String text;
  final bool available;
  final bool blowUp;
  int calls = 0;

  @override
  bool get isAvailable => available;

  @override
  Future<Transcript> transcribe(
    String path,
    AppLanguage language, {
    bool toEnglish = false,
  }) async {
    calls++;
    if (blowUp) throw const VoiceException(VoiceFailure.network, 'no signal');
    return Transcript(text: text, languageCode: language.ttsLocale);
  }

  @override
  Future<String> translate(
    String text, {
    required AppLanguage from,
    required AppLanguage to,
  }) async => text;

  @override
  Future<Uint8List> speak(String text, AppLanguage language) async =>
      throw UnimplementedError();

  @override
  int get maxSpeakChars => 2500;

  @override
  Duration get maxClipLength => const Duration(seconds: 30);

  @override
  String get voiceName => 'fake';
}

void main() {
  late Directory scratch;
  late String photo;
  late String note;

  setUp(() {
    scratch = Directory.systemTemp.createTempSync('capture-transcript');
    photo = '${scratch.path}/a.jpg';
    note = '${scratch.path}/note.m4a';
    File(photo).writeAsBytesSync([0xFF, 0xD8]);
    File(note).writeAsBytesSync([0x00]);
  });

  tearDown(() => scratch.deleteSync(recursive: true));

  group('a spoken capture reaching the review stage', () {
    test('the artisan\'s own words become the listing description', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-1',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'यह मिट्टी का घड़ा है, हाथ से बनाया गया है',
      );

      final listing = await api.listing('cap-1');
      expect(listing.description, 'यह मिट्टी का घड़ा है, हाथ से बनाया गया है');
    });

    test('a material the artisan named is picked up, and nothing else is', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-2',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'यह मिट्टी का घड़ा है',
      );

      final listing = await api.listing('cap-2');
      expect(listing.factSheet.material, 'मिट्टी');

      expect(listing.factSheet.hoursToMake, isNull);
      expect(listing.factSheet.size, isNull);
    });

    test('a capture with no words invents no material', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-3',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'this is something I made last winter',
      );

      final listing = await api.listing('cap-3');
      expect(listing.factSheet.material, isNull);
    });

    test('answering the follow-up keeps what was said, not a stock sentence', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-4',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'बाँस की टोकरी',
      );

      final answered = await api.answerQuestion(
        listingId: 'cap-4',
        voiceReplyPath: 'reply.m4a',
        transcript: 'इसे बनाने में दो दिन लगे',
      );

      expect(answered.description, contains('बाँस की टोकरी'));
      expect(answered.description, contains('इसे बनाने में दो दिन लगे'));
      expect(answered.description, isNot(contains('Handmade piece')));
      expect(answered.followUpQuestion, isNull);
    });

    test('a spoken field correction stores the spoken value', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-5',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'मिट्टी का घड़ा',
      );

      final corrected = await api.answerQuestion(
        listingId: 'cap-5',
        voiceReplyPath: 'reply.m4a',
        field: 'colour',
        transcript: 'गहरा लाल',
      );

      expect(corrected.factSheet.colour, 'गहरा लाल');
    });

    test('a price correction is read as paise', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-6',
        photoPaths: [photo],
        voiceNotePath: note,
        description: 'मिट्टी का घड़ा',
      );

      final corrected = await api.answerQuestion(
        listingId: 'cap-6',
        voiceReplyPath: 'reply.m4a',
        field: 'price',
        transcript: 'दो सौ पचास 250 रुपये',
      );

      expect(corrected.factSheet.priceInPaise, 25000);
    });

    test('with no transcript the canned demo listing is still produced', () async {
      final api = MockApi(uploadDuration: Duration.zero);
      await api.uploadCapture(
        captureId: 'cap-7',
        photoPaths: [photo],
        voiceNotePath: note,
      );

      final listing = await api.listing('cap-7');
      expect(listing.factSheet.material, 'Clay');
    });
  });

  group('the voice api used for capture', () {
    test('a transcript is only asked for once per recording', () async {
      final voice = _FakeVoice('a clay pot');
      expect(voice.calls, 0);
      await voice.transcribe('note.m4a', AppLanguage.supported.first);
      expect(voice.calls, 1);
    });

    test('a failed transcription throws rather than returning nonsense', () async {
      final voice = _FakeVoice('', blowUp: true);
      expect(
        () => voice.transcribe('note.m4a', AppLanguage.supported.first),
        throwsA(isA<VoiceException>()),
      );
    });
  });
}
