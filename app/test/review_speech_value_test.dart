import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/models/fact_sheet.dart';
import 'package:kirtikar/state/review_controller.dart';

void main() {
  group('reading a spoken correction', () {
    test('words fields keep what the artisan actually said', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.material, ' नीली मिट्टी '),
        'नीली मिट्टी',
      );
    });

    test('chip fields accept an answer that is not one of the presets', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.colour, 'हल्का फ़िरोज़ा'),
        'हल्का फ़िरोज़ा',
      );
    });

    test('price is stored in paise', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.price, '450 rupees'),
        45000,
      );
    });

    test('quantity is stored as spoken', () {
      expect(ReviewController.valueFromSpeech(ListingField.quantity, '3'), 3);
    });

    test('a number surrounded by words is still found', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.price, 'इसकी कीमत 250 रुपये है'),
        25000,
      );
    });

    test('Devanagari digits are read like ASCII ones', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.price, '१२५ रुपये'),
        12500,
      );
    });

    test('Tamil, Bengali and Telugu digits are read too', () {
      expect(ReviewController.valueFromSpeech(ListingField.quantity, '௪'), 4);
      expect(ReviewController.valueFromSpeech(ListingField.quantity, '৭'), 7);
      expect(ReviewController.valueFromSpeech(ListingField.quantity, '౬'), 6);
    });

    test('only the first run of digits is taken', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.quantity, '12 pots, 3 jars'),
        12,
      );
    });

    test('a number field with no number at all is refused', () {
      expect(
        ReviewController.valueFromSpeech(ListingField.price, 'बहुत सस्ता'),
        isNull,
      );
    });

    test('empty speech is refused rather than saved as blank', () {
      expect(ReviewController.valueFromSpeech(ListingField.material, '   '), isNull);
    });
  });
}
