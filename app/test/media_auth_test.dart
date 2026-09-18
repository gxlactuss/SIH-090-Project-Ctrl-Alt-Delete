import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/remote/media_auth.dart';

void main() {
  MediaAuth auth({String? token = 'abc'}) =>
      MediaAuth(baseUrl: 'https://api.example.test/api/v1', token: () => token);

  test('a photo on the api origin carries the token', () {
    expect(auth().headersFor('https://api.example.test/media/l1/0.jpg'), {
      'authorization': 'Bearer abc',
    });
  });

  test('a photo on another host, scheme or port is fetched bare', () {
    final media = auth();
    expect(media.headersFor('https://cdn.example.test/l1/0.jpg'), isNull);
    expect(media.headersFor('http://api.example.test/media/0.jpg'), isNull);
    expect(media.headersFor('https://api.example.test:8443/0.jpg'), isNull);
    expect(media.headersFor('https://api.example.test.evil/0.jpg'), isNull);
  });

  test('no token yet means no headers', () {
    expect(
      auth(token: null).headersFor('https://api.example.test/media/0.jpg'),
      isNull,
    );
  });
}
