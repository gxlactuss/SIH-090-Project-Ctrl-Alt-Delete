import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_language.dart';
import '../models/seller_profile.dart';

/// Owns the seller profile, the chosen language, and whether setup is done.
///
/// Everything here is on the phone. The profile is written once at the end of
/// onboarding and read on every cold start, so 1.1 can decide in one frame
/// whether to show onboarding or the app.
class SellerRepository {
  /// The instance is injected only by tests; production opens its own.
  SellerRepository({this._prefs});


  static const _kProfile = 'seller_profile';
  static const _kLanguage = 'language_code';
  static const _kOnboardingComplete = 'onboarding_complete';
  static const _kWelcomeSeen = 'welcome_seen';
  static const _kSpeechSpeed = 'speech_speed';
  static const _kAutoRead = 'auto_read_screens';
  static const _kVolume = 'speech_volume';
  static const _kNotifySold = 'notify_sold';
  static const _kNotifyAttention = 'notify_attention';
  static const _kNotifyUpload = 'notify_upload';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  // --- Language -------------------------------------------------------

  /// The picker is screen one, so this is read before anything is drawn.
  /// Null means the seller has never chosen, which is what routes them there.
  Future<String?> languageCode() async => (await _store).getString(_kLanguage);

  Future<AppLanguage> language() async =>
      AppLanguage.byCode(await languageCode());

  Future<void> saveLanguage(AppLanguage language) async =>
      (await _store).setString(_kLanguage, language.code);

  // --- Onboarding progress --------------------------------------------

  Future<bool> hasCompletedSetup() async =>
      (await _store).getBool(_kOnboardingComplete) ?? false;

  Future<void> markSetupComplete() async =>
      (await _store).setBool(_kOnboardingComplete, true);

  /// The three welcome cards are skippable and replayable from Help, so we
  /// remember them separately from setup as a whole.
  Future<bool> hasSeenWelcome() async =>
      (await _store).getBool(_kWelcomeSeen) ?? false;

  Future<void> markWelcomeSeen() async =>
      (await _store).setBool(_kWelcomeSeen, true);

  // --- Profile --------------------------------------------------------

  Future<SellerProfile?> profile() async {
    final raw = (await _store).getString(_kProfile);
    if (raw == null) return null;
    try {
      return SellerProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // A profile we cannot parse is a profile we do not have. Better to
      // re-run setup than to crash on every cold start.
      return null;
    }
  }

  Future<void> saveProfile(SellerProfile profile) async =>
      (await _store).setString(_kProfile, jsonEncode(profile.toJson()));

  // --- Voice and audio settings (8.8) ---------------------------------

  Future<double> speechSpeed() async =>
      (await _store).getDouble(_kSpeechSpeed) ?? 0.85;

  Future<void> saveSpeechSpeed(double speed) async =>
      (await _store).setDouble(_kSpeechSpeed, speed);

  Future<bool> autoReadScreens() async =>
      (await _store).getBool(_kAutoRead) ?? false;

  Future<void> saveAutoReadScreens(bool value) async =>
      (await _store).setBool(_kAutoRead, value);

  Future<double> volume() async => (await _store).getDouble(_kVolume) ?? 1.0;

  Future<void> saveVolume(double value) async =>
      (await _store).setDouble(_kVolume, value);

  // --- Notification settings (8.7) ------------------------------------
  //
  // All three default to on. A seller who has just published something needs
  // to be told when it sells, and someone who has never seen a notification
  // setting will never go looking for one to turn on.

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

  /// Used by 8.11, and by anyone who needs a clean first run on a test phone.
  /// By default the language survives, because a seller who signs out still
  /// reads the same script tomorrow. [includeLanguage] is for the dev fresh
  /// start, which has to land on 1.2 rather than 1.3.
  Future<void> clear({bool includeLanguage = false}) async {
    final store = await _store;
    await Future.wait([
      store.remove(_kProfile),
      store.remove(_kOnboardingComplete),
      store.remove(_kWelcomeSeen),
      store.remove(_kNotifySold),
      store.remove(_kNotifyAttention),
      store.remove(_kNotifyUpload),
      if (includeLanguage) store.remove(_kLanguage),
    ]);
  }
}
