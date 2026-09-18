import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/models/app_language.dart';
import '../data/models/craft_type.dart';
import '../data/models/seller_profile.dart';
import '../data/repositories/auth_repository.dart';
import 'app_state.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({required this.appState, AuthRepository? auth})
    : auth = auth ?? AuthRepository();

  final AppState appState;
  final AuthRepository auth;

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

  AppLanguage get language => appState.language;

  Future<SellerProfile> finish() async {
    final profile = SellerProfile(
      id: const Uuid().v4(),
      name: _name.trim(),
      languageCode: appState.language.code,
      phone: _phone,
      craft: _craft,
    );
    await appState.completeSetup(profile);
    return profile;
  }
}
