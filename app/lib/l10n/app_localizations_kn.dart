import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಕಾರಿಗರ್';

  @override
  String get actionNext => 'ಮುಂದೆ';

  @override
  String get actionBack => 'ಹಿಂದೆ';

  @override
  String get actionSkip => 'ಬಿಡಿ';

  @override
  String get actionDone => 'ಆಯಿತು';

  @override
  String get actionListen => 'ಕೇಳಿ';

  @override
  String get actionStopListening => 'ನಿಲ್ಲಿಸಿ';

  @override
  String stepOfSteps(int current, int total) {
    return 'ಹಂತ $current, ಒಟ್ಟು $total';
  }

  @override
  String get splashTagline => 'ಮಾತನಾಡಿ, ನಿಮ್ಮ ವಸ್ತು ಮಾರಾಟವಾಗುತ್ತದೆ';

  @override
  String get languageTitle => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get languageHint => 'ನೀವು ಮಾತನಾಡುವ ಭಾಷೆಯನ್ನು ಒತ್ತಿ';

  @override
  String get welcomeCard1Title => 'ಮೂರು ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get welcomeCard1Body =>
      'ನೀವು ಮಾಡಿದ ವಸ್ತುವಿನ ಮೂರು ಫೋಟೋ ತೆಗೆಯಿರಿ. ಹೇಗೆ ತೆಗೆಯಬೇಕು ಎಂದು ಆ್ಯಪ್ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get welcomeCard2Title => 'ಮಾತಿನಲ್ಲಿ ಹೇಳಿ';

  @override
  String get welcomeCard2Body =>
      'ಇದು ಏನು, ಯಾವುದರಿಂದ ಮಾಡಿದ್ದು, ಬೆಲೆ ಎಷ್ಟು — ಸುಮ್ಮನೆ ಹೇಳಿ. ಬರೆಯುವ ಅಗತ್ಯವಿಲ್ಲ.';

  @override
  String get welcomeCard3Title => 'ಇದು ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತದೆ';

  @override
  String get welcomeCard3Body =>
      'ಮೊದಲು ನಿಮಗೆ ಓದಿ ಹೇಳಲಾಗುತ್ತದೆ. ನೀವು ಹೌದು ಎಂದಾಗ ಮಾತ್ರ ಆನ್‌ಲೈನ್‌ಗೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get welcomeStart => 'ಶುರು ಮಾಡಿ';

  @override
  String get permissionsTitle => 'ಆ್ಯಪ್‌ಗೆ ಮೂರು ವಿಷಯಗಳಿಗೆ ಅನುಮತಿ ಬೇಕು';

  @override
  String get permissionCameraTitle => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get permissionCameraBody =>
      'ನಿಮ್ಮ ವಸ್ತುವಿನ ಫೋಟೋ ತೆಗೆಯಲು. ನೀವು ಹೌದು ಎನ್ನುವವರೆಗೆ ಫೋಟೋಗಳು ನಿಮ್ಮ ಫೋನಿನಲ್ಲೇ ಇರುತ್ತವೆ.';

  @override
  String get permissionMicTitle => 'ಮೈಕ್';

  @override
  String get permissionMicBody => 'ಬರೆಯುವ ಬದಲು ಮಾತನಾಡಲು.';

  @override
  String get permissionNotificationTitle => 'ಸೂಚನೆಗಳು';

  @override
  String get permissionNotificationBody =>
      'ಏನಾದರೂ ಮಾರಾಟವಾದ ತಕ್ಷಣ ನಿಮಗೆ ತಿಳಿಸಲು.';

  @override
  String get permissionAllow => 'ಅನುಮತಿ ಕೊಡಿ';

  @override
  String get permissionNotNow => 'ಈಗ ಬೇಡ';

  @override
  String get permissionGranted => 'ಅನುಮತಿ ಇದೆ';

  @override
  String get permissionDeniedTitle => 'ಅನುಮತಿ ಸಿಗಲಿಲ್ಲ';

  @override
  String get permissionDeniedBody =>
      'ಇದಿಲ್ಲದೆ ಇದು ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ. ಫೋನಿನ ಸೆಟ್ಟಿಂಗ್ಸ್‌ಗೆ ಹೋಗಿ ಅನುಮತಿ ಕೊಡಿ.';

  @override
  String get permissionOpenSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್ ತೆರೆಯಿರಿ';

  @override
  String get phoneTitle => 'ನಿಮ್ಮ ಫೋನ್ ನಂಬರ್';

  @override
  String get phoneWhy =>
      'ಈ ನಂಬರಿಗೆ ನಾವು ಒಂದು ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ. ಈ ನಂಬರನ್ನು ಬೇರೆ ಯಾರಿಗೂ ಕೊಡುವುದಿಲ್ಲ.';

  @override
  String get phoneInvalid => 'ಹತ್ತು ಅಂಕಿಯ ನಂಬರ್ ಹಾಕಿ';

  @override
  String phoneUnknown(String number) {
    return 'ಈ ಡೆಮೋದಲ್ಲಿ ಈ ನಂಬರ್ ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ. $number ಬಳಸಿ.';
  }

  @override
  String get phoneSendCode => 'ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String get otpTitle => 'ಬಂದ ಕೋಡ್ ಹಾಕಿ';

  @override
  String otpSentTo(String number) {
    return '$number ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds ಸೆಕೆಂಡಿನಲ್ಲಿ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get otpResend => 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String get otpCallMe => 'ನನಗೆ ಕರೆ ಮಾಡಿ ಹೇಳಿ';

  @override
  String get otpCalling =>
      'ಸ್ವಲ್ಪ ಹೊತ್ತಿನಲ್ಲಿ ಕರೆ ಬರುತ್ತದೆ ಮತ್ತು ಕೋಡ್ ಓದಿ ಹೇಳಲಾಗುತ್ತದೆ.';

  @override
  String get otpWrong => 'ಕೋಡ್ ಸರಿಯಿಲ್ಲ. ಮತ್ತೆ ಹಾಕಿ.';

  @override
  String get phoneSendFailed =>
      'ಕೋಡ್ ಕಳುಹಿಸಲು ಆಗಲಿಲ್ಲ. ನೆಟ್‌ವರ್ಕ್ ನೋಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get otpExpired => 'ಕೋಡ್ ಅವಧಿ ಮುಗಿದಿದೆ. ಮತ್ತೆ ಕಳುಹಿಸಿ.';

  @override
  String get authTooManyTries =>
      'ತುಂಬಾ ಬಾರಿ ಪ್ರಯತ್ನಿಸಲಾಗಿದೆ. ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get otpChangeNumber => 'ನಂಬರ್ ಬದಲಿಸಿ';

  @override
  String get otpAutoRead => 'ಸಂದೇಶ ತಾನಾಗಿಯೇ ಓದಲಾಯಿತು';

  @override
  String get profileTitle => 'ನಿಮ್ಮ ಬಗ್ಗೆ ಹೇಳಿ';

  @override
  String get profileNameLabel => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get profileNameHint => 'ಹೇಳಿ ಅಥವಾ ಬರೆಯಿರಿ';

  @override
  String get profileNameMissing => 'ನಿಮ್ಮ ಹೆಸರು ಹೇಳಿ';

  @override
  String get profileCraftLabel => 'ನೀವು ಏನು ಮಾಡುತ್ತೀರಿ';

  @override
  String get profileCraftMissing => 'ಒಂದನ್ನು ಆರಿಸಿ';

  @override
  String get profileSpeakToFill => 'ಹೇಳಿ';

  @override
  String get profileListening => 'ಕೇಳುತ್ತಿದ್ದೇವೆ…';

  @override
  String get dictationUnavailable =>
      'ಈ ಫೋನಿನಲ್ಲಿ ಮಾತಿನಿಂದ ಬರೆಯುವುದು ಕೆಲಸ ಮಾಡುತ್ತಿಲ್ಲ. ದಯವಿಟ್ಟು ಬರೆಯಿರಿ.';

  @override
  String get dictationNothingHeard =>
      'ಏನೂ ಕೇಳಿಸಲಿಲ್ಲ. ಮೈಕ್ ಒತ್ತಿ ಮತ್ತೆ ಮಾತನಾಡಿ.';

  @override
  String get craftWeaving => 'ನೇಯ್ಗೆ';

  @override
  String get craftPottery => 'ಕುಂಬಾರಿಕೆ';

  @override
  String get craftWoodwork => 'ಮರದ ಕೆಲಸ';

  @override
  String get craftMetalwork => 'ಲೋಹದ ಕೆಲಸ';

  @override
  String get craftJewellery => 'ಆಭರಣ';

  @override
  String get craftEmbroidery => 'ಕಸೂತಿ';

  @override
  String get craftPainting => 'ಚಿತ್ರಕಲೆ';

  @override
  String get craftLeather => 'ಚರ್ಮದ ಕೆಲಸ';

  @override
  String get craftBamboo => 'ಬಿದಿರು ಮತ್ತು ಬೆತ್ತ';

  @override
  String get craftOther => 'ಬೇರೆ ಏನಾದರೂ';

  @override
  String get ondcTitle => 'ನಿಮ್ಮ ONDC ಖಾತೆ ಜೋಡಿಸಿ';

  @override
  String get ondcExplain =>
      'ONDC ಯಲ್ಲಿ ಖರೀದಿದಾರರು ನೀವು ಮಾಡಿದ್ದನ್ನು ನೋಡಿ ಖರೀದಿಸುತ್ತಾರೆ. ಹಣ ನೇರವಾಗಿ ನಿಮಗೆ ಬರುತ್ತದೆ, ನಮ್ಮ ಮೂಲಕ ಅಲ್ಲ.';

  @override
  String get ondcMalformed =>
      'ಇದು ಸೆಲ್ಲರ್ ಐಡಿಯಂತೆ ಕಾಣುತ್ತಿಲ್ಲ. ದಯವಿಟ್ಟು ಪರಿಶೀಲಿಸಿ, ಅಥವಾ ಕೋಡ್ ಅನ್ನು ಮತ್ತೆ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ.';

  @override
  String get ondcEmailLabel => 'ONDC ಇಮೇಲ್';

  @override
  String get ondcEmailMalformed =>
      'ಇದು ಇಮೇಲ್ ವಿಳಾಸದಂತೆ ಕಾಣುತ್ತಿಲ್ಲ. ದಯವಿಟ್ಟು ಅದನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get ondcSellerIdLabel => 'ಮಾರಾಟಗಾರರ ಐಡಿ';

  @override
  String get ondcScan => 'QR ಕೋಡ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get ondcLink => 'ಖಾತೆ ಜೋಡಿಸಿ';

  @override
  String get ondcLinking => 'ಜೋಡಿಸುತ್ತಿದ್ದೇವೆ…';

  @override
  String get ondcFailed => 'ಈ ಖಾತೆ ಸಿಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ನೋಡಿ.';

  @override
  String get ondcNoAccount => 'ನನಗೆ ಇನ್ನೂ ಖಾತೆ ಇಲ್ಲ';

  @override
  String get ondcNoAccountExplain =>
      'ಪರವಾಗಿಲ್ಲ. ನೀವು ವಸ್ತುಗಳನ್ನು ಸಿದ್ಧ ಮಾಡಿಟ್ಟುಕೊಳ್ಳಬಹುದು. ಖಾತೆ ಜೋಡಿಸಿದ ತಕ್ಷಣ ಎಲ್ಲವೂ ಒಟ್ಟಿಗೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get practiceTitle => 'ಒಳ್ಳೆಯ ಫೋಟೋ ತೆಗೆಯುವುದು ಹೇಗೆ';

  @override
  String get practiceIntro =>
      'ಒಂದೇ ಮಡಕೆ, ಒಮ್ಮೆ ಚೆನ್ನಾಗಿ ಮತ್ತು ಒಮ್ಮೆ ಕೆಟ್ಟದಾಗಿ ತೆಗೆದದ್ದು. ಎರಡನ್ನೂ ನೋಡಲು ಸರಿಸಿ.';

  @override
  String get practiceGoodBadge => 'ಹೀಗೆ ಮಾಡಿ';

  @override
  String get practiceGoodTitle => 'ಒಳ್ಳೆಯ ಫೋಟೋ';

  @override
  String get practiceGoodTip1 => 'ಸ್ಪಷ್ಟ: ಫೋನ್ ಅಲುಗಾಡದಂತೆ ಹಿಡಿದಿತ್ತು';

  @override
  String get practiceGoodTip2 => 'ಬೆಳಕು: ಕಿಟಕಿ ಅಥವಾ ಬಾಗಿಲ ಬಳಿ ತೆಗೆದದ್ದು';

  @override
  String get practiceGoodTip3 => 'ಇಡೀ ವಸ್ತು ಫೋಟೋದಲ್ಲಿದೆ';

  @override
  String get practiceBadBadge => 'ಹೀಗೆ ಮಾಡಬೇಡಿ';

  @override
  String get practiceBadTitle => 'ಕೆಟ್ಟ ಫೋಟೋ';

  @override
  String get practiceBadTip1 => 'ಮಸುಕು: ಫೋನ್ ಅಲುಗಾಡಿತು';

  @override
  String get practiceBadTip2 => 'ಖರೀದಿದಾರರಿಗೆ ವಿವರಗಳು ಕಾಣುವುದಿಲ್ಲ';

  @override
  String get practiceBadTip3 => 'ಆಪ್ ನಿಮಗೆ ಮತ್ತೆ ಫೋಟೋ ತೆಗೆಯಲು ಹೇಳುತ್ತದೆ';

  @override
  String get practiceFinish => 'ಆ್ಯಪ್ ತೆರೆಯಿರಿ';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navListings => 'ವಸ್ತುಗಳು';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String homeGreeting(String name) {
    return 'ನಮಸ್ಕಾರ, $name';
  }

  @override
  String get homeAddProduct => 'ವಸ್ತು ಸೇರಿಸಿ';

  @override
  String get homeAddProductSpoken =>
      'ವಸ್ತು ಸೇರಿಸಲು ಈ ದೊಡ್ಡ ಬಟನ್ ಒತ್ತಿ. ಮೂರು ಫೋಟೋ ತೆಗೆಯಿರಿ, ಇದು ಏನು ಎಂದು ಹೇಳಿ, ಅದು ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತದೆ.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ವಸ್ತುಗಳು ಕಳುಹಿಸಲು ಬಾಕಿ ಇವೆ',
      one: '1 ವಸ್ತು ಕಳುಹಿಸಲು ಬಾಕಿ ಇದೆ',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಮಾರಾಟವಾಗಿವೆ',
      one: '1 ಮಾರಾಟವಾಗಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ವಸ್ತುಗಳು';

  @override
  String get homeNextTitle => 'ಈಗ ಮಾಡಬೇಕಾದದ್ದು';

  @override
  String get homeEmptyTitle => 'ಇಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ';

  @override
  String get homeEmptyBody =>
      'ಮೇಲಿನ ದೊಡ್ಡ ಬಟನ್ ಒತ್ತಿ ನಿಮ್ಮ ಮೊದಲ ವಸ್ತುವನ್ನು ಸೇರಿಸಿ.';

  @override
  String get offlineNoNetwork => 'ಈಗ ನೆಟ್‌ವರ್ಕ್ ಇಲ್ಲ';

  @override
  String get offlineNothingLost =>
      'ಏನೂ ಕಳೆದುಹೋಗಿಲ್ಲ. ನೆಟ್‌ವರ್ಕ್ ಬಂದಾಗ ತಾನಾಗಿಯೇ ಹೋಗುತ್ತದೆ.';

  @override
  String get statusQueued => 'ಕಳುಹಿಸಲು ಬಾಕಿ';

  @override
  String get statusProcessing => 'ಸಿದ್ಧವಾಗುತ್ತಿದೆ';

  @override
  String get statusNeedsAttention => 'ನಿಮ್ಮ ಉತ್ತರ ಬೇಕು';

  @override
  String get statusReady => 'ಮಾರಾಟಕ್ಕೆ ಸಿದ್ಧ';

  @override
  String get statusPublished => 'ಮಾರಾಟದಲ್ಲಿದೆ';

  @override
  String get statusFailed => 'ಕಳುಹಿಸಲಾಗಲಿಲ್ಲ';

  @override
  String get listingUntitled => 'ವಸ್ತು';

  @override
  String get listingNoPrice => 'ಬೆಲೆ ಹೇಳಿಲ್ಲ';

  @override
  String get captureTitle => 'ವಸ್ತು ಸೇರಿಸಿ';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ಫೋಟೋ $current / $total';
  }

  @override
  String get capturePhotoWhole => 'ಇಡೀ ವಸ್ತುವನ್ನು ತೋರಿಸಿ';

  @override
  String get capturePhotoDetail => 'ಹತ್ತಿರದಿಂದ ಒಂದು ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get capturePhotoScale => 'ಅಳತೆ ಗೊತ್ತಾಗಲು ಪಕ್ಕದಲ್ಲಿ ಕೈ ಇಡಿ';

  @override
  String get captureTakePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get captureFromGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ';

  @override
  String get captureTorchOn => 'ಬೆಳಕು ಆನ್';

  @override
  String get captureTorchOff => 'ಬೆಳಕು ಆಫ್';

  @override
  String get captureCameraFailed => 'ಕ್ಯಾಮೆರಾ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get captureCameraRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get captureCameraPermission =>
      'ನಿಮ್ಮ ವಸ್ತುವಿನ ಫೋಟೋ ತೆಗೆಯಲು ಆ್ಯಪ್‌ಗೆ ಕ್ಯಾಮೆರಾ ಬೇಕು.';

  @override
  String get captureOpenSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್ ತೆರೆಯಿರಿ';

  @override
  String get captureLeaveTitle => 'ಉಳಿಸದೆ ಹೊರಗೆ ಹೋಗುವುದೇ?';

  @override
  String get captureLeaveBody => 'ಫೋಟೋಗಳು ಮತ್ತು ನೀವು ಹೇಳಿದ್ದು ಅಳಿಸಿಹೋಗುತ್ತದೆ.';

  @override
  String get captureLeaveConfirm => 'ಅಳಿಸಿಬಿಡಿ';

  @override
  String get captureLeaveCancel => 'ಇಲ್ಲೇ ಇರಿ';

  @override
  String get shotReviewChecking => 'ಫೋಟೋ ಪರಿಶೀಲಿಸುತ್ತಿದ್ದೇವೆ…';

  @override
  String get shotReviewRetake => 'ಮತ್ತೆ ತೆಗೆಯಿರಿ';

  @override
  String get qualityTooDark =>
      'ಈ ಫೋಟೋ ತುಂಬಾ ಕತ್ತಲಾಗಿದೆ. ಬಾಗಿಲಿನ ಹತ್ತಿರ ನಿಂತು ತೆಗೆಯಿರಿ.';

  @override
  String get qualityTooBright =>
      'ಇದರ ಮೇಲೆ ತುಂಬಾ ಬೆಳಕಿದೆ. ಬಿಸಿಲಿಗೆ ಬೆನ್ನು ಮಾಡಿ ತೆಗೆಯಿರಿ.';

  @override
  String get qualityBlurry =>
      'ಈ ಫೋಟೋ ಸ್ಪಷ್ಟವಾಗಿಲ್ಲ. ಫೋನ್ ಅಲುಗಾಡದಂತೆ ಹಿಡಿದು ಮತ್ತೆ ತೆಗೆಯಿರಿ.';

  @override
  String get qualityUnreadable =>
      'ಈ ಫೋಟೋ ಸರಿಯಾಗಿ ಉಳಿಯಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ತೆಗೆಯಿರಿ.';

  @override
  String get qualityNoSubject =>
      'ಈ ಫೋಟೋದಲ್ಲಿ ವಸ್ತು ಕಾಣುತ್ತಿಲ್ಲ. ಅದನ್ನು ಗೆರೆಯೊಳಗೆ ಇಟ್ಟು ಹತ್ತಿರ ಬನ್ನಿ.';

  @override
  String get qualityOutOfFrame =>
      'ಈ ಫೋಟೋದಲ್ಲಿ ವಸ್ತುವಿನ ಒಂದು ಭಾಗ ಮಾತ್ರ ಇದೆ. ಇಡೀ ವಸ್ತುವನ್ನು ಗೆರೆಯೊಳಗೆ ಇಡಿ.';

  @override
  String get qualityWarningTitle => 'ಇದನ್ನು ಮತ್ತೆ ತೆಗೆಯಿರಿ';

  @override
  String get qualityKeepAnyway => 'ಆದರೂ ಇಟ್ಟುಕೊಳ್ಳಿ';

  @override
  String get photoSetTitle => 'ನಿಮ್ಮ ಮೂರು ಫೋಟೋಗಳು';

  @override
  String get photoSetBody =>
      'ಖರೀದಿದಾರರು ಮೊದಲ ಫೋಟೋವನ್ನೇ ಮೊದಲು ನೋಡುತ್ತಾರೆ. ಫೋಟೋವನ್ನು ಮತ್ತೆ ತೆಗೆಯಲು ಅದನ್ನು ಒತ್ತಿ.';

  @override
  String get photoSetMain => 'ಮೊದಲ ಫೋಟೋ';

  @override
  String get photoSetRetakeThis => 'ಇದನ್ನು ಮತ್ತೆ ತೆಗೆಯಿರಿ';

  @override
  String get photoSetConfirm => 'ಈ ಫೋಟೋಗಳು ಸರಿಯಾಗಿವೆ';

  @override
  String get photoEditOpen => 'ಫೋಟೋ ಕತ್ತರಿಸಿ ಅಥವಾ ತಿರುಗಿಸಿ';

  @override
  String get photoEditTitle => 'ಫೋಟೋ ಕತ್ತರಿಸಿ';

  @override
  String get photoEditBody =>
      'ಕತ್ತರಿಸಲು ಚೌಕಟ್ಟಿನ ಮೂಲೆ ಅಥವಾ ಅಂಚನ್ನು ಎಳೆಯಿರಿ. ಸರಿಸಲು ಚೌಕಟ್ಟಿನ ಒಳಗಿನಿಂದ ಎಳೆಯಿರಿ.';

  @override
  String get photoEditTurn => 'ತಿರುಗಿಸಿ';

  @override
  String get photoEditStraighten => 'ನೇರ ಮಾಡಿ';

  @override
  String get photoEditReset => 'ಮತ್ತೆ ಶುರು ಮಾಡಿ';

  @override
  String get photoEditDone => 'ಈ ಫೋಟೋ ಬಳಸಿ';

  @override
  String get photoEditCancel => 'ಹಿಂದೆ ಹೋಗಿ';

  @override
  String get photoEditFailed => 'ಈ ಬದಲಾವಣೆ ಉಳಿಸಲಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get photoIssueTooDark => 'ತುಂಬಾ ಕತ್ತಲು, ಸರಿಯಾಗಿ ಕಾಣುವುದಿಲ್ಲ';

  @override
  String get photoIssueTooBright => 'ಇದರ ಮೇಲೆ ತುಂಬಾ ಬೆಳಕು';

  @override
  String get photoIssueBlurry => 'ಮಸುಕಾಗಿದೆ, ಸಾಕಷ್ಟು ಸ್ಪಷ್ಟವಿಲ್ಲ';

  @override
  String get photoIssueNoSubject => 'ಈ ಫೋಟೋದಲ್ಲಿ ಯಾವ ವಸ್ತುವೂ ಕಾಣುತ್ತಿಲ್ಲ';

  @override
  String get photoIssueUnreadable => 'ಈ ಫೋಟೋ ಉಳಿಯಲಿಲ್ಲ';

  @override
  String get photoIssueOutOfFrame => 'ವಸ್ತು ಪೂರ್ತಿ ಫೋಟೋದಲ್ಲಿ ಇಲ್ಲ';

  @override
  String get voiceTitle => 'ಈಗ ಇದು ಏನು ಎಂದು ಹೇಳಿ';

  @override
  String get voiceBody =>
      'ಇದು ಏನು, ಯಾವುದರಿಂದ ಮಾಡಿದ್ದು, ಎಷ್ಟು ದೊಡ್ಡದು, ಮಾಡಲು ಎಷ್ಟು ಸಮಯ ಹಿಡಿಯಿತು, ಮತ್ತು ಬೆಲೆ ಎಷ್ಟು.';

  @override
  String get voiceHoldToSpeak => 'ಒತ್ತಿ ಹಿಡಿದು ಮಾತನಾಡಿ';

  @override
  String get voiceRecording => 'ಮಾತನಾಡಿ… ಮುಗಿದಾಗ ಬಿಡಿ';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total ರಲ್ಲಿ $seconds ಸೆಕೆಂಡ್';
  }

  @override
  String get voiceTooShort =>
      'ಅದು ತುಂಬಾ ಚಿಕ್ಕದಾಗಿತ್ತು. ಬಟನ್ ಒತ್ತಿ ಹಿಡಿದು ಮತ್ತೆ ಮಾತನಾಡಿ.';

  @override
  String get voiceFailed =>
      'ಮೈಕ್ ಶುರುವಾಗಲಿಲ್ಲ. ಆ್ಯಪ್‌ಗೆ ಮೈಕ್ ಅನುಮತಿ ಇದೆಯೇ ನೋಡಿ.';

  @override
  String get voiceBackToPhotos => 'ಫೋಟೋಗಳಿಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get playbackPlay => 'ಕೇಳಿ';

  @override
  String get playbackStop => 'ನಿಲ್ಲಿಸಿ';

  @override
  String get playbackAgain => 'ಮತ್ತೆ ಹೇಳಿ';

  @override
  String get playbackAccept => 'ಇದು ಸರಿ';

  @override
  String get playbackUnavailable =>
      'ಈ ಫೋನ್ ಅದನ್ನು ಕೇಳಿಸಲು ಆಗುತ್ತಿಲ್ಲ. ನೀವು ಆದರೂ ಕಳುಹಿಸಬಹುದು, ಅಥವಾ ಮತ್ತೆ ಹೇಳಬಹುದು.';

  @override
  String get savedTitle => 'ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get savedBody => 'ನೆಟ್‌ವರ್ಕ್ ಬಂದಾಗ ತಾನಾಗಿಯೇ ಹೋಗುತ್ತದೆ.';

  @override
  String get savedBodyOnline =>
      'ಈಗ ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ. ನೀವು ಇಲ್ಲಿ ಕಾಯುವ ಅಗತ್ಯವಿಲ್ಲ.';

  @override
  String get savedAddAnother => 'ಇನ್ನೊಂದು ವಸ್ತು ಸೇರಿಸಿ';

  @override
  String get savedGoHome => 'ಮುಖಪುಟಕ್ಕೆ ಹೋಗಿ';

  @override
  String get saveFailed => 'ಈ ಫೋನಿನಲ್ಲಿ ಉಳಿಸಲಾಗಲಿಲ್ಲ. ಬಹುಶಃ ಜಾಗ ಇಲ್ಲ.';

  @override
  String get saveRetry => 'ಮತ್ತೆ ಉಳಿಸಲು ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get queueTitle => 'ಕಳುಹಿಸಲು ಬಾಕಿ';

  @override
  String get queueBody =>
      'ಇಲ್ಲಿ ಏನೂ ಕಳೆದುಹೋಗಿಲ್ಲ. ನೆಟ್‌ವರ್ಕ್ ಬಂದ ತಕ್ಷಣ ಪ್ರತಿಯೊಂದೂ ಹೋಗುತ್ತದೆ.';

  @override
  String get queueEmptyTitle => 'ಏನೂ ಬಾಕಿ ಇಲ್ಲ';

  @override
  String get queueEmptyBody => 'ನೀವು ಮಾಡಿದ್ದೆಲ್ಲವೂ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get queueStateWaiting => 'ನೆಟ್‌ವರ್ಕ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String queueStateUploading(int percent) {
    return 'ಕಳುಹಿಸುತ್ತಿದೆ… ನೂರರಲ್ಲಿ $percent';
  }

  @override
  String get queueStateProcessing => 'ಈಗ ನಮ್ಮ ಬಳಿ ಇದೆ. ನಾವು ಬರೆಯುತ್ತಿದ್ದೇವೆ.';

  @override
  String get queueStateFailed => 'ಹೋಗಲಿಲ್ಲ. ಕಾರಣ ನೋಡಲು ಒತ್ತಿ.';

  @override
  String get queueItemTitle => 'ಈ ವಸ್ತು';

  @override
  String queueMadeAt(String date) {
    return '$date ರಂದು ಮಾಡಿದ್ದು';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಬಾರಿ ಪ್ರಯತ್ನಿಸಲಾಗಿದೆ',
      one: 'ಒಮ್ಮೆ ಪ್ರಯತ್ನಿಸಲಾಗಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'ಈಗಲೇ ಕಳುಹಿಸಲು ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get queueRetryWaiting => 'ಇನ್ನೂ ನೆಟ್‌ವರ್ಕ್ ಇಲ್ಲ. ತಾನಾಗಿಯೇ ಹೋಗುತ್ತದೆ.';

  @override
  String get queueDelete => 'ಈ ವಸ್ತು ಅಳಿಸಿ';

  @override
  String get queueDeleteTitle => 'ಈ ವಸ್ತು ಅಳಿಸುವುದೇ?';

  @override
  String get queueDeleteBody =>
      'ಫೋಟೋಗಳು ಮತ್ತು ನೀವು ಹೇಳಿದ್ದು ಹೋಗುತ್ತದೆ. ಇದನ್ನು ಮರಳಿ ಪಡೆಯಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get queueDeleteConfirm => 'ಹೌದು, ಅಳಿಸಿ';

  @override
  String get queueDeleteCancel => 'ಬೇಡ, ಇರಲಿ';

  @override
  String get failureNetwork =>
      'ನೆಟ್‌ವರ್ಕ್ ಅರ್ಧದಲ್ಲೇ ನಿಂತಿತು. ಸಿಗ್ನಲ್ ಬಂದಾಗ ತಾನಾಗಿಯೇ ಮತ್ತೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get failureServer =>
      'ನಮ್ಮ ಕಡೆಯಿಂದ ಉತ್ತರ ಬರಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get failureMissingFiles =>
      'ಫೋಟೋಗಳು ಈಗ ಈ ಫೋನಿನಲ್ಲಿ ಇಲ್ಲ, ಹಾಗಾಗಿ ಇದನ್ನು ಕಳುಹಿಸಲಾಗದು. ದಯವಿಟ್ಟು ಮತ್ತೆ ಮಾಡಿ.';

  @override
  String get failureRejected => 'ಇದನ್ನು ಸ್ವೀಕರಿಸಲಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಮಾಡಿ.';

  @override
  String get failureUnknown => 'ಏನೋ ತಪ್ಪಾಯಿತು. ನೀವು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಬಹುದು.';

  @override
  String get processingTitle => 'ನಾವು ಬರೆಯುತ್ತಿದ್ದೇವೆ';

  @override
  String get processingBody =>
      'ನಿಮ್ಮ ಫೋಟೋಗಳು ಮತ್ತು ಮಾತುಗಳು ನಮ್ಮ ಬಳಿ ಇವೆ. ಇದಕ್ಕೆ ಕೆಲವು ನಿಮಿಷ ಬೇಕು.';

  @override
  String get processingLeave =>
      'ನೀವು ಇಲ್ಲಿ ಕಾಯುವ ಅಗತ್ಯವಿಲ್ಲ. ಸಿದ್ಧವಾದಾಗ ನಾವು ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get processingGoHome => 'ಮುಖಪುಟಕ್ಕೆ ಹೋಗಿ';

  @override
  String get attentionTitle => 'ಒಂದು ಪ್ರಶ್ನೆ';

  @override
  String get attentionBody => 'ಉಳಿದದ್ದೆಲ್ಲಾ ನಮಗೆ ಅರ್ಥವಾಯಿತು. ಇದೊಂದೇ ಬಾಕಿ.';

  @override
  String get attentionHoldToAnswer => 'ಒತ್ತಿ ಹಿಡಿದು ಉತ್ತರಿಸಿ';

  @override
  String get attentionAnswering => 'ನಿಮ್ಮ ಉತ್ತರ ಕಳುಹಿಸುತ್ತಿದ್ದೇವೆ…';

  @override
  String get attentionFailed => 'ನಿಮ್ಮ ಉತ್ತರ ಹೋಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಹೇಳಿ.';

  @override
  String get readBackTitle => 'ನಮಗೆ ಅರ್ಥವಾದದ್ದು ಇದು';

  @override
  String get readBackListen => 'ಪೂರ್ತಿ ಕೇಳಿ';

  @override
  String get readBackFields => 'ನಾವು ಬರೆದುಕೊಂಡದ್ದು';

  @override
  String get readBackCorrect => 'ತಪ್ಪಿರುವುದನ್ನು ಒತ್ತಿ';

  @override
  String get readBackApprove => 'ಇದೆಲ್ಲವೂ ಸರಿ';

  @override
  String get notSaid => 'ಹೇಳಿಲ್ಲ';

  @override
  String get fieldMaterial => 'ಯಾವುದರಿಂದ ಮಾಡಿದ್ದು';

  @override
  String get fieldSize => 'ಅಳತೆ';

  @override
  String get fieldColour => 'ಬಣ್ಣ';

  @override
  String get fieldTechnique => 'ಹೇಗೆ ಮಾಡಿದ್ದು';

  @override
  String get fieldQuantity => 'ಎಷ್ಟು';

  @override
  String get fieldPrice => 'ಬೆಲೆ';

  @override
  String correctTitle(String field) {
    return 'ಸರಿಯಾದ $field ಹೇಳಿ';
  }

  @override
  String get correctHoldToSpeak => 'ಒತ್ತಿ ಹಿಡಿದು ಹೇಳಿ';

  @override
  String get correctListening => 'ಕೇಳುತ್ತಿದ್ದೇವೆ…';

  @override
  String get correctFailedOnce => 'ನಮಗೆ ಅರ್ಥವಾಗಲಿಲ್ಲ. ಇನ್ನೊಮ್ಮೆ ಹೇಳಿ.';

  @override
  String get correctUseKeypad => 'ಬದಲಾಗಿ ಬರೆಯಿರಿ';

  @override
  String get correctUseVoice => 'ಬದಲಾಗಿ ಹೇಳಿ';

  @override
  String get correctPick => 'ಅಥವಾ ಒಂದನ್ನು ಆರಿಸಿ';

  @override
  String get correctSave => 'ಇದನ್ನು ಉಳಿಸಿ';

  @override
  String get correctCancel => 'ಇದ್ದಂತೆ ಇರಲಿ';

  @override
  String get colourRed => 'ಕೆಂಪು';

  @override
  String get colourBlue => 'ನೀಲಿ';

  @override
  String get colourGreen => 'ಹಸಿರು';

  @override
  String get colourYellow => 'ಹಳದಿ';

  @override
  String get colourBlack => 'ಕಪ್ಪು';

  @override
  String get colourWhite => 'ಬಿಳಿ';

  @override
  String get colourBrown => 'ಕಂದು';

  @override
  String get colourMulti => 'ಹಲವು ಬಣ್ಣ';

  @override
  String get sizeSmall => 'ಚಿಕ್ಕದು';

  @override
  String get sizeMedium => 'ಮಧ್ಯಮ';

  @override
  String get sizeLarge => 'ದೊಡ್ಡದು';

  @override
  String get sizeExtraLarge => 'ತುಂಬಾ ದೊಡ್ಡದು';

  @override
  String get suggestTitle => 'ಇದನ್ನೂ ಸೇರಿಸೋಣವೇ?';

  @override
  String get suggestYes => 'ಹೌದು, ಸೇರಿಸಿ';

  @override
  String get suggestNo => 'ಬೇಡ, ಬಿಡಿ';

  @override
  String get suggestSkip => 'ನನಗೆ ಖಚಿತವಿಲ್ಲ';

  @override
  String suggestProgress(int current, int total) {
    return '$total ರಲ್ಲಿ $current';
  }

  @override
  String get suggestDone => 'ಇನ್ನೇನೂ ಸೇರಿಸಲು ಇಲ್ಲ';

  @override
  String get priceTitle => 'ಬೆಲೆ ಎಷ್ಟು?';

  @override
  String get priceBody => 'ಇದು ಒಂದು ತುಂಡಿನ ಬೆಲೆ.';

  @override
  String priceFloor(String amount) {
    return 'ನಿಮಗೆ ಆದ ಖರ್ಚು: $amount';
  }

  @override
  String get priceFloorExplain =>
      'ನಿಮ್ಮ ಸಾಮಗ್ರಿ ಮತ್ತು ನಿಮ್ಮ ಸಮಯ ಸೇರಿ ಇಷ್ಟಾಗುತ್ತದೆ. ಇದಕ್ಕಿಂತ ಕಡಿಮೆಗೆ ಮಾರಿದರೆ ನಿಮಗೆ ನಷ್ಟ.';

  @override
  String priceBand(String low, String high) {
    return 'ಇಂತಹ ವಸ್ತುಗಳನ್ನು ಬೇರೆಯವರು $low ರಿಂದ $high ಗೆ ಮಾರುತ್ತಾರೆ';
  }

  @override
  String get priceBelowFloor =>
      'ಇದು ನಿಮ್ಮ ಖರ್ಚಿಗಿಂತ ಕಡಿಮೆ. ಆದರೂ ನೀವು ಇದನ್ನೇ ಆರಿಸಬಹುದು.';

  @override
  String get priceSayIt => 'ಬೆಲೆ ಹೇಳಿ';

  @override
  String get priceConfirm => 'ಈ ಬೆಲೆ ಸರಿ';

  @override
  String get stockTitle => 'ನಿಮ್ಮ ಬಳಿ ಎಷ್ಟಿವೆ?';

  @override
  String get stockBody =>
      'ಎಲ್ಲವೂ ಮಾರಾಟವಾದಾಗ ನಾವು ನಿಮಗಾಗಿ ಇದನ್ನು ತೆಗೆದುಹಾಕುತ್ತೇವೆ.';

  @override
  String get stockOneOfAKind => 'ಒಂದೇ ಇದೆ, ಇನ್ನೊಂದು ಎಂದಿಗೂ ಆಗುವುದಿಲ್ಲ';

  @override
  String get stockMore => 'ಇನ್ನೊಂದು';

  @override
  String get stockLess => 'ಒಂದು ಕಡಿಮೆ';

  @override
  String get stockConfirm => 'ಇದು ಸರಿ';

  @override
  String get photosTitle => 'ಯಾವ ಫೋಟೋ ಮೊದಲು ಬರಬೇಕು?';

  @override
  String get photosBody =>
      'ಖರೀದಿದಾರರು ಮೊದಲ ಫೋಟೋವನ್ನು ಎಲ್ಲಕ್ಕಿಂತ ಮೊದಲು ನೋಡುತ್ತಾರೆ.';

  @override
  String get photosMakeFirst => 'ಇದನ್ನು ಮೊದಲ ಫೋಟೋ ಮಾಡಿ';

  @override
  String get photosFirst => 'ಮೊದಲ ಫೋಟೋ';

  @override
  String get photosConfirm => 'ಈ ಫೋಟೋಗಳು ಸರಿ';

  @override
  String get previewTitle => 'ಖರೀದಿದಾರರು ಇದನ್ನು ನೋಡುತ್ತಾರೆ';

  @override
  String get previewListenAll => 'ಎಲ್ಲವನ್ನೂ ಕೇಳಿ';

  @override
  String get previewNoDescription => 'ಯಾವ ವಿವರಣೆಯೂ ಬರೆದಿಲ್ಲ.';

  @override
  String get previewConfirm => 'ಹೌದು, ಇದು ಸರಿ';

  @override
  String get previewChange => 'ಏನಾದರೂ ಬದಲಿಸಿ';

  @override
  String get consentTitle => 'ನಾವು ಇದನ್ನು ಮಾರಾಟಕ್ಕೆ ಇಡಬಹುದೇ?';

  @override
  String get consentPhoto => 'ನನ್ನ ಫೋಟೋಗಳನ್ನು ತೋರಿಸಿ';

  @override
  String get consentPhotoExplain =>
      'ನಿಮ್ಮ ವಸ್ತುವಿನ ಫೋಟೋಗಳು ಖರೀದಿದಾರರ ಪರದೆಯ ಮೇಲೆ ಹೋಗುತ್ತವೆ.';

  @override
  String get consentStory => 'ನನ್ನ ಕರಕುಶಲ ಕಥೆ ತೋರಿಸಿ';

  @override
  String get consentStoryExplain =>
      'ನಿಮ್ಮ ಹೆಸರು, ನಿಮ್ಮ ಊರು ಮತ್ತು ನೀವು ಹೇಗೆ ಮಾಡುತ್ತೀರಿ ಎಂಬುದು ಕಾರಿಗರ್ ಕಾರ್ಡ್ ಮೇಲೆ ಹೋಗುತ್ತದೆ. ಬೇಡ ಎಂದರೂ ನೀವು ಮಾರಬಹುದು.';

  @override
  String get consentNeeded => 'ಫೋಟೋಗಳಿಲ್ಲದೆ ನಾವು ಇದನ್ನು ಇಡಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get consentPublish => 'ಮಾರಾಟಕ್ಕೆ ಇಡಿ';

  @override
  String get publishingTitle => 'ಮಾರಾಟಕ್ಕೆ ಇಡುತ್ತಿದ್ದೇವೆ';

  @override
  String get publishingBody => 'ಇದಕ್ಕೆ ಸ್ವಲ್ಪ ಸಮಯ ಬೇಕು. ಆ್ಯಪ್ ಮುಚ್ಚಬೇಡಿ.';

  @override
  String get publishedTitle => 'ಇದು ಮಾರಾಟಕ್ಕಿದೆ';

  @override
  String get publishedBody => 'ಖರೀದಿದಾರರು ಈಗ ಇದನ್ನು ನೋಡಬಹುದು.';

  @override
  String get publishedShare => 'ವಾಟ್ಸ್‌ಆ್ಯಪ್‌ನಲ್ಲಿ ಕಳುಹಿಸಿ';

  @override
  String get publishedCopyLink => 'ಲಿಂಕ್ ಕಾಪಿ ಮಾಡಿ';

  @override
  String get publishedLinkCopied => 'ಲಿಂಕ್ ಕಾಪಿ ಆಯಿತು';

  @override
  String get publishedShowQr => 'ಸ್ಕ್ಯಾನ್ ಮಾಡುವ ಕೋಡ್ ತೋರಿಸಿ';

  @override
  String get publishedQrExplain =>
      'ಯಾರಾದರೂ ಇದರ ಕಡೆ ಫೋನ್ ಹಿಡಿದು ನಿಮ್ಮ ವಸ್ತುವನ್ನು ತೆರೆಯಬಹುದು.';

  @override
  String get publishedAnother => 'ಇದರಂತೆ ಇನ್ನೊಂದು ಮಾಡಿ';

  @override
  String get publishedDone => 'ಮುಖಪುಟಕ್ಕೆ ಹೋಗಿ';

  @override
  String get publishFailed =>
      'ಇದನ್ನು ಇಡಲಾಗಲಿಲ್ಲ. ಏನೂ ಕಳೆದುಹೋಗಿಲ್ಲ — ನೀವು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಬಹುದು.';

  @override
  String get publishRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get reviewLeaveTitle => 'ಸದ್ಯಕ್ಕೆ ಬಿಡುವುದೇ?';

  @override
  String get reviewLeaveBody =>
      'ನೀವು ಒಪ್ಪಿದ್ದು ಉಳಿಯುತ್ತದೆ. ನಿಮ್ಮ ವಸ್ತುಗಳಿಂದ ಮತ್ತೆ ಬರಬಹುದು.';

  @override
  String get reviewLeaveConfirm => 'ಸದ್ಯಕ್ಕೆ ಬಿಡಿ';

  @override
  String get editLeaveTitle => 'ನಿಮ್ಮ ಬದಲಾವಣೆಗಳು ಇನ್ನೂ ಮಾರಾಟದಲ್ಲಿಲ್ಲ';

  @override
  String get editLeaveBody =>
      'ನೀವು ಮಾಡಿದ ಬದಲಾವಣೆ ಉಳಿದಿದೆ, ಆದರೆ ಖರೀದಿದಾರರು ಇನ್ನೂ ಹಳೆಯದನ್ನೇ ನೋಡುತ್ತಾರೆ. ಕೊನೆಯ ಬಟನ್ ಒತ್ತಿದಾಗ ಮಾತ್ರ ಅದು ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get editLeaveConfirm => 'ಸರಿ, ನಂತರ ಮಾಡುತ್ತೇನೆ';

  @override
  String get reviewLeaveCancel => 'ಮುಂದುವರಿಸಿ';

  @override
  String get statusSoldOut => 'ಎಲ್ಲಾ ಮಾರಾಟವಾಗಿದೆ';

  @override
  String get statusUnpublished => 'ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get listingsTitle => 'ನಿಮ್ಮ ವಸ್ತುಗಳು';

  @override
  String get listingsEmptyTitle => 'ನೀವು ಇನ್ನೂ ಏನೂ ಮಾಡಿಲ್ಲ';

  @override
  String get listingsEmptyBody =>
      'ಮುಖಪುಟದ ದೊಡ್ಡ ಬಟನ್ ಒತ್ತಿ ನಿಮ್ಮ ಮೊದಲ ವಸ್ತುವನ್ನು ಸೇರಿಸಿ.';

  @override
  String get listingsEmptyFilter => 'ಇಲ್ಲಿ ಏನೂ ಇಲ್ಲ.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಉಳಿದಿವೆ',
      one: '1 ಉಳಿದಿದೆ',
      zero: 'ಏನೂ ಉಳಿದಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಬಾರಿ ನೋಡಲಾಗಿದೆ',
      one: 'ಒಮ್ಮೆ ನೋಡಲಾಗಿದೆ',
      zero: 'ಇನ್ನೂ ಯಾರೂ ನೋಡಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'ಎಷ್ಟಿವೆ ಎಂದು ಬದಲಿಸಿ';

  @override
  String get listingTitle => 'ಈ ವಸ್ತು';

  @override
  String get listingOpenPreview => 'ಖರೀದಿದಾರರು ನೋಡುವುದನ್ನು ನೋಡಿ';

  @override
  String get listingEdit => 'ಏನಾದರೂ ಬದಲಿಸಿ';

  @override
  String get listingDuplicate => 'ಇದರಂತೆ ಇನ್ನೊಂದು ಮಾಡಿ';

  @override
  String get listingUnpublish => 'ಮಾರಾಟದಿಂದ ತೆಗೆಯಿರಿ';

  @override
  String get listingRelist => 'ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಇಡಿ';

  @override
  String get listingFinish => 'ಇದನ್ನು ಮುಗಿಸಿ';

  @override
  String get listingSoldOutTitle => 'ಇವೆಲ್ಲವೂ ಮಾರಾಟವಾಗಿವೆ';

  @override
  String get listingSoldOutBody =>
      'ನಾವು ನಿಮಗಾಗಿ ಇದನ್ನು ಮಾರಾಟದಿಂದ ತೆಗೆದಿದ್ದೇವೆ. ಇನ್ನಷ್ಟು ಮಾಡಿದಾಗ ಮತ್ತೆ ಇಡಿ.';

  @override
  String get editTitle => 'ಈ ವಸ್ತುವನ್ನು ಬದಲಿಸಿ';

  @override
  String get editBody =>
      'ನೀವು ಇದನ್ನು ಮತ್ತೆ ನೋಡುತ್ತೀರಿ, ನಂತರ ಇದು ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get editRepublishing => 'ಬದಲಾವಣೆಗಳನ್ನು ಮಾರಾಟಕ್ಕೆ ಇಡುತ್ತಿದ್ದೇವೆ…';

  @override
  String get editRepublished => 'ನಿಮ್ಮ ಬದಲಾವಣೆಗಳು ಈಗ ಮಾರಾಟದಲ್ಲಿವೆ';

  @override
  String get editRepublishConfirm => 'ಬದಲಾವಣೆಯನ್ನು ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಇಡಿ';

  @override
  String get quickStockTitle => 'ಎಷ್ಟು ಉಳಿದಿವೆ?';

  @override
  String get quickStockMarkSoldOut => 'ಎಲ್ಲವೂ ಮಾರಾಟವಾಗಿವೆ';

  @override
  String get quickStockSave => 'ಉಳಿಸಿ';

  @override
  String get quickStockSaved => 'ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get actionUndo => 'ಮೊದಲಿನಂತೆ ಮಾಡಿ';

  @override
  String get unpublishTitle => 'ಮಾರಾಟದಿಂದ ತೆಗೆಯುವುದೇ?';

  @override
  String get unpublishBody =>
      'ಖರೀದಿದಾರರು ಇನ್ನು ಇದನ್ನು ನೋಡುವುದಿಲ್ಲ. ಏನೂ ಅಳಿಸುವುದಿಲ್ಲ, ಮತ್ತು ನೀವು ಯಾವಾಗ ಬೇಕಾದರೂ ಮತ್ತೆ ಇಡಬಹುದು.';

  @override
  String get unpublishConfirm => 'ಹೌದು, ತೆಗೆಯಿರಿ';

  @override
  String get unpublishCancel => 'ಬೇಡ, ಮಾರಾಟದಲ್ಲಿರಲಿ';

  @override
  String get unpublishDone => 'ಇದನ್ನು ಮಾರಾಟದಿಂದ ತೆಗೆಯಲಾಗಿದೆ';

  @override
  String get relistDone => 'ಇದು ಮತ್ತೆ ಮಾರಾಟದಲ್ಲಿದೆ';

  @override
  String get duplicateTitle => 'ಇದರಂತೆ ಇನ್ನೊಂದು ಮಾಡುವುದೇ?';

  @override
  String get duplicateBody =>
      'ನೀವು ಇದರ ಬಗ್ಗೆ ಹೇಳಿದ್ದನ್ನು ನಾವು ಇಟ್ಟುಕೊಳ್ಳುತ್ತೇವೆ. ನೀವು ಹೊಸ ಫೋಟೋ ಮಾತ್ರ ತೆಗೆಯಬೇಕು.';

  @override
  String get duplicateConfirm => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get duplicateCancel => 'ಈಗ ಬೇಡ';

  @override
  String get duplicateBanner =>
      'ಹಿಂದಿನದರಂತೆ ಇನ್ನೊಂದು ಮಾಡುತ್ತಿದ್ದೇವೆ. ಫೋಟೋಗಳು ಮಾತ್ರ ಹೊಸವು.';

  @override
  String get listingActionFailed => 'ಅದು ಆಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get salesNew => 'ಹೊಸದು';

  @override
  String get salesEmptyTitle => 'ಇನ್ನೂ ಏನೂ ಮಾರಾಟವಾಗಿಲ್ಲ';

  @override
  String get salesEmptyBody =>
      'ಯಾರಾದರೂ ಏನಾದರೂ ಖರೀದಿಸಿದಾಗ ಅದು ಇಲ್ಲಿ ಕಾಣುತ್ತದೆ ಮತ್ತು ನಾವು ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get salesLoading => 'ಏನು ಮಾರಾಟವಾಗಿದೆ ನೋಡುತ್ತಿದ್ದೇವೆ…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ತುಂಡುಗಳು',
      one: '1 ತುಂಡು',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date ಒಳಗೆ ಪ್ಯಾಕ್ ಮಾಡಿ';
  }

  @override
  String get salesPackByToday => 'ಇಂದೇ ಪ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get salesPackByTomorrow => 'ನಾಳೆಯೊಳಗೆ ಪ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get salesPackedAlready => 'ಇದರ ದಿನಾಂಕ ಮುಗಿದಿದೆ';

  @override
  String get saleTitle => 'ಈ ಆರ್ಡರ್';

  @override
  String get saleReadOnly =>
      'ಇದು ನಿಮಗೆ ತಿಳಿಸಲು ಮಾತ್ರ. ಆರ್ಡರ್‌ನ ಎಲ್ಲಾ ಕೆಲಸ ಮಾರುಕಟ್ಟೆಯಲ್ಲಿ ನಡೆಯುತ್ತದೆ, ಈ ಆ್ಯಪ್‌ನಲ್ಲಿ ಅಲ್ಲ.';

  @override
  String salePaid(String amount) {
    return 'ನಿಮಗೆ $amount ಸಿಗುತ್ತದೆ';
  }

  @override
  String salePlaced(String date) {
    return '$date ರಂದು ಮಾರಾಟವಾಗಿದೆ';
  }

  @override
  String saleGoingTo(String area) {
    return '$area ಗೆ ಹೋಗುತ್ತಿದೆ';
  }

  @override
  String get saleWhatToPack => 'ಏನು ಪ್ಯಾಕ್ ಮಾಡಬೇಕು';

  @override
  String get salePackingHelp => 'ಹೇಗೆ ಪ್ಯಾಕ್ ಮಾಡಬೇಕು';

  @override
  String get saleSeeListing => 'ಈ ವಸ್ತುವನ್ನು ನೋಡಿ';

  @override
  String get packingTitle => 'ಹೇಗೆ ಪ್ಯಾಕ್ ಮಾಡಬೇಕು';

  @override
  String get packingBody => 'ಒಂದೊಂದಾಗಿ ಮಾಡಿ. ಆದದ್ದನ್ನು ಒತ್ತಿ.';

  @override
  String get packingStep1 => 'ಬಟ್ಟೆಯಲ್ಲಿ ಅಥವಾ ಕಾಗದದಲ್ಲಿ ಸುತ್ತಿ, ಏನೂ ಉಜ್ಜದಂತೆ';

  @override
  String get packingStep2 =>
      'ಸುತ್ತಲೂ ಕಾಗದ ಅಥವಾ ಹುಲ್ಲು ತುಂಬಿ, ಪೆಟ್ಟಿಗೆಯಲ್ಲಿ ಅಲುಗಾಡದಂತೆ';

  @override
  String get packingStep3 => 'ಒಳಗೆ ಸರಿಯಾದ ಸಂಖ್ಯೆಯ ತುಂಡುಗಳಿವೆಯೇ ನೋಡಿ';

  @override
  String get packingStep4 => 'ಪೆಟ್ಟಿಗೆ ಮುಚ್ಚಿ ಸುತ್ತಲೂ ಟೇಪ್ ಹಾಕಿ';

  @override
  String get packingStep5 => 'ತೆಗೆದುಕೊಳ್ಳಲು ಬರುವವರಿಗಾಗಿ ಸಿದ್ಧವಾಗಿಡಿ';

  @override
  String get packingDone => 'ಎಲ್ಲಾ ಆಯಿತು';

  @override
  String packingProgress(int done, int total) {
    return '$total ರಲ್ಲಿ $done ಆಯಿತು';
  }

  @override
  String get earningsTitle => 'ನೀವು ಎಷ್ಟು ಗಳಿಸಿದ್ದೀರಿ';

  @override
  String get earningsWeek => 'ಈ ವಾರ';

  @override
  String get earningsMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get earningsTotal => 'ಶುರುವಿನಿಂದ';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ತುಂಡುಗಳು ಮಾರಾಟವಾಗಿವೆ',
      one: '1 ತುಂಡು ಮಾರಾಟವಾಗಿದೆ',
      zero: 'ಇನ್ನೂ ಏನೂ ಮಾರಾಟವಾಗಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'ಮಾರುಕಟ್ಟೆ ತನ್ನ ಪಾಲು ತೆಗೆದುಕೊಂಡ ನಂತರ ನಿಮಗೆ ಬರುವುದು ಇದು.';

  @override
  String get profileVillageLabel => 'ಊರು ಅಥವಾ ಕ್ಲಸ್ಟರ್';

  @override
  String get profileNotSet => 'ಕೊಟ್ಟಿಲ್ಲ';

  @override
  String get profileEditEntry => 'ನಿಮ್ಮ ವಿವರ ಬದಲಿಸಿ';

  @override
  String get profileStoryEntry => 'ನಿಮ್ಮ ಕರಕುಶಲ ಕಥೆ';

  @override
  String get profileLanguageEntry => 'ಭಾಷೆ';

  @override
  String get profilePhoneEntry => 'ಫೋನ್ ನಂಬರ್';

  @override
  String get profileOndcEntry => 'ನಿಮ್ಮ ಮಾರಾಟ ಖಾತೆ';

  @override
  String get profileNotificationsEntry => 'ನಾವು ನಿಮಗೆ ಏನು ತಿಳಿಸಬೇಕು';

  @override
  String get profileVoiceEntry => 'ಧ್ವನಿ ಮತ್ತು ಕೇಳುವುದು';

  @override
  String get profilePrivacyEntry => 'ನಿಮ್ಮ ಬಗ್ಗೆ ಏನು ಕಾಣುತ್ತದೆ';

  @override
  String get profileStorageEntry => 'ಈ ಫೋನಿನಲ್ಲಿ ಜಾಗ';

  @override
  String get profileAccountEntry => 'ಸೈನ್ ಔಟ್';

  @override
  String get editProfileTitle => 'ನಿಮ್ಮ ವಿವರ';

  @override
  String get editProfileAddPhoto => 'ನಿಮ್ಮ ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get editProfileChangePhoto => 'ಫೋಟೋ ಬದಲಿಸಿ';

  @override
  String get editProfileRemovePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get editProfilePhotoWhy =>
      'ನೀವು ಅನುಮತಿಸಿದರೆ ಮಾತ್ರ ಖರೀದಿದಾರರು ಇದನ್ನು ಕಾರಿಗರ್ ಕಾರ್ಡ್ ಮೇಲೆ ನೋಡುತ್ತಾರೆ.';

  @override
  String get editProfileVillageHint => 'ಹೇಳಿ ಅಥವಾ ಬರೆಯಿರಿ';

  @override
  String get editProfileSave => 'ಉಳಿಸಿ';

  @override
  String get editProfileSaved => 'ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get storyTitle => 'ನಿಮ್ಮ ಕರಕುಶಲ ಕಥೆ';

  @override
  String get storyBody =>
      'ನೀವು ಯಾರು ಮತ್ತು ಹೇಗೆ ಮಾಡುತ್ತೀರಿ ಎಂದು ಖರೀದಿದಾರರಿಗೆ ಹೇಳಿ. ನೀವು ಮಾತನಾಡಿ, ನಾವು ಬರೆದುಕೊಳ್ಳುತ್ತೇವೆ.';

  @override
  String get storyHoldToSpeak => 'ಒತ್ತಿ ಹಿಡಿದು ನಿಮ್ಮ ಕಥೆ ಹೇಳಿ';

  @override
  String get storyEmpty => 'ನೀವು ಇನ್ನೂ ನಿಮ್ಮ ಕಥೆ ಹೇಳಿಲ್ಲ.';

  @override
  String get storyEditHint => 'ನೀವು ಇದರ ಯಾವುದೇ ಪದವನ್ನು ಬದಲಿಸಬಹುದು.';

  @override
  String get storyExample =>
      'ಉದಾಹರಣೆಗೆ: ನಮ್ಮ ಮನೆಯಲ್ಲಿ ಮೂರು ತಲೆಮಾರುಗಳಿಂದ ಇವುಗಳನ್ನು ಮಾಡುತ್ತಿದ್ದೇವೆ, ಮತ್ತು ನಾನು ಇಂದಿಗೂ ನನ್ನ ಅಜ್ಜನ ಮಗ್ಗದಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತೇನೆ.';

  @override
  String get changePhoneTitle => 'ನಿಮ್ಮ ನಂಬರ್ ಬದಲಿಸಿ';

  @override
  String get changePhoneBody =>
      'ನಂಬರ್ ನಿಮ್ಮದೇ ಎಂದು ಖಚಿತಪಡಿಸಲು ನಾವು ಹೊಸ ನಂಬರಿಗೆ ಒಂದು ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String changePhoneCurrent(String number) {
    return 'ಈಗ ನಿಮ್ಮ ನಂಬರ್ $number';
  }

  @override
  String get changePhoneDone => 'ನಿಮ್ಮ ನಂಬರ್ ಬದಲಾಗಿದೆ';

  @override
  String get ondcAccountTitle => 'ನಿಮ್ಮ ಮಾರಾಟ ಖಾತೆ';

  @override
  String get ondcAccountLinked => 'ನಿಮ್ಮ ಖಾತೆ ಜೋಡಿಸಲಾಗಿದೆ';

  @override
  String get ondcAccountNone => 'ಇನ್ನೂ ಯಾವ ಖಾತೆಯೂ ಜೋಡಿಸಿಲ್ಲ';

  @override
  String get ondcAccountNoneBody =>
      'ನೀವು ವಸ್ತುಗಳನ್ನು ಮಾಡುತ್ತಿರಿ. ಖಾತೆ ಜೋಡಿಸಿದ ತಕ್ಷಣ ಅವು ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತವೆ.';

  @override
  String get ondcAccountLink => 'ಖಾತೆ ಜೋಡಿಸಿ';

  @override
  String get ondcAccountUnlink => 'ಈ ಖಾತೆ ತೆಗೆಯಿರಿ';

  @override
  String get ondcUnlinkTitle => 'ಈ ಖಾತೆ ತೆಗೆಯುವುದೇ?';

  @override
  String get ondcUnlinkBody =>
      'ಮಾರಾಟದಲ್ಲಿರುವುದೆಲ್ಲಾ ಇಳಿಯುತ್ತದೆ. ನೀವು ಮಾಡಿದ್ದು ಏನೂ ಅಳಿಸುವುದಿಲ್ಲ, ಮತ್ತು ನೀವು ಮತ್ತೆ ಜೋಡಿಸಬಹುದು.';

  @override
  String get ondcUnlinkConfirm => 'ಹೌದು, ತೆಗೆಯಿರಿ';

  @override
  String get ondcUnlinkCancel => 'ಬೇಡ, ಇರಲಿ';

  @override
  String get ondcUnlinkDone => 'ಖಾತೆ ತೆಗೆಯಲಾಗಿದೆ';

  @override
  String get notificationsTitle => 'ನಾವು ನಿಮಗೆ ಏನು ತಿಳಿಸಬೇಕು';

  @override
  String get notifySold => 'ಏನಾದರೂ ಮಾರಾಟವಾದಾಗ';

  @override
  String get notifySoldWhy =>
      'ಖರೀದಿದಾರರು ಹಣ ಕೊಟ್ಟ ತಕ್ಷಣ ತಿಳಿಸುತ್ತೇವೆ, ನೀವು ಪ್ಯಾಕ್ ಮಾಡಲು ಶುರು ಮಾಡಬಹುದು.';

  @override
  String get notifyAttention => 'ನಾವು ನಿಮ್ಮನ್ನು ಏನಾದರೂ ಕೇಳಬೇಕಾದಾಗ';

  @override
  String get notifyAttentionWhy =>
      'ಕೆಲವೊಮ್ಮೆ ವಸ್ತು ಮಾರಾಟಕ್ಕೆ ಹೋಗುವ ಮೊದಲು ಒಂದು ವಿಷಯ ಬಾಕಿ ಇರುತ್ತದೆ.';

  @override
  String get notifyUpload => 'ವಸ್ತು ಕಳುಹಿಸಿದಾಗ';

  @override
  String get notifyUploadWhy =>
      'ನೀವು ಫೋನಿನಲ್ಲಿ ಮಾಡಿದ್ದು ನಮ್ಮನ್ನು ತಲುಪಿದಾಗ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get notifyPackBy => 'ಪ್ಯಾಕ್ ಮಾಡುವ ಸಮಯ ಬಂದಾಗ';

  @override
  String get notifyPackByWhy =>
      'ಮಾರಾಟವನ್ನು ಪ್ಯಾಕ್ ಮಾಡಬೇಕಾದ ದಿನಾಂಕದ ಒಂದು ದಿನ ಮೊದಲು ಮತ್ತು ಅದೇ ದಿನ ನಾವು ನಿಮಗೆ ನೆನಪಿಸುತ್ತೇವೆ.';

  @override
  String get notificationsBlocked =>
      'ಈ ಫೋನ್ ನಿಮಗೆ ಏನೂ ಕಳುಹಿಸಲು ನಮಗೆ ಬಿಡುತ್ತಿಲ್ಲ. ಫೋನಿನ ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಇದನ್ನು ಆನ್ ಮಾಡಬಹುದು.';

  @override
  String get voiceSettingsTitle => 'ಧ್ವನಿ ಮತ್ತು ಕೇಳುವುದು';

  @override
  String get voiceSpeed => 'ನಾವು ಎಷ್ಟು ವೇಗವಾಗಿ ಮಾತನಾಡಬೇಕು';

  @override
  String get voiceSpeedSlow => 'ನಿಧಾನ';

  @override
  String get voiceSpeedFast => 'ವೇಗ';

  @override
  String get voiceTry => 'ಈಗ ಮಾತನಾಡಿ ತೋರಿಸಿ';

  @override
  String get voiceSample => 'ನಾವು ನಿಮ್ಮೊಂದಿಗೆ ಈ ವೇಗದಲ್ಲಿ ಮಾತನಾಡುತ್ತೇವೆ.';

  @override
  String get voiceAutoRead => 'ಪ್ರತಿ ಪರದೆ ತೆರೆದಾಗ ಓದಿ ಹೇಳಿ';

  @override
  String get voiceAutoReadWhy =>
      'ಇದು ಆಫ್ ಇದ್ದರೆ, ನೀವು ಸ್ಪೀಕರ್ ಒತ್ತಿದಾಗ ಮಾತ್ರ ನಾವು ಮಾತನಾಡುತ್ತೇವೆ.';

  @override
  String get voiceUnavailable =>
      'ಈ ಫೋನ್ ಮಾತನಾಡಲು ಆಗುವುದಿಲ್ಲ. ಎಲ್ಲವೂ ಕೆಲಸ ಮಾಡುತ್ತದೆ, ಆದರೆ ಏನೂ ಓದಿ ಹೇಳುವುದಿಲ್ಲ.';

  @override
  String get privacyTitle => 'ನಿಮ್ಮ ಬಗ್ಗೆ ಏನು ಕಾಣುತ್ತದೆ';

  @override
  String get privacyBody =>
      'ಪ್ರತಿ ವಸ್ತುವನ್ನು ಮಾರಾಟಕ್ಕೆ ಇಟ್ಟಾಗ ನೀವು ಇವುಗಳಿಗೆ ಹೌದು ಎಂದಿದ್ದೀರಿ. ಇವುಗಳಲ್ಲಿ ಯಾವುದನ್ನಾದರೂ ಹಿಂಪಡೆಯಬಹುದು.';

  @override
  String get privacyPhoto => 'ಈ ವಸ್ತುವಿನ ಫೋಟೋಗಳು';

  @override
  String get privacyStory => 'ನಿಮ್ಮ ಹೆಸರು, ಊರು ಮತ್ತು ಕಥೆ';

  @override
  String get privacyNothing => 'ಈಗ ನಿಮ್ಮದು ಏನೂ ಮಾರಾಟದಲ್ಲಿಲ್ಲ.';

  @override
  String get privacyWithdrawTitle => 'ಇದನ್ನು ಹಿಂಪಡೆಯುವುದೇ?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ಫೋಟೋಗಳಿಲ್ಲದೆ ಈ ವಸ್ತು ಮಾರಾಟದಲ್ಲಿರಲು ಆಗದು, ಹಾಗಾಗಿ ಇದು ಇಳಿಯುತ್ತದೆ. ಏನೂ ಅಳಿಸುವುದಿಲ್ಲ.';

  @override
  String get privacyWithdrawStoryBody =>
      'ನಿಮ್ಮ ಹೆಸರು, ಊರು ಮತ್ತು ಕಥೆಯನ್ನು ಈ ವಸ್ತುವಿನಿಂದ ತೆಗೆಯಲಾಗುತ್ತದೆ. ಇದು ಮಾರಾಟದಲ್ಲೇ ಇರುತ್ತದೆ.';

  @override
  String get privacyWithdrawConfirm => 'ಹೌದು, ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get privacyWithdrawCancel => 'ಬೇಡ, ಇರಲಿ';

  @override
  String get privacyWithdrawn => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get storageTitle => 'ಈ ಫೋನಿನಲ್ಲಿ ಜಾಗ';

  @override
  String get storagePhotos => 'ಫೋಟೋಗಳು ಮತ್ತು ರೆಕಾರ್ಡಿಂಗ್‌ಗಳು';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ವಿಷಯಗಳು ಕಳುಹಿಸಲು ಬಾಕಿ ಇವೆ',
      one: '1 ವಿಷಯ ಕಳುಹಿಸಲು ಬಾಕಿ ಇದೆ',
      zero: 'ಕಳುಹಿಸಲು ಏನೂ ಬಾಕಿ ಇಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'ಈಗಾಗಲೇ ಕಳುಹಿಸಿದ್ದನ್ನು ತೆಗೆಯಿರಿ';

  @override
  String get storageClearWhy =>
      'ಇನ್ನೂ ಕಳುಹಿಸಲು ಬಾಕಿ ಇರುವುದನ್ನು ಎಂದಿಗೂ ಮುಟ್ಟುವುದಿಲ್ಲ.';

  @override
  String storageCleared(String size) {
    return '$size ಖಾಲಿಯಾಯಿತು';
  }

  @override
  String get storageNothingToClear => 'ತೆಗೆಯಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get accountTitle => 'ಸೈನ್ ಔಟ್';

  @override
  String get accountSignOut => 'ಈ ಫೋನಿನಿಂದ ಸೈನ್ ಔಟ್ ಮಾಡಿ';

  @override
  String get accountSignOutTitle => 'ಸೈನ್ ಔಟ್ ಮಾಡುವುದೇ?';

  @override
  String get accountSignOutBody =>
      'ಕಳುಹಿಸಲು ಬಾಕಿ ಇರುವುದು ಕಳೆದುಹೋಗುತ್ತದೆ. ಮಾರಾಟದಲ್ಲಿರುವುದು ಮಾರಾಟದಲ್ಲೇ ಇರುತ್ತದೆ.';

  @override
  String get accountSignOutConfirm => 'ಹೌದು, ಸೈನ್ ಔಟ್';

  @override
  String get accountSignOutCancel => 'ಬೇಡ, ಸೈನ್ ಇನ್ ಆಗಿರಲಿ';

  @override
  String get accountDelete => 'ನನ್ನ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get accountDeleteTitle => 'ನಿಮ್ಮ ಖಾತೆ ಅಳಿಸುವುದೇ?';

  @override
  String get accountDeleteBody =>
      'ಎಲ್ಲವೂ ಮಾರಾಟದಿಂದ ಇಳಿಯುತ್ತದೆ ಮತ್ತು ಈ ಫೋನಿನಲ್ಲಿರುವುದೆಲ್ಲಾ ಅಳಿಸುತ್ತದೆ. ಇದನ್ನು ಮರಳಿ ಪಡೆಯಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get accountDeleteConfirm => 'ಹೌದು, ಎಲ್ಲವನ್ನೂ ಅಳಿಸಿ';

  @override
  String get accountDeleteCancel => 'ಬೇಡ, ನನ್ನ ಖಾತೆ ಇರಲಿ';

  @override
  String get accountDeleteHold => 'ಅಳಿಸಲು ಬಟನ್ ಒತ್ತಿ ಹಿಡಿಯಿರಿ';

  @override
  String get profileHelpEntry => 'ಸಹಾಯ';

  @override
  String get helpTitle => 'ಸಹಾಯ';

  @override
  String get helpBody =>
      'ಚಿಕ್ಕ ಉತ್ತರಗಳು, ಓದಿ ಹೇಳಲಾಗುತ್ತದೆ. ಕೇಳಲು ಯಾವುದನ್ನಾದರೂ ಒತ್ತಿ.';

  @override
  String get helpSteps => 'ಹೀಗೆ ಮಾಡಿ';

  @override
  String get helpTopicPhotos => 'ಒಳ್ಳೆಯ ಫೋಟೋ ತೆಗೆಯುವುದು';

  @override
  String get helpTopicPhotosBody =>
      'ಒಳ್ಳೆಯ ಫೋಟೋಗಳಿಂದ ಮಾರಾಟವಾಗುತ್ತದೆ. ಖರೀದಿದಾರರು ವಸ್ತುವನ್ನು ಕೈಯಲ್ಲಿ ಹಿಡಿಯಲಾಗದು, ಅವರ ಬಳಿ ಫೋಟೋ ಮಾತ್ರ ಇರುತ್ತದೆ.';

  @override
  String get helpTopicPhotosStep1 =>
      'ಬಾಗಿಲು ಅಥವಾ ಕಿಟಕಿಯ ಹತ್ತಿರ ನಿಲ್ಲಿ, ಹಗಲಿನ ಬೆಳಕು ವಸ್ತುವಿನ ಮೇಲೆ ಬೀಳುವಂತೆ';

  @override
  String get helpTopicPhotosStep2 =>
      'ವಸ್ತುವನ್ನು ಸರಳ ಬಟ್ಟೆಯ ಮೇಲೆ ಇಡಿ, ಸುತ್ತಲೂ ಬೇರೇನೂ ಇಲ್ಲದಂತೆ';

  @override
  String get helpTopicPhotosStep3 =>
      'ಫೋಟೋ ತೆಗೆಯುವವರೆಗೆ ಎರಡೂ ಕೈಗಳಿಂದ ಫೋನ್ ಅಲುಗಾಡದಂತೆ ಹಿಡಿಯಿರಿ';

  @override
  String get helpTopicPhotosStep4 =>
      'ಕೆಲಸ ಕಾಣುವಂತೆ ಹತ್ತಿರದಿಂದ ಒಂದು ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get helpTopicPhotosStep5 =>
      'ಅಳತೆ ಗೊತ್ತಾಗಲು ಒಂದು ಫೋಟೋದಲ್ಲಿ ಪಕ್ಕದಲ್ಲಿ ಕೈ ಇಡಿ';

  @override
  String get helpTopicVoice => 'ನಿಮ್ಮ ವಸ್ತುವಿನ ಬಗ್ಗೆ ಏನು ಹೇಳಬೇಕು';

  @override
  String get helpTopicVoiceBody =>
      'ಎದುರು ನಿಂತ ಗ್ರಾಹಕರೊಂದಿಗೆ ಮಾತನಾಡುವಂತೆಯೇ ಮಾತನಾಡಿ. ಹೇಳುವುದಕ್ಕೆ ತಪ್ಪು ರೀತಿ ಇಲ್ಲ.';

  @override
  String get helpTopicVoiceStep1 => 'ಇದು ಏನು ಎಂದು ಹೇಳಿ';

  @override
  String get helpTopicVoiceStep2 => 'ಇದು ಯಾವುದರಿಂದ ಮಾಡಿದ್ದು ಎಂದು ಹೇಳಿ';

  @override
  String get helpTopicVoiceStep3 =>
      'ಇದು ಎಷ್ಟು ದೊಡ್ಡದು ಎಂದು ಇಂಚು ಅಥವಾ ಅಡಿಯಲ್ಲಿ ಹೇಳಿ';

  @override
  String get helpTopicVoiceStep4 => 'ಮಾಡಲು ಎಷ್ಟು ಸಮಯ ಹಿಡಿಯಿತು ಎಂದು ಹೇಳಿ';

  @override
  String get helpTopicVoiceStep5 => 'ಇದಕ್ಕೆ ನಿಮಗೆ ಎಷ್ಟು ಬೇಕು ಎಂದು ಹೇಳಿ';

  @override
  String get helpTopicPrice => 'ಬೆಲೆ ನಿಗದಿ ಮಾಡುವುದು';

  @override
  String get helpTopicPriceBody =>
      'ನಿಮ್ಮ ಬೆಲೆಯಲ್ಲಿ ಸಾಮಗ್ರಿಯ ಖರ್ಚು ಮತ್ತು ನಿಮ್ಮ ಸಮಯದ ಬೆಲೆ ಎರಡೂ ಬರಬೇಕು. ನಾವು ನಿಮ್ಮೊಂದಿಗೆ ಅದನ್ನು ಲೆಕ್ಕ ಹಾಕುತ್ತೇವೆ, ಹೇಳದೆ ಅದಕ್ಕಿಂತ ಕೆಳಗೆ ಹೋಗಲು ಎಂದಿಗೂ ಬಿಡುವುದಿಲ್ಲ.';

  @override
  String get helpTopicPriceStep1 => 'ಸಾಮಗ್ರಿಗೆ ಎಷ್ಟು ಖರ್ಚಾಯಿತು ಲೆಕ್ಕ ಹಾಕಿ';

  @override
  String get helpTopicPriceStep2 => 'ಕೆಲಸಕ್ಕೆ ಎಷ್ಟು ದಿನ ಹಿಡಿಯಿತು ಲೆಕ್ಕ ಹಾಕಿ';

  @override
  String get helpTopicPriceStep3 =>
      'ನಾವು ಸೂಚಿಸುವುದನ್ನು ನೋಡಿ, ನಿಮಗೆ ಹೆಚ್ಚು ಗೊತ್ತಿದ್ದರೆ ಬದಲಿಸಿ';

  @override
  String get helpTopicPriceStep4 =>
      'ನಿಮ್ಮ ಖರ್ಚಿಗಿಂತ ಕಡಿಮೆ ಇದ್ದರೆ ನಾವು ಹೇಳುತ್ತೇವೆ, ಆದರೆ ಆಯ್ಕೆ ನಿಮ್ಮದೇ';

  @override
  String get helpTopicSold => 'ಮಾರಾಟವಾದ ನಂತರ ಏನಾಗುತ್ತದೆ';

  @override
  String get helpTopicSoldBody =>
      'ಖರೀದಿದಾರರು ಮಾರುಕಟ್ಟೆಯಲ್ಲಿ ಹಣ ಕೊಡುತ್ತಾರೆ. ನೀವು ಪ್ಯಾಕ್ ಮಾಡಿ ಕೊಡುತ್ತೀರಿ, ಹಣ ನಿಮಗೆ ಬರುತ್ತದೆ.';

  @override
  String get helpTopicSoldStep1 => 'ಮಾರಾಟವಾದ ತಕ್ಷಣ ನಾವು ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ';

  @override
  String get helpTopicSoldStep2 =>
      'ಏನು ಮತ್ತು ಎಷ್ಟು ಪ್ಯಾಕ್ ಮಾಡಬೇಕು ಎಂದು ತೆರೆದು ನೋಡಿ';

  @override
  String get helpTopicSoldStep3 => 'ನಾವು ತೋರಿಸುವ ದಿನಾಂಕದ ಮೊದಲು ಪ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get helpTopicSoldStep4 => 'ತೆಗೆದುಕೊಳ್ಳಲು ಬರುವವರಿಗೆ ಕೊಡಿ';

  @override
  String get helpTopicSoldStep5 => 'ಅದರ ನಂತರ ಹಣ ನಿಮಗೆ ತಲುಪುತ್ತದೆ';

  @override
  String get helpVideoComing => 'ಇದಕ್ಕಾಗಿ ಒಂದು ಚಿಕ್ಕ ವೀಡಿಯೊ ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ.';

  @override
  String get helpPractice => 'ಒಳ್ಳೆಯ ಫೋಟೋ ತೆಗೆಯುವುದು ಹೇಗೆ';

  @override
  String get helpPracticeBody =>
      'ಒಂದೇ ಮಡಕೆಯ ಒಂದು ಒಳ್ಳೆಯ ಮತ್ತು ಒಂದು ಕೆಟ್ಟ ಫೋಟೋ.';

  @override
  String get helpFaqEntry => 'ಜನರು ಕೇಳುವ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get helpAboutEntry => 'ಕಾರಿಗರ್ ಬಗ್ಗೆ';

  @override
  String get helpSupportEntry => 'ಒಬ್ಬ ವ್ಯಕ್ತಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get helpTermsEntry => 'ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತೆ';

  @override
  String get faqTitle => 'ಜನರು ಕೇಳುವ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get faqQ1 => 'ಇದಕ್ಕೆ ನಾನು ಏನಾದರೂ ಕೊಡಬೇಕೇ?';

  @override
  String get faqA1 =>
      'ಇಲ್ಲ. ವಸ್ತುಗಳನ್ನು ಇಡುವುದು ಉಚಿತ. ಏನಾದರೂ ಮಾರಾಟವಾದಾಗ ಮಾತ್ರ ಮಾರುಕಟ್ಟೆ ಸಣ್ಣ ಪಾಲು ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ.';

  @override
  String get faqQ2 => 'ನೆಟ್‌ವರ್ಕ್ ಇಲ್ಲದಿದ್ದರೆ?';

  @override
  String get faqA2 =>
      'ಎಲ್ಲವೂ ಕೆಲಸ ಮಾಡುತ್ತಲೇ ಇರುತ್ತದೆ. ನೀವು ಮಾಡಿದ್ದು ನಿಮ್ಮ ಫೋನಿನಲ್ಲಿ ಇರುತ್ತದೆ ಮತ್ತು ನೆಟ್‌ವರ್ಕ್ ಬಂದಾಗ ತಾನಾಗಿಯೇ ಹೋಗುತ್ತದೆ.';

  @override
  String get faqQ3 => 'ನನ್ನ ಹಣ ಯಾರಿಗೆ ಹೋಗುತ್ತದೆ?';

  @override
  String get faqA3 =>
      'ನಿಮಗೆ. ಖರೀದಿದಾರರು ಮಾರುಕಟ್ಟೆಯಲ್ಲಿ ಹಣ ಕೊಡುತ್ತಾರೆ ಮತ್ತು ಅದು ನಿಮ್ಮ ಖಾತೆಗೆ ಬರುತ್ತದೆ. ಹಣ ಎಂದಿಗೂ ನಮ್ಮ ಮೂಲಕ ಹೋಗುವುದಿಲ್ಲ.';

  @override
  String get faqQ4 => 'ಮಾರಾಟಕ್ಕೆ ಇಟ್ಟ ನಂತರ ಏನಾದರೂ ಬದಲಿಸಬಹುದೇ?';

  @override
  String get faqA4 =>
      'ಹೌದು. ನಿಮ್ಮ ವಸ್ತುಗಳಿಂದ ತೆರೆಯಿರಿ, ಬೇಕಾದ್ದನ್ನು ಬದಲಿಸಿ, ಅದು ಮತ್ತೆ ಮಾರಾಟಕ್ಕೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get faqQ5 => 'ನಾನು ಏನಾದರೂ ತಪ್ಪು ಹೇಳಿದರೆ?';

  @override
  String get faqA5 =>
      'ನೀವು ಕೇಳಿ ಸರಿ ಎನ್ನುವವರೆಗೆ ಏನೂ ಮಾರಾಟಕ್ಕೆ ಹೋಗುವುದಿಲ್ಲ. ಮಾತನಾಡಿ ಯಾವುದೇ ಭಾಗವನ್ನು ಸರಿಪಡಿಸಬಹುದು.';

  @override
  String get faqQ6 => 'ನನಗೆ ಓದಲು-ಬರೆಯಲು ಬರಬೇಕೇ?';

  @override
  String get faqA6 =>
      'ಇಲ್ಲ. ನೀವು ಎಲ್ಲವನ್ನೂ ಮಾತನಾಡಿ ಮತ್ತು ಒತ್ತಿ ಮಾಡಬಹುದು. ಪ್ರತಿ ಪರದೆಯನ್ನೂ ನಿಮಗೆ ಓದಿ ಹೇಳಬಹುದು.';

  @override
  String get faqQ7 => 'ನನ್ನ ಹೆಸರು ಮತ್ತು ಊರು ಯಾರು ನೋಡುತ್ತಾರೆ?';

  @override
  String get faqA7 =>
      'ನೀವು ಅನುಮತಿಸಿದರೆ ಮಾತ್ರ, ಪ್ರತಿ ವಸ್ತುವಿಗೂ ಬೇರೆಯಾಗಿ. ನೀವು ಯಾವಾಗ ಬೇಕಾದರೂ ಹಿಂಪಡೆಯಬಹುದು.';

  @override
  String get aboutTitle => 'ಕಾರಿಗರ್ ಬಗ್ಗೆ';

  @override
  String get aboutWhatTitle => 'ಇದು ಏನು';

  @override
  String get aboutWhat =>
      'ಕಾರಿಗರ್ ಕೈಯಿಂದ ಮಾಡಿದ ವಸ್ತುಗಳನ್ನು ONDC ಗೆ — ಭಾರತದ ಮುಕ್ತ ಖರೀದಿ-ಮಾರಾಟ ಜಾಲಕ್ಕೆ — ತಲುಪಿಸುತ್ತದೆ, ಮತ್ತು ಅದಕ್ಕಾಗಿ ಮಾಡುವವರು ಬರೆಯಬೇಕಿಲ್ಲ, ಮಾತನಾಡಿದರೆ ಸಾಕು. ನಿಮ್ಮದೇ ಭಾಷೆಯಲ್ಲಿ ಕೆಲವು ಫೋಟೋಗಳು ಮತ್ತು ಒಂದು ಧ್ವನಿ ಸಂದೇಶದಿಂದ ದೇಶದಾದ್ಯಂತ ಖರೀದಿದಾರರು ಹುಡುಕಬಹುದಾದ ಪಟ್ಟಿ ತಯಾರಾಗುತ್ತದೆ.';

  @override
  String get aboutWhyTitle => 'ನಾವು ಇದನ್ನು ಏಕೆ ಮಾಡಿದೆವು';

  @override
  String get aboutWhy =>
      'ಭಾರತದಲ್ಲಿ ಸುಮಾರು ಎಪ್ಪತ್ತು ಲಕ್ಷ ಕುಶಲಕರ್ಮಿಗಳು ಜನರು ಖರೀದಿಸಲು ಬಯಸುವ ವಸ್ತುಗಳನ್ನು ಮಾಡುತ್ತಾರೆ, ಮತ್ತು ಅವರಲ್ಲಿ ಹೆಚ್ಚಿನವರು ಲಾಭದ ವ್ಯತ್ಯಾಸವನ್ನು ಇಟ್ಟುಕೊಳ್ಳುವ ಮಧ್ಯವರ್ತಿಯ ಮೂಲಕ ಮಾರುತ್ತಾರೆ. ಅಡ್ಡಿ ಕೆಲಸದಲ್ಲಿಲ್ಲ. ಅಡ್ಡಿ ಫಾರ್ಮ್‌ನಲ್ಲಿದೆ: ಆನ್‌ಲೈನ್ ಪಟ್ಟಿಗೆ ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿ ಟೈಪ್ ಮಾಡುವುದು, ಹಲವು ಕಾಲಂಗಳು ಮತ್ತು ಕ್ಯಾಟಲಾಗ್‌ನಂತೆ ತೆಗೆದ ಫೋಟೋ ಬೇಕು. ಈ ಆ್ಯಪ್ ಆ ಫಾರ್ಮ್ ಅನ್ನೇ ತೆಗೆದುಹಾಕುತ್ತದೆ.';

  @override
  String get aboutHowTitle => 'ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get aboutHow =>
      'ಮೂರು ಫೋಟೋ ತೆಗೆಯಿರಿ ಮತ್ತು ಇದು ಏನು ಎಂದು ಹೇಳಿ. ನಮ್ಮ ವ್ಯವಸ್ಥೆ ಕೇಳುತ್ತದೆ, ಪಟ್ಟಿ ಬರೆಯುತ್ತದೆ, ಮತ್ತು ನಿಮಗೆ ಓದಿ ಹೇಳುತ್ತದೆ. ನೀವು ಕೇಳಿ ಸರಿ ಎನ್ನುವವರೆಗೆ ಏನೂ ಹೊರಗೆ ಹೋಗುವುದಿಲ್ಲ.';

  @override
  String get aboutSihTitle => 'ಸ್ಮಾರ್ಟ್ ಇಂಡಿಯಾ ಹ್ಯಾಕಥಾನ್ 2025';

  @override
  String get aboutSih =>
      'ಸಮಸ್ಯೆ 090 ಗಾಗಿ ಮಾಡಲಾಗಿದೆ: ಕುಶಲಕರ್ಮಿಗಳು ಮತ್ತು ನೇಕಾರರು ONDC ಯಲ್ಲಿ ಖರೀದಿದಾರರನ್ನು ತಲುಪಲು ಸಹಾಯ.';

  @override
  String get aboutMissionTitle => 'ನಾವು ಏನು ಮಾಡಲು ಬಯಸುತ್ತೇವೆ';

  @override
  String get aboutMission => 'ಒಂದು ಕೆಲಸದ ಬೆಲೆ ಅದನ್ನು ಮಾಡಿದವರ ಕೈಯಲ್ಲೇ ಇರಬೇಕು.';

  @override
  String get supportTitle => 'ಒಬ್ಬ ವ್ಯಕ್ತಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get supportBody =>
      'ಏನಾದರೂ ಕೆಲಸ ಮಾಡದಿದ್ದರೆ, ಅಥವಾ ಏನು ಮಾಡಬೇಕು ಎಂದು ಗೊತ್ತಾಗದಿದ್ದರೆ, ನಮಗೆ ಕರೆ ಮಾಡಿ. ಒಬ್ಬ ವ್ಯಕ್ತಿ ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ ಉತ್ತರಿಸುತ್ತಾರೆ.';

  @override
  String get supportCall => 'ನಮಗೆ ಕರೆ ಮಾಡಿ';

  @override
  String get supportWhatsApp => 'ವಾಟ್ಸ್‌ಆ್ಯಪ್‌ನಲ್ಲಿ ಸಂದೇಶ ಕಳುಹಿಸಿ';

  @override
  String get supportHours => 'ಪ್ರತಿದಿನ, ಬೆಳಿಗ್ಗೆ ಒಂಬತ್ತರಿಂದ ಸಂಜೆ ಏಳರವರೆಗೆ.';

  @override
  String supportNumber(String number) {
    return 'ನಮ್ಮ ನಂಬರ್ $number';
  }

  @override
  String supportFailed(String number) {
    return 'ನಿಮ್ಮ ಫೋನ್ ಅದನ್ನು ತೆರೆಯಲಾಗಲಿಲ್ಲ. ನಮ್ಮ ನಂಬರ್ $number.';
  }

  @override
  String get termsTitle => 'ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತೆ';

  @override
  String get termsSummaryTitle => 'ಚಿಕ್ಕದಾಗಿ';

  @override
  String get termsSummary1 =>
      'ನೀವು ಮಾಡಿದ್ದು ನಿಮ್ಮದೇ. ನಾವು ನಿಮಗಾಗಿ ಅದನ್ನು ಮಾರಾಟಕ್ಕೆ ಇಡುತ್ತೇವೆ ಮತ್ತು ಮಾರಾಟದಿಂದ ಏನೂ ತೆಗೆದುಕೊಳ್ಳುವುದಿಲ್ಲ.';

  @override
  String get termsSummary2 =>
      'ನಿಮ್ಮ ಫೋಟೋಗಳು ಮತ್ತು ಧ್ವನಿಯನ್ನು ನಿಮ್ಮ ಪಟ್ಟಿ ಬರೆಯಲು ಮಾತ್ರ ಬಳಸಲಾಗುತ್ತದೆ, ಬೇರೇನಕ್ಕೂ ಅಲ್ಲ.';

  @override
  String get termsSummary3 =>
      'ನಿಮ್ಮ ಹೆಸರು, ಊರು ಮತ್ತು ಕಥೆ ನೀವು ಅನುಮತಿಸಿದ ವಸ್ತುಗಳ ಮೇಲೆ ಮಾತ್ರ ಹೋಗುತ್ತದೆ, ಮತ್ತು ನೀವು ಹಿಂಪಡೆಯಬಹುದು.';

  @override
  String get termsSummary4 =>
      'ಹಣ ಖರೀದಿದಾರರಿಂದ ನೇರವಾಗಿ ನಿಮಗೆ ಹೋಗುತ್ತದೆ. ಎಂದಿಗೂ ನಮ್ಮ ಮೂಲಕ ಹೋಗುವುದಿಲ್ಲ.';

  @override
  String get termsSummary5 =>
      'ನೀವು ಯಾವಾಗ ಬೇಕಾದರೂ ಈ ಫೋನಿನಿಂದ ಎಲ್ಲವನ್ನೂ ಅಳಿಸಬಹುದು.';

  @override
  String get termsFullTitle => 'ಪೂರ್ತಿ ಪಠ್ಯ';

  @override
  String get termsFullBody =>
      'ಬಳಕೆಯ ಪೂರ್ತಿ ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿ ನಮ್ಮ ವೆಬ್‌ಸೈಟ್‌ನಲ್ಲಿದೆ. ಇಲ್ಲಿ ಏನಾದರೂ ಅರ್ಥವಾಗದಿದ್ದರೆ ನಮಗೆ ಕರೆ ಮಾಡಿ, ಒಬ್ಬ ವ್ಯಕ್ತಿ ವಿವರಿಸುತ್ತಾರೆ.';

  @override
  String get termsOpenFull => 'ಪೂರ್ತಿ ಪಠ್ಯ ಓದಿ';

  @override
  String get termsAgreeTitle => 'ಶುರು ಮಾಡುವ ಮೊದಲು';

  @override
  String get termsAgreeBody =>
      'ನೀವು ಈ ವಿಷಯಗಳಿಗೆ ಒಪ್ಪುತ್ತಿದ್ದೀರಿ. ಕೇಳಲು ಸ್ಪೀಕರ್ ಒತ್ತಿ.';

  @override
  String get termsAgreeCheck => 'ನಾನು ನಿಯಮಗಳಿಗೆ ಒಪ್ಪುತ್ತೇನೆ';

  @override
  String get termsAgreeContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get termsAgreeNeeded =>
      'ಮೊದಲು “ನಾನು ನಿಯಮಗಳಿಗೆ ಒಪ್ಪುತ್ತೇನೆ” ಗುರುತು ಮಾಡಿ.';

  @override
  String versionNumber(String version) {
    return 'ಆವೃತ್ತಿ $version';
  }

  @override
  String get versionCheck => 'ಹೊಸ ಆವೃತ್ತಿ ನೋಡಿ';

  @override
  String get versionLicences => 'ಪರವಾನಗಿಗಳು';

  @override
  String get versionLicencesWhy => 'ಈ ಆ್ಯಪ್ ಆಧರಿಸಿರುವ ಉಚಿತ ಸಾಫ್ಟ್‌ವೇರ್.';

  @override
  String get noNetworkTitle => 'ನೆಟ್‌ವರ್ಕ್ ಇಲ್ಲ';

  @override
  String get noNetworkBody =>
      'ನೀವು ಕೆಲಸ ಮುಂದುವರಿಸಿ. ಎಲ್ಲವೂ ನಿಮ್ಮ ಫೋನಿನಲ್ಲಿ ಇರುತ್ತದೆ ಮತ್ತು ನೆಟ್‌ವರ್ಕ್ ಬಂದಾಗ ತಾನಾಗಿಯೇ ಹೋಗುತ್ತದೆ.';

  @override
  String get noNetworkNeeded =>
      'ಈ ಒಂದು ಕೆಲಸಕ್ಕೆ ನೆಟ್‌ವರ್ಕ್ ಬೇಕು. ಸಿಗ್ನಲ್ ಬಂದಾಗ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get serverErrorTitle => 'ನಮ್ಮ ಕಡೆಗೆ ತಲುಪಲು ಆಗಲಿಲ್ಲ';

  @override
  String get serverErrorBody =>
      'ನೀವು ಮಾಡಿದ್ದು ಏನೂ ಕಳೆದುಹೋಗಿಲ್ಲ. ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಹೊತ್ತಿನ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get actionTryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get permissionRecoveryTitle => 'ಆ್ಯಪ್‌ಗೆ ನಿಮ್ಮ ಅನುಮತಿ ಬೇಕು';

  @override
  String get permissionRecoveryBody =>
      'ಫೋನ್ ಆ್ಯಪ್‌ಗೆ ಇವುಗಳನ್ನು ಬಳಸಲು ಬಿಡುತ್ತಿಲ್ಲ. ಫೋನಿನ ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಆನ್ ಮಾಡಿ ಇಲ್ಲಿಗೆ ಹಿಂತಿರುಗಬಹುದು.';

  @override
  String get permissionCameraWhy =>
      'ನೀವು ಮಾಡಿದ್ದರ ಫೋಟೋ ತೆಗೆಯಲು. ಇದಿಲ್ಲದೆ ಏನನ್ನೂ ಮಾರಾಟಕ್ಕೆ ಇಡಲಾಗದು.';

  @override
  String get permissionMicWhy =>
      'ಬರೆಯುವ ಬದಲು ಮಾತನಾಡಲು. ಇದಿಲ್ಲದೆ ಎಲ್ಲವನ್ನೂ ಬರೆಯಬೇಕಾಗುತ್ತದೆ.';

  @override
  String get permissionNotifyTitle => 'ಸೂಚನೆಗಳು';

  @override
  String get permissionNotifyWhy =>
      'ಏನಾದರೂ ಮಾರಾಟವಾದಾಗ ನಾವು ತಿಳಿಸಲು. ಇದಿಲ್ಲದೆ ನೀವು ಆ್ಯಪ್ ತೆರೆದು ನೋಡಬೇಕಾಗುತ್ತದೆ.';

  @override
  String get permissionBlocked => 'ಅನುಮತಿ ಇಲ್ಲ';

  @override
  String get permissionAsk => 'ಮತ್ತೆ ಕೇಳಿ';

  @override
  String get permissionRecheck => 'ನಾನು ಆನ್ ಮಾಡಿದ್ದೇನೆ';

  @override
  String get permissionAllGood => 'ಆ್ಯಪ್‌ಗೆ ಬೇಕಾದ ಎಲ್ಲಾ ಅನುಮತಿಗಳಿವೆ.';

  @override
  String get updateTitle => 'ದಯವಿಟ್ಟು ಆ್ಯಪ್ ಅಪ್‌ಡೇಟ್ ಮಾಡಿ';

  @override
  String get updateBody =>
      'ಈ ಆವೃತ್ತಿ ಇನ್ನು ನಮ್ಮೊಂದಿಗೆ ಮಾತನಾಡಲು ಆಗದು. ಸ್ಟೋರ್‌ನಲ್ಲಿ ಹೊಸ ಆವೃತ್ತಿ ಇದೆ, ಮತ್ತು ಅಪ್‌ಡೇಟ್ ನಂತರವೂ ನಿಮ್ಮ ಫೋನಿನಲ್ಲಿರುವುದೆಲ್ಲಾ ಹಾಗೆಯೇ ಇರುತ್ತದೆ.';

  @override
  String get updateAction => 'ಹೊಸ ಆವೃತ್ತಿ ಪಡೆಯಿರಿ';

  @override
  String get updateFailed => 'ಸ್ಟೋರ್ ತೆರೆಯಲಿಲ್ಲ. ಅಲ್ಲಿ ಕಾರಿಗರ್ ಹುಡುಕಿ.';

  @override
  String get emptyNudge =>
      'ಮುಖಪುಟದ ದೊಡ್ಡ ಬಟನ್ ಒತ್ತಿ ನಿಮ್ಮ ಮೊದಲ ವಸ್ತುವನ್ನು ಸೇರಿಸಿ.';

  @override
  String get productsInProgress => 'ಸಿದ್ಧವಾಗುತ್ತಿದೆ';

  @override
  String get productsListed => 'ಮಾರಾಟದಲ್ಲಿ';

  @override
  String get productsSold => 'ಮಾರಾಟವಾಗಿದೆ';

  @override
  String get voiceTypeInstead => 'ಬರೆದು ಹೇಳಿ';

  @override
  String get voiceSpeakInstead => 'ಮಾತನಾಡಿ ಹೇಳಿ';

  @override
  String get voiceTypeTitle => 'ಈಗ ಇದು ಏನು ಎಂದು ಬರೆಯಿರಿ';

  @override
  String get voiceTypeHint => 'ಇಲ್ಲಿ ಬರೆಯಿರಿ…';

  @override
  String get voiceTypeSave => 'ಈ ವಿವರಣೆಯನ್ನೇ ಇಡಿ';

  @override
  String get devSimulateResult => 'Dev: show a finished product';

  @override
  String get errorNotAllowed =>
      'ಈ ಖಾತೆಯಿಂದ ಇದನ್ನು ಮಾಡಲು ಆಗುವುದಿಲ್ಲ. ಸಹಾಯಕ್ಕಾಗಿ ನಮಗೆ ಕರೆ ಮಾಡಿ.';

  @override
  String get errorNotFound => 'ಇದು ಈಗ ಇಲ್ಲ.';

  @override
  String get errorConflict =>
      'ಇದನ್ನು ಬೇರೆಡೆ ಬದಲಾಯಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ತೆರೆದು ಇನ್ನೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorInvalid =>
      'ಕೆಲವು ವಿವರಗಳನ್ನು ಸ್ವೀಕರಿಸಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
}
