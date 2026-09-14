import 'dart:ui';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.endonym,
    required this.ttsLocale,
    required this.fontFamily,
  });

  final String code;

  final String endonym;

  final String ttsLocale;

  final String fontFamily;

  Locale get locale => Locale(code);

  static const List<AppLanguage> supported = [
    AppLanguage(
      code: 'hi',
      endonym: 'हिंदी',
      ttsLocale: 'hi-IN',
      fontFamily: 'NotoSansDevanagari',
    ),
    AppLanguage(
      code: 'mr',
      endonym: 'मराठी',
      ttsLocale: 'mr-IN',
      fontFamily: 'NotoSansDevanagari',
    ),
    AppLanguage(
      code: 'en',
      endonym: 'English',
      ttsLocale: 'en-IN',
      fontFamily: 'NotoSansDevanagari',
    ),
    AppLanguage(
      code: 'bn',
      endonym: 'বাংলা',
      ttsLocale: 'bn-IN',
      fontFamily: 'NotoSansBengali',
    ),
    AppLanguage(
      code: 'gu',
      endonym: 'ગુજરાતી',
      ttsLocale: 'gu-IN',
      fontFamily: 'NotoSansGujarati',
    ),
    AppLanguage(
      code: 'kn',
      endonym: 'ಕನ್ನಡ',
      ttsLocale: 'kn-IN',
      fontFamily: 'NotoSansKannada',
    ),
    AppLanguage(
      code: 'ml',
      endonym: 'മലയാളം',
      ttsLocale: 'ml-IN',
      fontFamily: 'NotoSansMalayalam',
    ),
    AppLanguage(
      code: 'or',
      endonym: 'ଓଡ଼ିଆ',
      ttsLocale: 'or-IN',
      fontFamily: 'NotoSansOriya',
    ),
    AppLanguage(
      code: 'pa',
      endonym: 'ਪੰਜਾਬੀ',
      ttsLocale: 'pa-IN',
      fontFamily: 'NotoSansGurmukhi',
    ),
    AppLanguage(
      code: 'ta',
      endonym: 'தமிழ்',
      ttsLocale: 'ta-IN',
      fontFamily: 'NotoSansTamil',
    ),
    AppLanguage(
      code: 'te',
      endonym: 'తెలుగు',
      ttsLocale: 'te-IN',
      fontFamily: 'NotoSansTelugu',
    ),
  ];

  static const AppLanguage fallback = AppLanguage(
    code: 'hi',
    endonym: 'हिंदी',
    ttsLocale: 'hi-IN',
    fontFamily: 'NotoSansDevanagari',
  );

  static AppLanguage byCode(String? code) =>
      supported.firstWhere((l) => l.code == code, orElse: () => fallback);

  static List<Locale> get locales =>
      supported.map((l) => l.locale).toList(growable: false);

  static List<String> get fontFamilies =>
      {for (final l in supported) l.fontFamily}.toList(growable: false);
}
