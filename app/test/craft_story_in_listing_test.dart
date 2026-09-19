import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/remote/mock_api.dart';

void main() {
  late Directory scratch;
  late String photo;
  late String note;

  setUp(() {
    scratch = Directory.systemTemp.createTempSync('craft-story');
    photo = '${scratch.path}/a.jpg';
    note = '${scratch.path}/note.m4a';
    File(photo).writeAsBytesSync([0xFF, 0xD8]);
    File(note).writeAsBytesSync([0x00]);
  });

  tearDown(() => scratch.deleteSync(recursive: true));

  Future<String?> describe({String? story, String said = 'A blue clay pot.'}) async {
    final api = MockApi(
      uploadDuration: Duration.zero,
      craftStory: story == null ? null : () => story,
    );
    await api.uploadCapture(
      captureId: 'cap',
      photoPaths: [photo],
      voiceNotePath: note,
      description: said,
    );
    return (await api.listing('cap')).description;
  }

  test('one clause of the story joins what the artisan said', () async {
    final description = await describe(
      story: 'I learned this craft from my grandmother. She worked in Jaipur for forty years.',
    );

    expect(description, startsWith('A blue clay pot.'));
    expect(description, contains('I learned this craft from my grandmother'));
  });

  test('only the first sentence is borrowed, never the whole story', () async {
    final description = await describe(
      story: 'I learned this craft from my grandmother. She worked in Jaipur for forty years.',
    );

    expect(description, isNot(contains('forty years')));
  });

  test('a listing without a story is left exactly as spoken', () async {
    expect(await describe(), 'A blue clay pot.');
  });

  test('a blank story adds nothing', () async {
    expect(await describe(story: '   \n '), 'A blue clay pot.');
  });

  test('a very long first sentence is cut short', () async {
    final description = await describe(story: '${'pottery ' * 80}.');

    expect(description!.length, lessThan(320));
    expect(description, contains('…'));
  });

  test('the story is not repeated when the artisan already said it', () async {
    final description = await describe(
      said: 'A blue clay pot. I learned this craft from my grandmother.',
      story: 'I learned this craft from my grandmother. She worked in Jaipur.',
    );

    expect(
      'I learned this craft from my grandmother'.allMatches(description!).length,
      1,
    );
  });

  test('the story never becomes a fact about the piece', () async {
    final api = MockApi(
      uploadDuration: Duration.zero,
      craftStory: () => 'I have woven silk saris in Varanasi for thirty years.',
    );
    await api.uploadCapture(
      captureId: 'cap',
      photoPaths: [photo],
      voiceNotePath: note,
      description: 'यह मिट्टी का घड़ा है',
    );

    final listing = await api.listing('cap');

    expect(listing.factSheet.material, 'मिट्टी');
    expect(listing.factSheet.size, isNull);
    expect(listing.factSheet.priceInPaise, isNull);
  });
}

extension on String {
  Iterable<Match> allMatches(String input) => RegExp(RegExp.escape(this)).allMatches(input);
}
