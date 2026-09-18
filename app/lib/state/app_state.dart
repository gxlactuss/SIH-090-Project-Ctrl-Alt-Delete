import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/dev/dev_accounts.dart';
import '../core/dev/dev_flags.dart';
import '../data/models/app_language.dart';
import '../data/models/craft_type.dart';
import '../data/models/seller_profile.dart';
import '../data/repositories/seller_repository.dart';
import '../services/speech_service.dart';

class AppState extends ChangeNotifier {
  AppState({required this.sellers, required this.speech});

  final SellerRepository sellers;
  final SpeechService speech;

  bool _loaded = false;

  bool get isLoaded => _loaded;

  AppLanguage _language = AppLanguage.fallback;
  AppLanguage get language => _language;

  bool _hasChosenLanguage = false;
  bool get hasChosenLanguage => _hasChosenLanguage;

  SellerProfile? _profile;
  SellerProfile? get profile => _profile;

  bool _setupComplete = false;
  bool get hasCompletedSetup => _setupComplete;

  bool _welcomeSeen = false;
  bool get hasSeenWelcome => _welcomeSeen;

  bool _termsAccepted = false;
  bool get hasAcceptedTerms => _termsAccepted;

  bool _practiceSeen = false;

  bool get hasSeenPractice => _practiceSeen;

  bool _ondcAsked = false;

  bool get hasBeenAskedOndc => _ondcAsked;

  Future<void> bootstrap() async {
    if (DevAccounts.enabled && DevFlags.freshStart) {
      await sellers.clear(includeLanguage: true);
    }

    final code = await sellers.languageCode();
    _hasChosenLanguage = code != null;
    _language = AppLanguage.byCode(code);
    _profile = await sellers.profile();
    _setupComplete = await sellers.hasCompletedSetup();
    _welcomeSeen = await sellers.hasSeenWelcome();
    _termsAccepted =
        ((await sellers.acceptedTermsVersion()) ?? 0) >=
        AppConstants.termsVersion;
    _practiceSeen = await sellers.hasSeenPractice();
    _ondcAsked = await sellers.hasBeenAskedOndc();

    unawaited(
      speech.init(
        language: _language,
        speed: await sellers.speechSpeed(),
        autoReadScreens: await sellers.autoReadScreens(),
      ),
    );

    _loaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    _hasChosenLanguage = true;
    notifyListeners();
    await sellers.saveLanguage(language);
    await speech.setLanguage(language);
  }

  Future<void> setSpeechSpeed(double speed) async {
    await speech.setSpeed(speed);
    await sellers.saveSpeechSpeed(speed);
  }

  Future<void> setAutoReadScreens(bool value) async {
    speech.setAutoReadScreens(value);
    await sellers.saveAutoReadScreens(value);
  }

  Future<void> markWelcomeSeen() async {
    if (_welcomeSeen) return;
    _welcomeSeen = true;
    await sellers.markWelcomeSeen();
  }

  Future<void> acceptTerms() async {
    _termsAccepted = true;
    notifyListeners();
    await sellers.markTermsAccepted(AppConstants.termsVersion, DateTime.now());
  }

  Future<void> markPracticeSeen() async {
    if (_practiceSeen) return;
    _practiceSeen = true;
    await sellers.markPracticeSeen();
  }

  Future<void> markOndcAsked() async {
    if (_ondcAsked) return;
    _ondcAsked = true;
    await sellers.markOndcAsked();
  }

  Future<void> updateProfile({
    String? name,
    String? village,
    CraftType? craft,
    String? photoPath,
    String? craftStory,
    String? phone,
    String? ondcSellerId,
    String? ondcEmail,
    bool clearOndc = false,
    bool clearPhoto = false,
  }) async {
    final current = _profile;
    if (current == null) return;

    _profile = current.copyWith(
      name: name,
      village: village,
      craft: craft,
      photoPath: photoPath,
      clearPhoto: clearPhoto,
      craftStory: craftStory,
      phone: phone,
      ondcSellerId: ondcSellerId,
      ondcEmail: ondcEmail,
      clearOndc: clearOndc,
    );
    notifyListeners();
    await sellers.saveProfile(_profile!);
  }

  Future<void> signOut() async {
    await sellers.clear();
    _profile = null;
    _setupComplete = false;
    _welcomeSeen = false;
    _termsAccepted = false;
    _practiceSeen = false;
    _ondcAsked = false;
    notifyListeners();
  }

  Future<void> completeSetup(SellerProfile profile) async {
    _profile = profile;
    _setupComplete = true;
    await sellers.saveProfile(profile);
    await sellers.markSetupComplete();
    notifyListeners();
  }
}
