import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'கீர்த்திகர்';

  @override
  String get actionNext => 'அடுத்து';

  @override
  String get actionBack => 'பின்செல்';

  @override
  String get actionSkip => 'தவிர்';

  @override
  String get actionDone => 'முடிந்தது';

  @override
  String get actionListen => 'கேளுங்கள்';

  @override
  String get actionStopListening => 'நிறுத்து';

  @override
  String stepOfSteps(int current, int total) {
    return 'படி $current, மொத்தம் $total';
  }

  @override
  String get splashTagline => 'பேசுங்கள், உங்கள் பொருள் விற்றுவிடும்';

  @override
  String get languageTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுங்கள்';

  @override
  String get languageHint => 'நீங்கள் பேசும் மொழியை அழுத்துங்கள்';

  @override
  String get welcomeCard1Title => 'மூன்று படங்கள் எடுங்கள்';

  @override
  String get welcomeCard1Body =>
      'நீங்கள் செய்த பொருளின் மூன்று படங்கள் எடுங்கள். எப்படி எடுப்பது என்று செயலி காட்டும்.';

  @override
  String get welcomeCard2Title => 'பேசிச் சொல்லுங்கள்';

  @override
  String get welcomeCard2Body =>
      'இது என்ன, எதனால் செய்தது, விலை என்ன, சொன்னால் போதும். எழுதத் தேவையில்லை.';

  @override
  String get welcomeCard3Title => 'இது விற்பனைக்குப் போகிறது';

  @override
  String get welcomeCard3Body =>
      'முதலில் உங்களுக்குப் படித்துக் காட்டுவோம். நீங்கள் ஆம் என்றால்தான் இணையத்தில் போகும்.';

  @override
  String get welcomeStart => 'தொடங்குங்கள்';

  @override
  String get permissionsTitle => 'செயலிக்கு மூன்று அனுமதிகள் தேவை';

  @override
  String get permissionCameraTitle => 'கேமரா';

  @override
  String get permissionCameraBody =>
      'உங்கள் பொருளைப் படம் எடுக்க. நீங்கள் ஆம் என்று சொல்லும் வரை படங்கள் உங்கள் போனிலேயே இருக்கும்.';

  @override
  String get permissionMicTitle => 'மைக்';

  @override
  String get permissionMicBody => 'எழுதுவதற்குப் பதில் பேசுவதற்கு.';

  @override
  String get permissionNotificationTitle => 'அறிவிப்புகள்';

  @override
  String get permissionNotificationBody =>
      'ஏதாவது விற்றவுடன் உங்களுக்குச் சொல்வதற்கு.';

  @override
  String get permissionAllow => 'அனுமதி கொடுங்கள்';

  @override
  String get permissionNotNow => 'இப்போது வேண்டாம்';

  @override
  String get permissionGranted => 'அனுமதி உள்ளது';

  @override
  String get permissionDeniedTitle => 'அனுமதி கிடைக்கவில்லை';

  @override
  String get permissionDeniedBody =>
      'இது இல்லாமல் இது வேலை செய்யாது. போன் செட்டிங்ஸில் சென்று அனுமதி கொடுங்கள்.';

  @override
  String get permissionOpenSettings => 'செட்டிங்ஸ் திற';

  @override
  String get phoneTitle => 'உங்கள் போன் எண்';

  @override
  String get phoneWhy =>
      'இந்த எண்ணுக்கு ஒரு குறியீடு அனுப்புவோம். இந்த எண் வேறு யாருக்கும் கொடுக்கப்படாது.';

  @override
  String get phoneInvalid => 'பத்து இலக்க எண்ணை உள்ளிடுங்கள்';

  @override
  String phoneUnknown(String number) {
    return 'இந்த டெமோவில் இந்த எண் வேலை செய்யாது. $number பயன்படுத்துங்கள்.';
  }

  @override
  String get phoneSendCode => 'குறியீடு அனுப்பு';

  @override
  String get otpTitle => 'வந்த குறியீட்டை உள்ளிடுங்கள்';

  @override
  String otpSentTo(String number) {
    return '$number க்கு அனுப்பப்பட்டது';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds வினாடிகளில் மீண்டும் அனுப்பு';
  }

  @override
  String get otpResend => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String get otpCallMe => 'எனக்கு போன் செய்து சொல்லுங்கள்';

  @override
  String get otpCalling =>
      'சிறிது நேரத்தில் அழைப்பு வரும், குறியீடு படித்துக் காட்டப்படும்.';

  @override
  String get otpWrong => 'குறியீடு சரியில்லை. மீண்டும் உள்ளிடுங்கள்.';

  @override
  String get phoneSendFailed =>
      'குறியீட்டை அனுப்ப முடியவில்லை. நெட்வொர்க்கைப் பார்த்து மீண்டும் முயலுங்கள்.';

  @override
  String get otpExpired =>
      'குறியீட்டின் நேரம் முடிந்தது. மீண்டும் அனுப்புங்கள்.';

  @override
  String get authTooManyTries =>
      'பல முறை முயன்றாகிவிட்டது. சிறிது நேரம் கழித்து மீண்டும் முயலுங்கள்.';

  @override
  String get otpChangeNumber => 'எண்ணை மாற்று';

  @override
  String get otpAutoRead => 'செய்தி தானாகப் படிக்கப்பட்டது';

  @override
  String get profileTitle => 'உங்களைப் பற்றிச் சொல்லுங்கள்';

  @override
  String get profileNameLabel => 'உங்கள் பெயர்';

  @override
  String get profileNameHint => 'சொல்லுங்கள் அல்லது எழுதுங்கள்';

  @override
  String get profileNameMissing => 'உங்கள் பெயரைச் சொல்லுங்கள்';

  @override
  String get profileCraftLabel => 'நீங்கள் என்ன செய்கிறீர்கள்';

  @override
  String get profileCraftMissing => 'ஒன்றைத் தேர்ந்தெடுங்கள்';

  @override
  String get profileSpeakToFill => 'சொல்லுங்கள்';

  @override
  String get profileListening => 'கேட்கிறோம்…';

  @override
  String get dictationUnavailable =>
      'இந்த போனில் பேசி எழுதுவது வேலை செய்யவில்லை. தயவுசெய்து எழுதுங்கள்.';

  @override
  String get dictationNothingHeard =>
      'எதுவும் கேட்கவில்லை. மைக்கை அழுத்தி மீண்டும் பேசுங்கள்.';

  @override
  String get craftWeaving => 'நெசவு';

  @override
  String get craftPottery => 'மண்பாண்டம்';

  @override
  String get craftWoodwork => 'மரவேலை';

  @override
  String get craftMetalwork => 'உலோக வேலை';

  @override
  String get craftJewellery => 'நகைகள்';

  @override
  String get craftEmbroidery => 'பூத்தையல்';

  @override
  String get craftPainting => 'ஓவியம்';

  @override
  String get craftLeather => 'தோல் வேலை';

  @override
  String get craftBamboo => 'மூங்கில் மற்றும் பிரம்பு';

  @override
  String get craftOther => 'வேறு ஏதாவது';

  @override
  String get ondcTitle => 'உங்கள் ONDC கணக்கை இணையுங்கள்';

  @override
  String get ondcExplain =>
      'ONDC-யில்தான் வாங்குபவர்கள் நீங்கள் செய்ததைப் பார்த்து வாங்குகிறார்கள். பணம் நேராக உங்களுக்கு வரும், எங்கள் வழியாக அல்ல.';

  @override
  String get ondcMalformed =>
      'இது விற்பனையாளர் ஐடி போல் தெரியவில்லை. சரிபார்க்கவும், அல்லது குறியீட்டை மீண்டும் ஸ்கேன் செய்யவும்.';

  @override
  String get ondcEmailLabel => 'ONDC மின்னஞ்சல்';

  @override
  String get ondcEmailMalformed =>
      'இது மின்னஞ்சல் முகவரி போலத் தெரியவில்லை. தயவுசெய்து அதைச் சரிபாருங்கள்.';

  @override
  String get ondcSellerIdLabel => 'விற்பனையாளர் ஐடி';

  @override
  String get ondcScan => 'QR குறியீட்டை ஸ்கேன் செய்யுங்கள்';

  @override
  String get ondcLink => 'கணக்கை இணை';

  @override
  String get ondcLinking => 'இணைக்கிறோம்…';

  @override
  String get ondcFailed => 'அந்தக் கணக்கு கிடைக்கவில்லை. சரிபாருங்கள்.';

  @override
  String get ondcNoAccount => 'எனக்கு இன்னும் கணக்கு இல்லை';

  @override
  String get ondcNoAccountExplain =>
      'பரவாயில்லை. பொருட்களைத் தயார் செய்து வைக்கலாம். கணக்கு இணைந்தவுடன் எல்லாம் ஒன்றாகப் போகும்.';

  @override
  String get practiceTitle => 'நல்ல படம் எடுப்பது எப்படி';

  @override
  String get practiceIntro =>
      'ஒரே பானை, ஒருமுறை நன்றாகவும் ஒருமுறை மோசமாகவும் எடுத்தது. இரண்டையும் பார்க்க நகர்த்து.';

  @override
  String get practiceGoodBadge => 'இப்படிச் செய்';

  @override
  String get practiceGoodTitle => 'நல்ல படம்';

  @override
  String get practiceGoodTip1 => 'தெளிவு: கைபேசி அசையாமல் பிடிக்கப்பட்டது';

  @override
  String get practiceGoodTip2 =>
      'வெளிச்சம்: ஜன்னல் அல்லது வாசல் அருகே எடுத்தது';

  @override
  String get practiceGoodTip3 => 'பொருள் முழுவதும் படத்தில் உள்ளது';

  @override
  String get practiceBadBadge => 'இப்படிச் செய்யாதே';

  @override
  String get practiceBadTitle => 'மோசமான படம்';

  @override
  String get practiceBadTip1 => 'மங்கல்: கைபேசி அசைந்தது';

  @override
  String get practiceBadTip2 => 'வாங்குபவர்களுக்கு நுணுக்கங்கள் தெரியாது';

  @override
  String get practiceBadTip3 => 'மீண்டும் படம் எடுக்க ஆப் சொல்லும்';

  @override
  String get practiceFinish => 'செயலியைத் திற';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navListings => 'பொருட்கள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String homeGreeting(String name) {
    return 'வணக்கம், $name';
  }

  @override
  String get homeAddProduct => 'பொருள் சேர்';

  @override
  String get homeAddProductSpoken =>
      'பொருள் சேர்க்க இந்தப் பெரிய பொத்தானை அழுத்துங்கள். மூன்று படங்கள் எடுங்கள், இது என்ன என்று சொல்லுங்கள், அது விற்பனைக்குப் போகும்.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள் அனுப்பக் காத்திருக்கின்றன',
      one: '1 பொருள் அனுப்பக் காத்திருக்கிறது',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count விற்றன',
      one: '1 விற்றது',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'உங்கள் சமீபத்திய பொருட்கள்';

  @override
  String get homeNextTitle => 'அடுத்து செய்ய வேண்டியது';

  @override
  String get homeEmptyTitle => 'இங்கே இன்னும் எதுவும் இல்லை';

  @override
  String get homeEmptyBody =>
      'மேலே உள்ள பெரிய பொத்தானை அழுத்தி உங்கள் முதல் பொருளைச் சேருங்கள்.';

  @override
  String get offlineNoNetwork => 'இப்போது நெட்வொர்க் இல்லை';

  @override
  String get offlineNothingLost =>
      'எதுவும் இழக்கப்படவில்லை. நெட்வொர்க் வந்தவுடன் தானாகப் போகும்.';

  @override
  String get statusQueued => 'அனுப்பக் காத்திருக்கிறது';

  @override
  String get statusProcessing => 'தயாராகிறது';

  @override
  String get statusNeedsAttention => 'உங்கள் பதில் தேவை';

  @override
  String get statusReady => 'விற்பனைக்குத் தயார்';

  @override
  String get statusPublished => 'விற்பனையில் உள்ளது';

  @override
  String get statusFailed => 'அனுப்ப முடியவில்லை';

  @override
  String get listingUntitled => 'பொருள்';

  @override
  String get listingNoPrice => 'விலை சொல்லவில்லை';

  @override
  String get captureTitle => 'பொருள் சேர்';

  @override
  String capturePhotoStep(int current, int total) {
    return 'படம் $current / $total';
  }

  @override
  String get capturePhotoWhole => 'முழுப் பொருளையும் காட்டுங்கள்';

  @override
  String get capturePhotoDetail => 'அருகிலிருந்து ஒன்று எடுங்கள்';

  @override
  String get capturePhotoScale => 'அளவு தெரிய அருகில் கை வையுங்கள்';

  @override
  String get captureTakePhoto => 'படம் எடு';

  @override
  String get captureFromGallery => 'கேலரியிலிருந்து தேர்ந்தெடு';

  @override
  String get captureTorchOn => 'விளக்கு ஆன்';

  @override
  String get captureTorchOff => 'விளக்கு ஆஃப்';

  @override
  String get captureCameraFailed => 'கேமரா திறக்கவில்லை';

  @override
  String get captureCameraRetry => 'மீண்டும் முயலுங்கள்';

  @override
  String get captureCameraPermission =>
      'உங்கள் பொருளைப் படம் எடுக்க செயலிக்கு கேமரா தேவை.';

  @override
  String get captureOpenSettings => 'செட்டிங்ஸ் திற';

  @override
  String get captureLeaveTitle => 'சேமிக்காமல் வெளியேறவா?';

  @override
  String get captureLeaveBody => 'படங்களும் நீங்கள் சொன்னதும் அழிக்கப்படும்.';

  @override
  String get captureLeaveConfirm => 'அழித்துவிடு';

  @override
  String get captureLeaveCancel => 'இங்கேயே இரு';

  @override
  String get shotReviewChecking => 'படத்தைச் சரிபார்க்கிறோம்…';

  @override
  String get shotReviewRetake => 'மீண்டும் எடு';

  @override
  String get qualityTooDark =>
      'இந்தப் படம் மிகவும் இருட்டாக உள்ளது. கதவருகே நின்று எடுங்கள்.';

  @override
  String get qualityTooBright =>
      'இதில் வெளிச்சம் அதிகம். வெயிலுக்கு முதுகைக் காட்டி எடுங்கள்.';

  @override
  String get qualityBlurry =>
      'இந்தப் படம் தெளிவாக இல்லை. போனை அசையாமல் பிடித்து மீண்டும் எடுங்கள்.';

  @override
  String get qualityUnreadable =>
      'இந்தப் படம் சரியாகச் சேமிக்கப்படவில்லை. மீண்டும் எடுங்கள்.';

  @override
  String get qualityNoSubject =>
      'இந்தப் படத்தில் பொருள் தெரியவில்லை. அதைக் கோட்டுக்குள் வைத்து அருகில் வாருங்கள்.';

  @override
  String get qualityOutOfFrame =>
      'இந்தப் படத்தில் பொருளின் ஒரு பகுதி மட்டுமே உள்ளது. முழுப் பொருளையும் கோட்டுக்குள் வையுங்கள்.';

  @override
  String get qualityWarningTitle => 'இதை மீண்டும் எடுங்கள்';

  @override
  String get qualityKeepAnyway => 'பரவாயில்லை, வை';

  @override
  String get photoSetTitle => 'உங்கள் மூன்று படங்கள்';

  @override
  String get photoSetBody =>
      'வாங்குபவர்கள் முதலில் பார்ப்பது முதல் படம்தான். ஒரு படத்தை மீண்டும் எடுக்க அதை அழுத்துங்கள்.';

  @override
  String get photoSetMain => 'முதல் படம்';

  @override
  String get photoSetRetakeThis => 'இதை மீண்டும் எடு';

  @override
  String get photoSetConfirm => 'இந்தப் படங்கள் சரி';

  @override
  String get photoEditOpen => 'படத்தை வெட்டு அல்லது திருப்பு';

  @override
  String get photoEditTitle => 'படத்தை வெட்டு';

  @override
  String get photoEditBody =>
      'வெட்ட, பெட்டியின் மூலையையோ ஓரத்தையோ இழு. நகர்த்த, பெட்டியின் உள்ளே இருந்து இழு.';

  @override
  String get photoEditTurn => 'திருப்பு';

  @override
  String get photoEditStraighten => 'நேராக்கு';

  @override
  String get photoEditReset => 'மீண்டும் தொடங்கு';

  @override
  String get photoEditDone => 'இந்தப் படத்தைப் பயன்படுத்து';

  @override
  String get photoEditCancel => 'பின்செல்';

  @override
  String get photoEditFailed =>
      'இந்த மாற்றத்தைச் சேமிக்க முடியவில்லை. மீண்டும் முயற்சி செய்.';

  @override
  String get photoIssueTooDark => 'மிக இருட்டு, தெளிவாகத் தெரியவில்லை';

  @override
  String get photoIssueTooBright => 'இதில் வெளிச்சம் அதிகம்';

  @override
  String get photoIssueBlurry => 'மங்கலாக உள்ளது, போதுமான தெளிவில்லை';

  @override
  String get photoIssueNoSubject =>
      'இந்தப் படத்தில் பொருள் எதுவும் தெரியவில்லை';

  @override
  String get photoIssueUnreadable => 'இந்தப் படம் சேமிக்கப்படவில்லை';

  @override
  String get photoIssueOutOfFrame => 'பொருள் முழுவதும் படத்தில் இல்லை';

  @override
  String get voiceTitle => 'இப்போது இது என்ன என்று சொல்லுங்கள்';

  @override
  String get voiceBody =>
      'இது என்ன, எதனால் செய்தது, எவ்வளவு பெரியது, செய்ய எவ்வளவு நேரம் ஆனது, விலை என்ன.';

  @override
  String get voiceHoldToSpeak => 'அழுத்திப் பிடித்துப் பேசுங்கள்';

  @override
  String get voiceRecording => 'பேசுங்கள்… முடிந்ததும் விடுங்கள்';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total இல் $seconds வினாடிகள்';
  }

  @override
  String get voiceTooShort =>
      'அது மிகக் குறுகியதாக இருந்தது. பொத்தானை அழுத்திப் பிடித்து மீண்டும் பேசுங்கள்.';

  @override
  String get voiceFailed =>
      'மைக் தொடங்கவில்லை. செயலிக்கு மைக் அனுமதி உள்ளதா என்று பாருங்கள்.';

  @override
  String get voiceBackToPhotos => 'படங்களுக்குத் திரும்பு';

  @override
  String get playbackPlay => 'கேளுங்கள்';

  @override
  String get playbackStop => 'நிறுத்து';

  @override
  String get playbackAgain => 'மீண்டும் சொல்லுங்கள்';

  @override
  String get playbackAccept => 'இது சரி';

  @override
  String get playbackUnavailable =>
      'இந்த போனால் அதை ஒலிக்க முடியவில்லை. இருந்தாலும் அனுப்பலாம், அல்லது மீண்டும் சொல்லலாம்.';

  @override
  String get savedTitle => 'சேமிக்கப்பட்டது';

  @override
  String get savedBody => 'நெட்வொர்க் இருக்கும்போது தானாகப் போகும்.';

  @override
  String get savedBodyOnline =>
      'இப்போது அனுப்பப்படுகிறது. நீங்கள் இங்கே காத்திருக்கத் தேவையில்லை.';

  @override
  String get savedAddAnother => 'இன்னொரு பொருள் சேர்';

  @override
  String get savedGoHome => 'முகப்புக்குச் செல்';

  @override
  String get saveFailed =>
      'இந்த போனில் சேமிக்க முடியவில்லை. இடம் இல்லாமல் இருக்கலாம்.';

  @override
  String get saveRetry => 'மீண்டும் சேமிக்க முயலுங்கள்';

  @override
  String get queueTitle => 'அனுப்பக் காத்திருப்பவை';

  @override
  String get queueBody =>
      'இங்கே எதுவும் இழக்கப்படவில்லை. நெட்வொர்க் வந்தவுடன் ஒவ்வொன்றும் போகும்.';

  @override
  String get queueEmptyTitle => 'எதுவும் காத்திருக்கவில்லை';

  @override
  String get queueEmptyBody => 'நீங்கள் செய்த எல்லாம் அனுப்பப்பட்டுவிட்டது.';

  @override
  String get queueStateWaiting => 'நெட்வொர்க்கிற்காகக் காத்திருக்கிறது';

  @override
  String queueStateUploading(int percent) {
    return 'அனுப்புகிறோம்… நூற்றில் $percent';
  }

  @override
  String get queueStateProcessing => 'இப்போது எங்களிடம் உள்ளது. எழுதுகிறோம்.';

  @override
  String get queueStateFailed => 'போகவில்லை. காரணம் பார்க்க அழுத்துங்கள்.';

  @override
  String get queueItemTitle => 'இந்தப் பொருள்';

  @override
  String queueMadeAt(String date) {
    return '$date அன்று செய்தது';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count முறை முயன்றது',
      one: 'ஒருமுறை முயன்றது',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'இப்போது அனுப்ப முயலுங்கள்';

  @override
  String get queueRetryWaiting => 'இன்னும் நெட்வொர்க் இல்லை. தானாகப் போகும்.';

  @override
  String get queueDelete => 'இந்தப் பொருளை அழி';

  @override
  String get queueDeleteTitle => 'இந்தப் பொருளை அழிக்கவா?';

  @override
  String get queueDeleteBody =>
      'படங்களும் நீங்கள் சொன்னதும் போய்விடும். இதைத் திரும்பப் பெற முடியாது.';

  @override
  String get queueDeleteConfirm => 'ஆம், அழி';

  @override
  String get queueDeleteCancel => 'வேண்டாம், வை';

  @override
  String get failureNetwork =>
      'நெட்வொர்க் பாதியில் நின்றது. சிக்னல் வந்தவுடன் தானாக மீண்டும் போகும்.';

  @override
  String get failureServer =>
      'எங்கள் பக்கத்திலிருந்து பதில் வரவில்லை. மீண்டும் முயல்வோம்.';

  @override
  String get failureMissingFiles =>
      'படங்கள் இப்போது இந்த போனில் இல்லை, அதனால் இதை அனுப்ப முடியாது. மீண்டும் செய்யுங்கள்.';

  @override
  String get failureRejected =>
      'இது ஏற்றுக்கொள்ளப்படவில்லை. மீண்டும் செய்யுங்கள்.';

  @override
  String get failureUnknown => 'ஏதோ தவறு நடந்தது. மீண்டும் முயலலாம்.';

  @override
  String get processingTitle => 'நாங்கள் எழுதுகிறோம்';

  @override
  String get processingBody =>
      'உங்கள் படங்களும் வார்த்தைகளும் எங்களிடம் உள்ளன. இதற்குச் சில நிமிடங்கள் ஆகும்.';

  @override
  String get processingLeave =>
      'நீங்கள் இங்கே காத்திருக்கத் தேவையில்லை. தயாரானதும் சொல்வோம்.';

  @override
  String get processingGoHome => 'முகப்புக்குச் செல்';

  @override
  String get attentionTitle => 'ஒரு கேள்வி';

  @override
  String get attentionBody => 'மற்ற எல்லாம் புரிந்தது. இது மட்டும் இல்லை.';

  @override
  String get attentionHoldToAnswer => 'அழுத்திப் பிடித்துப் பதில் சொல்லுங்கள்';

  @override
  String get attentionAnswering => 'உங்கள் பதிலை அனுப்புகிறோம்…';

  @override
  String get attentionFailed => 'உங்கள் பதில் போகவில்லை. மீண்டும் சொல்லுங்கள்.';

  @override
  String get readBackTitle => 'நாங்கள் புரிந்துகொண்டது இது';

  @override
  String get readBackListen => 'முழுவதும் கேளுங்கள்';

  @override
  String get readBackFields => 'நாங்கள் எழுதியவை';

  @override
  String get readBackCorrect => 'தவறானதை அழுத்துங்கள்';

  @override
  String get readBackApprove => 'இவை எல்லாம் சரி';

  @override
  String get notSaid => 'சொல்லவில்லை';

  @override
  String get fieldMaterial => 'எதனால் செய்தது';

  @override
  String get fieldSize => 'அளவு';

  @override
  String get fieldColour => 'நிறம்';

  @override
  String get fieldQuantity => 'எத்தனை';

  @override
  String get fieldPrice => 'விலை';

  @override
  String correctTitle(String field) {
    return 'சரியான $field சொல்லுங்கள்';
  }

  @override
  String get correctHoldToSpeak => 'அழுத்திப் பிடித்துச் சொல்லுங்கள்';

  @override
  String get correctListening => 'கேட்கிறோம்…';

  @override
  String get correctFailedOnce =>
      'எங்களுக்குப் புரியவில்லை. இன்னொருமுறை சொல்லுங்கள்.';

  @override
  String get correctUseKeypad => 'பதிலாக எழுதுங்கள்';

  @override
  String get correctUseVoice => 'பதிலாகப் பேசுங்கள்';

  @override
  String get correctPick => 'அல்லது ஒன்றைத் தேர்ந்தெடுங்கள்';

  @override
  String get correctSave => 'இதைச் சேமி';

  @override
  String get correctCancel => 'அப்படியே இருக்கட்டும்';

  @override
  String get correctTypeHint => 'பதிலை இங்கே எழுதுங்கள்';

  @override
  String correctHeard(Object text) {
    return 'நாங்கள் கேட்டது “$text”';
  }

  @override
  String get listingCancelAction => 'இந்தப் பட்டியலை ரத்து செய்';

  @override
  String get listingCancelTitle => 'இந்தப் பட்டியலை ரத்து செய்யவா?';

  @override
  String get listingCancelBody =>
      'புகைப்படங்கள், பதிவு மற்றும் நீங்கள் சொன்ன அனைத்தும் அழிந்துவிடும். இது திரும்பக் கிடைக்காது.';

  @override
  String get listingCancelConfirm => 'ஆம், ரத்து செய்';

  @override
  String get listingCancelKeep => 'வேண்டாம், இருக்கட்டும்';

  @override
  String get photoSaveAction => 'படங்களைச் சேமி';

  @override
  String get photoSaved => 'உங்கள் படங்களில் சேமிக்கப்பட்டது';

  @override
  String get photoSaveFailed => 'படத்தைச் சேமிக்க முடியவில்லை';

  @override
  String get photoSaveDenied => 'படத்தைச் சேமிக்க அனுமதி கொடுங்கள்';

  @override
  String get colourRed => 'சிவப்பு';

  @override
  String get colourBlue => 'நீலம்';

  @override
  String get colourGreen => 'பச்சை';

  @override
  String get colourYellow => 'மஞ்சள்';

  @override
  String get colourBlack => 'கருப்பு';

  @override
  String get colourWhite => 'வெள்ளை';

  @override
  String get colourBrown => 'பழுப்பு';

  @override
  String get colourMulti => 'பல நிறங்கள்';

  @override
  String get sizeSmall => 'சிறியது';

  @override
  String get sizeMedium => 'நடுத்தரம்';

  @override
  String get sizeLarge => 'பெரியது';

  @override
  String get sizeExtraLarge => 'மிகப் பெரியது';

  @override
  String get suggestTitle => 'இதையும் சேர்க்கலாமா?';

  @override
  String get suggestYes => 'ஆம், சேர்';

  @override
  String get suggestNo => 'வேண்டாம், விடு';

  @override
  String get suggestSkip => 'எனக்குத் தெரியவில்லை';

  @override
  String suggestProgress(int current, int total) {
    return '$total இல் $current';
  }

  @override
  String get suggestDone => 'இனி சேர்க்க எதுவும் இல்லை';

  @override
  String get priceTitle => 'விலை என்ன?';

  @override
  String get priceBody => 'இது ஒரு பொருளுக்கான விலை.';

  @override
  String priceBand(String low, String high) {
    return 'இதுபோன்ற பொருட்களை மற்றவர்கள் $low முதல் $high வரை விற்கிறார்கள்';
  }

  @override
  String get priceBelowFloor =>
      'இது உங்கள் செலவைவிடக் குறைவு. இருந்தாலும் இதையே தேர்ந்தெடுக்கலாம்.';

  @override
  String get priceSayIt => 'விலையைச் சொல்லுங்கள்';

  @override
  String get priceConfirm => 'இந்த விலை சரி';

  @override
  String get stockTitle => 'உங்களிடம் எத்தனை உள்ளன?';

  @override
  String get stockBody => 'எல்லாம் விற்றதும் உங்களுக்காக இதை நீக்கிவிடுவோம்.';

  @override
  String get stockOneOfAKind => 'ஒன்றுதான் உள்ளது, இனி இதுபோல் வேறொன்று வராது';

  @override
  String get stockMore => 'இன்னும் ஒன்று';

  @override
  String get stockLess => 'ஒன்று குறைவு';

  @override
  String get stockConfirm => 'இது சரி';

  @override
  String get photosTitle => 'எந்தப் படம் முதலில் வரும்?';

  @override
  String get photosBody =>
      'வாங்குபவர்கள் முதல் படத்தைத்தான் எல்லாவற்றுக்கும் முன் பார்க்கிறார்கள்.';

  @override
  String get photosMakeFirst => 'இதை முதல் படமாக்கு';

  @override
  String get photosFirst => 'முதல் படம்';

  @override
  String get photosConfirm => 'இந்தப் படங்கள் சரி';

  @override
  String get previewTitle => 'வாங்குபவர்கள் இதைப் பார்ப்பார்கள்';

  @override
  String get previewListenAll => 'எல்லாம் கேளுங்கள்';

  @override
  String get previewNoDescription => 'விவரம் எதுவும் எழுதப்படவில்லை.';

  @override
  String get previewConfirm => 'ஆம், இது சரி';

  @override
  String get previewChange => 'ஏதாவது மாற்று';

  @override
  String get consentTitle => 'இதை விற்பனைக்கு வைக்கலாமா?';

  @override
  String get consentPhoto => 'என் படங்களைக் காட்டு';

  @override
  String get consentPhotoExplain =>
      'உங்கள் பொருளின் படங்கள் வாங்குபவரின் திரையில் போகும்.';

  @override
  String get consentStory => 'என் கைவினைக் கதையைக் காட்டு';

  @override
  String get consentStoryExplain =>
      'உங்கள் பெயர், ஊர், நீங்கள் எப்படிச் செய்கிறீர்கள் என்பது கைவினைஞர் அட்டையில் போகும். வேண்டாம் என்றாலும் விற்கலாம்.';

  @override
  String get consentNeeded => 'படங்கள் இல்லாமல் இதை வைக்க முடியாது.';

  @override
  String get consentPublish => 'விற்பனைக்கு வை';

  @override
  String get publishingTitle => 'விற்பனைக்கு வைக்கிறோம்';

  @override
  String get publishingBody =>
      'இதற்குச் சிறிது நேரம் ஆகும். செயலியை மூட வேண்டாம்.';

  @override
  String get publishedTitle => 'இது விற்பனையில் உள்ளது';

  @override
  String get publishedBody => 'வாங்குபவர்கள் இப்போது இதைப் பார்க்கலாம்.';

  @override
  String get publishedShare => 'வாட்ஸ்அப்பில் அனுப்பு';

  @override
  String get publishedCopyLink => 'இணைப்பை நகலெடு';

  @override
  String get publishedLinkCopied => 'இணைப்பு நகலெடுக்கப்பட்டது';

  @override
  String get publishedShowQr => 'ஸ்கேன் செய்யும் குறியீட்டைக் காட்டு';

  @override
  String get publishedQrExplain =>
      'யார் வேண்டுமானாலும் இதை நோக்கி போனைக் காட்டி உங்கள் பொருளைத் திறக்கலாம்.';

  @override
  String get publishedAnother => 'இதுபோல் இன்னொன்று செய்';

  @override
  String get publishedDone => 'முகப்புக்குச் செல்';

  @override
  String get publishFailed =>
      'இதை வைக்க முடியவில்லை. எதுவும் இழக்கப்படவில்லை, மீண்டும் முயலலாம்.';

  @override
  String get publishRetry => 'மீண்டும் முயலுங்கள்';

  @override
  String get reviewLeaveTitle => 'இப்போதைக்கு விடவா?';

  @override
  String get reviewLeaveBody =>
      'நீங்கள் ஒப்புக்கொண்டவை இருக்கும். உங்கள் பொருட்களிலிருந்து திரும்ப வரலாம்.';

  @override
  String get reviewLeaveConfirm => 'இப்போதைக்கு விடு';

  @override
  String get editLeaveTitle => 'உங்கள் மாற்றங்கள் இன்னும் விற்பனையில் இல்லை';

  @override
  String get editLeaveBody =>
      'நீங்கள் மாற்றியது சேமிக்கப்பட்டது, ஆனால் வாங்குபவர்கள் இன்னும் பழையதையே பார்க்கிறார்கள். கடைசிப் பொத்தானை அழுத்தினால்தான் மீண்டும் விற்பனைக்குப் போகும்.';

  @override
  String get editLeaveConfirm => 'சரி, பிறகு செய்கிறேன்';

  @override
  String get reviewLeaveCancel => 'தொடருங்கள்';

  @override
  String get statusSoldOut => 'எல்லாம் விற்றது';

  @override
  String get statusUnpublished => 'நீக்கப்பட்டது';

  @override
  String get listingsTitle => 'உங்கள் பொருட்கள்';

  @override
  String get listingsEmptyTitle => 'நீங்கள் இன்னும் எதுவும் செய்யவில்லை';

  @override
  String get listingsEmptyBody =>
      'முகப்பில் உள்ள பெரிய பொத்தானை அழுத்தி உங்கள் முதல் பொருளைச் சேருங்கள்.';

  @override
  String get listingsEmptyFilter => 'இங்கே எதுவும் இல்லை.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மீதம்',
      one: '1 மீதம்',
      zero: 'எதுவும் மீதமில்லை',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count முறை பார்க்கப்பட்டது',
      one: 'ஒருமுறை பார்க்கப்பட்டது',
      zero: 'இன்னும் யாரும் பார்க்கவில்லை',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'எண்ணிக்கையை மாற்று';

  @override
  String get listingTitle => 'இந்தப் பொருள்';

  @override
  String get listingOpenPreview => 'வாங்குபவர்கள் பார்ப்பதைப் பாருங்கள்';

  @override
  String get listingEdit => 'ஏதாவது மாற்று';

  @override
  String get listingDuplicate => 'இதுபோல் இன்னொன்று செய்';

  @override
  String get listingUnpublish => 'விற்பனையிலிருந்து எடு';

  @override
  String get listingRelist => 'மீண்டும் விற்பனைக்கு வை';

  @override
  String get listingFinish => 'இதை முடி';

  @override
  String get listingSoldOutTitle => 'இவை எல்லாம் விற்றுவிட்டன';

  @override
  String get listingSoldOutBody =>
      'உங்களுக்காக இதை விற்பனையிலிருந்து எடுத்துவிட்டோம். மேலும் செய்ததும் மீண்டும் வையுங்கள்.';

  @override
  String get editTitle => 'இந்தப் பொருளை மாற்று';

  @override
  String get editBody =>
      'நீங்கள் இதை மீண்டும் சரிபார்ப்பீர்கள், பிறகு மீண்டும் விற்பனைக்குப் போகும்.';

  @override
  String get editRepublishing => 'மாற்றங்களை விற்பனைக்கு வைக்கிறோம்…';

  @override
  String get editRepublished => 'உங்கள் மாற்றங்கள் இப்போது விற்பனையில்';

  @override
  String get editRepublishConfirm => 'மாற்றத்தை மீண்டும் விற்பனைக்கு வை';

  @override
  String get quickStockTitle => 'எத்தனை மீதம் உள்ளன?';

  @override
  String get quickStockMarkSoldOut => 'எல்லாம் விற்றுவிட்டன';

  @override
  String get quickStockSave => 'சேமி';

  @override
  String get quickStockSaved => 'சேமிக்கப்பட்டது';

  @override
  String get actionUndo => 'முன்பு போல் ஆக்கு';

  @override
  String get unpublishTitle => 'விற்பனையிலிருந்து எடுக்கவா?';

  @override
  String get unpublishBody =>
      'வாங்குபவர்கள் இனி இதைப் பார்க்க மாட்டார்கள். எதுவும் அழிக்கப்படாது, எப்போது வேண்டுமானாலும் மீண்டும் வைக்கலாம்.';

  @override
  String get unpublishConfirm => 'ஆம், எடு';

  @override
  String get unpublishCancel => 'வேண்டாம், விற்பனையில் இருக்கட்டும்';

  @override
  String get unpublishDone => 'விற்பனையிலிருந்து எடுக்கப்பட்டது';

  @override
  String get relistDone => 'மீண்டும் விற்பனையில் உள்ளது';

  @override
  String get duplicateTitle => 'இதுபோல் இன்னொன்று செய்யவா?';

  @override
  String get duplicateBody =>
      'இதைப் பற்றி நீங்கள் சொன்னதை வைத்துக்கொள்வோம். புதிய படங்கள் மட்டும் எடுத்தால் போதும்.';

  @override
  String get duplicateConfirm => 'படங்கள் எடு';

  @override
  String get duplicateCancel => 'இப்போது வேண்டாம்';

  @override
  String get duplicateBanner =>
      'கடந்ததுபோல் இன்னொன்று செய்கிறோம். படங்கள் மட்டுமே புதியவை.';

  @override
  String get listingActionFailed => 'அது நடக்கவில்லை. மீண்டும் முயலுங்கள்.';

  @override
  String get salesNew => 'புதியது';

  @override
  String get salesEmptyTitle => 'இன்னும் எதுவும் விற்கவில்லை';

  @override
  String get salesEmptyBody =>
      'யாராவது ஏதாவது வாங்கினால் இங்கே தெரியும், நாங்கள் உங்களுக்குச் சொல்வோம்.';

  @override
  String get salesLoading => 'என்ன விற்றது என்று பார்க்கிறோம்…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள்',
      one: '1 பொருள்',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date க்குள் பேக் செய்யுங்கள்';
  }

  @override
  String get salesPackByToday => 'இன்றே பேக் செய்யுங்கள்';

  @override
  String get salesPackByTomorrow => 'நாளைக்குள் பேக் செய்யுங்கள்';

  @override
  String get salesPackedAlready => 'இதன் தேதி கடந்துவிட்டது';

  @override
  String get saleTitle => 'இந்த ஆர்டர்';

  @override
  String get saleReadOnly =>
      'இது உங்களுக்குத் தெரிவிக்க மட்டுமே. ஆர்டரின் எல்லா வேலையும் சந்தையில் நடக்கிறது, இந்தச் செயலியில் அல்ல.';

  @override
  String salePaid(String amount) {
    return 'உங்களுக்கு $amount கிடைக்கும்';
  }

  @override
  String salePlaced(String date) {
    return '$date அன்று விற்றது';
  }

  @override
  String saleGoingTo(String area) {
    return '$area க்குப் போகிறது';
  }

  @override
  String get saleWhatToPack => 'என்ன பேக் செய்வது';

  @override
  String get salePackingHelp => 'எப்படி பேக் செய்வது';

  @override
  String get saleSeeListing => 'இந்தப் பொருளைப் பாருங்கள்';

  @override
  String get packingTitle => 'எப்படி பேக் செய்வது';

  @override
  String get packingBody => 'ஒவ்வொன்றாகச் செய்யுங்கள். முடிந்ததை அழுத்துங்கள்.';

  @override
  String get packingStep1 =>
      'எதுவும் உரசாமல் இருக்கத் துணியில் அல்லது காகிதத்தில் சுற்றுங்கள்';

  @override
  String get packingStep2 =>
      'பெட்டிக்குள் அசையாமல் இருக்கச் சுற்றிலும் காகிதம் அல்லது வைக்கோல் நிரப்புங்கள்';

  @override
  String get packingStep3 => 'உள்ளே சரியான எண்ணிக்கை உள்ளதா என்று பாருங்கள்';

  @override
  String get packingStep4 => 'பெட்டியை மூடிச் சுற்றிலும் டேப் ஒட்டுங்கள்';

  @override
  String get packingStep5 => 'எடுக்க வருபவருக்காகத் தயாராக வையுங்கள்';

  @override
  String get packingDone => 'எல்லாம் முடிந்தது';

  @override
  String packingProgress(int done, int total) {
    return '$total இல் $done முடிந்தது';
  }

  @override
  String get earningsTitle => 'நீங்கள் எவ்வளவு சம்பாதித்தீர்கள்';

  @override
  String get earningsWeek => 'இந்த வாரம்';

  @override
  String get earningsMonth => 'இந்த மாதம்';

  @override
  String get earningsTotal => 'தொடக்கத்திலிருந்து';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள் விற்றன',
      one: '1 பொருள் விற்றது',
      zero: 'இன்னும் எதுவும் விற்கவில்லை',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'சந்தை தன் பங்கை எடுத்த பிறகு உங்களுக்கு வருவது இதுதான்.';

  @override
  String get profileVillageLabel => 'ஊர் அல்லது கிளஸ்டர்';

  @override
  String get profileNotSet => 'கொடுக்கவில்லை';

  @override
  String get profileEditEntry => 'உங்கள் விவரங்களை மாற்று';

  @override
  String get profileStoryEntry => 'உங்கள் கைவினைக் கதை';

  @override
  String get profileLanguageEntry => 'மொழி';

  @override
  String get profilePhoneEntry => 'போன் எண்';

  @override
  String get profileOndcEntry => 'உங்கள் விற்பனைக் கணக்கு';

  @override
  String get profileNotificationsEntry => 'நாங்கள் எதைப் பற்றிச் சொல்வது';

  @override
  String get profileVoiceEntry => 'குரலும் ஒலியும்';

  @override
  String get profilePrivacyEntry => 'உங்களைப் பற்றி என்ன தெரிகிறது';

  @override
  String get profileStorageEntry => 'இந்த போனில் இடம்';

  @override
  String get profileAccountEntry => 'வெளியேறு';

  @override
  String get editProfileTitle => 'உங்கள் விவரங்கள்';

  @override
  String get editProfileAddPhoto => 'உங்கள் படத்தைச் சேர்';

  @override
  String get editProfileChangePhoto => 'படத்தை மாற்று';

  @override
  String get editProfileRemovePhoto => 'படத்தை நீக்கு';

  @override
  String get editProfilePhotoWhy =>
      'நீங்கள் அனுமதித்தால் மட்டுமே வாங்குபவர்கள் இதைக் கைவினைஞர் அட்டையில் பார்ப்பார்கள்.';

  @override
  String get editProfileVillageHint => 'சொல்லுங்கள் அல்லது எழுதுங்கள்';

  @override
  String get editProfileSave => 'சேமி';

  @override
  String get editProfileSaved => 'சேமிக்கப்பட்டது';

  @override
  String get storyTitle => 'உங்கள் கைவினைக் கதை';

  @override
  String get storyBody =>
      'நீங்கள் யார், எப்படிச் செய்கிறீர்கள் என்று வாங்குபவர்களிடம் சொல்லுங்கள். நீங்கள் பேசுங்கள், நாங்கள் எழுதிக்கொள்வோம்.';

  @override
  String get storyHoldToSpeak =>
      'அழுத்திப் பிடித்து உங்கள் கதையைச் சொல்லுங்கள்';

  @override
  String get storyEmpty => 'நீங்கள் இன்னும் உங்கள் கதையைச் சொல்லவில்லை.';

  @override
  String get storyEditHint => 'இதில் எந்த வார்த்தையையும் மாற்றலாம்.';

  @override
  String get storyExample =>
      'உதாரணம்: எங்கள் குடும்பம் மூன்று தலைமுறைகளாக இவற்றைச் செய்கிறது, நான் இன்றும் என் தாத்தாவின் தறியில் வேலை செய்கிறேன்.';

  @override
  String get changePhoneTitle => 'உங்கள் எண்ணை மாற்றுங்கள்';

  @override
  String get changePhoneBody =>
      'எண் உங்களுடையதுதான் என்று உறுதிசெய்ய புதிய எண்ணுக்கு ஒரு குறியீடு அனுப்புவோம்.';

  @override
  String changePhoneCurrent(String number) {
    return 'இப்போது உங்கள் எண் $number';
  }

  @override
  String get changePhoneDone => 'உங்கள் எண் மாற்றப்பட்டது';

  @override
  String get ondcAccountTitle => 'உங்கள் விற்பனைக் கணக்கு';

  @override
  String get ondcAccountLinked => 'உங்கள் கணக்கு இணைக்கப்பட்டுள்ளது';

  @override
  String get ondcAccountNone => 'இன்னும் எந்தக் கணக்கும் இணைக்கப்படவில்லை';

  @override
  String get ondcAccountNoneBody =>
      'பொருட்களைச் செய்துகொண்டே இருங்கள். கணக்கு இணைந்தவுடன் அவை விற்பனைக்குப் போகும்.';

  @override
  String get ondcAccountLink => 'கணக்கை இணை';

  @override
  String get ondcAccountUnlink => 'இந்தக் கணக்கைப் பிரி';

  @override
  String get ondcUnlinkTitle => 'இந்தக் கணக்கைப் பிரிக்கவா?';

  @override
  String get ondcUnlinkBody =>
      'விற்பனையில் உள்ள அனைத்தும் இறங்கும். நீங்கள் செய்தது எதுவும் அழிக்கப்படாது, மீண்டும் இணைக்கலாம்.';

  @override
  String get ondcUnlinkConfirm => 'ஆம், பிரி';

  @override
  String get ondcUnlinkCancel => 'வேண்டாம், வை';

  @override
  String get ondcUnlinkDone => 'கணக்கு பிரிக்கப்பட்டது';

  @override
  String get notificationsTitle => 'நாங்கள் எதைப் பற்றிச் சொல்வது';

  @override
  String get notifySold => 'ஏதாவது விற்கும்போது';

  @override
  String get notifySoldWhy =>
      'வாங்குபவர் பணம் செலுத்தியவுடன் சொல்வோம், நீங்கள் பேக் செய்யத் தொடங்கலாம்.';

  @override
  String get notifyAttention => 'உங்களிடம் ஏதாவது கேட்க வேண்டியிருக்கும்போது';

  @override
  String get notifyAttentionWhy =>
      'சில நேரங்களில் ஒரு பொருள் விற்பனைக்குப் போகும் முன் ஒரு விஷயம் விடுபடும்.';

  @override
  String get notifyUpload => 'ஒரு பொருள் அனுப்பப்பட்டதும்';

  @override
  String get notifyUploadWhy =>
      'நீங்கள் போனில் செய்தது எங்களை அடைந்ததும் சொல்வோம்.';

  @override
  String get notifyPackBy => 'பேக் செய்ய நேரம் வந்தால்';

  @override
  String get notifyPackByWhy =>
      'ஒரு விற்பனையை பேக் செய்ய வேண்டிய தேதிக்கு ஒரு நாள் முன்பும் அன்றும் உங்களுக்கு நினைவூட்டுவோம்.';

  @override
  String get notificationsBlocked =>
      'இந்த போன் உங்களுக்கு எதையும் அனுப்ப எங்களை அனுமதிக்கவில்லை. போன் செட்டிங்ஸில் இதை இயக்கலாம்.';

  @override
  String get voiceSettingsTitle => 'குரலும் ஒலியும்';

  @override
  String get voiceSpeed => 'நாங்கள் எவ்வளவு வேகமாகப் பேசுவது';

  @override
  String get voiceSpeedSlow => 'மெதுவாக';

  @override
  String get voiceSpeedFast => 'வேகமாக';

  @override
  String get voiceTry => 'இப்போது ஏதாவது சொல்லிக் காட்டு';

  @override
  String get voiceSample => 'நாங்கள் உங்களிடம் இந்த வேகத்தில் பேசுவோம்.';

  @override
  String get voiceAutoRead => 'ஒவ்வொரு திரையும் திறக்கும்போது படித்துக் காட்டு';

  @override
  String get voiceAutoReadWhy =>
      'இது அணைந்திருந்தால், நீங்கள் ஸ்பீக்கரை அழுத்தும்போது மட்டுமே பேசுவோம்.';

  @override
  String get voiceUnavailable =>
      'இந்த போனால் பேச முடியாது. எல்லாம் வேலை செய்யும், ஆனால் எதுவும் படித்துக் காட்டப்படாது.';

  @override
  String get privacyTitle => 'உங்களைப் பற்றி என்ன தெரிகிறது';

  @override
  String get privacyBody =>
      'ஒவ்வொரு பொருளையும் விற்பனைக்கு வைத்தபோது இவற்றுக்கு ஆம் என்றீர்கள். இவற்றில் எதையும் திரும்பப் பெறலாம்.';

  @override
  String get privacyPhoto => 'இந்தப் பொருளின் படங்கள்';

  @override
  String get privacyStory => 'உங்கள் பெயர், ஊர், கதை';

  @override
  String get privacyNothing => 'இப்போது உங்களுடையது எதுவும் விற்பனையில் இல்லை.';

  @override
  String get privacyWithdrawTitle => 'இதைத் திரும்பப் பெறவா?';

  @override
  String get privacyWithdrawPhotoBody =>
      'படங்கள் இல்லாமல் இந்தப் பொருள் விற்பனையில் இருக்க முடியாது, அதனால் இறங்கும். எதுவும் அழிக்கப்படாது.';

  @override
  String get privacyWithdrawStoryBody =>
      'உங்கள் பெயர், ஊர், கதை இந்தப் பொருளிலிருந்து நீக்கப்படும். இது விற்பனையிலேயே இருக்கும்.';

  @override
  String get privacyWithdrawConfirm => 'ஆம், திரும்பப் பெறு';

  @override
  String get privacyWithdrawCancel => 'வேண்டாம், இருக்கட்டும்';

  @override
  String get privacyWithdrawn => 'திரும்பப் பெறப்பட்டது';

  @override
  String get storageTitle => 'இந்த போனில் இடம்';

  @override
  String get storagePhotos => 'படங்களும் பதிவுகளும்';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள் அனுப்பக் காத்திருக்கின்றன',
      one: '1 பொருள் அனுப்பக் காத்திருக்கிறது',
      zero: 'அனுப்ப எதுவும் காத்திருக்கவில்லை',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'அனுப்பப்பட்டவற்றை நீக்கு';

  @override
  String get storageClearWhy =>
      'இன்னும் அனுப்பக் காத்திருப்பவை ஒருபோதும் தொடப்படாது.';

  @override
  String storageCleared(String size) {
    return '$size காலியானது';
  }

  @override
  String get storageNothingToClear => 'நீக்க எதுவும் இல்லை';

  @override
  String get accountTitle => 'வெளியேறு';

  @override
  String get accountSignOut => 'இந்த போனிலிருந்து வெளியேறு';

  @override
  String get accountSignOutTitle => 'வெளியேறவா?';

  @override
  String get accountSignOutBody =>
      'அனுப்பக் காத்திருப்பவை இழக்கப்படும். விற்பனையில் உள்ளவை விற்பனையிலேயே இருக்கும்.';

  @override
  String get accountSignOutConfirm => 'ஆம், வெளியேறு';

  @override
  String get accountSignOutCancel => 'வேண்டாம், உள்ளேயே இரு';

  @override
  String get accountDelete => 'என் கணக்கை அழி';

  @override
  String get accountDeleteTitle => 'உங்கள் கணக்கை அழிக்கவா?';

  @override
  String get accountDeleteBody =>
      'எல்லாம் விற்பனையிலிருந்து இறங்கும், இந்த போனில் உள்ள அனைத்தும் அழிக்கப்படும். இதைத் திரும்பப் பெற முடியாது.';

  @override
  String get accountDeleteConfirm => 'ஆம், எல்லாவற்றையும் அழி';

  @override
  String get accountDeleteCancel => 'வேண்டாம், என் கணக்கு இருக்கட்டும்';

  @override
  String get accountDeleteHold => 'அழிக்கப் பொத்தானை அழுத்திப் பிடியுங்கள்';

  @override
  String get profileHelpEntry => 'உதவி';

  @override
  String get helpTitle => 'உதவி';

  @override
  String get helpBody =>
      'சுருக்கமான பதில்கள், படித்துக் காட்டப்படும். கேட்க எதையாவது அழுத்துங்கள்.';

  @override
  String get helpSteps => 'இப்படிச் செய்யுங்கள்';

  @override
  String get helpTopicPhotos => 'நல்ல படங்கள் எடுப்பது';

  @override
  String get helpTopicPhotosBody =>
      'நல்ல படங்கள் விற்கும். வாங்குபவர் பொருளைக் கையில் எடுக்க முடியாது, அவரிடம் படம் மட்டுமே உள்ளது.';

  @override
  String get helpTopicPhotosStep1 =>
      'பகல் வெளிச்சம் பொருளின் மேல் விழக் கதவு அல்லது ஜன்னல் அருகே நில்லுங்கள்';

  @override
  String get helpTopicPhotosStep2 =>
      'சுற்றிலும் வேறு எதுவும் இல்லாமல் பொருளை ஒரு சாதாரணத் துணியின் மேல் வையுங்கள்';

  @override
  String get helpTopicPhotosStep3 =>
      'படம் எடுக்கும் வரை இரண்டு கைகளாலும் போனை அசையாமல் பிடியுங்கள்';

  @override
  String get helpTopicPhotosStep4 =>
      'வேலைப்பாடு தெரிய அருகிலிருந்து ஒன்று எடுங்கள்';

  @override
  String get helpTopicPhotosStep5 =>
      'அளவு தெரிய ஒரு படத்தில் அருகில் கை வையுங்கள்';

  @override
  String get helpTopicVoice => 'உங்கள் பொருளைப் பற்றி என்ன சொல்வது';

  @override
  String get helpTopicVoiceBody =>
      'எதிரே நிற்கும் வாடிக்கையாளரிடம் பேசுவது போலவே பேசுங்கள். சொல்வதில் தவறான வழி இல்லை.';

  @override
  String get helpTopicVoiceStep1 => 'இது என்ன என்று சொல்லுங்கள்';

  @override
  String get helpTopicVoiceStep2 => 'இது எதனால் செய்தது என்று சொல்லுங்கள்';

  @override
  String get helpTopicVoiceStep3 =>
      'இது எவ்வளவு பெரியது என்று அங்குலம் அல்லது அடியில் சொல்லுங்கள்';

  @override
  String get helpTopicVoiceStep4 =>
      'செய்ய எவ்வளவு நேரம் ஆனது என்று சொல்லுங்கள்';

  @override
  String get helpTopicVoiceStep5 =>
      'இதற்கு உங்களுக்கு எவ்வளவு வேண்டும் என்று சொல்லுங்கள்';

  @override
  String get helpTopicPrice => 'விலையை நிர்ணயிப்பது';

  @override
  String get helpTopicPriceBody =>
      'உங்கள் விலையில் மூலப்பொருள் செலவும் உங்கள் நேரத்தின் மதிப்பும் அடங்க வேண்டும். உங்களுடன் சேர்ந்து அதைக் கணக்கிடுகிறோம், சொல்லாமல் அதற்குக் கீழே போக ஒருபோதும் விடமாட்டோம்.';

  @override
  String get helpTopicPriceStep1 =>
      'மூலப்பொருட்களுக்கு எவ்வளவு செலவானது என்று கணக்கிடுங்கள்';

  @override
  String get helpTopicPriceStep2 =>
      'வேலைக்கு எத்தனை நாட்கள் ஆனது என்று கணக்கிடுங்கள்';

  @override
  String get helpTopicPriceStep3 =>
      'நாங்கள் பரிந்துரைப்பதைப் பாருங்கள், உங்களுக்கு நன்றாகத் தெரிந்தால் மாற்றுங்கள்';

  @override
  String get helpTopicPriceStep4 =>
      'உங்கள் செலவைவிடக் குறைவாக இருந்தால் சொல்வோம், ஆனால் முடிவு உங்களுடையது';

  @override
  String get helpTopicSold => 'விற்ற பிறகு என்ன நடக்கும்';

  @override
  String get helpTopicSoldBody =>
      'வாங்குபவர் சந்தையில் பணம் செலுத்துகிறார். நீங்கள் பேக் செய்து ஒப்படைக்கிறீர்கள், பணம் உங்களுக்கு வருகிறது.';

  @override
  String get helpTopicSoldStep1 => 'விற்றவுடன் உங்களுக்குச் சொல்வோம்';

  @override
  String get helpTopicSoldStep2 =>
      'என்ன, எத்தனை பேக் செய்வது என்று திறந்து பாருங்கள்';

  @override
  String get helpTopicSoldStep3 =>
      'நாங்கள் காட்டும் தேதிக்கு முன் பேக் செய்யுங்கள்';

  @override
  String get helpTopicSoldStep4 => 'எடுக்க வருபவரிடம் ஒப்படையுங்கள்';

  @override
  String get helpTopicSoldStep5 => 'அதன் பிறகு பணம் உங்களை வந்தடையும்';

  @override
  String get helpVideoComing => 'இதற்கான ஒரு சிறிய வீடியோ விரைவில் வருகிறது.';

  @override
  String get helpPractice => 'நல்ல படம் எடுப்பது எப்படி';

  @override
  String get helpPracticeBody =>
      'ஒரே பானையின் ஒரு நல்ல படமும் ஒரு மோசமான படமும்.';

  @override
  String get helpFaqEntry => 'மக்கள் கேட்கும் கேள்விகள்';

  @override
  String get helpAboutEntry => 'கீர்த்திகர் பற்றி';

  @override
  String get helpSupportEntry => 'ஒருவரிடம் பேசுங்கள்';

  @override
  String get helpTermsEntry => 'விதிமுறைகளும் தனியுரிமையும்';

  @override
  String get faqTitle => 'மக்கள் கேட்கும் கேள்விகள்';

  @override
  String get faqQ1 => 'இதற்கு எனக்கு ஏதாவது செலவாகுமா?';

  @override
  String get faqA1 =>
      'இல்லை. பொருட்களை வைப்பது இலவசம். ஏதாவது விற்றால் மட்டுமே சந்தை சிறிய பங்கை எடுக்கும்.';

  @override
  String get faqQ2 => 'நெட்வொர்க் இல்லையென்றால்?';

  @override
  String get faqA2 =>
      'எல்லாம் வேலை செய்துகொண்டே இருக்கும். நீங்கள் செய்வது போனில் இருக்கும், நெட்வொர்க் வந்ததும் தானாக அனுப்பப்படும்.';

  @override
  String get faqQ3 => 'என் பணம் யாருக்குப் போகும்?';

  @override
  String get faqA3 =>
      'உங்களுக்கு. வாங்குபவர் சந்தையில் பணம் செலுத்துகிறார், அது உங்கள் கணக்குக்கு வருகிறது. பணம் ஒருபோதும் எங்கள் வழியாகப் போகாது.';

  @override
  String get faqQ4 => 'விற்பனைக்கு வைத்த பிறகு ஏதாவது மாற்றலாமா?';

  @override
  String get faqA4 =>
      'ஆம். உங்கள் பொருட்களிலிருந்து திறந்து, வேண்டியதை மாற்றுங்கள், அது மீண்டும் விற்பனைக்குப் போகும்.';

  @override
  String get faqQ5 => 'நான் ஏதாவது தவறாகச் சொன்னால்?';

  @override
  String get faqA5 =>
      'நீங்கள் கேட்டுச் சரி என்று சொல்லும் வரை எதுவும் விற்பனைக்குப் போகாது. எந்தப் பகுதியையும் பேசித் திருத்தலாம்.';

  @override
  String get faqQ6 => 'எனக்குப் படிக்க, எழுதத் தெரிய வேண்டுமா?';

  @override
  String get faqA6 =>
      'இல்லை. எல்லாவற்றையும் பேசியும் அழுத்தியும் செய்யலாம். ஒவ்வொரு திரையையும் உங்களுக்குப் படித்துக் காட்டலாம்.';

  @override
  String get faqQ7 => 'என் பெயரையும் ஊரையும் யார் பார்ப்பார்கள்?';

  @override
  String get faqA7 =>
      'நீங்கள் அனுமதித்தால் மட்டுமே, ஒவ்வொரு பொருளுக்கும் தனியாக. எப்போது வேண்டுமானாலும் திரும்பப் பெறலாம்.';

  @override
  String get aboutTitle => 'கீர்த்திகர் பற்றி';

  @override
  String get aboutWhatTitle => 'இது என்ன';

  @override
  String get aboutWhat =>
      'கீர்த்திகர் கையால் செய்த பொருட்களை ONDC-க்கு, இந்தியாவின் திறந்த வாங்கல்-விற்றல் வலைப்பின்னலுக்கு, கொண்டு சேர்க்கிறது, அதற்குச் செய்பவர் தட்டச்சு செய்யத் தேவையில்லை, பேசினால் போதும். உங்கள் சொந்த மொழியில் சில படங்களும் ஒரு குரல் பதிவும், நாடு முழுவதும் உள்ள வாங்குபவர்கள் கண்டுபிடிக்கக்கூடிய பட்டியலாக மாறுகின்றன.';

  @override
  String get aboutWhyTitle => 'நாங்கள் ஏன் இதை உருவாக்கினோம்';

  @override
  String get aboutWhy =>
      'இந்தியாவில் சுமார் எழுபது லட்சம் கைவினைஞர்கள் மக்கள் வாங்க விரும்பும் பொருட்களைச் செய்கிறார்கள், அவர்களில் பெரும்பாலோர் வித்தியாசத்தை எடுத்துக்கொள்ளும் இடைத்தரகர் மூலம் விற்கிறார்கள். தடை வேலையில் இல்லை. படிவத்தில் உள்ளது: இணையப் பட்டியல் ஆங்கிலத் தட்டச்சு, பல கட்டங்கள், அட்டவணைப் படம் போன்றவற்றைக் கேட்கிறது. இந்தச் செயலி அந்தப் படிவத்தையே நீக்குகிறது.';

  @override
  String get aboutHowTitle => 'இது எப்படி வேலை செய்கிறது';

  @override
  String get aboutHow =>
      'மூன்று படங்கள் எடுத்து இது என்ன என்று சொல்லுங்கள். எங்கள் அமைப்பு கேட்கிறது, பட்டியலை எழுதுகிறது, உங்களுக்குப் படித்துக் காட்டுகிறது. நீங்கள் கேட்டுச் சரி என்று சொல்லும் வரை எதுவும் வெளியே போகாது.';

  @override
  String get aboutSihTitle => 'ஸ்மார்ட் இந்தியா ஹேக்கத்தான் 2025';

  @override
  String get aboutSih =>
      'சிக்கல் 090-க்காக உருவாக்கப்பட்டது: கைவினைஞர்களும் நெசவாளர்களும் ONDC-யில் வாங்குபவர்களை அடைய உதவுவது.';

  @override
  String get aboutMissionTitle => 'நாங்கள் என்ன செய்ய முயல்கிறோம்';

  @override
  String get aboutMission =>
      'ஒரு வேலையின் விலை அதைச் செய்தவரின் கையிலேயே இருக்க வேண்டும்.';

  @override
  String get supportTitle => 'ஒருவரிடம் பேசுங்கள்';

  @override
  String get supportBody =>
      'ஏதாவது வேலை செய்யவில்லை என்றால், அல்லது என்ன செய்வது என்று தெரியவில்லை என்றால், எங்களை அழையுங்கள். ஒருவர் உங்கள் மொழியில் பதில் சொல்வார்.';

  @override
  String get supportCall => 'எங்களை அழையுங்கள்';

  @override
  String get supportWhatsApp => 'வாட்ஸ்அப்பில் செய்தி அனுப்புங்கள்';

  @override
  String get supportHours => 'தினமும், காலை ஒன்பது முதல் மாலை ஏழு வரை.';

  @override
  String supportNumber(String number) {
    return 'எங்கள் எண் $number';
  }

  @override
  String supportFailed(String number) {
    return 'உங்கள் போனால் அதைத் திறக்க முடியவில்லை. எங்கள் எண் $number.';
  }

  @override
  String get termsTitle => 'விதிமுறைகளும் தனியுரிமையும்';

  @override
  String get termsSummaryTitle => 'சுருக்கமாக';

  @override
  String get termsSummary1 =>
      'நீங்கள் செய்வது உங்களுடையது. உங்களுக்காக அதை விற்பனைக்கு வைக்கிறோம், விற்பனையிலிருந்து எதுவும் எடுப்பதில்லை.';

  @override
  String get termsSummary2 =>
      'உங்கள் படங்களும் குரலும் உங்கள் பட்டியலை எழுத மட்டுமே பயன்படுத்தப்படுகின்றன, வேறு எதற்கும் அல்ல.';

  @override
  String get termsSummary3 =>
      'உங்கள் பெயர், ஊர், கதை நீங்கள் அனுமதித்த பொருட்களில் மட்டுமே போகும், அதைத் திரும்பப் பெறலாம்.';

  @override
  String get termsSummary4 =>
      'பணம் வாங்குபவரிடமிருந்து நேராக உங்களுக்குப் போகிறது. ஒருபோதும் எங்கள் வழியாகப் போகாது.';

  @override
  String get termsSummary5 =>
      'எப்போது வேண்டுமானாலும் இந்த போனிலிருந்து எல்லாவற்றையும் அழிக்கலாம்.';

  @override
  String get termsFullTitle => 'முழு உரை';

  @override
  String get termsFullBody =>
      'பயன்பாட்டின் முழு விதிமுறைகளும் தனியுரிமைக் கொள்கையும் எங்கள் இணையதளத்தில் உள்ளன. இங்கே ஏதாவது புரியவில்லை என்றால் எங்களை அழையுங்கள், ஒருவர் விளக்குவார்.';

  @override
  String get termsOpenFull => 'முழு உரையைப் படி';

  @override
  String get termsAgreeTitle => 'தொடங்கும் முன்';

  @override
  String get termsAgreeBody =>
      'நீங்கள் இவற்றுக்கு ஒப்புக்கொள்கிறீர்கள். கேட்க ஸ்பீக்கரை அழுத்து.';

  @override
  String get termsAgreeCheck => 'நான் விதிமுறைகளை ஏற்கிறேன்';

  @override
  String get termsAgreeContinue => 'தொடர்';

  @override
  String get termsAgreeNeeded =>
      'முதலில் “நான் விதிமுறைகளை ஏற்கிறேன்” என்பதைத் தேர்ந்தெடு.';

  @override
  String versionNumber(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get versionCheck => 'புதிய பதிப்பைச் சரிபார்';

  @override
  String get versionLicences => 'உரிமங்கள்';

  @override
  String get versionLicencesWhy =>
      'இந்தச் செயலி உருவாக்கப்பட்ட இலவச மென்பொருள்.';

  @override
  String get noNetworkTitle => 'நெட்வொர்க் இல்லை';

  @override
  String get noNetworkBody =>
      'நீங்கள் வேலையைத் தொடரலாம். எல்லாம் போனில் இருக்கும், நெட்வொர்க் வந்ததும் தானாகப் போகும்.';

  @override
  String get noNetworkNeeded =>
      'இந்த ஒரு வேலைக்கு நெட்வொர்க் தேவை. சிக்னல் வந்ததும் மீண்டும் முயலுங்கள்.';

  @override
  String get serverErrorTitle => 'எங்கள் பக்கத்தை அடைய முடியவில்லை';

  @override
  String get serverErrorBody =>
      'நீங்கள் செய்தது எதுவும் இழக்கப்படவில்லை. சிறிது நேரம் கழித்து மீண்டும் முயலுங்கள்.';

  @override
  String get actionTryAgain => 'மீண்டும் முயலுங்கள்';

  @override
  String get permissionRecoveryTitle => 'செயலிக்கு உங்கள் அனுமதி தேவை';

  @override
  String get permissionRecoveryBody =>
      'போன் இவற்றைப் பயன்படுத்தச் செயலியை அனுமதிக்கவில்லை. போன் செட்டிங்ஸில் இவற்றை இயக்கிவிட்டு இங்கே திரும்பலாம்.';

  @override
  String get permissionCameraWhy =>
      'நீங்கள் செய்ததைப் படம் எடுக்க. இது இல்லாமல் எதையும் விற்பனைக்கு வைக்க முடியாது.';

  @override
  String get permissionMicWhy =>
      'தட்டச்சுக்குப் பதில் பேசுவதற்கு. இது இல்லாமல் எல்லாவற்றையும் தட்டச்சு செய்ய வேண்டும்.';

  @override
  String get permissionNotifyTitle => 'அறிவிப்புகள்';

  @override
  String get permissionNotifyWhy =>
      'ஏதாவது விற்றால் சொல்வதற்கு. இது இல்லாமல் தெரிந்துகொள்ளச் செயலியைத் திறக்க வேண்டும்.';

  @override
  String get permissionBlocked => 'அனுமதி இல்லை';

  @override
  String get permissionAsk => 'மீண்டும் கேள்';

  @override
  String get permissionRecheck => 'நான் இயக்கிவிட்டேன்';

  @override
  String get permissionAllGood =>
      'செயலிக்குத் தேவையான அனைத்துக்கும் அனுமதி உள்ளது.';

  @override
  String get updateTitle => 'தயவுசெய்து செயலியைப் புதுப்பியுங்கள்';

  @override
  String get updateBody =>
      'இந்தப் பதிப்பால் இனி எங்களுடன் பேச முடியாது. ஸ்டோரில் புதிய பதிப்பு உள்ளது, புதுப்பித்த பிறகும் உங்கள் போனில் உள்ள அனைத்தும் அப்படியே இருக்கும்.';

  @override
  String get updateAction => 'புதிய பதிப்பைப் பெறு';

  @override
  String get updateFailed =>
      'ஸ்டோர் திறக்கவில்லை. அங்கே கீர்த்திகர் என்று தேடுங்கள்.';

  @override
  String get emptyNudge =>
      'முகப்பில் உள்ள பெரிய பொத்தானை அழுத்தி உங்கள் முதல் பொருளைச் சேருங்கள்.';

  @override
  String get productsInProgress => 'தயாராகிறது';

  @override
  String get productsListed => 'விற்பனையில்';

  @override
  String get productsSold => 'விற்றது';

  @override
  String get voiceTypeInstead => 'எழுதிச் சொல்லுங்கள்';

  @override
  String get voiceSpeakInstead => 'பேசிச் சொல்லுங்கள்';

  @override
  String get voiceTypeTitle => 'இப்போது இது என்ன என்று எழுதுங்கள்';

  @override
  String get voiceTypeHint => 'இங்கே எழுதுங்கள்…';

  @override
  String get voiceTypeSave => 'இந்த விவரத்தையே வை';

  @override
  String get errorNotAllowed =>
      'இந்தக் கணக்கால் இதைச் செய்ய முடியாது. உதவிக்கு எங்களை அழையுங்கள்.';

  @override
  String get errorNotFound => 'இது இப்போது இங்கு இல்லை.';

  @override
  String get errorConflict =>
      'இது வேறு இடத்தில் மாற்றப்பட்டுள்ளது. மீண்டும் திறந்து இன்னொரு முறை முயலுங்கள்.';

  @override
  String get errorInvalid =>
      'சில விவரங்கள் ஏற்கப்படவில்லை. சரிபார்த்து மீண்டும் முயலுங்கள்.';

  @override
  String get voiceGuideTitle => 'இவற்றைப் பற்றி சொல்லலாம்';

  @override
  String get voiceGuideWhat => 'பொருளின் பெயர்';

  @override
  String get voiceGuideSize => 'உயரம்';

  @override
  String get voiceGuideColour => 'நிறம்';

  @override
  String get voiceGuideTime => 'செய்ய ஆன நேரம்';

  @override
  String get voiceGuideCost => 'பொருட்களின் செலவு';
}
