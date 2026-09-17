import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/models/app_language.dart';
import '../data/models/craft_type.dart';
import '../data/models/seller_profile.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/ondc_repository.dart';
import 'app_state.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required this.appState,
    this.auth = const AuthRepository(),
    this.ondc = const OndcRepository(),
  });

  final AppState appState;
  final AuthRepository auth;
  final OndcRepository ondc;

  String _phone = '';
  String get phone => _phone;
  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  CraftType? _craft;
  CraftType? get craft => _craft;
  void setCraft(CraftType? value) {
    _craft = value;
    notifyListeners();
  }

  String? _ondcEmail;
  String? _ondcSellerId;
  String? get ondcEmail => _ondcEmail;
  String? get ondcSellerId => _ondcSellerId;

  bool _ondcAnswered = false;
  bool get ondcAnswered => _ondcAnswered;

  bool get hasOndcAccount => _ondcSellerId != null && _ondcSellerId!.isNotEmpty;

  void linkOndc({required String email, required String sellerId}) {
    _ondcEmail = email.trim();
    _ondcSellerId = sellerId.trim();
    _ondcAnswered = true;
    notifyListeners();
  }

  void skipOndc() {
    _ondcEmail = null;
    _ondcSellerId = null;
    _ondcAnswered = true;
    notifyListeners();
  }

  AppLanguage get language => appState.language;

  Future<SellerProfile> finish() async {
    final profile = SellerProfile(
      id: const Uuid().v4(),
      name: _name.trim(),
      languageCode: appState.language.code,
      phone: _phone,
      craft: _craft,
      ondcSellerId: _ondcSellerId,
      ondcEmail: _ondcEmail,
    );
    await appState.completeSetup(profile);
    return profile;
  }
}
