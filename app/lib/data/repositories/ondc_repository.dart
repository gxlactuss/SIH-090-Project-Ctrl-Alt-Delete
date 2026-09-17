import '../../core/constants/app_constants.dart';
import '../../core/dev/dev_accounts.dart';

/// What happened when we tried to link an ONDC seller account.
enum OndcLinkOutcome { linked, notFound }

/// Screen 1.8, and later 8.6.
///
/// We never hold ONDC money or ONDC orders -- this only records which seller
/// account a published catalogue belongs to. Linking is therefore allowed to
/// fail without blocking anything: a seller with no account still captures
/// and still keeps drafts.
class OndcRepository {
  const OndcRepository();

  String? get demoEmail => DevAccounts.enabled ? DevAccounts.ondcEmail : null;

  String? get demoSellerId => DevAccounts.enabled ? DevAccounts.ondcField : null;

  Future<OndcLinkOutcome> link({
    required String email,
    required String sellerId,
  }) async {
    await Future<void>.delayed(AppConstants.fakeNetworkDelay);

    if (DevAccounts.enabled &&
        email.trim().toLowerCase() == DevAccounts.ondcEmail &&
        sellerId.trim() == DevAccounts.ondcField) {
      return OndcLinkOutcome.linked;
    }
    return OndcLinkOutcome.notFound;
  }
}
