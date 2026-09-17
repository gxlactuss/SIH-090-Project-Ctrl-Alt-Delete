import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/craft_type.dart';
import '../../data/models/seller_profile.dart';
import '../../state/app_state.dart';
import '../routing/app_routes.dart';
import 'dev_accounts.dart';

Future<void> skipOnboardingForDev(BuildContext context) async {
  assert(DevAccounts.enabled);
  if (!DevAccounts.enabled) return;

  final appState = context.read<AppState>();
  final navigator = Navigator.of(context);

  await appState.setLanguage(appState.language);
  await appState.markWelcomeSeen();
  await appState.acceptTerms();
  await appState.completeSetup(
    SellerProfile(
      id: const Uuid().v4(),
      name: 'Dev Seller',
      languageCode: appState.language.code,
      phone: DevAccounts.phone,
      craft: CraftType.values.first,
      ondcSellerId: DevAccounts.ondcSellerId,
    ),
  );

  navigator.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
}
