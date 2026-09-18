import '../../core/config/app_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/dev/dev_accounts.dart';

enum OndcLinkOutcome { linked, malformed, emailMalformed, notFound }

class OndcRepository {
  const OndcRepository({
    this.demoLinking = AppConfig.ondcDemoLinking,
    this.delay = AppConstants.fakeNetworkDelay,
  });

  final bool demoLinking;

  final Duration delay;

  String? get demoSellerId =>
      DevAccounts.enabled ? DevAccounts.ondcSellerId : null;

  String? get demoEmail => DevAccounts.enabled ? DevAccounts.ondcEmail : null;

  static final RegExp _wellFormed = RegExp(
    r'^[A-Za-z0-9][A-Za-z0-9._:/-]{1,62}[A-Za-z0-9]$',
  );

  static bool isWellFormed(String sellerId) {
    final id = sellerId.trim();
    return _wellFormed.hasMatch(id) && !id.contains('://');
  }

  static final RegExp _emailShape = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)*\.[A-Za-z]{2,}$",
  );

  static bool isEmailWellFormed(String email) {
    final value = email.trim();
    if (value.length > 254 || !_emailShape.hasMatch(value)) return false;
    final local = value.substring(0, value.indexOf('@'));
    return local.length <= 64 &&
        !local.startsWith('.') &&
        !local.endsWith('.') &&
        !value.contains('..');
  }

  Future<OndcLinkOutcome> link({
    required String email,
    required String sellerId,
  }) async {
    if (!isEmailWellFormed(email)) return OndcLinkOutcome.emailMalformed;
    if (!isWellFormed(sellerId)) return OndcLinkOutcome.malformed;
    await Future<void>.delayed(delay);
    return demoLinking ? OndcLinkOutcome.linked : OndcLinkOutcome.notFound;
  }
}
