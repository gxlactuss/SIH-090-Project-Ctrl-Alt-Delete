import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਕੀਰਤੀਕਰ';

  @override
  String get actionNext => 'ਅੱਗੇ';

  @override
  String get actionBack => 'ਪਿੱਛੇ';

  @override
  String get actionSkip => 'ਛੱਡੋ';

  @override
  String get actionDone => 'ਹੋ ਗਿਆ';

  @override
  String get actionListen => 'ਸੁਣੋ';

  @override
  String get actionStopListening => 'ਰੋਕੋ';

  @override
  String stepOfSteps(int current, int total) {
    return 'ਕਦਮ $current, ਕੁੱਲ $total';
  }

  @override
  String get splashTagline => 'ਬੋਲੋ, ਤੇ ਤੁਹਾਡੀ ਚੀਜ਼ ਵਿਕ ਜਾਵੇਗੀ';

  @override
  String get languageTitle => 'ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get languageHint => 'ਜਿਹੜੀ ਭਾਸ਼ਾ ਤੁਸੀਂ ਬੋਲਦੇ ਹੋ, ਉਸ ਨੂੰ ਦਬਾਓ';

  @override
  String get welcomeCard1Title => 'ਤਿੰਨ ਫੋਟੋਆਂ ਖਿੱਚੋ';

  @override
  String get welcomeCard1Body =>
      'ਆਪਣੀ ਬਣਾਈ ਚੀਜ਼ ਦੀਆਂ ਤਿੰਨ ਫੋਟੋਆਂ ਖਿੱਚੋ। ਕਿਵੇਂ ਖਿੱਚਣੀਆਂ ਹਨ, ਐਪ ਦੱਸੇਗੀ।';

  @override
  String get welcomeCard2Title => 'ਬੋਲ ਕੇ ਦੱਸੋ';

  @override
  String get welcomeCard2Body =>
      'ਇਹ ਕੀ ਹੈ, ਕਿਸ ਚੀਜ਼ ਦੀ ਬਣੀ ਹੈ, ਕੀਮਤ ਕਿੰਨੀ ਹੈ, ਬੱਸ ਬੋਲ ਦਿਓ। ਲਿਖਣ ਦੀ ਲੋੜ ਨਹੀਂ।';

  @override
  String get welcomeCard3Title => 'ਇਹ ਵਿਕਰੀ \'ਤੇ ਜਾਂਦੀ ਹੈ';

  @override
  String get welcomeCard3Body =>
      'ਪਹਿਲਾਂ ਤੁਹਾਨੂੰ ਪੜ੍ਹ ਕੇ ਸੁਣਾਇਆ ਜਾਵੇਗਾ। ਤੁਹਾਡੀ ਹਾਂ ਤੋਂ ਬਾਅਦ ਹੀ ਇਹ ਔਨਲਾਈਨ ਜਾਵੇਗੀ।';

  @override
  String get welcomeStart => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get permissionsTitle => 'ਐਪ ਨੂੰ ਤਿੰਨ ਚੀਜ਼ਾਂ ਦੀ ਇਜਾਜ਼ਤ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get permissionCameraTitle => 'ਕੈਮਰਾ';

  @override
  String get permissionCameraBody =>
      'ਤੁਹਾਡੀ ਚੀਜ਼ ਦੀਆਂ ਫੋਟੋਆਂ ਖਿੱਚਣ ਲਈ। ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਹਾਂ ਨਹੀਂ ਕਹਿੰਦੇ, ਫੋਟੋਆਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਰਹਿੰਦੀਆਂ ਹਨ।';

  @override
  String get permissionMicTitle => 'ਮਾਈਕ';

  @override
  String get permissionMicBody => 'ਤਾਂ ਜੋ ਤੁਸੀਂ ਲਿਖਣ ਦੀ ਥਾਂ ਬੋਲ ਸਕੋ।';

  @override
  String get permissionNotificationTitle => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get permissionNotificationBody =>
      'ਤਾਂ ਜੋ ਕੁਝ ਵਿਕਦੇ ਹੀ ਅਸੀਂ ਤੁਹਾਨੂੰ ਦੱਸ ਸਕੀਏ।';

  @override
  String get permissionAllow => 'ਇਜਾਜ਼ਤ ਦਿਓ';

  @override
  String get permissionNotNow => 'ਹੁਣ ਨਹੀਂ';

  @override
  String get permissionGranted => 'ਇਜਾਜ਼ਤ ਹੈ';

  @override
  String get permissionDeniedTitle => 'ਇਜਾਜ਼ਤ ਨਹੀਂ ਮਿਲੀ';

  @override
  String get permissionDeniedBody =>
      'ਇਸ ਤੋਂ ਬਿਨਾਂ ਇਹ ਕੰਮ ਨਹੀਂ ਕਰੇਗਾ। ਫ਼ੋਨ ਦੀਆਂ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਜਾ ਕੇ ਇਜਾਜ਼ਤ ਦਿਓ।';

  @override
  String get permissionOpenSettings => 'ਸੈਟਿੰਗਾਂ ਖੋਲ੍ਹੋ';

  @override
  String get phoneTitle => 'ਤੁਹਾਡਾ ਫ਼ੋਨ ਨੰਬਰ';

  @override
  String get phoneWhy =>
      'ਅਸੀਂ ਇਸ ਨੰਬਰ \'ਤੇ ਇੱਕ ਕੋਡ ਭੇਜਾਂਗੇ। ਇਹ ਨੰਬਰ ਕਿਸੇ ਹੋਰ ਨੂੰ ਨਹੀਂ ਦਿੱਤਾ ਜਾਂਦਾ।';

  @override
  String get phoneInvalid => 'ਦਸ ਅੰਕਾਂ ਦਾ ਨੰਬਰ ਪਾਓ';

  @override
  String phoneUnknown(String number) {
    return 'ਇਸ ਡੈਮੋ ਵਿੱਚ ਇਹ ਨੰਬਰ ਨਹੀਂ ਚੱਲੇਗਾ। $number ਵਰਤੋ।';
  }

  @override
  String get phoneSendCode => 'ਕੋਡ ਭੇਜੋ';

  @override
  String get otpTitle => 'ਆਇਆ ਕੋਡ ਪਾਓ';

  @override
  String otpSentTo(String number) {
    return '$number \'ਤੇ ਭੇਜਿਆ';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds ਸਕਿੰਟਾਂ ਬਾਅਦ ਦੁਬਾਰਾ ਭੇਜੋ';
  }

  @override
  String get otpResend => 'ਕੋਡ ਦੁਬਾਰਾ ਭੇਜੋ';

  @override
  String get otpCallMe => 'ਮੈਨੂੰ ਫ਼ੋਨ ਕਰਕੇ ਦੱਸੋ';

  @override
  String get otpCalling =>
      'ਥੋੜ੍ਹੀ ਦੇਰ ਵਿੱਚ ਫ਼ੋਨ ਆਵੇਗਾ ਅਤੇ ਕੋਡ ਪੜ੍ਹ ਕੇ ਸੁਣਾਇਆ ਜਾਵੇਗਾ।';

  @override
  String get otpWrong => 'ਕੋਡ ਸਹੀ ਨਹੀਂ ਹੈ। ਦੁਬਾਰਾ ਪਾਓ।';

  @override
  String get phoneSendFailed =>
      'ਕੋਡ ਭੇਜਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ। ਨੈੱਟਵਰਕ ਦੇਖੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get otpExpired => 'ਕੋਡ ਦਾ ਸਮਾਂ ਖਤਮ ਹੋ ਗਿਆ। ਦੁਬਾਰਾ ਭੇਜੋ।';

  @override
  String get authTooManyTries =>
      'ਬਹੁਤ ਵਾਰ ਕੋਸ਼ਿਸ਼ ਹੋ ਗਈ। ਥੋੜ੍ਹੀ ਦੇਰ ਬਾਅਦ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get otpChangeNumber => 'ਨੰਬਰ ਬਦਲੋ';

  @override
  String get otpAutoRead => 'ਸੁਨੇਹਾ ਆਪਣੇ ਆਪ ਪੜ੍ਹ ਲਿਆ ਗਿਆ';

  @override
  String get profileTitle => 'ਆਪਣੇ ਬਾਰੇ ਦੱਸੋ';

  @override
  String get profileNameLabel => 'ਤੁਹਾਡਾ ਨਾਮ';

  @override
  String get profileNameHint => 'ਬੋਲ ਕੇ ਦੱਸੋ ਜਾਂ ਲਿਖੋ';

  @override
  String get profileNameMissing => 'ਆਪਣਾ ਨਾਮ ਦੱਸੋ';

  @override
  String get profileCraftLabel => 'ਤੁਸੀਂ ਕੀ ਬਣਾਉਂਦੇ ਹੋ';

  @override
  String get profileCraftMissing => 'ਇੱਕ ਚੁਣੋ';

  @override
  String get profileSpeakToFill => 'ਬੋਲ ਕੇ ਦੱਸੋ';

  @override
  String get profileListening => 'ਸੁਣ ਰਹੇ ਹਾਂ…';

  @override
  String get dictationUnavailable =>
      'ਇਸ ਫ਼ੋਨ \'ਤੇ ਬੋਲ ਕੇ ਲਿਖਣਾ ਨਹੀਂ ਚੱਲ ਰਿਹਾ। ਕਿਰਪਾ ਕਰਕੇ ਲਿਖੋ।';

  @override
  String get dictationNothingHeard =>
      'ਕੁਝ ਸੁਣਾਈ ਨਹੀਂ ਦਿੱਤਾ। ਮਾਈਕ ਦਬਾ ਕੇ ਦੁਬਾਰਾ ਬੋਲੋ।';

  @override
  String get craftWeaving => 'ਬੁਣਾਈ';

  @override
  String get craftPottery => 'ਮਿੱਟੀ ਦਾ ਕੰਮ';

  @override
  String get craftWoodwork => 'ਲੱਕੜ ਦਾ ਕੰਮ';

  @override
  String get craftMetalwork => 'ਧਾਤ ਦਾ ਕੰਮ';

  @override
  String get craftJewellery => 'ਗਹਿਣੇ';

  @override
  String get craftEmbroidery => 'ਕਢਾਈ';

  @override
  String get craftPainting => 'ਚਿੱਤਰਕਾਰੀ';

  @override
  String get craftLeather => 'ਚਮੜੇ ਦਾ ਕੰਮ';

  @override
  String get craftBamboo => 'ਬਾਂਸ ਅਤੇ ਬੈਂਤ';

  @override
  String get craftOther => 'ਕੁਝ ਹੋਰ';

  @override
  String get ondcTitle => 'ਆਪਣਾ ONDC ਖਾਤਾ ਜੋੜੋ';

  @override
  String get ondcExplain =>
      'ONDC ਉਹ ਥਾਂ ਹੈ ਜਿੱਥੇ ਖਰੀਦਦਾਰ ਤੁਹਾਡੀ ਚੀਜ਼ ਦੇਖਦੇ ਅਤੇ ਖਰੀਦਦੇ ਹਨ। ਪੈਸੇ ਸਿੱਧੇ ਤੁਹਾਨੂੰ ਮਿਲਦੇ ਹਨ, ਸਾਡੇ ਰਾਹੀਂ ਨਹੀਂ।';

  @override
  String get ondcMalformed =>
      'ਇਹ ਸੇਲਰ ਆਈਡੀ ਵਰਗਾ ਨਹੀਂ ਲੱਗਦਾ। ਕਿਰਪਾ ਕਰਕੇ ਜਾਂਚੋ, ਜਾਂ ਕੋਡ ਦੁਬਾਰਾ ਸਕੈਨ ਕਰੋ।';

  @override
  String get ondcEmailLabel => 'ONDC ਈਮੇਲ';

  @override
  String get ondcEmailMalformed =>
      'ਇਹ ਈਮੇਲ ਪਤੇ ਵਰਗਾ ਨਹੀਂ ਲੱਗਦਾ। ਕਿਰਪਾ ਕਰਕੇ ਇਸਨੂੰ ਜਾਂਚੋ।';

  @override
  String get ondcSellerIdLabel => 'ਵਿਕਰੇਤਾ ਆਈਡੀ';

  @override
  String get ondcScan => 'QR ਕੋਡ ਸਕੈਨ ਕਰੋ';

  @override
  String get ondcLink => 'ਖਾਤਾ ਜੋੜੋ';

  @override
  String get ondcLinking => 'ਜੋੜ ਰਹੇ ਹਾਂ…';

  @override
  String get ondcFailed => 'ਇਹ ਖਾਤਾ ਨਹੀਂ ਮਿਲਿਆ। ਦੁਬਾਰਾ ਜਾਂਚੋ।';

  @override
  String get ondcNoAccount => 'ਮੇਰੇ ਕੋਲ ਅਜੇ ਖਾਤਾ ਨਹੀਂ ਹੈ';

  @override
  String get ondcNoAccountExplain =>
      'ਕੋਈ ਗੱਲ ਨਹੀਂ। ਤੁਸੀਂ ਚੀਜ਼ਾਂ ਤਿਆਰ ਕਰਕੇ ਰੱਖ ਸਕਦੇ ਹੋ। ਖਾਤਾ ਜੁੜਦੇ ਹੀ ਸਭ ਕੁਝ ਇਕੱਠਾ ਚਲਾ ਜਾਵੇਗਾ।';

  @override
  String get practiceTitle => 'ਵਧੀਆ ਫੋਟੋ ਕਿਵੇਂ ਖਿੱਚੀਏ';

  @override
  String get practiceIntro =>
      'ਉਹੀ ਇੱਕ ਘੜਾ, ਇੱਕ ਵਾਰ ਚੰਗੀ ਤਰ੍ਹਾਂ ਅਤੇ ਇੱਕ ਵਾਰ ਮਾੜੀ ਤਰ੍ਹਾਂ ਖਿੱਚਿਆ। ਦੋਵੇਂ ਵੇਖਣ ਲਈ ਖਿਸਕਾਓ।';

  @override
  String get practiceGoodBadge => 'ਇਸ ਤਰ੍ਹਾਂ ਕਰੋ';

  @override
  String get practiceGoodTitle => 'ਵਧੀਆ ਫੋਟੋ';

  @override
  String get practiceGoodTip1 => 'ਸਾਫ਼: ਫੋਨ ਟਿਕਾ ਕੇ ਰੱਖਿਆ ਸੀ';

  @override
  String get practiceGoodTip2 => 'ਰੋਸ਼ਨੀ: ਖਿੜਕੀ ਜਾਂ ਦਰਵਾਜ਼ੇ ਕੋਲ ਖਿੱਚੀ';

  @override
  String get practiceGoodTip3 => 'ਪੂਰਾ ਸਾਮਾਨ ਫੋਟੋ ਵਿੱਚ ਹੈ';

  @override
  String get practiceBadBadge => 'ਇਸ ਤਰ੍ਹਾਂ ਨਾ ਕਰੋ';

  @override
  String get practiceBadTitle => 'ਮਾੜੀ ਫੋਟੋ';

  @override
  String get practiceBadTip1 => 'ਧੁੰਦਲੀ: ਫੋਨ ਹਿੱਲ ਗਿਆ';

  @override
  String get practiceBadTip2 => 'ਖਰੀਦਦਾਰ ਬਾਰੀਕੀਆਂ ਨਹੀਂ ਵੇਖ ਸਕਦੇ';

  @override
  String get practiceBadTip3 => 'ਐਪ ਤੁਹਾਨੂੰ ਫਿਰ ਫੋਟੋ ਖਿੱਚਣ ਲਈ ਕਹੇਗੀ';

  @override
  String get practiceFinish => 'ਐਪ ਖੋਲ੍ਹੋ';

  @override
  String get navHome => 'ਹੋਮ';

  @override
  String get navListings => 'ਚੀਜ਼ਾਂ';

  @override
  String get navProfile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String homeGreeting(String name) {
    return 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ, $name';
  }

  @override
  String get homeAddProduct => 'ਚੀਜ਼ ਜੋੜੋ';

  @override
  String get homeAddProductSpoken =>
      'ਚੀਜ਼ ਜੋੜਨ ਲਈ ਇਹ ਵੱਡਾ ਬਟਨ ਦਬਾਓ। ਤਿੰਨ ਫੋਟੋਆਂ ਖਿੱਚੋ, ਦੱਸੋ ਇਹ ਕੀ ਹੈ, ਅਤੇ ਇਹ ਵਿਕਰੀ \'ਤੇ ਚਲੀ ਜਾਵੇਗੀ।';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਚੀਜ਼ਾਂ ਭੇਜਣੀਆਂ ਬਾਕੀ ਹਨ',
      one: '1 ਚੀਜ਼ ਭੇਜਣੀ ਬਾਕੀ ਹੈ',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਵਿਕੀਆਂ',
      one: '1 ਵਿਕੀ',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'ਤੁਹਾਡੀਆਂ ਨਵੀਆਂ ਚੀਜ਼ਾਂ';

  @override
  String get homeNextTitle => 'ਹੁਣ ਇਹ ਕਰਨਾ ਹੈ';

  @override
  String get homeEmptyTitle => 'ਇੱਥੇ ਅਜੇ ਕੁਝ ਨਹੀਂ';

  @override
  String get homeEmptyBody => 'ਉੱਪਰ ਵਾਲਾ ਵੱਡਾ ਬਟਨ ਦਬਾ ਕੇ ਆਪਣੀ ਪਹਿਲੀ ਚੀਜ਼ ਜੋੜੋ।';

  @override
  String get offlineNoNetwork => 'ਇਸ ਵੇਲੇ ਨੈੱਟਵਰਕ ਨਹੀਂ ਹੈ';

  @override
  String get offlineNothingLost =>
      'ਕੁਝ ਵੀ ਗੁਆਚਿਆ ਨਹੀਂ। ਨੈੱਟਵਰਕ ਆਉਣ \'ਤੇ ਆਪਣੇ ਆਪ ਚਲਾ ਜਾਵੇਗਾ।';

  @override
  String get statusQueued => 'ਭੇਜਣਾ ਬਾਕੀ';

  @override
  String get statusProcessing => 'ਤਿਆਰ ਹੋ ਰਹੀ ਹੈ';

  @override
  String get statusNeedsAttention => 'ਤੁਹਾਡਾ ਜਵਾਬ ਚਾਹੀਦਾ ਹੈ';

  @override
  String get statusReady => 'ਵਿਕਰੀ ਲਈ ਤਿਆਰ';

  @override
  String get statusPublished => 'ਵਿਕਰੀ \'ਤੇ ਹੈ';

  @override
  String get statusFailed => 'ਭੇਜੀ ਨਹੀਂ ਜਾ ਸਕੀ';

  @override
  String get listingUntitled => 'ਚੀਜ਼';

  @override
  String get listingNoPrice => 'ਕੀਮਤ ਨਹੀਂ ਦੱਸੀ';

  @override
  String get captureTitle => 'ਚੀਜ਼ ਜੋੜੋ';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ਫੋਟੋ $current / $total';
  }

  @override
  String get capturePhotoWhole => 'ਪੂਰੀ ਚੀਜ਼ ਦਿਖਾਓ';

  @override
  String get capturePhotoDetail => 'ਨੇੜਿਓਂ ਇੱਕ ਫੋਟੋ ਖਿੱਚੋ';

  @override
  String get capturePhotoScale => 'ਨਾਲ ਹੱਥ ਰੱਖੋ, ਤਾਂ ਜੋ ਆਕਾਰ ਪਤਾ ਲੱਗੇ';

  @override
  String get captureTakePhoto => 'ਫੋਟੋ ਖਿੱਚੋ';

  @override
  String get captureFromGallery => 'ਗੈਲਰੀ ਵਿੱਚੋਂ ਚੁਣੋ';

  @override
  String get captureTorchOn => 'ਰੋਸ਼ਨੀ ਚਾਲੂ';

  @override
  String get captureTorchOff => 'ਰੋਸ਼ਨੀ ਬੰਦ';

  @override
  String get captureCameraFailed => 'ਕੈਮਰਾ ਨਹੀਂ ਖੁੱਲ੍ਹਿਆ';

  @override
  String get captureCameraRetry => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get captureCameraPermission =>
      'ਤੁਹਾਡੀ ਚੀਜ਼ ਦੀਆਂ ਫੋਟੋਆਂ ਖਿੱਚਣ ਲਈ ਐਪ ਨੂੰ ਕੈਮਰਾ ਚਾਹੀਦਾ ਹੈ।';

  @override
  String get captureOpenSettings => 'ਸੈਟਿੰਗਾਂ ਖੋਲ੍ਹੋ';

  @override
  String get captureLeaveTitle => 'ਸੰਭਾਲੇ ਬਿਨਾਂ ਬਾਹਰ ਜਾਣਾ ਹੈ?';

  @override
  String get captureLeaveBody => 'ਫੋਟੋਆਂ ਅਤੇ ਜੋ ਤੁਸੀਂ ਕਿਹਾ ਉਹ ਮਿਟ ਜਾਵੇਗਾ।';

  @override
  String get captureLeaveConfirm => 'ਮਿਟਾ ਦਿਓ';

  @override
  String get captureLeaveCancel => 'ਇੱਥੇ ਹੀ ਰਹੋ';

  @override
  String get shotReviewChecking => 'ਫੋਟੋ ਜਾਂਚ ਰਹੇ ਹਾਂ…';

  @override
  String get shotReviewRetake => 'ਦੁਬਾਰਾ ਖਿੱਚੋ';

  @override
  String get qualityTooDark =>
      'ਇਹ ਫੋਟੋ ਬਹੁਤ ਹਨੇਰੀ ਹੈ। ਦਰਵਾਜ਼ੇ ਕੋਲ ਖੜ੍ਹੇ ਹੋ ਕੇ ਖਿੱਚੋ।';

  @override
  String get qualityTooBright =>
      'ਇਸ \'ਤੇ ਬਹੁਤ ਰੋਸ਼ਨੀ ਹੈ। ਧੁੱਪ ਵੱਲ ਪਿੱਠ ਕਰਕੇ ਖਿੱਚੋ।';

  @override
  String get qualityBlurry =>
      'ਇਹ ਫੋਟੋ ਸਾਫ਼ ਨਹੀਂ ਹੈ। ਫ਼ੋਨ ਟਿਕਾ ਕੇ ਦੁਬਾਰਾ ਖਿੱਚੋ।';

  @override
  String get qualityUnreadable =>
      'ਇਹ ਫੋਟੋ ਠੀਕ ਤਰ੍ਹਾਂ ਸੰਭਾਲੀ ਨਹੀਂ ਗਈ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਖਿੱਚੋ।';

  @override
  String get qualityNoSubject =>
      'ਇਸ ਫੋਟੋ ਵਿੱਚ ਚੀਜ਼ ਨਹੀਂ ਦਿਸਦੀ। ਇਸ ਨੂੰ ਲਕੀਰ ਦੇ ਅੰਦਰ ਰੱਖੋ ਅਤੇ ਨੇੜੇ ਆਓ।';

  @override
  String get qualityOutOfFrame =>
      'ਇਸ ਫੋਟੋ ਵਿੱਚ ਚੀਜ਼ ਦਾ ਸਿਰਫ਼ ਇੱਕ ਹਿੱਸਾ ਹੈ। ਪੂਰੀ ਚੀਜ਼ ਲਕੀਰ ਦੇ ਅੰਦਰ ਰੱਖੋ।';

  @override
  String get qualityWarningTitle => 'ਇਹ ਦੁਬਾਰਾ ਖਿੱਚੋ';

  @override
  String get qualityKeepAnyway => 'ਫਿਰ ਵੀ ਰੱਖੋ';

  @override
  String get photoSetTitle => 'ਤੁਹਾਡੀਆਂ ਤਿੰਨ ਫੋਟੋਆਂ';

  @override
  String get photoSetBody =>
      'ਪਹਿਲੀ ਫੋਟੋ ਖਰੀਦਦਾਰ ਸਭ ਤੋਂ ਪਹਿਲਾਂ ਦੇਖਦੇ ਹਨ। ਕੋਈ ਫੋਟੋ ਦੁਬਾਰਾ ਖਿੱਚਣ ਲਈ ਉਸ ਨੂੰ ਦਬਾਓ।';

  @override
  String get photoSetMain => 'ਪਹਿਲੀ ਫੋਟੋ';

  @override
  String get photoSetRetakeThis => 'ਇਹ ਦੁਬਾਰਾ ਖਿੱਚੋ';

  @override
  String get photoSetConfirm => 'ਇਹ ਫੋਟੋਆਂ ਠੀਕ ਹਨ';

  @override
  String get photoEditOpen => 'ਫੋਟੋ ਕੱਟੋ ਜਾਂ ਘੁਮਾਓ';

  @override
  String get photoEditTitle => 'ਫੋਟੋ ਕੱਟੋ';

  @override
  String get photoEditBody =>
      'ਕੱਟਣ ਲਈ ਡੱਬੇ ਦਾ ਕੋਨਾ ਜਾਂ ਕਿਨਾਰਾ ਖਿੱਚੋ। ਖਿਸਕਾਉਣ ਲਈ ਡੱਬੇ ਦੇ ਅੰਦਰੋਂ ਖਿੱਚੋ।';

  @override
  String get photoEditTurn => 'ਘੁਮਾਓ';

  @override
  String get photoEditStraighten => 'ਸਿੱਧਾ ਕਰੋ';

  @override
  String get photoEditReset => 'ਫਿਰ ਤੋਂ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get photoEditDone => 'ਇਹ ਫੋਟੋ ਵਰਤੋ';

  @override
  String get photoEditCancel => 'ਵਾਪਸ ਜਾਓ';

  @override
  String get photoEditFailed =>
      'ਇਹ ਬਦਲਾਅ ਸੰਭਾਲਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ। ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get photoIssueTooDark => 'ਬਹੁਤ ਹਨੇਰੀ, ਸਾਫ਼ ਨਹੀਂ ਦਿਸਦੀ';

  @override
  String get photoIssueTooBright => 'ਇਸ \'ਤੇ ਬਹੁਤ ਰੋਸ਼ਨੀ ਹੈ';

  @override
  String get photoIssueBlurry => 'ਧੁੰਦਲੀ, ਕਾਫ਼ੀ ਸਾਫ਼ ਨਹੀਂ';

  @override
  String get photoIssueNoSubject => 'ਇਸ ਫੋਟੋ ਵਿੱਚ ਕੋਈ ਚੀਜ਼ ਨਹੀਂ ਦਿਸਦੀ';

  @override
  String get photoIssueUnreadable => 'ਇਹ ਫੋਟੋ ਸੰਭਾਲੀ ਨਹੀਂ ਗਈ';

  @override
  String get photoIssueOutOfFrame => 'ਚੀਜ਼ ਪੂਰੀ ਫੋਟੋ ਵਿੱਚ ਨਹੀਂ';

  @override
  String get voiceTitle => 'ਹੁਣ ਦੱਸੋ ਇਹ ਕੀ ਹੈ';

  @override
  String get voiceBody =>
      'ਇਹ ਕੀ ਹੈ, ਕਿਸ ਚੀਜ਼ ਦੀ ਬਣੀ ਹੈ, ਕਿੰਨੀ ਵੱਡੀ ਹੈ, ਬਣਾਉਣ ਵਿੱਚ ਕਿੰਨਾ ਸਮਾਂ ਲੱਗਿਆ, ਅਤੇ ਕੀਮਤ ਕਿੰਨੀ।';

  @override
  String get voiceHoldToSpeak => 'ਦਬਾ ਕੇ ਬੋਲੋ';

  @override
  String get voiceRecording => 'ਬੋਲੋ… ਗੱਲ ਪੂਰੀ ਹੋਣ \'ਤੇ ਛੱਡ ਦਿਓ';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total ਵਿੱਚੋਂ $seconds ਸਕਿੰਟ';
  }

  @override
  String get voiceTooShort => 'ਇਹ ਬਹੁਤ ਛੋਟਾ ਸੀ। ਬਟਨ ਦਬਾ ਕੇ ਦੁਬਾਰਾ ਬੋਲੋ।';

  @override
  String get voiceFailed =>
      'ਮਾਈਕ ਸ਼ੁਰੂ ਨਹੀਂ ਹੋਇਆ। ਦੇਖੋ ਕਿ ਐਪ ਨੂੰ ਮਾਈਕ ਦੀ ਇਜਾਜ਼ਤ ਹੈ।';

  @override
  String get voiceBackToPhotos => 'ਫੋਟੋਆਂ \'ਤੇ ਵਾਪਸ ਜਾਓ';

  @override
  String get playbackPlay => 'ਸੁਣੋ';

  @override
  String get playbackStop => 'ਰੋਕੋ';

  @override
  String get playbackAgain => 'ਦੁਬਾਰਾ ਦੱਸੋ';

  @override
  String get playbackAccept => 'ਇਹ ਠੀਕ ਹੈ';

  @override
  String get playbackUnavailable =>
      'ਇਹ ਫ਼ੋਨ ਇਸ ਨੂੰ ਸੁਣਾ ਨਹੀਂ ਸਕਦਾ। ਤੁਸੀਂ ਫਿਰ ਵੀ ਭੇਜ ਸਕਦੇ ਹੋ, ਜਾਂ ਦੁਬਾਰਾ ਦੱਸ ਸਕਦੇ ਹੋ।';

  @override
  String get savedTitle => 'ਸੰਭਾਲਿਆ ਗਿਆ';

  @override
  String get savedBody => 'ਨੈੱਟਵਰਕ ਆਉਣ \'ਤੇ ਆਪਣੇ ਆਪ ਚਲਾ ਜਾਵੇਗਾ।';

  @override
  String get savedBodyOnline =>
      'ਇਹ ਹੁਣ ਭੇਜਿਆ ਜਾ ਰਿਹਾ ਹੈ। ਤੁਹਾਨੂੰ ਇੱਥੇ ਉਡੀਕ ਕਰਨ ਦੀ ਲੋੜ ਨਹੀਂ।';

  @override
  String get savedAddAnother => 'ਇੱਕ ਹੋਰ ਚੀਜ਼ ਜੋੜੋ';

  @override
  String get savedGoHome => 'ਹੋਮ \'ਤੇ ਜਾਓ';

  @override
  String get saveFailed =>
      'ਇਹ ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਸੰਭਾਲਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ। ਸ਼ਾਇਦ ਥਾਂ ਨਹੀਂ ਬਚੀ।';

  @override
  String get saveRetry => 'ਦੁਬਾਰਾ ਸੰਭਾਲਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get queueTitle => 'ਭੇਜਣਾ ਬਾਕੀ';

  @override
  String get queueBody =>
      'ਇੱਥੇ ਕੁਝ ਵੀ ਗੁਆਚਿਆ ਨਹੀਂ। ਨੈੱਟਵਰਕ ਆਉਂਦੇ ਹੀ ਹਰ ਇੱਕ ਚਲੀ ਜਾਵੇਗੀ।';

  @override
  String get queueEmptyTitle => 'ਕੁਝ ਵੀ ਬਾਕੀ ਨਹੀਂ';

  @override
  String get queueEmptyBody => 'ਤੁਸੀਂ ਜੋ ਬਣਾਇਆ ਸਭ ਭੇਜਿਆ ਜਾ ਚੁੱਕਾ ਹੈ।';

  @override
  String get queueStateWaiting => 'ਨੈੱਟਵਰਕ ਦੀ ਉਡੀਕ';

  @override
  String queueStateUploading(int percent) {
    return 'ਭੇਜ ਰਹੇ ਹਾਂ… ਸੌ ਵਿੱਚੋਂ $percent';
  }

  @override
  String get queueStateProcessing => 'ਹੁਣ ਸਾਡੇ ਕੋਲ ਹੈ। ਅਸੀਂ ਲਿਖ ਰਹੇ ਹਾਂ।';

  @override
  String get queueStateFailed => 'ਨਹੀਂ ਗਈ। ਕਾਰਨ ਦੇਖਣ ਲਈ ਦਬਾਓ।';

  @override
  String get queueItemTitle => 'ਇਹ ਚੀਜ਼';

  @override
  String queueMadeAt(String date) {
    return '$date ਨੂੰ ਬਣਾਈ';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਵਾਰ ਕੋਸ਼ਿਸ਼ ਕੀਤੀ',
      one: 'ਇੱਕ ਵਾਰ ਕੋਸ਼ਿਸ਼ ਕੀਤੀ',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'ਹੁਣੇ ਭੇਜਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get queueRetryWaiting => 'ਅਜੇ ਨੈੱਟਵਰਕ ਨਹੀਂ ਹੈ। ਇਹ ਆਪਣੇ ਆਪ ਚਲੀ ਜਾਵੇਗੀ।';

  @override
  String get queueDelete => 'ਇਹ ਚੀਜ਼ ਮਿਟਾਓ';

  @override
  String get queueDeleteTitle => 'ਇਹ ਚੀਜ਼ ਮਿਟਾਉਣੀ ਹੈ?';

  @override
  String get queueDeleteBody =>
      'ਫੋਟੋਆਂ ਅਤੇ ਜੋ ਤੁਸੀਂ ਕਿਹਾ ਉਹ ਚਲਾ ਜਾਵੇਗਾ। ਇਹ ਵਾਪਸ ਨਹੀਂ ਆਵੇਗਾ।';

  @override
  String get queueDeleteConfirm => 'ਹਾਂ, ਮਿਟਾ ਦਿਓ';

  @override
  String get queueDeleteCancel => 'ਨਹੀਂ, ਰਹਿਣ ਦਿਓ';

  @override
  String get failureNetwork =>
      'ਨੈੱਟਵਰਕ ਵਿਚਕਾਰ ਹੀ ਰੁਕ ਗਿਆ। ਸਿਗਨਲ ਆਉਣ \'ਤੇ ਆਪਣੇ ਆਪ ਦੁਬਾਰਾ ਜਾਵੇਗਾ।';

  @override
  String get failureServer =>
      'ਸਾਡੇ ਪਾਸਿਓਂ ਜਵਾਬ ਨਹੀਂ ਆਇਆ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕੀਤੀ ਜਾਵੇਗੀ।';

  @override
  String get failureMissingFiles =>
      'ਫੋਟੋਆਂ ਹੁਣ ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਨਹੀਂ ਹਨ, ਇਸ ਲਈ ਇਹ ਭੇਜੀ ਨਹੀਂ ਜਾ ਸਕਦੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਬਣਾਓ।';

  @override
  String get failureRejected => 'ਇਹ ਮਨਜ਼ੂਰ ਨਹੀਂ ਹੋਈ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਬਣਾਓ।';

  @override
  String get failureUnknown =>
      'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ। ਤੁਸੀਂ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get processingTitle => 'ਅਸੀਂ ਲਿਖ ਰਹੇ ਹਾਂ';

  @override
  String get processingBody =>
      'ਤੁਹਾਡੀਆਂ ਫੋਟੋਆਂ ਅਤੇ ਤੁਹਾਡੇ ਸ਼ਬਦ ਸਾਡੇ ਕੋਲ ਹਨ। ਇਸ ਵਿੱਚ ਕੁਝ ਮਿੰਟ ਲੱਗਦੇ ਹਨ।';

  @override
  String get processingLeave =>
      'ਤੁਹਾਨੂੰ ਇੱਥੇ ਉਡੀਕ ਕਰਨ ਦੀ ਲੋੜ ਨਹੀਂ। ਤਿਆਰ ਹੋਣ \'ਤੇ ਅਸੀਂ ਦੱਸਾਂਗੇ।';

  @override
  String get processingGoHome => 'ਹੋਮ \'ਤੇ ਜਾਓ';

  @override
  String get attentionTitle => 'ਇੱਕ ਸਵਾਲ';

  @override
  String get attentionBody => 'ਬਾਕੀ ਸਭ ਅਸੀਂ ਸਮਝ ਗਏ। ਸਿਰਫ਼ ਇਹੀ ਰਹਿ ਗਿਆ।';

  @override
  String get attentionHoldToAnswer => 'ਦਬਾ ਕੇ ਜਵਾਬ ਦਿਓ';

  @override
  String get attentionAnswering => 'ਤੁਹਾਡਾ ਜਵਾਬ ਭੇਜ ਰਹੇ ਹਾਂ…';

  @override
  String get attentionFailed => 'ਤੁਹਾਡਾ ਜਵਾਬ ਨਹੀਂ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਦੱਸੋ।';

  @override
  String get attentionRetakePhotos => 'ਫੋਟੋਆਂ ਦੁਬਾਰਾ ਖਿੱਚੋ';

  @override
  String get attentionRetakeSending => 'ਤੁਹਾਡੀਆਂ ਨਵੀਆਂ ਫੋਟੋਆਂ ਭੇਜ ਰਹੇ ਹਾਂ…';

  @override
  String get attentionRetakeFailed =>
      'ਨਵੀਆਂ ਫੋਟੋਆਂ ਨਹੀਂ ਗਈਆਂ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get readBackTitle => 'ਅਸੀਂ ਇਹ ਸਮਝਿਆ';

  @override
  String get readBackListen => 'ਪੂਰਾ ਸੁਣੋ';

  @override
  String get readBackFields => 'ਅਸੀਂ ਜੋ ਲਿਖਿਆ';

  @override
  String get readBackCorrect => 'ਜੋ ਗਲਤ ਹੈ ਉਸ ਨੂੰ ਦਬਾਓ';

  @override
  String get readBackApprove => 'ਇਹ ਸਭ ਠੀਕ ਹੈ';

  @override
  String get notSaid => 'ਨਹੀਂ ਦੱਸਿਆ';

  @override
  String get fieldMaterial => 'ਕਿਸ ਚੀਜ਼ ਦੀ ਬਣੀ';

  @override
  String get fieldSize => 'ਆਕਾਰ';

  @override
  String get fieldColour => 'ਰੰਗ';

  @override
  String get fieldTechnique => 'ਕਿਵੇਂ ਬਣਾਈ';

  @override
  String get fieldOrigin => 'ਕਿੱਥੇ ਬਣਾਈ';

  @override
  String get fieldQuantity => 'ਕਿੰਨੀਆਂ';

  @override
  String get fieldPrice => 'ਕੀਮਤ';

  @override
  String correctTitle(String field) {
    return 'ਸਹੀ $field ਦੱਸੋ';
  }

  @override
  String get correctHoldToSpeak => 'ਦਬਾ ਕੇ ਦੱਸੋ';

  @override
  String get correctListening => 'ਸੁਣ ਰਹੇ ਹਾਂ…';

  @override
  String get correctFailedOnce => 'ਸਾਨੂੰ ਸਮਝ ਨਹੀਂ ਆਇਆ। ਇੱਕ ਵਾਰ ਹੋਰ ਦੱਸੋ।';

  @override
  String get correctUseKeypad => 'ਇਸ ਦੀ ਥਾਂ ਲਿਖੋ';

  @override
  String get correctUseVoice => 'ਇਸ ਦੀ ਥਾਂ ਬੋਲੋ';

  @override
  String get correctPick => 'ਜਾਂ ਇਹਨਾਂ ਵਿੱਚੋਂ ਚੁਣੋ';

  @override
  String get correctSave => 'ਇਹ ਸੰਭਾਲੋ';

  @override
  String get correctCancel => 'ਜਿਵੇਂ ਹੈ ਰਹਿਣ ਦਿਓ';

  @override
  String get correctTypeHint => 'ਜਵਾਬ ਇੱਥੇ ਲਿਖੋ';

  @override
  String correctHeard(Object text) {
    return 'ਅਸੀਂ ਸੁਣਿਆ “$text”';
  }

  @override
  String get listingCancelAction => 'ਇਹ ਸੂਚੀ ਰੱਦ ਕਰੋ';

  @override
  String get listingCancelTitle => 'ਇਹ ਸੂਚੀ ਰੱਦ ਕਰਨੀ ਹੈ?';

  @override
  String get listingCancelBody =>
      'ਫੋਟੋਆਂ, ਰਿਕਾਰਡਿੰਗ ਅਤੇ ਤੁਹਾਡੀ ਕਹੀ ਹਰ ਗੱਲ ਮਿਟ ਜਾਵੇਗੀ। ਇਹ ਵਾਪਸ ਨਹੀਂ ਆਵੇਗਾ।';

  @override
  String get listingCancelConfirm => 'ਹਾਂ, ਰੱਦ ਕਰੋ';

  @override
  String get listingCancelKeep => 'ਨਹੀਂ, ਰਹਿਣ ਦਿਓ';

  @override
  String get photoSaveAction => 'ਫੋਟੋ ਸੰਭਾਲੋ';

  @override
  String get photoSaved => 'ਤੁਹਾਡੀਆਂ ਫੋਟੋਆਂ ਵਿੱਚ ਸੰਭਾਲ ਦਿੱਤੀ';

  @override
  String get photoSaveFailed => 'ਫੋਟੋ ਸੰਭਾਲੀ ਨਹੀਂ ਜਾ ਸਕੀ';

  @override
  String get photoSaveDenied => 'ਫੋਟੋ ਸੰਭਾਲਣ ਲਈ ਇਜਾਜ਼ਤ ਦਿਓ';

  @override
  String get colourRed => 'ਲਾਲ';

  @override
  String get colourBlue => 'ਨੀਲਾ';

  @override
  String get colourGreen => 'ਹਰਾ';

  @override
  String get colourYellow => 'ਪੀਲਾ';

  @override
  String get colourBlack => 'ਕਾਲਾ';

  @override
  String get colourWhite => 'ਚਿੱਟਾ';

  @override
  String get colourBrown => 'ਭੂਰਾ';

  @override
  String get colourMulti => 'ਕਈ ਰੰਗ';

  @override
  String get sizeSmall => 'ਛੋਟਾ';

  @override
  String get sizeMedium => 'ਦਰਮਿਆਨਾ';

  @override
  String get sizeLarge => 'ਵੱਡਾ';

  @override
  String get sizeExtraLarge => 'ਬਹੁਤ ਵੱਡਾ';

  @override
  String get suggestTitle => 'ਕੀ ਇਹ ਵੀ ਜੋੜੀਏ?';

  @override
  String get suggestYes => 'ਹਾਂ, ਜੋੜੋ';

  @override
  String get suggestNo => 'ਨਹੀਂ, ਰਹਿਣ ਦਿਓ';

  @override
  String get suggestSkip => 'ਮੈਨੂੰ ਪੱਕਾ ਨਹੀਂ ਪਤਾ';

  @override
  String suggestProgress(int current, int total) {
    return '$total ਵਿੱਚੋਂ $current';
  }

  @override
  String get suggestDone => 'ਹੋਰ ਕੁਝ ਜੋੜਨ ਲਈ ਨਹੀਂ';

  @override
  String get priceTitle => 'ਕੀਮਤ ਕਿੰਨੀ ਹੈ?';

  @override
  String get priceBody => 'ਇਹ ਇੱਕ ਨਗ ਦੀ ਕੀਮਤ ਹੈ।';

  @override
  String priceFloor(String amount) {
    return 'ਤੁਹਾਡਾ ਖਰਚਾ: $amount';
  }

  @override
  String get priceFloorExplain =>
      'ਤੁਹਾਡਾ ਸਮਾਨ ਅਤੇ ਤੁਹਾਡਾ ਸਮਾਂ ਮਿਲਾ ਕੇ ਇੰਨਾ ਬਣਦਾ ਹੈ। ਇਸ ਤੋਂ ਘੱਟ ਵਿੱਚ ਵੇਚਣ ਨਾਲ ਤੁਹਾਨੂੰ ਘਾਟਾ ਪਵੇਗਾ।';

  @override
  String priceBand(String low, String high) {
    return 'ਇਹੋ ਜਿਹੀਆਂ ਚੀਜ਼ਾਂ ਹੋਰ ਲੋਕ $low ਤੋਂ $high ਵਿੱਚ ਵੇਚਦੇ ਹਨ';
  }

  @override
  String get priceBelowFloor =>
      'ਇਹ ਤੁਹਾਡੇ ਖਰਚੇ ਤੋਂ ਘੱਟ ਹੈ। ਫਿਰ ਵੀ ਤੁਸੀਂ ਇਹੀ ਰੱਖ ਸਕਦੇ ਹੋ।';

  @override
  String get priceSayIt => 'ਕੀਮਤ ਦੱਸੋ';

  @override
  String get priceConfirm => 'ਇਹ ਕੀਮਤ ਠੀਕ ਹੈ';

  @override
  String get stockTitle => 'ਤੁਹਾਡੇ ਕੋਲ ਕਿੰਨੀਆਂ ਹਨ?';

  @override
  String get stockBody => 'ਸਭ ਵਿਕ ਜਾਣ \'ਤੇ ਅਸੀਂ ਤੁਹਾਡੇ ਲਈ ਇਸ ਨੂੰ ਹਟਾ ਦੇਵਾਂਗੇ।';

  @override
  String get stockOneOfAKind =>
      'ਸਿਰਫ਼ ਇੱਕ ਹੀ ਹੈ, ਅਤੇ ਇਹੋ ਜਿਹੀ ਹੋਰ ਕਦੇ ਨਹੀਂ ਬਣੇਗੀ';

  @override
  String get stockMore => 'ਇੱਕ ਹੋਰ';

  @override
  String get stockLess => 'ਇੱਕ ਘੱਟ';

  @override
  String get stockConfirm => 'ਇਹ ਠੀਕ ਹੈ';

  @override
  String get photosTitle => 'ਕਿਹੜੀ ਫੋਟੋ ਪਹਿਲਾਂ ਆਵੇ?';

  @override
  String get photosBody => 'ਖਰੀਦਦਾਰ ਪਹਿਲੀ ਫੋਟੋ ਸਭ ਤੋਂ ਪਹਿਲਾਂ ਦੇਖਦੇ ਹਨ।';

  @override
  String get photosMakeFirst => 'ਇਸ ਨੂੰ ਪਹਿਲੀ ਫੋਟੋ ਬਣਾਓ';

  @override
  String get photosFirst => 'ਪਹਿਲੀ ਫੋਟੋ';

  @override
  String get photosConfirm => 'ਇਹ ਫੋਟੋਆਂ ਠੀਕ ਹਨ';

  @override
  String get previewTitle => 'ਖਰੀਦਦਾਰ ਇਹ ਦੇਖਣਗੇ';

  @override
  String get previewListenAll => 'ਸਭ ਸੁਣੋ';

  @override
  String get previewNoDescription => 'ਕੋਈ ਵੇਰਵਾ ਨਹੀਂ ਲਿਖਿਆ ਗਿਆ।';

  @override
  String get previewConfirm => 'ਹਾਂ, ਇਹ ਠੀਕ ਹੈ';

  @override
  String get previewChange => 'ਕੁਝ ਬਦਲੋ';

  @override
  String get consentTitle => 'ਕੀ ਅਸੀਂ ਇਸ ਨੂੰ ਵਿਕਰੀ \'ਤੇ ਰੱਖੀਏ?';

  @override
  String get consentPhoto => 'ਮੇਰੀਆਂ ਫੋਟੋਆਂ ਦਿਖਾਓ';

  @override
  String get consentPhotoExplain =>
      'ਤੁਹਾਡੀ ਚੀਜ਼ ਦੀਆਂ ਫੋਟੋਆਂ ਖਰੀਦਦਾਰ ਦੀ ਸਕਰੀਨ \'ਤੇ ਜਾਣਗੀਆਂ।';

  @override
  String get consentStory => 'ਮੇਰੀ ਕਾਰੀਗਰੀ ਦੀ ਕਹਾਣੀ ਦਿਖਾਓ';

  @override
  String get consentStoryExplain =>
      'ਤੁਹਾਡਾ ਨਾਮ, ਤੁਹਾਡਾ ਪਿੰਡ ਅਤੇ ਤੁਸੀਂ ਕਿਵੇਂ ਬਣਾਉਂਦੇ ਹੋ, ਇਹ ਕਾਰੀਗਰ ਕਾਰਡ \'ਤੇ ਜਾਵੇਗਾ। ਨਾਂਹ ਕਹਿ ਕੇ ਵੀ ਤੁਸੀਂ ਵੇਚ ਸਕਦੇ ਹੋ।';

  @override
  String get consentNeeded => 'ਫੋਟੋਆਂ ਤੋਂ ਬਿਨਾਂ ਅਸੀਂ ਇਸ ਨੂੰ ਨਹੀਂ ਰੱਖ ਸਕਦੇ।';

  @override
  String get consentPublish => 'ਵਿਕਰੀ \'ਤੇ ਰੱਖੋ';

  @override
  String get publishingTitle => 'ਵਿਕਰੀ \'ਤੇ ਰੱਖ ਰਹੇ ਹਾਂ';

  @override
  String get publishingBody => 'ਇਸ ਵਿੱਚ ਥੋੜ੍ਹਾ ਸਮਾਂ ਲੱਗੇਗਾ। ਐਪ ਬੰਦ ਨਾ ਕਰੋ।';

  @override
  String get publishedTitle => 'ਇਹ ਵਿਕਰੀ \'ਤੇ ਲੱਗ ਗਈ';

  @override
  String get publishedBody => 'ਖਰੀਦਦਾਰ ਹੁਣ ਇਸ ਨੂੰ ਦੇਖ ਸਕਦੇ ਹਨ।';

  @override
  String get publishedShare => 'ਵਟਸਐਪ \'ਤੇ ਭੇਜੋ';

  @override
  String get publishedCopyLink => 'ਲਿੰਕ ਕਾਪੀ ਕਰੋ';

  @override
  String get publishedLinkCopied => 'ਲਿੰਕ ਕਾਪੀ ਹੋ ਗਿਆ';

  @override
  String get publishedShowQr => 'ਸਕੈਨ ਕਰਨ ਵਾਲਾ ਕੋਡ ਦਿਖਾਓ';

  @override
  String get publishedQrExplain =>
      'ਕੋਈ ਵੀ ਆਪਣਾ ਫ਼ੋਨ ਇਸ ਵੱਲ ਕਰਕੇ ਤੁਹਾਡੀ ਚੀਜ਼ ਖੋਲ੍ਹ ਸਕਦਾ ਹੈ।';

  @override
  String get publishedAnother => 'ਇਸ ਵਰਗੀ ਇੱਕ ਹੋਰ ਬਣਾਓ';

  @override
  String get publishedDone => 'ਹੋਮ \'ਤੇ ਜਾਓ';

  @override
  String get publishFailed =>
      'ਇਹ ਰੱਖੀ ਨਹੀਂ ਜਾ ਸਕੀ। ਕੁਝ ਵੀ ਗੁਆਚਿਆ ਨਹੀਂ, ਤੁਸੀਂ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get publishRetry => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get reviewLeaveTitle => 'ਹੁਣ ਲਈ ਛੱਡਣਾ ਹੈ?';

  @override
  String get reviewLeaveBody =>
      'ਜੋ ਤੁਸੀਂ ਮਨਜ਼ੂਰ ਕੀਤਾ ਉਹ ਰਹੇਗਾ। ਤੁਸੀਂ ਆਪਣੀਆਂ ਚੀਜ਼ਾਂ ਵਿੱਚੋਂ ਵਾਪਸ ਆ ਸਕਦੇ ਹੋ।';

  @override
  String get reviewLeaveConfirm => 'ਹੁਣ ਲਈ ਛੱਡੋ';

  @override
  String get editLeaveTitle => 'ਤੁਹਾਡੀਆਂ ਤਬਦੀਲੀਆਂ ਅਜੇ ਵਿਕਰੀ \'ਤੇ ਨਹੀਂ';

  @override
  String get editLeaveBody =>
      'ਤੁਸੀਂ ਜੋ ਬਦਲਿਆ ਉਹ ਸੰਭਾਲਿਆ ਗਿਆ ਹੈ, ਪਰ ਖਰੀਦਦਾਰਾਂ ਨੂੰ ਅਜੇ ਵੀ ਪੁਰਾਣੀ ਹੀ ਦਿਸਦੀ ਹੈ। ਆਖਰੀ ਬਟਨ ਦਬਾਉਣ \'ਤੇ ਹੀ ਇਹ ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਜਾਵੇਗੀ।';

  @override
  String get editLeaveConfirm => 'ਠੀਕ ਹੈ, ਬਾਅਦ ਵਿੱਚ ਕਰਾਂਗਾ';

  @override
  String get reviewLeaveCancel => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get statusSoldOut => 'ਸਭ ਵਿਕ ਗਈਆਂ';

  @override
  String get statusUnpublished => 'ਹਟਾ ਲਈ';

  @override
  String get listingsTitle => 'ਤੁਹਾਡੀਆਂ ਚੀਜ਼ਾਂ';

  @override
  String get listingsEmptyTitle => 'ਤੁਸੀਂ ਅਜੇ ਕੁਝ ਨਹੀਂ ਬਣਾਇਆ';

  @override
  String get listingsEmptyBody =>
      'ਹੋਮ ਵਾਲਾ ਵੱਡਾ ਬਟਨ ਦਬਾ ਕੇ ਆਪਣੀ ਪਹਿਲੀ ਚੀਜ਼ ਜੋੜੋ।';

  @override
  String get listingsEmptyFilter => 'ਇੱਥੇ ਕੁਝ ਨਹੀਂ।';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਬਚੀਆਂ',
      one: '1 ਬਚੀ',
      zero: 'ਕੁਝ ਨਹੀਂ ਬਚਿਆ',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਵਾਰ ਦੇਖੀ ਗਈ',
      one: 'ਇੱਕ ਵਾਰ ਦੇਖੀ ਗਈ',
      zero: 'ਅਜੇ ਕਿਸੇ ਨੇ ਨਹੀਂ ਦੇਖੀ',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'ਗਿਣਤੀ ਬਦਲੋ';

  @override
  String get listingTitle => 'ਇਹ ਚੀਜ਼';

  @override
  String get listingOpenPreview => 'ਦੇਖੋ ਖਰੀਦਦਾਰ ਕੀ ਦੇਖਦੇ ਹਨ';

  @override
  String get listingEdit => 'ਕੁਝ ਬਦਲੋ';

  @override
  String get listingDuplicate => 'ਇਸ ਵਰਗੀ ਇੱਕ ਹੋਰ ਬਣਾਓ';

  @override
  String get listingUnpublish => 'ਵਿਕਰੀ ਤੋਂ ਹਟਾਓ';

  @override
  String get listingRelist => 'ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਰੱਖੋ';

  @override
  String get listingFinish => 'ਇਹ ਪੂਰੀ ਕਰੋ';

  @override
  String get listingSoldOutTitle => 'ਇਹ ਸਭ ਵਿਕ ਗਈਆਂ';

  @override
  String get listingSoldOutBody =>
      'ਅਸੀਂ ਤੁਹਾਡੇ ਲਈ ਇਸ ਨੂੰ ਵਿਕਰੀ ਤੋਂ ਹਟਾ ਦਿੱਤਾ। ਹੋਰ ਬਣਾਉਣ \'ਤੇ ਮੁੜ ਰੱਖੋ।';

  @override
  String get editTitle => 'ਇਹ ਚੀਜ਼ ਬਦਲੋ';

  @override
  String get editBody =>
      'ਤੁਸੀਂ ਇਸ ਨੂੰ ਦੁਬਾਰਾ ਦੇਖੋਗੇ, ਅਤੇ ਫਿਰ ਇਹ ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਜਾਵੇਗੀ।';

  @override
  String get editRepublishing => 'ਤਬਦੀਲੀਆਂ ਵਿਕਰੀ \'ਤੇ ਰੱਖ ਰਹੇ ਹਾਂ…';

  @override
  String get editRepublished => 'ਤੁਹਾਡੀਆਂ ਤਬਦੀਲੀਆਂ ਹੁਣ ਵਿਕਰੀ \'ਤੇ ਹਨ';

  @override
  String get editRepublishConfirm => 'ਤਬਦੀਲੀ ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਰੱਖੋ';

  @override
  String get quickStockTitle => 'ਕਿੰਨੀਆਂ ਬਚੀਆਂ ਹਨ?';

  @override
  String get quickStockMarkSoldOut => 'ਸਭ ਵਿਕ ਗਈਆਂ ਹਨ';

  @override
  String get quickStockSave => 'ਸੰਭਾਲੋ';

  @override
  String get quickStockSaved => 'ਸੰਭਾਲਿਆ ਗਿਆ';

  @override
  String get actionUndo => 'ਪਹਿਲਾਂ ਵਾਂਗ ਕਰੋ';

  @override
  String get unpublishTitle => 'ਵਿਕਰੀ ਤੋਂ ਹਟਾਉਣੀ ਹੈ?';

  @override
  String get unpublishBody =>
      'ਖਰੀਦਦਾਰ ਇਸ ਨੂੰ ਹੁਣ ਨਹੀਂ ਦੇਖਣਗੇ। ਕੁਝ ਨਹੀਂ ਮਿਟੇਗਾ, ਅਤੇ ਤੁਸੀਂ ਕਦੇ ਵੀ ਮੁੜ ਰੱਖ ਸਕਦੇ ਹੋ।';

  @override
  String get unpublishConfirm => 'ਹਾਂ, ਹਟਾ ਦਿਓ';

  @override
  String get unpublishCancel => 'ਨਹੀਂ, ਵਿਕਰੀ \'ਤੇ ਰਹਿਣ ਦਿਓ';

  @override
  String get unpublishDone => 'ਇਹ ਵਿਕਰੀ ਤੋਂ ਹਟਾ ਦਿੱਤੀ';

  @override
  String get relistDone => 'ਇਹ ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਹੈ';

  @override
  String get duplicateTitle => 'ਇਸ ਵਰਗੀ ਇੱਕ ਹੋਰ ਬਣਾਉਣੀ ਹੈ?';

  @override
  String get duplicateBody =>
      'ਤੁਸੀਂ ਇਸ ਬਾਰੇ ਜੋ ਦੱਸਿਆ ਉਹ ਅਸੀਂ ਰੱਖਾਂਗੇ। ਤੁਹਾਨੂੰ ਸਿਰਫ਼ ਨਵੀਆਂ ਫੋਟੋਆਂ ਖਿੱਚਣੀਆਂ ਹਨ।';

  @override
  String get duplicateConfirm => 'ਫੋਟੋਆਂ ਖਿੱਚੋ';

  @override
  String get duplicateCancel => 'ਹੁਣ ਨਹੀਂ';

  @override
  String get duplicateBanner =>
      'ਪਿਛਲੀ ਵਰਗੀ ਇੱਕ ਹੋਰ ਬਣਾ ਰਹੇ ਹਾਂ। ਸਿਰਫ਼ ਫੋਟੋਆਂ ਨਵੀਆਂ ਹਨ।';

  @override
  String get listingActionFailed =>
      'ਇਹ ਨਹੀਂ ਹੋਇਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get salesNew => 'ਨਵਾਂ';

  @override
  String get salesEmptyTitle => 'ਅਜੇ ਕੁਝ ਨਹੀਂ ਵਿਕਿਆ';

  @override
  String get salesEmptyBody =>
      'ਜਦੋਂ ਕੋਈ ਕੁਝ ਖਰੀਦੇਗਾ, ਇਹ ਇੱਥੇ ਦਿਸੇਗਾ ਅਤੇ ਅਸੀਂ ਤੁਹਾਨੂੰ ਦੱਸਾਂਗੇ।';

  @override
  String get salesLoading => 'ਦੇਖ ਰਹੇ ਹਾਂ ਕੀ ਵਿਕਿਆ…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਨਗ',
      one: '1 ਨਗ',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date ਤੱਕ ਪੈਕ ਕਰੋ';
  }

  @override
  String get salesPackByToday => 'ਅੱਜ ਹੀ ਪੈਕ ਕਰੋ';

  @override
  String get salesPackByTomorrow => 'ਕੱਲ੍ਹ ਤੱਕ ਪੈਕ ਕਰੋ';

  @override
  String get salesPackedAlready => 'ਇਸ ਦੀ ਤਾਰੀਖ਼ ਲੰਘ ਚੁੱਕੀ ਹੈ';

  @override
  String get saleTitle => 'ਇਹ ਆਰਡਰ';

  @override
  String get saleReadOnly =>
      'ਇਹ ਸਿਰਫ਼ ਤੁਹਾਨੂੰ ਦੱਸਣ ਲਈ ਹੈ। ਆਰਡਰ ਦਾ ਸਾਰਾ ਕੰਮ ਬਾਜ਼ਾਰ \'ਤੇ ਹੁੰਦਾ ਹੈ, ਇਸ ਐਪ ਵਿੱਚ ਨਹੀਂ।';

  @override
  String salePaid(String amount) {
    return 'ਤੁਹਾਨੂੰ $amount ਮਿਲਣਗੇ';
  }

  @override
  String salePlaced(String date) {
    return '$date ਨੂੰ ਵਿਕੀ';
  }

  @override
  String saleGoingTo(String area) {
    return '$area ਜਾ ਰਹੀ ਹੈ';
  }

  @override
  String get saleWhatToPack => 'ਕੀ ਪੈਕ ਕਰਨਾ ਹੈ';

  @override
  String get salePackingHelp => 'ਕਿਵੇਂ ਪੈਕ ਕਰਨਾ ਹੈ';

  @override
  String get saleSeeListing => 'ਇਹ ਚੀਜ਼ ਦੇਖੋ';

  @override
  String get packingTitle => 'ਕਿਵੇਂ ਪੈਕ ਕਰਨਾ ਹੈ';

  @override
  String get packingBody => 'ਇੱਕ-ਇੱਕ ਕਰਕੇ ਕਰੋ। ਜੋ ਹੋ ਜਾਵੇ ਉਸ ਨੂੰ ਦਬਾਓ।';

  @override
  String get packingStep1 =>
      'ਕੱਪੜੇ ਜਾਂ ਕਾਗਜ਼ ਵਿੱਚ ਲਪੇਟੋ, ਤਾਂ ਜੋ ਕੁਝ ਰਗੜ ਨਾ ਲੱਗੇ';

  @override
  String get packingStep2 =>
      'ਚਾਰੇ ਪਾਸੇ ਕਾਗਜ਼ ਜਾਂ ਪਰਾਲੀ ਭਰੋ, ਤਾਂ ਜੋ ਡੱਬੇ ਵਿੱਚ ਹਿੱਲੇ ਨਾ';

  @override
  String get packingStep3 => 'ਦੇਖੋ ਕਿ ਅੰਦਰ ਸਹੀ ਗਿਣਤੀ ਵਿੱਚ ਨਗ ਹਨ';

  @override
  String get packingStep4 => 'ਡੱਬਾ ਬੰਦ ਕਰਕੇ ਚਾਰੇ ਪਾਸੇ ਟੇਪ ਲਗਾਓ';

  @override
  String get packingStep5 => 'ਲੈਣ ਆਉਣ ਵਾਲੇ ਲਈ ਤਿਆਰ ਰੱਖੋ';

  @override
  String get packingDone => 'ਸਭ ਹੋ ਗਿਆ';

  @override
  String packingProgress(int done, int total) {
    return '$total ਵਿੱਚੋਂ $done ਹੋਏ';
  }

  @override
  String get earningsTitle => 'ਤੁਸੀਂ ਕਿੰਨਾ ਕਮਾਇਆ';

  @override
  String get earningsWeek => 'ਇਸ ਹਫ਼ਤੇ';

  @override
  String get earningsMonth => 'ਇਸ ਮਹੀਨੇ';

  @override
  String get earningsTotal => 'ਸ਼ੁਰੂ ਤੋਂ';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਨਗ ਵਿਕੇ',
      one: '1 ਨਗ ਵਿਕਿਆ',
      zero: 'ਅਜੇ ਕੁਝ ਨਹੀਂ ਵਿਕਿਆ',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'ਬਾਜ਼ਾਰ ਦਾ ਹਿੱਸਾ ਕੱਟਣ ਤੋਂ ਬਾਅਦ ਜੋ ਤੁਹਾਨੂੰ ਮਿਲਦਾ ਹੈ, ਉਹ ਇਹ ਹੈ।';

  @override
  String get profileVillageLabel => 'ਪਿੰਡ ਜਾਂ ਕਲੱਸਟਰ';

  @override
  String get profileNotSet => 'ਨਹੀਂ ਦਿੱਤਾ';

  @override
  String get profileEditEntry => 'ਆਪਣੀ ਜਾਣਕਾਰੀ ਬਦਲੋ';

  @override
  String get profileStoryEntry => 'ਤੁਹਾਡੀ ਕਾਰੀਗਰੀ ਦੀ ਕਹਾਣੀ';

  @override
  String get profileLanguageEntry => 'ਭਾਸ਼ਾ';

  @override
  String get profilePhoneEntry => 'ਫ਼ੋਨ ਨੰਬਰ';

  @override
  String get profileOndcEntry => 'ਤੁਹਾਡਾ ਵਿਕਰੀ ਖਾਤਾ';

  @override
  String get profileNotificationsEntry => 'ਅਸੀਂ ਤੁਹਾਨੂੰ ਕੀ ਦੱਸੀਏ';

  @override
  String get profileVoiceEntry => 'ਆਵਾਜ਼ ਅਤੇ ਸੁਣਨਾ';

  @override
  String get profilePrivacyEntry => 'ਤੁਹਾਡੇ ਬਾਰੇ ਕੀ ਦਿਸਦਾ ਹੈ';

  @override
  String get profileStorageEntry => 'ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਥਾਂ';

  @override
  String get profileAccountEntry => 'ਸਾਈਨ ਆਊਟ';

  @override
  String get editProfileTitle => 'ਤੁਹਾਡੀ ਜਾਣਕਾਰੀ';

  @override
  String get editProfileAddPhoto => 'ਆਪਣੀ ਫੋਟੋ ਜੋੜੋ';

  @override
  String get editProfileChangePhoto => 'ਫੋਟੋ ਬਦਲੋ';

  @override
  String get editProfileRemovePhoto => 'ਫੋਟੋ ਹਟਾਓ';

  @override
  String get editProfilePhotoWhy =>
      'ਤੁਹਾਡੀ ਇਜਾਜ਼ਤ ਹੋਣ \'ਤੇ ਹੀ ਖਰੀਦਦਾਰ ਇਸ ਨੂੰ ਕਾਰੀਗਰ ਕਾਰਡ \'ਤੇ ਦੇਖਦੇ ਹਨ।';

  @override
  String get editProfileVillageHint => 'ਬੋਲੋ ਜਾਂ ਲਿਖੋ';

  @override
  String get editProfileSave => 'ਸੰਭਾਲੋ';

  @override
  String get editProfileSaved => 'ਸੰਭਾਲਿਆ ਗਿਆ';

  @override
  String get storyTitle => 'ਤੁਹਾਡੀ ਕਾਰੀਗਰੀ ਦੀ ਕਹਾਣੀ';

  @override
  String get storyBody =>
      'ਖਰੀਦਦਾਰਾਂ ਨੂੰ ਦੱਸੋ ਤੁਸੀਂ ਕੌਣ ਹੋ ਅਤੇ ਕਿਵੇਂ ਬਣਾਉਂਦੇ ਹੋ। ਤੁਸੀਂ ਬੋਲੋ, ਅਸੀਂ ਲਿਖ ਲਵਾਂਗੇ।';

  @override
  String get storyHoldToSpeak => 'ਦਬਾ ਕੇ ਆਪਣੀ ਕਹਾਣੀ ਦੱਸੋ';

  @override
  String get storyEmpty => 'ਤੁਸੀਂ ਅਜੇ ਆਪਣੀ ਕਹਾਣੀ ਨਹੀਂ ਦੱਸੀ।';

  @override
  String get storyEditHint => 'ਤੁਸੀਂ ਇਸ ਦਾ ਕੋਈ ਵੀ ਸ਼ਬਦ ਬਦਲ ਸਕਦੇ ਹੋ।';

  @override
  String get storyExample =>
      'ਜਿਵੇਂ: ਸਾਡੇ ਪਰਿਵਾਰ ਵਿੱਚ ਤਿੰਨ ਪੀੜ੍ਹੀਆਂ ਤੋਂ ਇਹ ਬਣਦੀਆਂ ਹਨ, ਅਤੇ ਮੈਂ ਅੱਜ ਵੀ ਆਪਣੇ ਦਾਦੇ ਦੀ ਖੱਡੀ \'ਤੇ ਕੰਮ ਕਰਦਾ ਹਾਂ।';

  @override
  String get changePhoneTitle => 'ਆਪਣਾ ਨੰਬਰ ਬਦਲੋ';

  @override
  String get changePhoneBody =>
      'ਨੰਬਰ ਤੁਹਾਡਾ ਹੀ ਹੈ, ਇਹ ਪੱਕਾ ਕਰਨ ਲਈ ਅਸੀਂ ਨਵੇਂ ਨੰਬਰ \'ਤੇ ਇੱਕ ਕੋਡ ਭੇਜਾਂਗੇ।';

  @override
  String changePhoneCurrent(String number) {
    return 'ਹੁਣ ਤੁਹਾਡਾ ਨੰਬਰ $number ਹੈ';
  }

  @override
  String get changePhoneDone => 'ਤੁਹਾਡਾ ਨੰਬਰ ਬਦਲ ਗਿਆ';

  @override
  String get ondcAccountTitle => 'ਤੁਹਾਡਾ ਵਿਕਰੀ ਖਾਤਾ';

  @override
  String get ondcAccountLinked => 'ਤੁਹਾਡਾ ਖਾਤਾ ਜੁੜਿਆ ਹੋਇਆ ਹੈ';

  @override
  String get ondcAccountNone => 'ਅਜੇ ਕੋਈ ਖਾਤਾ ਨਹੀਂ ਜੁੜਿਆ';

  @override
  String get ondcAccountNoneBody =>
      'ਤੁਸੀਂ ਚੀਜ਼ਾਂ ਬਣਾਉਂਦੇ ਰਹੋ। ਖਾਤਾ ਜੁੜਦੇ ਹੀ ਉਹ ਵਿਕਰੀ \'ਤੇ ਚਲੀਆਂ ਜਾਣਗੀਆਂ।';

  @override
  String get ondcAccountLink => 'ਖਾਤਾ ਜੋੜੋ';

  @override
  String get ondcAccountUnlink => 'ਇਹ ਖਾਤਾ ਹਟਾਓ';

  @override
  String get ondcUnlinkTitle => 'ਇਹ ਖਾਤਾ ਹਟਾਉਣਾ ਹੈ?';

  @override
  String get ondcUnlinkBody =>
      'ਵਿਕਰੀ \'ਤੇ ਜੋ ਹੈ ਸਭ ਉੱਤਰ ਜਾਵੇਗਾ। ਤੁਹਾਡਾ ਬਣਾਇਆ ਕੁਝ ਨਹੀਂ ਮਿਟੇਗਾ, ਅਤੇ ਤੁਸੀਂ ਇਸ ਨੂੰ ਮੁੜ ਜੋੜ ਸਕਦੇ ਹੋ।';

  @override
  String get ondcUnlinkConfirm => 'ਹਾਂ, ਹਟਾ ਦਿਓ';

  @override
  String get ondcUnlinkCancel => 'ਨਹੀਂ, ਰਹਿਣ ਦਿਓ';

  @override
  String get ondcUnlinkDone => 'ਖਾਤਾ ਹਟਾ ਦਿੱਤਾ';

  @override
  String get notificationsTitle => 'ਅਸੀਂ ਤੁਹਾਨੂੰ ਕੀ ਦੱਸੀਏ';

  @override
  String get notifySold => 'ਜਦੋਂ ਕੁਝ ਵਿਕੇ';

  @override
  String get notifySoldWhy =>
      'ਖਰੀਦਦਾਰ ਦੇ ਪੈਸੇ ਦਿੰਦੇ ਹੀ ਅਸੀਂ ਦੱਸਾਂਗੇ, ਤਾਂ ਜੋ ਤੁਸੀਂ ਪੈਕ ਕਰਨਾ ਸ਼ੁਰੂ ਕਰ ਸਕੋ।';

  @override
  String get notifyAttention => 'ਜਦੋਂ ਸਾਨੂੰ ਤੁਹਾਡੇ ਤੋਂ ਕੁਝ ਪੁੱਛਣਾ ਹੋਵੇ';

  @override
  String get notifyAttentionWhy =>
      'ਕਈ ਵਾਰ ਚੀਜ਼ ਵਿਕਰੀ \'ਤੇ ਜਾਣ ਤੋਂ ਪਹਿਲਾਂ ਇੱਕ ਗੱਲ ਰਹਿ ਜਾਂਦੀ ਹੈ।';

  @override
  String get notifyUpload => 'ਜਦੋਂ ਚੀਜ਼ ਭੇਜੀ ਜਾਵੇ';

  @override
  String get notifyUploadWhy =>
      'ਤੁਸੀਂ ਫ਼ੋਨ \'ਤੇ ਜੋ ਬਣਾਇਆ ਉਹ ਸਾਡੇ ਤੱਕ ਪਹੁੰਚਣ \'ਤੇ ਦੱਸਾਂਗੇ।';

  @override
  String get notifyPackBy => 'ਜਦੋਂ ਪੈਕ ਕਰਨ ਦਾ ਸਮਾਂ ਹੋਵੇ';

  @override
  String get notifyPackByWhy =>
      'ਜਿਹੜੀ ਵਿਕਰੀ ਪੈਕ ਕਰਨੀ ਹੈ, ਉਸਦੀ ਤਾਰੀਖ ਤੋਂ ਇੱਕ ਦਿਨ ਪਹਿਲਾਂ ਅਤੇ ਉਸੇ ਦਿਨ ਅਸੀਂ ਤੁਹਾਨੂੰ ਯਾਦ ਕਰਾਵਾਂਗੇ।';

  @override
  String get notificationsBlocked =>
      'ਇਹ ਫ਼ੋਨ ਸਾਨੂੰ ਤੁਹਾਨੂੰ ਕੁਝ ਭੇਜਣ ਨਹੀਂ ਦੇ ਰਿਹਾ। ਤੁਸੀਂ ਫ਼ੋਨ ਦੀਆਂ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਇਸ ਨੂੰ ਚਾਲੂ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get voiceSettingsTitle => 'ਆਵਾਜ਼ ਅਤੇ ਸੁਣਨਾ';

  @override
  String get voiceSpeed => 'ਅਸੀਂ ਕਿੰਨਾ ਤੇਜ਼ ਬੋਲੀਏ';

  @override
  String get voiceSpeedSlow => 'ਹੌਲੀ';

  @override
  String get voiceSpeedFast => 'ਤੇਜ਼';

  @override
  String get voiceTry => 'ਹੁਣੇ ਬੋਲ ਕੇ ਸੁਣਾਓ';

  @override
  String get voiceSample => 'ਅਸੀਂ ਤੁਹਾਡੇ ਨਾਲ ਇੰਨੀ ਤੇਜ਼ੀ ਨਾਲ ਬੋਲਾਂਗੇ।';

  @override
  String get voiceAutoRead => 'ਹਰ ਸਕਰੀਨ ਖੁੱਲ੍ਹਦੇ ਹੀ ਪੜ੍ਹ ਕੇ ਸੁਣਾਓ';

  @override
  String get voiceAutoReadWhy =>
      'ਇਹ ਬੰਦ ਹੋਵੇ ਤਾਂ ਅਸੀਂ ਸਿਰਫ਼ ਸਪੀਕਰ ਦਬਾਉਣ \'ਤੇ ਬੋਲਦੇ ਹਾਂ।';

  @override
  String get voiceUnavailable =>
      'ਇਹ ਫ਼ੋਨ ਬੋਲ ਨਹੀਂ ਸਕਦਾ। ਸਭ ਕੁਝ ਚੱਲੇਗਾ, ਪਰ ਕੁਝ ਪੜ੍ਹ ਕੇ ਨਹੀਂ ਸੁਣਾਇਆ ਜਾਵੇਗਾ।';

  @override
  String get privacyTitle => 'ਤੁਹਾਡੇ ਬਾਰੇ ਕੀ ਦਿਸਦਾ ਹੈ';

  @override
  String get privacyBody =>
      'ਹਰ ਚੀਜ਼ ਵਿਕਰੀ \'ਤੇ ਰੱਖਦੇ ਸਮੇਂ ਤੁਸੀਂ ਇਹਨਾਂ ਨੂੰ ਹਾਂ ਕਹੀ ਸੀ। ਤੁਸੀਂ ਇਹਨਾਂ ਵਿੱਚੋਂ ਕੋਈ ਵੀ ਵਾਪਸ ਲੈ ਸਕਦੇ ਹੋ।';

  @override
  String get privacyPhoto => 'ਇਸ ਚੀਜ਼ ਦੀਆਂ ਫੋਟੋਆਂ';

  @override
  String get privacyStory => 'ਤੁਹਾਡਾ ਨਾਮ, ਪਿੰਡ ਅਤੇ ਕਹਾਣੀ';

  @override
  String get privacyNothing => 'ਇਸ ਵੇਲੇ ਤੁਹਾਡਾ ਕੁਝ ਵੀ ਵਿਕਰੀ \'ਤੇ ਨਹੀਂ।';

  @override
  String get privacyWithdrawTitle => 'ਇਹ ਵਾਪਸ ਲੈਣਾ ਹੈ?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ਫੋਟੋਆਂ ਤੋਂ ਬਿਨਾਂ ਇਹ ਚੀਜ਼ ਵਿਕਰੀ \'ਤੇ ਨਹੀਂ ਰਹਿ ਸਕਦੀ, ਇਸ ਲਈ ਇਹ ਉੱਤਰ ਜਾਵੇਗੀ। ਕੁਝ ਨਹੀਂ ਮਿਟੇਗਾ।';

  @override
  String get privacyWithdrawStoryBody =>
      'ਤੁਹਾਡਾ ਨਾਮ, ਪਿੰਡ ਅਤੇ ਕਹਾਣੀ ਇਸ ਚੀਜ਼ ਤੋਂ ਹਟਾ ਦਿੱਤੀ ਜਾਵੇਗੀ। ਇਹ ਵਿਕਰੀ \'ਤੇ ਰਹੇਗੀ।';

  @override
  String get privacyWithdrawConfirm => 'ਹਾਂ, ਵਾਪਸ ਲਓ';

  @override
  String get privacyWithdrawCancel => 'ਨਹੀਂ, ਰਹਿਣ ਦਿਓ';

  @override
  String get privacyWithdrawn => 'ਵਾਪਸ ਲੈ ਲਿਆ';

  @override
  String get storageTitle => 'ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਥਾਂ';

  @override
  String get storagePhotos => 'ਫੋਟੋਆਂ ਅਤੇ ਰਿਕਾਰਡਿੰਗਾਂ';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਚੀਜ਼ਾਂ ਭੇਜਣੀਆਂ ਬਾਕੀ ਹਨ',
      one: '1 ਚੀਜ਼ ਭੇਜਣੀ ਬਾਕੀ ਹੈ',
      zero: 'ਭੇਜਣ ਲਈ ਕੁਝ ਬਾਕੀ ਨਹੀਂ',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'ਜੋ ਭੇਜਿਆ ਜਾ ਚੁੱਕਾ ਹੈ ਉਹ ਹਟਾਓ';

  @override
  String get storageClearWhy =>
      'ਜੋ ਅਜੇ ਭੇਜਣਾ ਬਾਕੀ ਹੈ, ਉਸ ਨੂੰ ਕਦੇ ਹੱਥ ਨਹੀਂ ਲਾਇਆ ਜਾਂਦਾ।';

  @override
  String storageCleared(String size) {
    return '$size ਖਾਲੀ ਹੋਈ';
  }

  @override
  String get storageNothingToClear => 'ਹਟਾਉਣ ਲਈ ਕੁਝ ਨਹੀਂ';

  @override
  String get accountTitle => 'ਸਾਈਨ ਆਊਟ';

  @override
  String get accountSignOut => 'ਇਸ ਫ਼ੋਨ ਤੋਂ ਸਾਈਨ ਆਊਟ ਕਰੋ';

  @override
  String get accountSignOutTitle => 'ਸਾਈਨ ਆਊਟ ਕਰਨਾ ਹੈ?';

  @override
  String get accountSignOutBody =>
      'ਜੋ ਭੇਜਣਾ ਬਾਕੀ ਹੈ ਉਹ ਗੁਆਚ ਜਾਵੇਗਾ। ਜੋ ਵਿਕਰੀ \'ਤੇ ਹੈ ਉਹ ਵਿਕਰੀ \'ਤੇ ਹੀ ਰਹੇਗਾ।';

  @override
  String get accountSignOutConfirm => 'ਹਾਂ, ਸਾਈਨ ਆਊਟ';

  @override
  String get accountSignOutCancel => 'ਨਹੀਂ, ਸਾਈਨ ਇਨ ਰਹਿਣ ਦਿਓ';

  @override
  String get accountDelete => 'ਮੇਰਾ ਖਾਤਾ ਮਿਟਾਓ';

  @override
  String get accountDeleteTitle => 'ਆਪਣਾ ਖਾਤਾ ਮਿਟਾਉਣਾ ਹੈ?';

  @override
  String get accountDeleteBody =>
      'ਸਭ ਕੁਝ ਵਿਕਰੀ ਤੋਂ ਉੱਤਰ ਜਾਵੇਗਾ ਅਤੇ ਇਸ ਫ਼ੋਨ ਦਾ ਸਭ ਕੁਝ ਮਿਟ ਜਾਵੇਗਾ। ਇਹ ਵਾਪਸ ਨਹੀਂ ਆਵੇਗਾ।';

  @override
  String get accountDeleteConfirm => 'ਹਾਂ, ਸਭ ਮਿਟਾ ਦਿਓ';

  @override
  String get accountDeleteCancel => 'ਨਹੀਂ, ਮੇਰਾ ਖਾਤਾ ਰਹਿਣ ਦਿਓ';

  @override
  String get accountDeleteHold => 'ਮਿਟਾਉਣ ਲਈ ਬਟਨ ਦਬਾ ਕੇ ਰੱਖੋ';

  @override
  String get profileHelpEntry => 'ਮਦਦ';

  @override
  String get helpTitle => 'ਮਦਦ';

  @override
  String get helpBody =>
      'ਛੋਟੇ ਜਵਾਬ, ਪੜ੍ਹ ਕੇ ਸੁਣਾਏ ਜਾਂਦੇ ਹਨ। ਸੁਣਨ ਲਈ ਕਿਸੇ ਨੂੰ ਵੀ ਦਬਾਓ।';

  @override
  String get helpSteps => 'ਇਸ ਤਰ੍ਹਾਂ ਕਰੋ';

  @override
  String get helpTopicPhotos => 'ਚੰਗੀਆਂ ਫੋਟੋਆਂ ਕਿਵੇਂ ਖਿੱਚੀਏ';

  @override
  String get helpTopicPhotosBody =>
      'ਚੰਗੀਆਂ ਫੋਟੋਆਂ ਨਾਲ ਚੀਜ਼ ਵਿਕਦੀ ਹੈ। ਖਰੀਦਦਾਰ ਚੀਜ਼ ਹੱਥ ਵਿੱਚ ਨਹੀਂ ਫੜ ਸਕਦਾ, ਉਸ ਕੋਲ ਸਿਰਫ਼ ਫੋਟੋ ਹੁੰਦੀ ਹੈ।';

  @override
  String get helpTopicPhotosStep1 =>
      'ਦਰਵਾਜ਼ੇ ਜਾਂ ਖਿੜਕੀ ਕੋਲ ਖੜ੍ਹੇ ਹੋਵੋ, ਤਾਂ ਜੋ ਦਿਨ ਦੀ ਰੋਸ਼ਨੀ ਚੀਜ਼ \'ਤੇ ਪਵੇ';

  @override
  String get helpTopicPhotosStep2 =>
      'ਚੀਜ਼ ਨੂੰ ਸਾਦੇ ਕੱਪੜੇ \'ਤੇ ਰੱਖੋ, ਆਲੇ-ਦੁਆਲੇ ਹੋਰ ਕੁਝ ਨਾ ਹੋਵੇ';

  @override
  String get helpTopicPhotosStep3 =>
      'ਫੋਟੋ ਖਿੱਚੇ ਜਾਣ ਤੱਕ ਦੋਵੇਂ ਹੱਥਾਂ ਨਾਲ ਫ਼ੋਨ ਟਿਕਾ ਕੇ ਰੱਖੋ';

  @override
  String get helpTopicPhotosStep4 =>
      'ਨੇੜਿਓਂ ਇੱਕ ਫੋਟੋ ਖਿੱਚੋ, ਤਾਂ ਜੋ ਕਾਰੀਗਰੀ ਦਿਸੇ';

  @override
  String get helpTopicPhotosStep5 =>
      'ਇੱਕ ਫੋਟੋ ਵਿੱਚ ਨਾਲ ਹੱਥ ਰੱਖੋ, ਤਾਂ ਜੋ ਆਕਾਰ ਪਤਾ ਲੱਗੇ';

  @override
  String get helpTopicVoice => 'ਆਪਣੀ ਚੀਜ਼ ਬਾਰੇ ਕੀ ਦੱਸਣਾ ਹੈ';

  @override
  String get helpTopicVoiceBody =>
      'ਜਿਵੇਂ ਸਾਹਮਣੇ ਖੜ੍ਹੇ ਗਾਹਕ ਨਾਲ ਗੱਲ ਕਰਦੇ ਹੋ, ਉਵੇਂ ਹੀ ਬੋਲੋ। ਬੋਲਣ ਦਾ ਕੋਈ ਗਲਤ ਤਰੀਕਾ ਨਹੀਂ।';

  @override
  String get helpTopicVoiceStep1 => 'ਦੱਸੋ ਇਹ ਕੀ ਹੈ';

  @override
  String get helpTopicVoiceStep2 => 'ਦੱਸੋ ਇਹ ਕਿਸ ਚੀਜ਼ ਦੀ ਬਣੀ ਹੈ';

  @override
  String get helpTopicVoiceStep3 => 'ਦੱਸੋ ਇਹ ਕਿੰਨੀ ਵੱਡੀ ਹੈ, ਇੰਚ ਜਾਂ ਫੁੱਟ ਵਿੱਚ';

  @override
  String get helpTopicVoiceStep4 => 'ਦੱਸੋ ਬਣਾਉਣ ਵਿੱਚ ਕਿੰਨਾ ਸਮਾਂ ਲੱਗਿਆ';

  @override
  String get helpTopicVoiceStep5 => 'ਦੱਸੋ ਤੁਹਾਨੂੰ ਇਸ ਦੇ ਕਿੰਨੇ ਪੈਸੇ ਚਾਹੀਦੇ ਹਨ';

  @override
  String get helpTopicPrice => 'ਕੀਮਤ ਕਿਵੇਂ ਤੈਅ ਕਰੀਏ';

  @override
  String get helpTopicPriceBody =>
      'ਕੀਮਤ ਵਿੱਚ ਤੁਹਾਡੇ ਸਮਾਨ ਦਾ ਖਰਚਾ ਅਤੇ ਤੁਹਾਡੇ ਸਮੇਂ ਦੀ ਕੀਮਤ ਦੋਵੇਂ ਨਿਕਲਣੇ ਚਾਹੀਦੇ ਹਨ। ਅਸੀਂ ਤੁਹਾਡੇ ਨਾਲ ਇਹ ਹਿਸਾਬ ਲਾਉਂਦੇ ਹਾਂ, ਅਤੇ ਦੱਸੇ ਬਿਨਾਂ ਕਦੇ ਇਸ ਤੋਂ ਹੇਠਾਂ ਨਹੀਂ ਜਾਣ ਦਿੰਦੇ।';

  @override
  String get helpTopicPriceStep1 => 'ਗਿਣੋ ਸਮਾਨ \'ਤੇ ਕਿੰਨਾ ਖਰਚਾ ਆਇਆ';

  @override
  String get helpTopicPriceStep2 => 'ਗਿਣੋ ਕੰਮ ਵਿੱਚ ਕਿੰਨੇ ਦਿਨ ਲੱਗੇ';

  @override
  String get helpTopicPriceStep3 =>
      'ਜੋ ਅਸੀਂ ਸੁਝਾਉਂਦੇ ਹਾਂ ਉਹ ਦੇਖੋ, ਅਤੇ ਤੁਹਾਨੂੰ ਬਿਹਤਰ ਪਤਾ ਹੋਵੇ ਤਾਂ ਬਦਲੋ';

  @override
  String get helpTopicPriceStep4 =>
      'ਜੇ ਇਹ ਤੁਹਾਡੇ ਖਰਚੇ ਤੋਂ ਘੱਟ ਹੋਵੇ ਤਾਂ ਅਸੀਂ ਦੱਸਾਂਗੇ, ਪਰ ਫ਼ੈਸਲਾ ਤੁਹਾਡਾ ਹੀ';

  @override
  String get helpTopicSold => 'ਵਿਕਣ ਤੋਂ ਬਾਅਦ ਕੀ ਹੁੰਦਾ ਹੈ';

  @override
  String get helpTopicSoldBody =>
      'ਖਰੀਦਦਾਰ ਬਾਜ਼ਾਰ \'ਤੇ ਪੈਸੇ ਦਿੰਦਾ ਹੈ। ਤੁਸੀਂ ਪੈਕ ਕਰਕੇ ਸੌਂਪ ਦਿੰਦੇ ਹੋ, ਅਤੇ ਪੈਸੇ ਤੁਹਾਡੇ ਕੋਲ ਆਉਂਦੇ ਹਨ।';

  @override
  String get helpTopicSoldStep1 => 'ਵਿਕਦੇ ਹੀ ਅਸੀਂ ਤੁਹਾਨੂੰ ਦੱਸਾਂਗੇ';

  @override
  String get helpTopicSoldStep2 => 'ਖੋਲ੍ਹ ਕੇ ਦੇਖੋ ਕੀ ਅਤੇ ਕਿੰਨਾ ਪੈਕ ਕਰਨਾ ਹੈ';

  @override
  String get helpTopicSoldStep3 =>
      'ਜੋ ਤਾਰੀਖ਼ ਅਸੀਂ ਦਿਖਾਉਂਦੇ ਹਾਂ ਉਸ ਤੋਂ ਪਹਿਲਾਂ ਪੈਕ ਕਰੋ';

  @override
  String get helpTopicSoldStep4 => 'ਲੈਣ ਆਉਣ ਵਾਲੇ ਨੂੰ ਸੌਂਪ ਦਿਓ';

  @override
  String get helpTopicSoldStep5 => 'ਉਸ ਤੋਂ ਬਾਅਦ ਪੈਸੇ ਤੁਹਾਡੇ ਤੱਕ ਪਹੁੰਚਦੇ ਹਨ';

  @override
  String get helpVideoComing => 'ਇਸ ਲਈ ਇੱਕ ਛੋਟੀ ਵੀਡੀਓ ਜਲਦੀ ਆ ਰਹੀ ਹੈ।';

  @override
  String get helpPractice => 'ਵਧੀਆ ਫੋਟੋ ਕਿਵੇਂ ਖਿੱਚੀਏ';

  @override
  String get helpPracticeBody => 'ਇੱਕੋ ਘੜੇ ਦੀ ਇੱਕ ਵਧੀਆ ਅਤੇ ਇੱਕ ਮਾੜੀ ਫੋਟੋ।';

  @override
  String get helpFaqEntry => 'ਲੋਕ ਜੋ ਪੁੱਛਦੇ ਹਨ';

  @override
  String get helpAboutEntry => 'ਕੀਰਤੀਕਰ ਬਾਰੇ';

  @override
  String get helpSupportEntry => 'ਕਿਸੇ ਬੰਦੇ ਨਾਲ ਗੱਲ ਕਰੋ';

  @override
  String get helpTermsEntry => 'ਸ਼ਰਤਾਂ ਅਤੇ ਨਿੱਜਤਾ';

  @override
  String get faqTitle => 'ਲੋਕ ਜੋ ਪੁੱਛਦੇ ਹਨ';

  @override
  String get faqQ1 => 'ਕੀ ਇਸ ਲਈ ਮੈਨੂੰ ਕੁਝ ਦੇਣਾ ਪਵੇਗਾ?';

  @override
  String get faqA1 =>
      'ਨਹੀਂ। ਚੀਜ਼ਾਂ ਰੱਖਣਾ ਮੁਫ਼ਤ ਹੈ। ਕੁਝ ਵਿਕਣ \'ਤੇ ਹੀ ਬਾਜ਼ਾਰ ਆਪਣਾ ਛੋਟਾ ਹਿੱਸਾ ਲੈਂਦਾ ਹੈ।';

  @override
  String get faqQ2 => 'ਜੇ ਨੈੱਟਵਰਕ ਨਾ ਹੋਵੇ ਤਾਂ?';

  @override
  String get faqA2 =>
      'ਸਭ ਕੁਝ ਚੱਲਦਾ ਰਹਿੰਦਾ ਹੈ। ਤੁਸੀਂ ਜੋ ਬਣਾਉਂਦੇ ਹੋ ਉਹ ਫ਼ੋਨ ਵਿੱਚ ਰਹਿੰਦਾ ਹੈ ਅਤੇ ਨੈੱਟਵਰਕ ਆਉਣ \'ਤੇ ਆਪਣੇ ਆਪ ਚਲਾ ਜਾਂਦਾ ਹੈ।';

  @override
  String get faqQ3 => 'ਮੇਰੇ ਪੈਸੇ ਕਿਸ ਨੂੰ ਮਿਲਦੇ ਹਨ?';

  @override
  String get faqA3 =>
      'ਤੁਹਾਨੂੰ। ਖਰੀਦਦਾਰ ਬਾਜ਼ਾਰ \'ਤੇ ਪੈਸੇ ਦਿੰਦਾ ਹੈ ਅਤੇ ਉਹ ਤੁਹਾਡੇ ਖਾਤੇ ਵਿੱਚ ਆਉਂਦੇ ਹਨ। ਪੈਸੇ ਕਦੇ ਸਾਡੇ ਰਾਹੀਂ ਨਹੀਂ ਜਾਂਦੇ।';

  @override
  String get faqQ4 => 'ਕੀ ਵਿਕਰੀ \'ਤੇ ਰੱਖਣ ਤੋਂ ਬਾਅਦ ਕੁਝ ਬਦਲ ਸਕਦਾ ਹਾਂ?';

  @override
  String get faqA4 =>
      'ਹਾਂ। ਆਪਣੀਆਂ ਚੀਜ਼ਾਂ ਵਿੱਚੋਂ ਖੋਲ੍ਹੋ, ਜੋ ਚਾਹੋ ਬਦਲੋ, ਅਤੇ ਇਹ ਮੁੜ ਵਿਕਰੀ \'ਤੇ ਚਲੀ ਜਾਵੇਗੀ।';

  @override
  String get faqQ5 => 'ਜੇ ਮੈਂ ਕੁਝ ਗਲਤ ਬੋਲ ਦਿੱਤਾ?';

  @override
  String get faqA5 =>
      'ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਸੁਣ ਕੇ ਠੀਕ ਨਹੀਂ ਕਹਿੰਦੇ, ਕੁਝ ਵਿਕਰੀ \'ਤੇ ਨਹੀਂ ਜਾਂਦਾ। ਤੁਸੀਂ ਬੋਲ ਕੇ ਕੋਈ ਵੀ ਹਿੱਸਾ ਠੀਕ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get faqQ6 => 'ਕੀ ਮੈਨੂੰ ਪੜ੍ਹਨਾ-ਲਿਖਣਾ ਆਉਣਾ ਚਾਹੀਦਾ ਹੈ?';

  @override
  String get faqA6 =>
      'ਨਹੀਂ। ਤੁਸੀਂ ਸਭ ਕੁਝ ਬੋਲ ਕੇ ਅਤੇ ਦਬਾ ਕੇ ਕਰ ਸਕਦੇ ਹੋ। ਹਰ ਸਕਰੀਨ ਤੁਹਾਨੂੰ ਪੜ੍ਹ ਕੇ ਸੁਣਾਈ ਜਾ ਸਕਦੀ ਹੈ।';

  @override
  String get faqQ7 => 'ਮੇਰਾ ਨਾਮ ਅਤੇ ਪਿੰਡ ਕੌਣ ਦੇਖਦਾ ਹੈ?';

  @override
  String get faqA7 =>
      'ਸਿਰਫ਼ ਤੁਹਾਡੀ ਇਜਾਜ਼ਤ ਨਾਲ, ਅਤੇ ਹਰ ਚੀਜ਼ ਲਈ ਵੱਖਰੀ। ਤੁਸੀਂ ਇਸ ਨੂੰ ਕਦੇ ਵੀ ਵਾਪਸ ਲੈ ਸਕਦੇ ਹੋ।';

  @override
  String get aboutTitle => 'ਕੀਰਤੀਕਰ ਬਾਰੇ';

  @override
  String get aboutWhatTitle => 'ਇਹ ਕੀ ਹੈ';

  @override
  String get aboutWhat =>
      'ਕੀਰਤੀਕਰ ਹੱਥ ਨਾਲ ਬਣੀਆਂ ਚੀਜ਼ਾਂ ਨੂੰ ONDC \'ਤੇ, ਭਾਰਤ ਦੇ ਖੁੱਲ੍ਹੇ ਖਰੀਦ-ਵੇਚ ਜਾਲ \'ਤੇ, ਪਹੁੰਚਾਉਂਦਾ ਹੈ, ਅਤੇ ਇਸ ਲਈ ਬਣਾਉਣ ਵਾਲੇ ਨੂੰ ਲਿਖਣਾ ਨਹੀਂ ਪੈਂਦਾ, ਬੋਲਣਾ ਪੈਂਦਾ ਹੈ। ਤੁਹਾਡੀ ਆਪਣੀ ਭਾਸ਼ਾ ਵਿੱਚ ਕੁਝ ਫੋਟੋਆਂ ਅਤੇ ਇੱਕ ਆਵਾਜ਼ ਸੁਨੇਹੇ ਤੋਂ ਅਜਿਹੀ ਸੂਚੀ ਬਣਦੀ ਹੈ ਜੋ ਦੇਸ਼ ਭਰ ਦੇ ਖਰੀਦਦਾਰ ਲੱਭ ਸਕਦੇ ਹਨ।';

  @override
  String get aboutWhyTitle => 'ਅਸੀਂ ਇਹ ਕਿਉਂ ਬਣਾਇਆ';

  @override
  String get aboutWhy =>
      'ਭਾਰਤ ਵਿੱਚ ਲਗਭਗ ਸੱਤਰ ਲੱਖ ਕਾਰੀਗਰ ਅਜਿਹੀਆਂ ਚੀਜ਼ਾਂ ਬਣਾਉਂਦੇ ਹਨ ਜੋ ਲੋਕ ਖਰੀਦਣਾ ਚਾਹੁੰਦੇ ਹਨ, ਅਤੇ ਉਹਨਾਂ ਵਿੱਚੋਂ ਬਹੁਤੇ ਵਿਚੋਲੇ ਰਾਹੀਂ ਵੇਚਦੇ ਹਨ ਜੋ ਫ਼ਰਕ ਦੇ ਪੈਸੇ ਰੱਖ ਲੈਂਦਾ ਹੈ। ਰੁਕਾਵਟ ਕੰਮ ਵਿੱਚ ਨਹੀਂ। ਰੁਕਾਵਟ ਫਾਰਮ ਵਿੱਚ ਹੈ: ਔਨਲਾਈਨ ਸੂਚੀ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਟਾਈਪ ਕਰਨਾ, ਬਹੁਤ ਸਾਰੇ ਖਾਨੇ ਭਰਨਾ ਅਤੇ ਕੈਟਾਲਾਗ ਵਰਗੀ ਫੋਟੋ ਮੰਗਦੀ ਹੈ। ਇਹ ਐਪ ਉਹ ਫਾਰਮ ਹੀ ਹਟਾ ਦਿੰਦੀ ਹੈ।';

  @override
  String get aboutHowTitle => 'ਇਹ ਕਿਵੇਂ ਕੰਮ ਕਰਦਾ ਹੈ';

  @override
  String get aboutHow =>
      'ਤਿੰਨ ਫੋਟੋਆਂ ਖਿੱਚੋ ਅਤੇ ਦੱਸੋ ਇਹ ਕੀ ਹੈ। ਸਾਡਾ ਸਿਸਟਮ ਸੁਣਦਾ ਹੈ, ਸੂਚੀ ਲਿਖਦਾ ਹੈ, ਅਤੇ ਤੁਹਾਨੂੰ ਪੜ੍ਹ ਕੇ ਸੁਣਾਉਂਦਾ ਹੈ। ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਸੁਣ ਕੇ ਠੀਕ ਨਹੀਂ ਕਹਿੰਦੇ, ਕੁਝ ਬਾਹਰ ਨਹੀਂ ਜਾਂਦਾ।';

  @override
  String get aboutSihTitle => 'ਸਮਾਰਟ ਇੰਡੀਆ ਹੈਕਾਥਾਨ 2025';

  @override
  String get aboutSih =>
      'ਸਮੱਸਿਆ 090 ਲਈ ਬਣਾਇਆ: ਕਾਰੀਗਰਾਂ ਅਤੇ ਜੁਲਾਹਿਆਂ ਨੂੰ ONDC \'ਤੇ ਖਰੀਦਦਾਰਾਂ ਤੱਕ ਪਹੁੰਚਾਉਣਾ।';

  @override
  String get aboutMissionTitle => 'ਅਸੀਂ ਕੀ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹਾਂ';

  @override
  String get aboutMission =>
      'ਕਿਸੇ ਕੰਮ ਦੀ ਕੀਮਤ ਉਸ ਨੂੰ ਬਣਾਉਣ ਵਾਲੇ ਦੇ ਹੱਥ ਵਿੱਚ ਹੀ ਰਹੇ।';

  @override
  String get supportTitle => 'ਕਿਸੇ ਬੰਦੇ ਨਾਲ ਗੱਲ ਕਰੋ';

  @override
  String get supportBody =>
      'ਜੇ ਕੁਝ ਨਹੀਂ ਚੱਲ ਰਿਹਾ, ਜਾਂ ਸਮਝ ਨਹੀਂ ਆ ਰਿਹਾ ਕੀ ਕਰੀਏ, ਤਾਂ ਸਾਨੂੰ ਫ਼ੋਨ ਕਰੋ। ਇੱਕ ਬੰਦਾ ਤੁਹਾਡੀ ਭਾਸ਼ਾ ਵਿੱਚ ਜਵਾਬ ਦੇਵੇਗਾ।';

  @override
  String get supportCall => 'ਸਾਨੂੰ ਫ਼ੋਨ ਕਰੋ';

  @override
  String get supportWhatsApp => 'ਵਟਸਐਪ \'ਤੇ ਸੁਨੇਹਾ ਭੇਜੋ';

  @override
  String get supportHours => 'ਹਰ ਰੋਜ਼, ਸਵੇਰੇ ਨੌਂ ਤੋਂ ਸ਼ਾਮ ਸੱਤ ਵਜੇ ਤੱਕ।';

  @override
  String supportNumber(String number) {
    return 'ਸਾਡਾ ਨੰਬਰ $number ਹੈ';
  }

  @override
  String supportFailed(String number) {
    return 'ਤੁਹਾਡਾ ਫ਼ੋਨ ਇਸ ਨੂੰ ਖੋਲ੍ਹ ਨਹੀਂ ਸਕਿਆ। ਸਾਡਾ ਨੰਬਰ $number ਹੈ।';
  }

  @override
  String get termsTitle => 'ਸ਼ਰਤਾਂ ਅਤੇ ਨਿੱਜਤਾ';

  @override
  String get termsSummaryTitle => 'ਸੰਖੇਪ ਵਿੱਚ';

  @override
  String get termsSummary1 =>
      'ਤੁਸੀਂ ਜੋ ਬਣਾਉਂਦੇ ਹੋ ਉਹ ਤੁਹਾਡਾ ਹੈ। ਅਸੀਂ ਇਸ ਨੂੰ ਤੁਹਾਡੇ ਲਈ ਵਿਕਰੀ \'ਤੇ ਰੱਖਦੇ ਹਾਂ ਅਤੇ ਵਿਕਰੀ ਵਿੱਚੋਂ ਕੁਝ ਨਹੀਂ ਲੈਂਦੇ।';

  @override
  String get termsSummary2 =>
      'ਤੁਹਾਡੀਆਂ ਫੋਟੋਆਂ ਅਤੇ ਤੁਹਾਡੀ ਆਵਾਜ਼ ਸਿਰਫ਼ ਤੁਹਾਡੀ ਸੂਚੀ ਲਿਖਣ ਲਈ ਵਰਤੀ ਜਾਂਦੀ ਹੈ, ਹੋਰ ਕਿਸੇ ਚੀਜ਼ ਲਈ ਨਹੀਂ।';

  @override
  String get termsSummary3 =>
      'ਤੁਹਾਡਾ ਨਾਮ, ਪਿੰਡ ਅਤੇ ਕਹਾਣੀ ਸਿਰਫ਼ ਉਹਨਾਂ ਚੀਜ਼ਾਂ \'ਤੇ ਜਾਂਦੀ ਹੈ ਜਿਹਨਾਂ ਦੀ ਤੁਸੀਂ ਇਜਾਜ਼ਤ ਦਿੱਤੀ, ਅਤੇ ਤੁਸੀਂ ਇਸ ਨੂੰ ਵਾਪਸ ਲੈ ਸਕਦੇ ਹੋ।';

  @override
  String get termsSummary4 =>
      'ਪੈਸੇ ਖਰੀਦਦਾਰ ਤੋਂ ਸਿੱਧੇ ਤੁਹਾਡੇ ਕੋਲ ਜਾਂਦੇ ਹਨ। ਕਦੇ ਸਾਡੇ ਰਾਹੀਂ ਨਹੀਂ ਜਾਂਦੇ।';

  @override
  String get termsSummary5 => 'ਤੁਸੀਂ ਕਦੇ ਵੀ ਇਸ ਫ਼ੋਨ ਤੋਂ ਸਭ ਕੁਝ ਮਿਟਾ ਸਕਦੇ ਹੋ।';

  @override
  String get termsFullTitle => 'ਪੂਰੀ ਲਿਖਤ';

  @override
  String get termsFullBody =>
      'ਵਰਤੋਂ ਦੀਆਂ ਪੂਰੀਆਂ ਸ਼ਰਤਾਂ ਅਤੇ ਨਿੱਜਤਾ ਨੀਤੀ ਸਾਡੀ ਵੈੱਬਸਾਈਟ \'ਤੇ ਹੈ। ਜੇ ਇੱਥੇ ਕੁਝ ਸਮਝ ਨਾ ਆਵੇ ਤਾਂ ਸਾਨੂੰ ਫ਼ੋਨ ਕਰੋ, ਇੱਕ ਬੰਦਾ ਸਮਝਾਵੇਗਾ।';

  @override
  String get termsOpenFull => 'ਪੂਰੀ ਲਿਖਤ ਪੜ੍ਹੋ';

  @override
  String get termsAgreeTitle => 'ਸ਼ੁਰੂ ਕਰਨ ਤੋਂ ਪਹਿਲਾਂ';

  @override
  String get termsAgreeBody =>
      'ਤੁਸੀਂ ਇਹਨਾਂ ਗੱਲਾਂ ਨਾਲ ਸਹਿਮਤ ਹੋ ਰਹੇ ਹੋ। ਸੁਣਨ ਲਈ ਸਪੀਕਰ ਦਬਾਓ।';

  @override
  String get termsAgreeCheck => 'ਮੈਂ ਸ਼ਰਤਾਂ ਨਾਲ ਸਹਿਮਤ ਹਾਂ';

  @override
  String get termsAgreeContinue => 'ਅੱਗੇ ਵਧੋ';

  @override
  String get termsAgreeNeeded =>
      'ਪਹਿਲਾਂ “ਮੈਂ ਸ਼ਰਤਾਂ ਨਾਲ ਸਹਿਮਤ ਹਾਂ” ’ਤੇ ਨਿਸ਼ਾਨ ਲਾਓ।';

  @override
  String versionNumber(String version) {
    return 'ਵਰਜਨ $version';
  }

  @override
  String get versionCheck => 'ਨਵਾਂ ਵਰਜਨ ਦੇਖੋ';

  @override
  String get versionLicences => 'ਲਾਇਸੰਸ';

  @override
  String get versionLicencesWhy => 'ਉਹ ਮੁਫ਼ਤ ਸਾਫ਼ਟਵੇਅਰ ਜਿਸ \'ਤੇ ਇਹ ਐਪ ਬਣੀ ਹੈ।';

  @override
  String get noNetworkTitle => 'ਨੈੱਟਵਰਕ ਨਹੀਂ';

  @override
  String get noNetworkBody =>
      'ਤੁਸੀਂ ਕੰਮ ਜਾਰੀ ਰੱਖੋ। ਸਭ ਕੁਝ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਰਹਿੰਦਾ ਹੈ ਅਤੇ ਨੈੱਟਵਰਕ ਆਉਣ \'ਤੇ ਆਪਣੇ ਆਪ ਚਲਾ ਜਾਂਦਾ ਹੈ।';

  @override
  String get noNetworkNeeded =>
      'ਇਸ ਇੱਕ ਕੰਮ ਲਈ ਨੈੱਟਵਰਕ ਚਾਹੀਦਾ ਹੈ। ਸਿਗਨਲ ਆਉਣ \'ਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get serverErrorTitle => 'ਅਸੀਂ ਆਪਣੇ ਪਾਸੇ ਨਹੀਂ ਪਹੁੰਚ ਸਕੇ';

  @override
  String get serverErrorBody =>
      'ਤੁਹਾਡਾ ਕੀਤਾ ਕੁਝ ਵੀ ਗੁਆਚਿਆ ਨਹੀਂ। ਕਿਰਪਾ ਕਰਕੇ ਥੋੜ੍ਹੀ ਦੇਰ ਬਾਅਦ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get actionTryAgain => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get permissionRecoveryTitle => 'ਐਪ ਨੂੰ ਤੁਹਾਡੀ ਇਜਾਜ਼ਤ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get permissionRecoveryBody =>
      'ਫ਼ੋਨ ਐਪ ਨੂੰ ਇਹ ਵਰਤਣ ਨਹੀਂ ਦੇ ਰਿਹਾ। ਤੁਸੀਂ ਫ਼ੋਨ ਦੀਆਂ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਇਹਨਾਂ ਨੂੰ ਚਾਲੂ ਕਰਕੇ ਇੱਥੇ ਵਾਪਸ ਆ ਸਕਦੇ ਹੋ।';

  @override
  String get permissionCameraWhy =>
      'ਤੁਹਾਡੀ ਬਣਾਈ ਚੀਜ਼ ਦੀਆਂ ਫੋਟੋਆਂ ਖਿੱਚਣ ਲਈ। ਇਸ ਤੋਂ ਬਿਨਾਂ ਕੁਝ ਵੀ ਵਿਕਰੀ \'ਤੇ ਨਹੀਂ ਰੱਖਿਆ ਜਾ ਸਕਦਾ।';

  @override
  String get permissionMicWhy =>
      'ਤਾਂ ਜੋ ਤੁਸੀਂ ਲਿਖਣ ਦੀ ਥਾਂ ਬੋਲ ਸਕੋ। ਇਸ ਤੋਂ ਬਿਨਾਂ ਸਭ ਕੁਝ ਲਿਖਣਾ ਪਵੇਗਾ।';

  @override
  String get permissionNotifyTitle => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get permissionNotifyWhy =>
      'ਤਾਂ ਜੋ ਕੁਝ ਵਿਕਣ \'ਤੇ ਅਸੀਂ ਦੱਸ ਸਕੀਏ। ਇਸ ਤੋਂ ਬਿਨਾਂ ਤੁਹਾਨੂੰ ਐਪ ਖੋਲ੍ਹ ਕੇ ਦੇਖਣਾ ਪਵੇਗਾ।';

  @override
  String get permissionBlocked => 'ਇਜਾਜ਼ਤ ਨਹੀਂ';

  @override
  String get permissionAsk => 'ਦੁਬਾਰਾ ਪੁੱਛੋ';

  @override
  String get permissionRecheck => 'ਮੈਂ ਚਾਲੂ ਕਰ ਦਿੱਤਾ';

  @override
  String get permissionAllGood => 'ਐਪ ਨੂੰ ਜੋ ਚਾਹੀਦਾ ਹੈ ਸਭ ਦੀ ਇਜਾਜ਼ਤ ਹੈ।';

  @override
  String get updateTitle => 'ਕਿਰਪਾ ਕਰਕੇ ਐਪ ਅੱਪਡੇਟ ਕਰੋ';

  @override
  String get updateBody =>
      'ਇਹ ਵਰਜਨ ਹੁਣ ਸਾਡੇ ਨਾਲ ਗੱਲ ਨਹੀਂ ਕਰ ਸਕਦਾ। ਸਟੋਰ ਵਿੱਚ ਨਵਾਂ ਵਰਜਨ ਹੈ, ਅਤੇ ਅੱਪਡੇਟ ਤੋਂ ਬਾਅਦ ਵੀ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦਾ ਸਭ ਕੁਝ ਉਵੇਂ ਹੀ ਰਹੇਗਾ।';

  @override
  String get updateAction => 'ਨਵਾਂ ਵਰਜਨ ਲਓ';

  @override
  String get updateFailed => 'ਸਟੋਰ ਨਹੀਂ ਖੁੱਲ੍ਹਿਆ। ਉੱਥੇ ਕੀਰਤੀਕਰ ਲੱਭੋ।';

  @override
  String get emptyNudge => 'ਹੋਮ ਵਾਲਾ ਵੱਡਾ ਬਟਨ ਦਬਾ ਕੇ ਆਪਣੀ ਪਹਿਲੀ ਚੀਜ਼ ਜੋੜੋ।';

  @override
  String get productsInProgress => 'ਤਿਆਰ ਹੋ ਰਹੀਆਂ';

  @override
  String get productsListed => 'ਵਿਕਰੀ \'ਤੇ';

  @override
  String get productsSold => 'ਵਿਕ ਗਈਆਂ';

  @override
  String get voiceTypeInstead => 'ਲਿਖ ਕੇ ਦੱਸੋ';

  @override
  String get voiceSpeakInstead => 'ਬੋਲ ਕੇ ਦੱਸੋ';

  @override
  String get voiceTypeTitle => 'ਹੁਣ ਲਿਖੋ ਇਹ ਚੀਜ਼ ਕੀ ਹੈ';

  @override
  String get voiceTypeHint => 'ਇੱਥੇ ਲਿਖੋ…';

  @override
  String get voiceTypeSave => 'ਇਹੀ ਵੇਰਵਾ ਰੱਖੋ';

  @override
  String get errorNotAllowed =>
      'ਇਹ ਖਾਤਾ ਇਹ ਨਹੀਂ ਕਰ ਸਕਦਾ। ਮਦਦ ਲਈ ਸਾਨੂੰ ਫ਼ੋਨ ਕਰੋ।';

  @override
  String get errorNotFound => 'ਇਹ ਹੁਣ ਇੱਥੇ ਨਹੀਂ ਹੈ।';

  @override
  String get errorConflict =>
      'ਇਹ ਕਿਤੇ ਹੋਰ ਬਦਲਿਆ ਗਿਆ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਖੋਲ੍ਹ ਕੇ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get errorInvalid =>
      'ਕੁਝ ਜਾਣਕਾਰੀ ਮੰਨੀ ਨਹੀਂ ਗਈ। ਕਿਰਪਾ ਕਰਕੇ ਜਾਂਚ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get voiceGuideTitle => 'ਤੁਸੀਂ ਇਹਨਾਂ ਬਾਰੇ ਦੱਸ ਸਕਦੇ ਹੋ';

  @override
  String get voiceGuideWhat => 'ਚੀਜ਼ ਦਾ ਨਾਮ';

  @override
  String get voiceGuideSize => 'ਉਚਾਈ';

  @override
  String get voiceGuideColour => 'ਰੰਗ';

  @override
  String get voiceGuideTime => 'ਬਣਾਉਣ ਵਿੱਚ ਲੱਗਿਆ ਸਮਾਂ';
}
