import 'package:flutter_test/flutter_test.dart';
import 'package:kaarigar/data/repositories/ondc_repository.dart';

void main() {
  test('seller ids in the shapes ONDC uses are well formed', () {
    for (final id in [
      'demo-seller-01',
      'seller.example.com',
      'SELLER_42',
      'ondc:provider/123',
      '  padded-id  ',
    ]) {
      expect(OndcRepository.isWellFormed(id), isTrue, reason: id);
    }
  });

  test('stray scans, typos and sentences are not', () {
    for (final id in [
      '',
      'a',
      'ab',
      'my seller id',
      'https://seller.example.com',
      '-leading-dash',
      'trailing.',
      'x' * 65,
      'सेलर-आईडी',
    ]) {
      expect(OndcRepository.isWellFormed(id), isFalse, reason: id);
    }
  });

  test('real-looking email addresses are well formed', () {
    for (final email in [
      'sunita@gmail.com',
      'a.b+shop@crafts.co.in',
      '  padded@example.com  ',
    ]) {
      expect(OndcRepository.isEmailWellFormed(email), isTrue, reason: email);
    }
  });

  test('anything else is not an email address', () {
    for (final email in [
      '',
      'sunita',
      'sunita@',
      '@gmail.com',
      'sunita@gmail',
      'sunita@gmail.c',
      'sunita @gmail.com',
      'sunita@@gmail.com',
      '.sunita@gmail.com',
      'sunita..devi@gmail.com',
      'sunita@-gmail.com',
      'सुनीता@gmail.com',
    ]) {
      expect(OndcRepository.isEmailWellFormed(email), isFalse, reason: email);
    }
  });

  Future<OndcLinkOutcome> linkNow(
    OndcRepository repository,
    String id, {
    String email = 'sunita@gmail.com',
  }) => repository.link(email: email, sellerId: id);

  test('a bad email is refused before the id is looked at', () async {
    const repository = OndcRepository(demoLinking: true);
    expect(
      await linkNow(repository, 'seller.example.com', email: 'sunita'),
      OndcLinkOutcome.emailMalformed,
    );
    expect(
      await linkNow(repository, 'not an id', email: 'sunita'),
      OndcLinkOutcome.emailMalformed,
    );
  });

  test(
    'demo linking links a well-formed id and refuses a malformed one',
    () async {
      const repository = OndcRepository(demoLinking: true);
      expect(
        await linkNow(repository, 'seller.example.com'),
        OndcLinkOutcome.linked,
      );
      expect(await linkNow(repository, 'not an id'), OndcLinkOutcome.malformed);
    },
  );

  test('without demo linking nothing is found yet', () async {
    const repository = OndcRepository(demoLinking: false);
    expect(
      await linkNow(repository, 'seller.example.com'),
      OndcLinkOutcome.notFound,
    );
    expect(await linkNow(repository, 'not an id'), OndcLinkOutcome.malformed);
  });
}
