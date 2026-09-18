import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_language.dart';
import '../models/seller_profile.dart';

class SellerRepository {
  SellerRepository({this._prefs});

  static const _kProfile = 'seller_profile';
  static const _kLanguage = 'language_code';
  static const _kOnboardingComplete = 'onboarding_complete';
  static const _kWelcomeSeen = 'welcome_seen';
  static const _kTermsVersion = 'terms_accepted_version';
  static const _kTermsAcceptedAt = 'terms_accepted_at';
  static const _kSpeechSpeed = 'speech_speed';
  static const _kAutoRead = 'auto_read_screens';
  static const _kNotifySold = 'notify_sold';
  static const _kNotifyAttention = 'notify_attention';
  static const _kNotifyUpload = 'notify_upload';
  static const _kNotifyPackBy = 'notify_pack_by';
  static const _kRemindedToPack = 'reminded_to_pack';
  static const _kPracticeSeen = 'practice_seen';
  static const _kOndcAsked = 'ondc_asked';
  static const _kNotificationsAsked = 'notifications_asked';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> languageCode() async => (await _store).getString(_kLanguage);

  Future<AppLanguage> language() async =>
      AppLanguage.byCode(await languageCode());

  Future<void> saveLanguage(AppLanguage language) async =>
      (await _store).setString(_kLanguage, language.code);

  Future<bool> hasCompletedSetup() async =>
      (await _store).getBool(_kOnboardingComplete) ?? false;

  Future<void> markSetupComplete() async =>
      (await _store).setBool(_kOnboardingComplete, true);

  Future<bool> hasSeenWelcome() async =>
      (await _store).getBool(_kWelcomeSeen) ?? false;

  Future<void> markWelcomeSeen() async =>
      (await _store).setBool(_kWelcomeSeen, true);

  Future<int?> acceptedTermsVersion() async =>
      (await _store).getInt(_kTermsVersion);

  Future<DateTime?> termsAcceptedAt() async {
    final raw = (await _store).getString(_kTermsAcceptedAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> markTermsAccepted(int version, DateTime at) async {
    final store = await _store;
    await store.setInt(_kTermsVersion, version);
    await store.setString(_kTermsAcceptedAt, at.toIso8601String());
  }

  Future<SellerProfile?> profile() async {
    final raw = (await _store).getString(_kProfile);
    if (raw == null) return null;
    try {
      return SellerProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(SellerProfile profile) async =>
      (await _store).setString(_kProfile, jsonEncode(profile.toJson()));

  Future<double> speechSpeed() async =>
      (await _store).getDouble(_kSpeechSpeed) ?? 0.85;

  Future<void> saveSpeechSpeed(double speed) async =>
      (await _store).setDouble(_kSpeechSpeed, speed);

  Future<bool> autoReadScreens() async =>
      (await _store).getBool(_kAutoRead) ?? false;

  Future<void> saveAutoReadScreens(bool value) async =>
      (await _store).setBool(_kAutoRead, value);

  Future<bool> notifySold() async =>
      (await _store).getBool(_kNotifySold) ?? true;

  Future<bool> notifyNeedsAttention() async =>
      (await _store).getBool(_kNotifyAttention) ?? true;

  Future<bool> notifyUploadFinished() async =>
      (await _store).getBool(_kNotifyUpload) ?? true;

  Future<void> saveNotifySold(bool value) async =>
      (await _store).setBool(_kNotifySold, value);

  Future<void> saveNotifyNeedsAttention(bool value) async =>
      (await _store).setBool(_kNotifyAttention, value);

  Future<void> saveNotifyUploadFinished(bool value) async =>
      (await _store).setBool(_kNotifyUpload, value);

  Future<bool> notifyPackBy() async =>
      (await _store).getBool(_kNotifyPackBy) ?? true;

  Future<void> saveNotifyPackBy(bool value) async =>
      (await _store).setBool(_kNotifyPackBy, value);

  Future<Set<String>> remindedToPack() async => {
    ...?(await _store).getStringList(_kRemindedToPack),
  };

  Future<void> saveRemindedToPack(Set<String> keys) async =>
      (await _store).setStringList(_kRemindedToPack, keys.toList());

  Future<bool> hasSeenPractice() async =>
      (await _store).getBool(_kPracticeSeen) ?? false;

  Future<void> markPracticeSeen() async =>
      (await _store).setBool(_kPracticeSeen, true);

  Future<bool> hasBeenAskedOndc() async =>
      (await _store).getBool(_kOndcAsked) ?? false;

  Future<void> markOndcAsked() async =>
      (await _store).setBool(_kOndcAsked, true);

  Future<bool> notificationsAsked() async =>
      (await _store).getBool(_kNotificationsAsked) ?? false;

  Future<void> markNotificationsAsked() async =>
      (await _store).setBool(_kNotificationsAsked, true);

  Future<void> clear({bool includeLanguage = false}) async {
    final store = await _store;
    await Future.wait([
      store.remove(_kProfile),
      store.remove(_kOnboardingComplete),
      store.remove(_kWelcomeSeen),
      store.remove(_kTermsVersion),
      store.remove(_kTermsAcceptedAt),
      store.remove(_kNotifySold),
      store.remove(_kNotifyAttention),
      store.remove(_kNotifyUpload),
      store.remove(_kNotifyPackBy),
      store.remove(_kRemindedToPack),
      store.remove(_kPracticeSeen),
      store.remove(_kOndcAsked),
      store.remove(_kNotificationsAsked),
      if (includeLanguage) store.remove(_kLanguage),
    ]);
  }
}
