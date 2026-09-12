import 'dart:ui';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.endonym,
    required this.ttsLocale,
  });

  final String code;

  final String endonym;

  final String ttsLocale;

  Locale get locale => Locale(code);

  static const List<AppLanguage> supported = [
    AppLanguage(code: 'hi', endonym: 'हिंदी', ttsLocale: 'hi-IN'),
    AppLanguage(code: 'mr', endonym: 'मराठी', ttsLocale: 'mr-IN'),
    AppLanguage(code: 'en', endonym: 'English', ttsLocale: 'en-IN'),
  ];

  static const AppLanguage fallback = AppLanguage(
    code: 'hi',
    endonym: 'हिंदी',
    ttsLocale: 'hi-IN',
  );

  static AppLanguage byCode(String? code) => supported.firstWhere(
        (l) => l.code == code,
        orElse: () => fallback,
      );

  static List<Locale> get locales =>
      supported.map((l) => l.locale).toList(growable: false);
}
