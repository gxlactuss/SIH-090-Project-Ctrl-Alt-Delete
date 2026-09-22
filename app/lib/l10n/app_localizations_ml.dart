import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'കീർത്തികർ';

  @override
  String get actionNext => 'അടുത്തത്';

  @override
  String get actionBack => 'പിന്നോട്ട്';

  @override
  String get actionSkip => 'ഒഴിവാക്കുക';

  @override
  String get actionDone => 'കഴിഞ്ഞു';

  @override
  String get actionListen => 'കേൾക്കുക';

  @override
  String get actionStopListening => 'നിർത്തുക';

  @override
  String stepOfSteps(int current, int total) {
    return 'ഘട്ടം $current, ആകെ $total';
  }

  @override
  String get splashTagline => 'പറയൂ, നിങ്ങളുടെ സാധനം വിറ്റുപോകും';

  @override
  String get languageTitle => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get languageHint => 'നിങ്ങൾ സംസാരിക്കുന്ന ഭാഷയിൽ അമർത്തുക';

  @override
  String get welcomeCard1Title => 'മൂന്ന് ഫോട്ടോ എടുക്കുക';

  @override
  String get welcomeCard1Body =>
      'നിങ്ങൾ ഉണ്ടാക്കിയ സാധനത്തിന്റെ മൂന്ന് ഫോട്ടോ എടുക്കുക. എങ്ങനെ എടുക്കണമെന്ന് ആപ്പ് കാണിച്ചുതരും.';

  @override
  String get welcomeCard2Title => 'പറഞ്ഞുകൊടുക്കുക';

  @override
  String get welcomeCard2Body =>
      'ഇത് എന്താണ്, എന്തുകൊണ്ട് ഉണ്ടാക്കി, വില എത്ര, വെറുതെ പറഞ്ഞാൽ മതി. എഴുതേണ്ട.';

  @override
  String get welcomeCard3Title => 'ഇത് വിൽപ്പനയ്ക്ക് പോകുന്നു';

  @override
  String get welcomeCard3Body =>
      'ആദ്യം നിങ്ങളെ വായിച്ചു കേൾപ്പിക്കും. നിങ്ങൾ അതെ എന്ന് പറഞ്ഞാൽ മാത്രമേ ഓൺലൈനിൽ പോകൂ.';

  @override
  String get welcomeStart => 'തുടങ്ങുക';

  @override
  String get permissionsTitle => 'ആപ്പിന് മൂന്ന് കാര്യങ്ങൾക്ക് അനുമതി വേണം';

  @override
  String get permissionCameraTitle => 'ക്യാമറ';

  @override
  String get permissionCameraBody =>
      'നിങ്ങളുടെ സാധനത്തിന്റെ ഫോട്ടോ എടുക്കാൻ. നിങ്ങൾ അതെ എന്ന് പറയുന്നതുവരെ ഫോട്ടോകൾ നിങ്ങളുടെ ഫോണിൽ തന്നെ ഇരിക്കും.';

  @override
  String get permissionMicTitle => 'മൈക്ക്';

  @override
  String get permissionMicBody => 'എഴുതുന്നതിനു പകരം സംസാരിക്കാൻ.';

  @override
  String get permissionNotificationTitle => 'അറിയിപ്പുകൾ';

  @override
  String get permissionNotificationBody =>
      'എന്തെങ്കിലും വിറ്റുപോയാൽ ഉടനെ അറിയിക്കാൻ.';

  @override
  String get permissionAllow => 'അനുവദിക്കുക';

  @override
  String get permissionNotNow => 'ഇപ്പോൾ വേണ്ട';

  @override
  String get permissionGranted => 'അനുവദിച്ചു';

  @override
  String get permissionDeniedTitle => 'അനുമതി കിട്ടിയില്ല';

  @override
  String get permissionDeniedBody =>
      'ഇതില്ലാതെ ഇത് പ്രവർത്തിക്കില്ല. ഫോണിന്റെ സെറ്റിംഗ്സിൽ പോയി അനുവദിക്കുക.';

  @override
  String get permissionOpenSettings => 'സെറ്റിംഗ്സ് തുറക്കുക';

  @override
  String get phoneTitle => 'നിങ്ങളുടെ ഫോൺ നമ്പർ';

  @override
  String get phoneWhy =>
      'ഈ നമ്പറിലേക്ക് ഞങ്ങൾ ഒരു കോഡ് അയയ്ക്കും. ഈ നമ്പർ മറ്റാർക്കും നൽകില്ല.';

  @override
  String get phoneInvalid => 'പത്ത് അക്ക നമ്പർ നൽകുക';

  @override
  String phoneUnknown(String number) {
    return 'ഈ ഡെമോയിൽ ഈ നമ്പർ പ്രവർത്തിക്കില്ല. $number ഉപയോഗിക്കുക.';
  }

  @override
  String get phoneSendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String get otpTitle => 'വന്ന കോഡ് നൽകുക';

  @override
  String otpSentTo(String number) {
    return '$number ലേക്ക് അയച്ചു';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds സെക്കൻഡിനു ശേഷം വീണ്ടും അയയ്ക്കുക';
  }

  @override
  String get otpResend => 'കോഡ് വീണ്ടും അയയ്ക്കുക';

  @override
  String get otpCallMe => 'എന്നെ വിളിച്ച് പറയൂ';

  @override
  String get otpCalling =>
      'കുറച്ചു കഴിഞ്ഞ് ഒരു കോൾ വരും, കോഡ് വായിച്ചു കേൾപ്പിക്കും.';

  @override
  String get otpWrong => 'കോഡ് ശരിയല്ല. വീണ്ടും നൽകുക.';

  @override
  String get phoneSendFailed =>
      'കോഡ് അയയ്ക്കാൻ കഴിഞ്ഞില്ല. നെറ്റ്‌വർക്ക് നോക്കി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get otpExpired => 'കോഡിന്റെ സമയം കഴിഞ്ഞു. വീണ്ടും അയയ്ക്കുക.';

  @override
  String get authTooManyTries =>
      'പലതവണ ശ്രമിച്ചു. കുറച്ചു കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get otpChangeNumber => 'നമ്പർ മാറ്റുക';

  @override
  String get otpAutoRead => 'സന്ദേശം സ്വയം വായിച്ചു';

  @override
  String get profileTitle => 'നിങ്ങളെക്കുറിച്ച് പറയൂ';

  @override
  String get profileNameLabel => 'നിങ്ങളുടെ പേര്';

  @override
  String get profileNameHint => 'പറയുക അല്ലെങ്കിൽ എഴുതുക';

  @override
  String get profileNameMissing => 'നിങ്ങളുടെ പേര് പറയൂ';

  @override
  String get profileCraftLabel => 'നിങ്ങൾ എന്ത് ഉണ്ടാക്കുന്നു';

  @override
  String get profileCraftMissing => 'ഒന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get profileSpeakToFill => 'പറയുക';

  @override
  String get profileListening => 'കേൾക്കുന്നു…';

  @override
  String get dictationUnavailable =>
      'ഈ ഫോണിൽ പറഞ്ഞ് എഴുതുന്നത് പ്രവർത്തിക്കുന്നില്ല. ദയവായി എഴുതുക.';

  @override
  String get dictationNothingHeard =>
      'ഒന്നും കേട്ടില്ല. മൈക്ക് അമർത്തി വീണ്ടും പറയുക.';

  @override
  String get craftWeaving => 'നെയ്ത്ത്';

  @override
  String get craftPottery => 'മൺപാത്ര നിർമ്മാണം';

  @override
  String get craftWoodwork => 'മരപ്പണി';

  @override
  String get craftMetalwork => 'ലോഹപ്പണി';

  @override
  String get craftJewellery => 'ആഭരണങ്ങൾ';

  @override
  String get craftEmbroidery => 'ചിത്രത്തുന്നൽ';

  @override
  String get craftPainting => 'ചിത്രരചന';

  @override
  String get craftLeather => 'തുകൽപ്പണി';

  @override
  String get craftBamboo => 'മുളയും ചൂരലും';

  @override
  String get craftOther => 'മറ്റെന്തെങ്കിലും';

  @override
  String get ondcTitle => 'നിങ്ങളുടെ ONDC അക്കൗണ്ട് ബന്ധിപ്പിക്കുക';

  @override
  String get ondcExplain =>
      'ONDC-യിലാണ് വാങ്ങുന്നവർ നിങ്ങൾ ഉണ്ടാക്കിയത് കണ്ട് വാങ്ങുന്നത്. പണം നേരിട്ട് നിങ്ങൾക്ക് വരും, ഞങ്ങളിലൂടെയല്ല.';

  @override
  String get ondcMalformed =>
      'ഇത് ഒരു സെല്ലർ ഐഡി പോലെ തോന്നുന്നില്ല. ദയവായി പരിശോധിക്കുക, അല്ലെങ്കിൽ കോഡ് വീണ്ടും സ്കാൻ ചെയ്യുക.';

  @override
  String get ondcEmailLabel => 'ONDC ഇമെയിൽ';

  @override
  String get ondcEmailMalformed =>
      'ഇത് ഒരു ഇമെയിൽ വിലാസം പോലെ തോന്നുന്നില്ല. ദയവായി അത് പരിശോധിക്കൂ.';

  @override
  String get ondcSellerIdLabel => 'വിൽപ്പനക്കാരന്റെ ഐഡി';

  @override
  String get ondcScan => 'QR കോഡ് സ്കാൻ ചെയ്യുക';

  @override
  String get ondcLink => 'അക്കൗണ്ട് ബന്ധിപ്പിക്കുക';

  @override
  String get ondcLinking => 'ബന്ധിപ്പിക്കുന്നു…';

  @override
  String get ondcFailed => 'ആ അക്കൗണ്ട് കണ്ടെത്താനായില്ല. ദയവായി പരിശോധിക്കുക.';

  @override
  String get ondcNoAccount => 'എനിക്ക് ഇതുവരെ അക്കൗണ്ട് ഇല്ല';

  @override
  String get ondcNoAccountExplain =>
      'കുഴപ്പമില്ല. നിങ്ങൾക്ക് സാധനങ്ങൾ തയ്യാറാക്കി വയ്ക്കാം. അക്കൗണ്ട് ബന്ധിപ്പിച്ചാലുടൻ എല്ലാം ഒരുമിച്ച് പോകും.';

  @override
  String get practiceTitle => 'നല്ല ഫോട്ടോ എങ്ങനെ എടുക്കാം';

  @override
  String get practiceIntro =>
      'ഒരേ കലം, ഒരിക്കൽ നന്നായും ഒരിക്കൽ മോശമായും എടുത്തത്. രണ്ടും കാണാൻ നീക്കുക.';

  @override
  String get practiceGoodBadge => 'ഇങ്ങനെ ചെയ്യുക';

  @override
  String get practiceGoodTitle => 'നല്ല ഫോട്ടോ';

  @override
  String get practiceGoodTip1 => 'വ്യക്തം: ഫോൺ അനങ്ങാതെ പിടിച്ചു';

  @override
  String get practiceGoodTip2 => 'വെളിച്ചം: ജനലിനോ വാതിലിനോ അടുത്ത് എടുത്തത്';

  @override
  String get practiceGoodTip3 => 'സാധനം മുഴുവനും ഫോട്ടോയിലുണ്ട്';

  @override
  String get practiceBadBadge => 'ഇങ്ങനെ ചെയ്യരുത്';

  @override
  String get practiceBadTitle => 'മോശം ഫോട്ടോ';

  @override
  String get practiceBadTip1 => 'മങ്ങിയത്: ഫോൺ അനങ്ങി';

  @override
  String get practiceBadTip2 => 'വാങ്ങുന്നവർക്ക് വിശദാംശങ്ങൾ കാണാനാവില്ല';

  @override
  String get practiceBadTip3 => 'ആപ്പ് നിങ്ങളോട് വീണ്ടും ഫോട്ടോ എടുക്കാൻ പറയും';

  @override
  String get practiceFinish => 'ആപ്പ് തുറക്കുക';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navListings => 'സാധനങ്ങൾ';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String homeGreeting(String name) {
    return 'നമസ്കാരം, $name';
  }

  @override
  String get homeAddProduct => 'സാധനം ചേർക്കുക';

  @override
  String get homeAddProductSpoken =>
      'സാധനം ചേർക്കാൻ ഈ വലിയ ബട്ടൺ അമർത്തുക. മൂന്ന് ഫോട്ടോ എടുക്കുക, ഇത് എന്താണെന്ന് പറയുക, അത് വിൽപ്പനയ്ക്ക് പോകും.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count സാധനങ്ങൾ അയയ്ക്കാൻ ബാക്കി',
      one: '1 സാധനം അയയ്ക്കാൻ ബാക്കി',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count വിറ്റു',
      one: '1 വിറ്റു',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'നിങ്ങളുടെ പുതിയ സാധനങ്ങൾ';

  @override
  String get homeNextTitle => 'ഇനി ചെയ്യേണ്ടത്';

  @override
  String get homeEmptyTitle => 'ഇവിടെ ഇതുവരെ ഒന്നുമില്ല';

  @override
  String get homeEmptyBody =>
      'മുകളിലെ വലിയ ബട്ടൺ അമർത്തി ആദ്യത്തെ സാധനം ചേർക്കുക.';

  @override
  String get offlineNoNetwork => 'ഇപ്പോൾ നെറ്റ്‌വർക്ക് ഇല്ല';

  @override
  String get offlineNothingLost =>
      'ഒന്നും നഷ്ടപ്പെട്ടിട്ടില്ല. നെറ്റ്‌വർക്ക് വരുമ്പോൾ സ്വയം പോകും.';

  @override
  String get statusQueued => 'അയയ്ക്കാൻ ബാക്കി';

  @override
  String get statusProcessing => 'തയ്യാറാകുന്നു';

  @override
  String get statusNeedsAttention => 'നിങ്ങളുടെ ഉത്തരം വേണം';

  @override
  String get statusReady => 'വിൽപ്പനയ്ക്ക് തയ്യാർ';

  @override
  String get statusPublished => 'വിൽപ്പനയിലുണ്ട്';

  @override
  String get statusFailed => 'അയയ്ക്കാനായില്ല';

  @override
  String get listingUntitled => 'സാധനം';

  @override
  String get listingNoPrice => 'വില പറഞ്ഞിട്ടില്ല';

  @override
  String get captureTitle => 'സാധനം ചേർക്കുക';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ഫോട്ടോ $current / $total';
  }

  @override
  String get capturePhotoWhole => 'സാധനം മുഴുവനായി കാണിക്കുക';

  @override
  String get capturePhotoDetail => 'അടുത്തുനിന്ന് ഒന്ന് എടുക്കുക';

  @override
  String get capturePhotoScale => 'വലിപ്പം മനസ്സിലാകാൻ അരികിൽ കൈ വയ്ക്കുക';

  @override
  String get captureTakePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get captureFromGallery => 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get captureTorchOn => 'ലൈറ്റ് ഓൺ';

  @override
  String get captureTorchOff => 'ലൈറ്റ് ഓഫ്';

  @override
  String get captureCameraFailed => 'ക്യാമറ തുറന്നില്ല';

  @override
  String get captureCameraRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get captureCameraPermission =>
      'നിങ്ങളുടെ സാധനത്തിന്റെ ഫോട്ടോ എടുക്കാൻ ആപ്പിന് ക്യാമറ വേണം.';

  @override
  String get captureOpenSettings => 'സെറ്റിംഗ്സ് തുറക്കുക';

  @override
  String get captureLeaveTitle => 'സേവ് ചെയ്യാതെ പോകണോ?';

  @override
  String get captureLeaveBody => 'ഫോട്ടോകളും നിങ്ങൾ പറഞ്ഞതും കളയും.';

  @override
  String get captureLeaveConfirm => 'കളയുക';

  @override
  String get captureLeaveCancel => 'ഇവിടെ നിൽക്കുക';

  @override
  String get shotReviewChecking => 'ഫോട്ടോ പരിശോധിക്കുന്നു…';

  @override
  String get shotReviewRetake => 'വീണ്ടും എടുക്കുക';

  @override
  String get qualityTooDark =>
      'ഈ ഫോട്ടോ വളരെ ഇരുണ്ടതാണ്. വാതിലിനടുത്ത് നിന്ന് എടുക്കുക.';

  @override
  String get qualityTooBright =>
      'ഇതിൽ വെളിച്ചം കൂടുതലാണ്. വെയിലിന് പുറം തിരിഞ്ഞ് എടുക്കുക.';

  @override
  String get qualityBlurry =>
      'ഈ ഫോട്ടോ വ്യക്തമല്ല. ഫോൺ അനങ്ങാതെ പിടിച്ച് വീണ്ടും എടുക്കുക.';

  @override
  String get qualityUnreadable =>
      'ഈ ഫോട്ടോ ശരിയായി സേവ് ആയില്ല. ദയവായി വീണ്ടും എടുക്കുക.';

  @override
  String get qualityNoSubject =>
      'ഈ ഫോട്ടോയിൽ സാധനം കാണുന്നില്ല. അത് വരയ്ക്കുള്ളിൽ വച്ച് അടുത്തേക്ക് വരൂ.';

  @override
  String get qualityOutOfFrame =>
      'ഈ ഫോട്ടോയിൽ സാധനത്തിന്റെ ഒരു ഭാഗം മാത്രമേയുള്ളൂ. സാധനം മുഴുവൻ വരയ്ക്കുള്ളിൽ വയ്ക്കുക.';

  @override
  String get qualityWarningTitle => 'ഇത് വീണ്ടും എടുക്കുക';

  @override
  String get qualityKeepAnyway => 'എന്നാലും സൂക്ഷിക്കുക';

  @override
  String get photoSetTitle => 'നിങ്ങളുടെ മൂന്ന് ഫോട്ടോകൾ';

  @override
  String get photoSetBody =>
      'വാങ്ങുന്നവർ ആദ്യം കാണുന്നത് ആദ്യത്തെ ഫോട്ടോയാണ്. ഒരു ഫോട്ടോ വീണ്ടും എടുക്കാൻ അതിൽ അമർത്തുക.';

  @override
  String get photoSetMain => 'ആദ്യത്തെ ഫോട്ടോ';

  @override
  String get photoSetRetakeThis => 'ഇത് വീണ്ടും എടുക്കുക';

  @override
  String get photoSetConfirm => 'ഈ ഫോട്ടോകൾ കൊള്ളാം';

  @override
  String get photoEditOpen => 'ഫോട്ടോ മുറിക്കുക അല്ലെങ്കിൽ തിരിക്കുക';

  @override
  String get photoEditTitle => 'ഫോട്ടോ മുറിക്കുക';

  @override
  String get photoEditBody =>
      'മുറിക്കാൻ ചതുരത്തിന്റെ മൂലയോ അരികോ വലിക്കുക. നീക്കാൻ ചതുരത്തിനുള്ളിൽ നിന്ന് വലിക്കുക.';

  @override
  String get photoEditTurn => 'തിരിക്കുക';

  @override
  String get photoEditStraighten => 'നേരെയാക്കുക';

  @override
  String get photoEditReset => 'വീണ്ടും തുടങ്ങുക';

  @override
  String get photoEditDone => 'ഈ ഫോട്ടോ ഉപയോഗിക്കുക';

  @override
  String get photoEditCancel => 'തിരികെ പോകുക';

  @override
  String get photoEditFailed =>
      'ഈ മാറ്റം സേവ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get photoIssueTooDark => 'വളരെ ഇരുണ്ടത്, വ്യക്തമായി കാണുന്നില്ല';

  @override
  String get photoIssueTooBright => 'ഇതിൽ വെളിച്ചം കൂടുതലാണ്';

  @override
  String get photoIssueBlurry => 'മങ്ങിയത്, വേണ്ടത്ര വ്യക്തമല്ല';

  @override
  String get photoIssueNoSubject => 'ഈ ഫോട്ടോയിൽ സാധനമൊന്നും കാണുന്നില്ല';

  @override
  String get photoIssueUnreadable => 'ഈ ഫോട്ടോ സേവ് ആയില്ല';

  @override
  String get photoIssueOutOfFrame => 'സാധനം മുഴുവൻ ഫോട്ടോയിൽ ഇല്ല';

  @override
  String get voiceTitle => 'ഇനി ഇത് എന്താണെന്ന് പറയുക';

  @override
  String get voiceBody =>
      'ഇത് എന്താണ്, എന്തുകൊണ്ട് ഉണ്ടാക്കി, എത്ര വലുതാണ്, ഉണ്ടാക്കാൻ എത്ര സമയമെടുത്തു, വില എത്ര.';

  @override
  String get voiceHoldToSpeak => 'അമർത്തിപ്പിടിച്ച് പറയുക';

  @override
  String get voiceRecording => 'പറയൂ… കഴിയുമ്പോൾ വിടുക';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total ൽ $seconds സെക്കൻഡ്';
  }

  @override
  String get voiceTooShort =>
      'അത് വളരെ ചെറുതായിരുന്നു. ബട്ടൺ അമർത്തിപ്പിടിച്ച് വീണ്ടും പറയുക.';

  @override
  String get voiceFailed =>
      'മൈക്ക് തുടങ്ങിയില്ല. ആപ്പിന് മൈക്ക് ഉപയോഗിക്കാൻ അനുമതിയുണ്ടോ എന്ന് നോക്കുക.';

  @override
  String get voiceBackToPhotos => 'ഫോട്ടോകളിലേക്ക് മടങ്ങുക';

  @override
  String get playbackPlay => 'കേൾക്കുക';

  @override
  String get playbackStop => 'നിർത്തുക';

  @override
  String get playbackAgain => 'വീണ്ടും പറയുക';

  @override
  String get playbackAccept => 'ഇത് ശരിയാണ്';

  @override
  String get playbackUnavailable =>
      'ഈ ഫോണിന് അത് കേൾപ്പിക്കാൻ കഴിയില്ല. നിങ്ങൾക്ക് എന്നാലും അയയ്ക്കാം, അല്ലെങ്കിൽ വീണ്ടും പറയാം.';

  @override
  String get savedTitle => 'സേവ് ചെയ്തു';

  @override
  String get savedBody => 'നെറ്റ്‌വർക്ക് ഉള്ളപ്പോൾ സ്വയം പോകും.';

  @override
  String get savedBodyOnline =>
      'ഇപ്പോൾ അയയ്ക്കുന്നു. നിങ്ങൾ ഇവിടെ കാത്തിരിക്കേണ്ട.';

  @override
  String get savedAddAnother => 'മറ്റൊരു സാധനം ചേർക്കുക';

  @override
  String get savedGoHome => 'ഹോമിലേക്ക് പോകുക';

  @override
  String get saveFailed => 'ഈ ഫോണിൽ സേവ് ചെയ്യാനായില്ല. സ്ഥലം ഇല്ലാതിരിക്കാം.';

  @override
  String get saveRetry => 'വീണ്ടും സേവ് ചെയ്യാൻ ശ്രമിക്കുക';

  @override
  String get queueTitle => 'അയയ്ക്കാൻ ബാക്കി';

  @override
  String get queueBody =>
      'ഇവിടെ ഒന്നും നഷ്ടപ്പെട്ടിട്ടില്ല. നെറ്റ്‌വർക്ക് വന്നാലുടൻ ഓരോന്നും പോകും.';

  @override
  String get queueEmptyTitle => 'ഒന്നും ബാക്കിയില്ല';

  @override
  String get queueEmptyBody => 'നിങ്ങൾ ഉണ്ടാക്കിയതെല്ലാം അയച്ചുകഴിഞ്ഞു.';

  @override
  String get queueStateWaiting => 'നെറ്റ്‌വർക്കിനായി കാത്തിരിക്കുന്നു';

  @override
  String queueStateUploading(int percent) {
    return 'അയയ്ക്കുന്നു… നൂറിൽ $percent';
  }

  @override
  String get queueStateProcessing =>
      'ഇപ്പോൾ ഞങ്ങളുടെ പക്കലുണ്ട്. ഞങ്ങൾ എഴുതുന്നു.';

  @override
  String get queueStateFailed => 'പോയില്ല. കാരണം കാണാൻ അമർത്തുക.';

  @override
  String get queueItemTitle => 'ഈ സാധനം';

  @override
  String queueMadeAt(String date) {
    return '$date ന് ഉണ്ടാക്കിയത്';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count തവണ ശ്രമിച്ചു',
      one: 'ഒരിക്കൽ ശ്രമിച്ചു',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'ഇപ്പോൾ അയയ്ക്കാൻ ശ്രമിക്കുക';

  @override
  String get queueRetryWaiting => 'ഇതുവരെ നെറ്റ്‌വർക്ക് ഇല്ല. സ്വയം പോകും.';

  @override
  String get queueDelete => 'ഈ സാധനം മായ്ക്കുക';

  @override
  String get queueDeleteTitle => 'ഈ സാധനം മായ്ക്കണോ?';

  @override
  String get queueDeleteBody =>
      'ഫോട്ടോകളും നിങ്ങൾ പറഞ്ഞതും പോകും. ഇത് തിരികെ കിട്ടില്ല.';

  @override
  String get queueDeleteConfirm => 'അതെ, മായ്ക്കുക';

  @override
  String get queueDeleteCancel => 'വേണ്ട, സൂക്ഷിക്കുക';

  @override
  String get failureNetwork =>
      'നെറ്റ്‌വർക്ക് പാതിവഴിയിൽ നിന്നു. സിഗ്നൽ വരുമ്പോൾ സ്വയം വീണ്ടും പോകും.';

  @override
  String get failureServer =>
      'ഞങ്ങളുടെ ഭാഗത്തുനിന്ന് മറുപടി വന്നില്ല. വീണ്ടും ശ്രമിക്കും.';

  @override
  String get failureMissingFiles =>
      'ഫോട്ടോകൾ ഇപ്പോൾ ഈ ഫോണിൽ ഇല്ല, അതിനാൽ ഇത് അയയ്ക്കാൻ കഴിയില്ല. ദയവായി വീണ്ടും ഉണ്ടാക്കുക.';

  @override
  String get failureRejected =>
      'ഇത് സ്വീകരിക്കാനായില്ല. ദയവായി വീണ്ടും ഉണ്ടാക്കുക.';

  @override
  String get failureUnknown => 'എന്തോ പിഴച്ചു. നിങ്ങൾക്ക് വീണ്ടും ശ്രമിക്കാം.';

  @override
  String get processingTitle => 'ഞങ്ങൾ എഴുതുന്നു';

  @override
  String get processingBody =>
      'നിങ്ങളുടെ ഫോട്ടോകളും വാക്കുകളും ഞങ്ങളുടെ പക്കലുണ്ട്. ഇതിന് കുറച്ച് മിനിറ്റ് എടുക്കും.';

  @override
  String get processingLeave =>
      'നിങ്ങൾ ഇവിടെ കാത്തിരിക്കേണ്ട. തയ്യാറാകുമ്പോൾ ഞങ്ങൾ അറിയിക്കും.';

  @override
  String get processingGoHome => 'ഹോമിലേക്ക് പോകുക';

  @override
  String get attentionTitle => 'ഒരു ചോദ്യം';

  @override
  String get attentionBody =>
      'ബാക്കിയെല്ലാം ഞങ്ങൾക്ക് മനസ്സിലായി. ഇത് മാത്രമേ ബാക്കിയുള്ളൂ.';

  @override
  String get attentionHoldToAnswer => 'അമർത്തിപ്പിടിച്ച് ഉത്തരം പറയുക';

  @override
  String get attentionAnswering => 'നിങ്ങളുടെ ഉത്തരം അയയ്ക്കുന്നു…';

  @override
  String get attentionFailed =>
      'നിങ്ങളുടെ ഉത്തരം പോയില്ല. ദയവായി വീണ്ടും പറയുക.';

  @override
  String get readBackTitle => 'ഞങ്ങൾക്ക് മനസ്സിലായത് ഇതാണ്';

  @override
  String get readBackListen => 'മുഴുവനും കേൾക്കുക';

  @override
  String get readBackFields => 'ഞങ്ങൾ എഴുതിയത്';

  @override
  String get readBackCorrect => 'തെറ്റായതിൽ അമർത്തുക';

  @override
  String get readBackApprove => 'ഇതെല്ലാം ശരിയാണ്';

  @override
  String get notSaid => 'പറഞ്ഞിട്ടില്ല';

  @override
  String get fieldMaterial => 'എന്തുകൊണ്ട് ഉണ്ടാക്കി';

  @override
  String get fieldSize => 'വലിപ്പം';

  @override
  String get fieldColour => 'നിറം';

  @override
  String get fieldQuantity => 'എത്ര എണ്ണം';

  @override
  String get fieldPrice => 'വില';

  @override
  String correctTitle(String field) {
    return 'ശരിയായ $field പറയുക';
  }

  @override
  String get correctHoldToSpeak => 'അമർത്തിപ്പിടിച്ച് പറയുക';

  @override
  String get correctListening => 'കേൾക്കുന്നു…';

  @override
  String get correctFailedOnce =>
      'ഞങ്ങൾക്ക് മനസ്സിലായില്ല. ഒരിക്കൽ കൂടി പറയുക.';

  @override
  String get correctUseKeypad => 'പകരം എഴുതുക';

  @override
  String get correctUseVoice => 'പകരം പറയുക';

  @override
  String get correctPick => 'അല്ലെങ്കിൽ ഒന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get correctSave => 'ഇത് സേവ് ചെയ്യുക';

  @override
  String get correctCancel => 'അങ്ങനെ തന്നെ ഇരിക്കട്ടെ';

  @override
  String get correctTypeHint => 'ഉത്തരം ഇവിടെ എഴുതുക';

  @override
  String correctHeard(Object text) {
    return 'ഞങ്ങൾ കേട്ടത് “$text”';
  }

  @override
  String get listingCancelAction => 'ഈ ലിസ്റ്റിംഗ് റദ്ദാക്കുക';

  @override
  String get listingCancelTitle => 'ഈ ലിസ്റ്റിംഗ് റദ്ദാക്കണോ?';

  @override
  String get listingCancelBody =>
      'ഫോട്ടോകളും റെക്കോർഡിംഗും നിങ്ങൾ പറഞ്ഞതെല്ലാം മായ്ക്കപ്പെടും. ഇത് തിരികെ കിട്ടില്ല.';

  @override
  String get listingCancelConfirm => 'അതെ, റദ്ദാക്കുക';

  @override
  String get listingCancelKeep => 'വേണ്ട, നിൽക്കട്ടെ';

  @override
  String get photoSaveAction => 'ഫോട്ടോ സേവ് ചെയ്യുക';

  @override
  String get photoSaved => 'നിങ്ങളുടെ ഫോട്ടോകളിൽ സേവ് ചെയ്തു';

  @override
  String get photoSaveFailed => 'ഫോട്ടോ സേവ് ചെയ്യാനായില്ല';

  @override
  String get photoSaveDenied => 'ഫോട്ടോ സേവ് ചെയ്യാൻ അനുമതി നൽകുക';

  @override
  String get colourRed => 'ചുവപ്പ്';

  @override
  String get colourBlue => 'നീല';

  @override
  String get colourGreen => 'പച്ച';

  @override
  String get colourYellow => 'മഞ്ഞ';

  @override
  String get colourBlack => 'കറുപ്പ്';

  @override
  String get colourWhite => 'വെള്ള';

  @override
  String get colourBrown => 'തവിട്ട്';

  @override
  String get colourMulti => 'പല നിറങ്ങൾ';

  @override
  String get sizeSmall => 'ചെറുത്';

  @override
  String get sizeMedium => 'ഇടത്തരം';

  @override
  String get sizeLarge => 'വലുത്';

  @override
  String get sizeExtraLarge => 'വളരെ വലുത്';

  @override
  String get suggestTitle => 'ഇതും ചേർക്കട്ടെ?';

  @override
  String get suggestYes => 'അതെ, ചേർക്കുക';

  @override
  String get suggestNo => 'വേണ്ട, ഒഴിവാക്കുക';

  @override
  String get suggestSkip => 'എനിക്ക് ഉറപ്പില്ല';

  @override
  String suggestProgress(int current, int total) {
    return '$total ൽ $current';
  }

  @override
  String get suggestDone => 'ഇനി ഒന്നും ചേർക്കാനില്ല';

  @override
  String get priceTitle => 'വില എത്ര?';

  @override
  String get priceBody => 'ഇത് ഒരെണ്ണത്തിന്റെ വിലയാണ്.';

  @override
  String priceBand(String low, String high) {
    return 'ഇത്തരം സാധനങ്ങൾ മറ്റുള്ളവർ $low മുതൽ $high വരെ വിൽക്കുന്നു';
  }

  @override
  String get priceBelowFloor =>
      'ഇത് നിങ്ങളുടെ ചെലവിനേക്കാൾ കുറവാണ്. എന്നാലും നിങ്ങൾക്ക് ഇത് തിരഞ്ഞെടുക്കാം.';

  @override
  String get priceSayIt => 'വില പറയുക';

  @override
  String get priceConfirm => 'ഈ വില ശരിയാണ്';

  @override
  String get stockTitle => 'നിങ്ങളുടെ പക്കൽ എത്ര എണ്ണമുണ്ട്?';

  @override
  String get stockBody =>
      'എല്ലാം വിറ്റുകഴിയുമ്പോൾ ഞങ്ങൾ നിങ്ങൾക്കായി ഇത് എടുത്തുമാറ്റും.';

  @override
  String get stockOneOfAKind =>
      'ഒന്നേയുള്ളൂ, ഇനി ഒരിക്കലും മറ്റൊന്ന് ഉണ്ടാകില്ല';

  @override
  String get stockMore => 'ഒന്നുകൂടി';

  @override
  String get stockLess => 'ഒന്ന് കുറവ്';

  @override
  String get stockConfirm => 'ഇത് ശരിയാണ്';

  @override
  String get photosTitle => 'ഏത് ഫോട്ടോ ആദ്യം വരണം?';

  @override
  String get photosBody =>
      'വാങ്ങുന്നവർ മറ്റെന്തിനും മുമ്പ് ആദ്യത്തെ ഫോട്ടോ കാണുന്നു.';

  @override
  String get photosMakeFirst => 'ഇത് ആദ്യത്തെ ഫോട്ടോ ആക്കുക';

  @override
  String get photosFirst => 'ആദ്യത്തെ ഫോട്ടോ';

  @override
  String get photosConfirm => 'ഈ ഫോട്ടോകൾ ശരിയാണ്';

  @override
  String get previewTitle => 'വാങ്ങുന്നവർ ഇത് കാണും';

  @override
  String get previewListenAll => 'എല്ലാം കേൾക്കുക';

  @override
  String get previewNoDescription => 'വിവരണമൊന്നും എഴുതിയിട്ടില്ല.';

  @override
  String get previewConfirm => 'അതെ, ഇത് ശരിയാണ്';

  @override
  String get previewChange => 'എന്തെങ്കിലും മാറ്റുക';

  @override
  String get consentTitle => 'ഞങ്ങൾ ഇത് വിൽപ്പനയ്ക്ക് വയ്ക്കട്ടെ?';

  @override
  String get consentPhoto => 'എന്റെ ഫോട്ടോകൾ കാണിക്കുക';

  @override
  String get consentPhotoExplain =>
      'നിങ്ങളുടെ സാധനത്തിന്റെ ഫോട്ടോകൾ വാങ്ങുന്നയാളുടെ സ്ക്രീനിൽ പോകും.';

  @override
  String get consentStory => 'എന്റെ കരകൗശല കഥ കാണിക്കുക';

  @override
  String get consentStoryExplain =>
      'നിങ്ങളുടെ പേര്, ഗ്രാമം, നിങ്ങൾ എങ്ങനെ ഉണ്ടാക്കുന്നു എന്നത് കാരിഗർ കാർഡിൽ പോകും. വേണ്ട എന്ന് പറഞ്ഞാലും നിങ്ങൾക്ക് വിൽക്കാം.';

  @override
  String get consentNeeded => 'ഫോട്ടോകളില്ലാതെ ഞങ്ങൾക്ക് ഇത് വയ്ക്കാനാവില്ല.';

  @override
  String get consentPublish => 'വിൽപ്പനയ്ക്ക് വയ്ക്കുക';

  @override
  String get publishingTitle => 'വിൽപ്പനയ്ക്ക് വയ്ക്കുന്നു';

  @override
  String get publishingBody => 'ഇതിന് അൽപ്പസമയം എടുക്കും. ആപ്പ് അടയ്ക്കരുത്.';

  @override
  String get publishedTitle => 'ഇത് വിൽപ്പനയ്ക്കുണ്ട്';

  @override
  String get publishedBody => 'വാങ്ങുന്നവർക്ക് ഇപ്പോൾ ഇത് കാണാം.';

  @override
  String get publishedShare => 'വാട്ട്‌സ്ആപ്പിൽ അയയ്ക്കുക';

  @override
  String get publishedCopyLink => 'ലിങ്ക് പകർത്തുക';

  @override
  String get publishedLinkCopied => 'ലിങ്ക് പകർത്തി';

  @override
  String get publishedShowQr => 'സ്കാൻ ചെയ്യാനുള്ള കോഡ് കാണിക്കുക';

  @override
  String get publishedQrExplain =>
      'ആർക്കും ഇതിനു നേരെ ഫോൺ പിടിച്ച് നിങ്ങളുടെ സാധനം തുറക്കാം.';

  @override
  String get publishedAnother => 'ഇതുപോലെ മറ്റൊന്ന് ഉണ്ടാക്കുക';

  @override
  String get publishedDone => 'ഹോമിലേക്ക് പോകുക';

  @override
  String get publishFailed =>
      'ഇത് വയ്ക്കാനായില്ല. ഒന്നും നഷ്ടപ്പെട്ടിട്ടില്ല, നിങ്ങൾക്ക് വീണ്ടും ശ്രമിക്കാം.';

  @override
  String get publishRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get reviewLeaveTitle => 'ഇപ്പോൾ ഇത് വിടണോ?';

  @override
  String get reviewLeaveBody =>
      'നിങ്ങൾ അംഗീകരിച്ചത് സൂക്ഷിക്കും. നിങ്ങളുടെ സാധനങ്ങളിൽ നിന്ന് തിരികെ വരാം.';

  @override
  String get reviewLeaveConfirm => 'ഇപ്പോൾ വിടുക';

  @override
  String get editLeaveTitle => 'നിങ്ങളുടെ മാറ്റങ്ങൾ ഇതുവരെ വിൽപ്പനയിലില്ല';

  @override
  String get editLeaveBody =>
      'നിങ്ങൾ മാറ്റിയത് സേവ് ആയി, പക്ഷേ വാങ്ങുന്നവർ ഇപ്പോഴും പഴയതാണ് കാണുന്നത്. അവസാനത്തെ ബട്ടൺ അമർത്തുമ്പോൾ മാത്രമേ ഇത് വീണ്ടും വിൽപ്പനയ്ക്ക് പോകൂ.';

  @override
  String get editLeaveConfirm => 'ശരി, പിന്നീട് ചെയ്യാം';

  @override
  String get reviewLeaveCancel => 'തുടരുക';

  @override
  String get statusSoldOut => 'എല്ലാം വിറ്റു';

  @override
  String get statusUnpublished => 'എടുത്തുമാറ്റി';

  @override
  String get listingsTitle => 'നിങ്ങളുടെ സാധനങ്ങൾ';

  @override
  String get listingsEmptyTitle => 'നിങ്ങൾ ഇതുവരെ ഒന്നും ഉണ്ടാക്കിയിട്ടില്ല';

  @override
  String get listingsEmptyBody =>
      'ഹോമിലെ വലിയ ബട്ടൺ അമർത്തി ആദ്യത്തെ സാധനം ചേർക്കുക.';

  @override
  String get listingsEmptyFilter => 'ഇവിടെ ഒന്നുമില്ല.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ബാക്കി',
      one: '1 ബാക്കി',
      zero: 'ഒന്നും ബാക്കിയില്ല',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count തവണ കണ്ടു',
      one: 'ഒരിക്കൽ കണ്ടു',
      zero: 'ഇതുവരെ ആരും കണ്ടിട്ടില്ല',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'എണ്ണം മാറ്റുക';

  @override
  String get listingTitle => 'ഈ സാധനം';

  @override
  String get listingOpenPreview => 'വാങ്ങുന്നവർ കാണുന്നത് കാണുക';

  @override
  String get listingEdit => 'എന്തെങ്കിലും മാറ്റുക';

  @override
  String get listingDuplicate => 'ഇതുപോലെ മറ്റൊന്ന് ഉണ്ടാക്കുക';

  @override
  String get listingUnpublish => 'വിൽപ്പനയിൽ നിന്ന് മാറ്റുക';

  @override
  String get listingRelist => 'വീണ്ടും വിൽപ്പനയ്ക്ക് വയ്ക്കുക';

  @override
  String get listingFinish => 'ഇത് പൂർത്തിയാക്കുക';

  @override
  String get listingSoldOutTitle => 'ഇവയെല്ലാം വിറ്റുപോയി';

  @override
  String get listingSoldOutBody =>
      'ഞങ്ങൾ നിങ്ങൾക്കായി ഇത് വിൽപ്പനയിൽ നിന്ന് മാറ്റി. കൂടുതൽ ഉണ്ടാക്കുമ്പോൾ വീണ്ടും വയ്ക്കുക.';

  @override
  String get editTitle => 'ഈ സാധനം മാറ്റുക';

  @override
  String get editBody =>
      'നിങ്ങൾ ഇത് വീണ്ടും പരിശോധിക്കും, പിന്നെ ഇത് വീണ്ടും വിൽപ്പനയ്ക്ക് പോകും.';

  @override
  String get editRepublishing => 'മാറ്റങ്ങൾ വിൽപ്പനയ്ക്ക് വയ്ക്കുന്നു…';

  @override
  String get editRepublished => 'നിങ്ങളുടെ മാറ്റങ്ങൾ ഇപ്പോൾ വിൽപ്പനയിലുണ്ട്';

  @override
  String get editRepublishConfirm => 'മാറ്റം വീണ്ടും വിൽപ്പനയ്ക്ക് വയ്ക്കുക';

  @override
  String get quickStockTitle => 'എത്ര ബാക്കിയുണ്ട്?';

  @override
  String get quickStockMarkSoldOut => 'എല്ലാം വിറ്റുപോയി';

  @override
  String get quickStockSave => 'സേവ് ചെയ്യുക';

  @override
  String get quickStockSaved => 'സേവ് ചെയ്തു';

  @override
  String get actionUndo => 'പഴയതുപോലെ ആക്കുക';

  @override
  String get unpublishTitle => 'വിൽപ്പനയിൽ നിന്ന് മാറ്റണോ?';

  @override
  String get unpublishBody =>
      'വാങ്ങുന്നവർ ഇനി ഇത് കാണില്ല. ഒന്നും മായ്ക്കില്ല, എപ്പോൾ വേണമെങ്കിലും വീണ്ടും വയ്ക്കാം.';

  @override
  String get unpublishConfirm => 'അതെ, മാറ്റുക';

  @override
  String get unpublishCancel => 'വേണ്ട, വിൽപ്പനയിൽ ഇരിക്കട്ടെ';

  @override
  String get unpublishDone => 'ഇത് വിൽപ്പനയിൽ നിന്ന് മാറ്റി';

  @override
  String get relistDone => 'ഇത് വീണ്ടും വിൽപ്പനയിലുണ്ട്';

  @override
  String get duplicateTitle => 'ഇതുപോലെ മറ്റൊന്ന് ഉണ്ടാക്കണോ?';

  @override
  String get duplicateBody =>
      'ഇതിനെക്കുറിച്ച് നിങ്ങൾ പറഞ്ഞത് ഞങ്ങൾ സൂക്ഷിക്കും. നിങ്ങൾ പുതിയ ഫോട്ടോകൾ മാത്രം എടുത്താൽ മതി.';

  @override
  String get duplicateConfirm => 'ഫോട്ടോകൾ എടുക്കുക';

  @override
  String get duplicateCancel => 'ഇപ്പോൾ വേണ്ട';

  @override
  String get duplicateBanner =>
      'കഴിഞ്ഞതുപോലെ മറ്റൊന്ന് ഉണ്ടാക്കുന്നു. ഫോട്ടോകൾ മാത്രമാണ് പുതിയത്.';

  @override
  String get listingActionFailed => 'അത് നടന്നില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get salesNew => 'പുതിയത്';

  @override
  String get salesEmptyTitle => 'ഇതുവരെ ഒന്നും വിറ്റിട്ടില്ല';

  @override
  String get salesEmptyBody =>
      'ആരെങ്കിലും എന്തെങ്കിലും വാങ്ങുമ്പോൾ അത് ഇവിടെ കാണും, ഞങ്ങൾ നിങ്ങളെ അറിയിക്കും.';

  @override
  String get salesLoading => 'എന്ത് വിറ്റു എന്ന് നോക്കുന്നു…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count എണ്ണം',
      one: '1 എണ്ണം',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date നുള്ളിൽ പാക്ക് ചെയ്യുക';
  }

  @override
  String get salesPackByToday => 'ഇന്നുതന്നെ പാക്ക് ചെയ്യുക';

  @override
  String get salesPackByTomorrow => 'നാളെയ്ക്കുള്ളിൽ പാക്ക് ചെയ്യുക';

  @override
  String get salesPackedAlready => 'ഇതിന്റെ തീയതി കഴിഞ്ഞു';

  @override
  String get saleTitle => 'ഈ ഓർഡർ';

  @override
  String get saleReadOnly =>
      'ഇത് നിങ്ങളെ അറിയിക്കാൻ മാത്രമാണ്. ഓർഡറിന്റെ എല്ലാ കാര്യങ്ങളും മാർക്കറ്റിലാണ് നടക്കുന്നത്, ഈ ആപ്പിലല്ല.';

  @override
  String salePaid(String amount) {
    return 'നിങ്ങൾക്ക് $amount കിട്ടും';
  }

  @override
  String salePlaced(String date) {
    return '$date ന് വിറ്റു';
  }

  @override
  String saleGoingTo(String area) {
    return '$area ലേക്ക് പോകുന്നു';
  }

  @override
  String get saleWhatToPack => 'എന്ത് പാക്ക് ചെയ്യണം';

  @override
  String get salePackingHelp => 'എങ്ങനെ പാക്ക് ചെയ്യണം';

  @override
  String get saleSeeListing => 'ഈ സാധനം കാണുക';

  @override
  String get packingTitle => 'എങ്ങനെ പാക്ക് ചെയ്യണം';

  @override
  String get packingBody =>
      'ഓരോന്നായി ചെയ്യുക. ചെയ്തുകഴിയുമ്പോൾ അതിൽ അമർത്തുക.';

  @override
  String get packingStep1 => 'ഒന്നും ഉരയാതിരിക്കാൻ തുണിയിലോ കടലാസിലോ പൊതിയുക';

  @override
  String get packingStep2 =>
      'പെട്ടിക്കുള്ളിൽ അനങ്ങാതിരിക്കാൻ ചുറ്റും കടലാസോ വൈക്കോലോ നിറയ്ക്കുക';

  @override
  String get packingStep3 => 'ഉള്ളിൽ ശരിയായ എണ്ണം ഉണ്ടോ എന്ന് നോക്കുക';

  @override
  String get packingStep4 => 'പെട്ടി അടച്ച് ചുറ്റും ടേപ്പ് ഒട്ടിക്കുക';

  @override
  String get packingStep5 => 'കൊണ്ടുപോകാൻ വരുന്നയാൾക്കായി തയ്യാറാക്കി വയ്ക്കുക';

  @override
  String get packingDone => 'എല്ലാം കഴിഞ്ഞു';

  @override
  String packingProgress(int done, int total) {
    return '$total ൽ $done കഴിഞ്ഞു';
  }

  @override
  String get earningsTitle => 'നിങ്ങൾ എത്ര സമ്പാദിച്ചു';

  @override
  String get earningsWeek => 'ഈ ആഴ്ച';

  @override
  String get earningsMonth => 'ഈ മാസം';

  @override
  String get earningsTotal => 'തുടങ്ങിയതു മുതൽ';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count എണ്ണം വിറ്റു',
      one: '1 എണ്ണം വിറ്റു',
      zero: 'ഇതുവരെ ഒന്നും വിറ്റിട്ടില്ല',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'മാർക്കറ്റ് അതിന്റെ പങ്ക് എടുത്തശേഷം നിങ്ങൾക്ക് കിട്ടുന്നത് ഇതാണ്.';

  @override
  String get profileVillageLabel => 'ഗ്രാമം അല്ലെങ്കിൽ ക്ലസ്റ്റർ';

  @override
  String get profileNotSet => 'നൽകിയിട്ടില്ല';

  @override
  String get profileEditEntry => 'നിങ്ങളുടെ വിവരങ്ങൾ മാറ്റുക';

  @override
  String get profileStoryEntry => 'നിങ്ങളുടെ കരകൗശല കഥ';

  @override
  String get profileLanguageEntry => 'ഭാഷ';

  @override
  String get profilePhoneEntry => 'ഫോൺ നമ്പർ';

  @override
  String get profileOndcEntry => 'നിങ്ങളുടെ വിൽപ്പന അക്കൗണ്ട്';

  @override
  String get profileNotificationsEntry => 'ഞങ്ങൾ എന്തൊക്കെ അറിയിക്കണം';

  @override
  String get profileVoiceEntry => 'ശബ്ദവും കേൾവിയും';

  @override
  String get profilePrivacyEntry => 'നിങ്ങളെക്കുറിച്ച് എന്ത് കാണിക്കുന്നു';

  @override
  String get profileStorageEntry => 'ഈ ഫോണിലെ സ്ഥലം';

  @override
  String get profileAccountEntry => 'സൈൻ ഔട്ട്';

  @override
  String get editProfileTitle => 'നിങ്ങളുടെ വിവരങ്ങൾ';

  @override
  String get editProfileAddPhoto => 'നിങ്ങളുടെ ഒരു ഫോട്ടോ ചേർക്കുക';

  @override
  String get editProfileChangePhoto => 'ഫോട്ടോ മാറ്റുക';

  @override
  String get editProfileRemovePhoto => 'ഫോട്ടോ നീക്കുക';

  @override
  String get editProfilePhotoWhy =>
      'നിങ്ങൾ അനുവദിച്ചാൽ മാത്രമേ വാങ്ങുന്നവർ ഇത് കാരിഗർ കാർഡിൽ കാണൂ.';

  @override
  String get editProfileVillageHint => 'പറയുക അല്ലെങ്കിൽ എഴുതുക';

  @override
  String get editProfileSave => 'സേവ് ചെയ്യുക';

  @override
  String get editProfileSaved => 'സേവ് ചെയ്തു';

  @override
  String get storyTitle => 'നിങ്ങളുടെ കരകൗശല കഥ';

  @override
  String get storyBody =>
      'നിങ്ങൾ ആരാണെന്നും എങ്ങനെ ഉണ്ടാക്കുന്നുവെന്നും വാങ്ങുന്നവരോട് പറയുക. നിങ്ങൾ പറയൂ, ഞങ്ങൾ എഴുതിയെടുക്കാം.';

  @override
  String get storyHoldToSpeak => 'അമർത്തിപ്പിടിച്ച് നിങ്ങളുടെ കഥ പറയുക';

  @override
  String get storyEmpty => 'നിങ്ങൾ ഇതുവരെ നിങ്ങളുടെ കഥ പറഞ്ഞിട്ടില്ല.';

  @override
  String get storyEditHint => 'ഇതിലെ ഏത് വാക്കും നിങ്ങൾക്ക് മാറ്റാം.';

  @override
  String get storyExample =>
      'ഉദാഹരണത്തിന്: ഞങ്ങളുടെ കുടുംബം മൂന്ന് തലമുറയായി ഇവ ഉണ്ടാക്കുന്നു, ഞാൻ ഇന്നും എന്റെ മുത്തച്ഛന്റെ തറിയിലാണ് പണിയെടുക്കുന്നത്.';

  @override
  String get changePhoneTitle => 'നിങ്ങളുടെ നമ്പർ മാറ്റുക';

  @override
  String get changePhoneBody =>
      'നമ്പർ നിങ്ങളുടേതാണെന്ന് ഉറപ്പാക്കാൻ പുതിയ നമ്പറിലേക്ക് ഞങ്ങൾ ഒരു കോഡ് അയയ്ക്കും.';

  @override
  String changePhoneCurrent(String number) {
    return 'ഇപ്പോൾ നിങ്ങളുടെ നമ്പർ $number ആണ്';
  }

  @override
  String get changePhoneDone => 'നിങ്ങളുടെ നമ്പർ മാറി';

  @override
  String get ondcAccountTitle => 'നിങ്ങളുടെ വിൽപ്പന അക്കൗണ്ട്';

  @override
  String get ondcAccountLinked => 'നിങ്ങളുടെ അക്കൗണ്ട് ബന്ധിപ്പിച്ചിട്ടുണ്ട്';

  @override
  String get ondcAccountNone => 'ഇതുവരെ അക്കൗണ്ടൊന്നും ബന്ധിപ്പിച്ചിട്ടില്ല';

  @override
  String get ondcAccountNoneBody =>
      'നിങ്ങൾ സാധനങ്ങൾ ഉണ്ടാക്കിക്കൊണ്ടിരിക്കുക. അക്കൗണ്ട് ബന്ധിപ്പിച്ചാലുടൻ അവ വിൽപ്പനയ്ക്ക് പോകും.';

  @override
  String get ondcAccountLink => 'അക്കൗണ്ട് ബന്ധിപ്പിക്കുക';

  @override
  String get ondcAccountUnlink => 'ഈ അക്കൗണ്ട് വേർപെടുത്തുക';

  @override
  String get ondcUnlinkTitle => 'ഈ അക്കൗണ്ട് വേർപെടുത്തണോ?';

  @override
  String get ondcUnlinkBody =>
      'വിൽപ്പനയിലുള്ളതെല്ലാം ഇറങ്ങും. നിങ്ങൾ ഉണ്ടാക്കിയതൊന്നും മായ്ക്കില്ല, വീണ്ടും ബന്ധിപ്പിക്കാം.';

  @override
  String get ondcUnlinkConfirm => 'അതെ, വേർപെടുത്തുക';

  @override
  String get ondcUnlinkCancel => 'വേണ്ട, സൂക്ഷിക്കുക';

  @override
  String get ondcUnlinkDone => 'അക്കൗണ്ട് വേർപെടുത്തി';

  @override
  String get notificationsTitle => 'ഞങ്ങൾ എന്തൊക്കെ അറിയിക്കണം';

  @override
  String get notifySold => 'എന്തെങ്കിലും വിറ്റുപോകുമ്പോൾ';

  @override
  String get notifySoldWhy =>
      'വാങ്ങുന്നയാൾ പണം നൽകിയാലുടൻ അറിയിക്കും, നിങ്ങൾക്ക് പാക്ക് ചെയ്യാൻ തുടങ്ങാം.';

  @override
  String get notifyAttention =>
      'ഞങ്ങൾക്ക് നിങ്ങളോട് എന്തെങ്കിലും ചോദിക്കാനുള്ളപ്പോൾ';

  @override
  String get notifyAttentionWhy =>
      'ചിലപ്പോൾ ഒരു സാധനം വിൽപ്പനയ്ക്ക് പോകുന്നതിനുമുമ്പ് ഒരു കാര്യം ബാക്കിയുണ്ടാകും.';

  @override
  String get notifyUpload => 'ഒരു സാധനം അയച്ചുകഴിയുമ്പോൾ';

  @override
  String get notifyUploadWhy =>
      'നിങ്ങൾ ഫോണിൽ ഉണ്ടാക്കിയത് ഞങ്ങളിലെത്തുമ്പോൾ അറിയിക്കും.';

  @override
  String get notifyPackBy => 'പാക്ക് ചെയ്യാൻ സമയമാകുമ്പോൾ';

  @override
  String get notifyPackByWhy =>
      'ഒരു വിൽപ്പന പാക്ക് ചെയ്യേണ്ട തീയതിയുടെ തലേദിവസവും അന്നും ഞങ്ങൾ നിങ്ങളെ ഓർമ്മിപ്പിക്കും.';

  @override
  String get notificationsBlocked =>
      'ഈ ഫോൺ നിങ്ങൾക്ക് ഒന്നും അയയ്ക്കാൻ ഞങ്ങളെ അനുവദിക്കുന്നില്ല. ഫോണിന്റെ സെറ്റിംഗ്സിൽ ഇത് ഓൺ ചെയ്യാം.';

  @override
  String get voiceSettingsTitle => 'ശബ്ദവും കേൾവിയും';

  @override
  String get voiceSpeed => 'ഞങ്ങൾ എത്ര വേഗത്തിൽ സംസാരിക്കണം';

  @override
  String get voiceSpeedSlow => 'പതുക്കെ';

  @override
  String get voiceSpeedFast => 'വേഗത്തിൽ';

  @override
  String get voiceTry => 'ഇപ്പോൾ എന്തെങ്കിലും പറയൂ';

  @override
  String get voiceSample => 'ഈ വേഗത്തിലാണ് ഞങ്ങൾ നിങ്ങളോട് സംസാരിക്കുക.';

  @override
  String get voiceAutoRead =>
      'ഓരോ സ്ക്രീനും തുറക്കുമ്പോൾ വായിച്ചു കേൾപ്പിക്കുക';

  @override
  String get voiceAutoReadWhy =>
      'ഇത് ഓഫാണെങ്കിൽ, നിങ്ങൾ സ്പീക്കർ അമർത്തുമ്പോൾ മാത്രമേ ഞങ്ങൾ സംസാരിക്കൂ.';

  @override
  String get voiceUnavailable =>
      'ഈ ഫോണിന് സംസാരിക്കാൻ കഴിയില്ല. എല്ലാം പ്രവർത്തിക്കും, പക്ഷേ ഒന്നും വായിച്ചു കേൾപ്പിക്കില്ല.';

  @override
  String get privacyTitle => 'നിങ്ങളെക്കുറിച്ച് എന്ത് കാണിക്കുന്നു';

  @override
  String get privacyBody =>
      'ഓരോ സാധനവും വിൽപ്പനയ്ക്ക് വച്ചപ്പോൾ നിങ്ങൾ ഇവയ്ക്ക് അതെ എന്ന് പറഞ്ഞു. ഇവയിൽ ഏതും തിരിച്ചെടുക്കാം.';

  @override
  String get privacyPhoto => 'ഈ സാധനത്തിന്റെ ഫോട്ടോകൾ';

  @override
  String get privacyStory => 'നിങ്ങളുടെ പേര്, ഗ്രാമം, കഥ';

  @override
  String get privacyNothing => 'ഇപ്പോൾ നിങ്ങളുടേതായി ഒന്നും വിൽപ്പനയിലില്ല.';

  @override
  String get privacyWithdrawTitle => 'ഇത് തിരിച്ചെടുക്കണോ?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ഫോട്ടോകളില്ലാതെ ഈ സാധനം വിൽപ്പനയിൽ തുടരാനാവില്ല, അതിനാൽ ഇത് ഇറങ്ങും. ഒന്നും മായ്ക്കില്ല.';

  @override
  String get privacyWithdrawStoryBody =>
      'നിങ്ങളുടെ പേര്, ഗ്രാമം, കഥ എന്നിവ ഈ സാധനത്തിൽ നിന്ന് നീക്കും. ഇത് വിൽപ്പനയിൽ തുടരും.';

  @override
  String get privacyWithdrawConfirm => 'അതെ, തിരിച്ചെടുക്കുക';

  @override
  String get privacyWithdrawCancel => 'വേണ്ട, ഇരിക്കട്ടെ';

  @override
  String get privacyWithdrawn => 'തിരിച്ചെടുത്തു';

  @override
  String get storageTitle => 'ഈ ഫോണിലെ സ്ഥലം';

  @override
  String get storagePhotos => 'ഫോട്ടോകളും റെക്കോർഡിംഗുകളും';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count എണ്ണം അയയ്ക്കാൻ ബാക്കി',
      one: '1 എണ്ണം അയയ്ക്കാൻ ബാക്കി',
      zero: 'അയയ്ക്കാൻ ഒന്നും ബാക്കിയില്ല',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'അയച്ചുകഴിഞ്ഞവ നീക്കുക';

  @override
  String get storageClearWhy => 'ഇനിയും അയയ്ക്കാനുള്ളവ ഒരിക്കലും തൊടില്ല.';

  @override
  String storageCleared(String size) {
    return '$size ഒഴിവാക്കി';
  }

  @override
  String get storageNothingToClear => 'നീക്കാൻ ഒന്നുമില്ല';

  @override
  String get accountTitle => 'സൈൻ ഔട്ട്';

  @override
  String get accountSignOut => 'ഈ ഫോണിൽ നിന്ന് സൈൻ ഔട്ട് ചെയ്യുക';

  @override
  String get accountSignOutTitle => 'സൈൻ ഔട്ട് ചെയ്യണോ?';

  @override
  String get accountSignOutBody =>
      'അയയ്ക്കാൻ ബാക്കിയുള്ളത് നഷ്ടപ്പെടും. വിൽപ്പനയിലുള്ളത് വിൽപ്പനയിൽ തന്നെ തുടരും.';

  @override
  String get accountSignOutConfirm => 'അതെ, സൈൻ ഔട്ട്';

  @override
  String get accountSignOutCancel => 'വേണ്ട, സൈൻ ഇൻ ആയി തുടരുക';

  @override
  String get accountDelete => 'എന്റെ അക്കൗണ്ട് മായ്ക്കുക';

  @override
  String get accountDeleteTitle => 'നിങ്ങളുടെ അക്കൗണ്ട് മായ്ക്കണോ?';

  @override
  String get accountDeleteBody =>
      'എല്ലാം വിൽപ്പനയിൽ നിന്ന് ഇറങ്ങും, ഈ ഫോണിലുള്ളതെല്ലാം മായും. ഇത് തിരികെ കിട്ടില്ല.';

  @override
  String get accountDeleteConfirm => 'അതെ, എല്ലാം മായ്ക്കുക';

  @override
  String get accountDeleteCancel => 'വേണ്ട, എന്റെ അക്കൗണ്ട് ഇരിക്കട്ടെ';

  @override
  String get accountDeleteHold => 'മായ്ക്കാൻ ബട്ടൺ അമർത്തിപ്പിടിക്കുക';

  @override
  String get profileHelpEntry => 'സഹായം';

  @override
  String get helpTitle => 'സഹായം';

  @override
  String get helpBody =>
      'ചെറിയ ഉത്തരങ്ങൾ, വായിച്ചു കേൾപ്പിക്കും. കേൾക്കാൻ ഏതിലെങ്കിലും അമർത്തുക.';

  @override
  String get helpSteps => 'ഇങ്ങനെ ചെയ്യുക';

  @override
  String get helpTopicPhotos => 'നല്ല ഫോട്ടോ എടുക്കൽ';

  @override
  String get helpTopicPhotosBody =>
      'നല്ല ഫോട്ടോകൾ വിൽക്കും. വാങ്ങുന്നവർക്ക് സാധനം കയ്യിലെടുക്കാൻ കഴിയില്ല, ഫോട്ടോ മാത്രമേ അവർക്കുള്ളൂ.';

  @override
  String get helpTopicPhotosStep1 =>
      'പകൽവെളിച്ചം സാധനത്തിൽ വീഴാൻ വാതിലിനോ ജനലിനോ അടുത്ത് നിൽക്കുക';

  @override
  String get helpTopicPhotosStep2 =>
      'ചുറ്റും മറ്റൊന്നുമില്ലാതെ സാധനം ഒരു സാധാരണ തുണിയിൽ വയ്ക്കുക';

  @override
  String get helpTopicPhotosStep3 =>
      'ഫോട്ടോ എടുക്കുന്നതുവരെ രണ്ട് കൈകൊണ്ടും ഫോൺ അനങ്ങാതെ പിടിക്കുക';

  @override
  String get helpTopicPhotosStep4 => 'പണി കാണാൻ അടുത്തുനിന്ന് ഒന്ന് എടുക്കുക';

  @override
  String get helpTopicPhotosStep5 =>
      'വലിപ്പം മനസ്സിലാകാൻ ഒരു ഫോട്ടോയിൽ അരികിൽ കൈ വയ്ക്കുക';

  @override
  String get helpTopicVoice => 'നിങ്ങളുടെ സാധനത്തെക്കുറിച്ച് എന്ത് പറയണം';

  @override
  String get helpTopicVoiceBody =>
      'മുന്നിൽ നിൽക്കുന്ന ഒരു ഉപഭോക്താവിനോട് പറയുന്നതുപോലെ പറയുക. പറയുന്നതിന് തെറ്റായ രീതിയില്ല.';

  @override
  String get helpTopicVoiceStep1 => 'ഇത് എന്താണെന്ന് പറയുക';

  @override
  String get helpTopicVoiceStep2 => 'ഇത് എന്തുകൊണ്ട് ഉണ്ടാക്കിയെന്ന് പറയുക';

  @override
  String get helpTopicVoiceStep3 =>
      'ഇഞ്ചിലോ അടിയിലോ ഇത് എത്ര വലുതാണെന്ന് പറയുക';

  @override
  String get helpTopicVoiceStep4 => 'ഉണ്ടാക്കാൻ എത്ര സമയമെടുത്തുവെന്ന് പറയുക';

  @override
  String get helpTopicVoiceStep5 => 'ഇതിന് നിങ്ങൾക്ക് എത്ര വേണമെന്ന് പറയുക';

  @override
  String get helpTopicPrice => 'വില നിശ്ചയിക്കൽ';

  @override
  String get helpTopicPriceBody =>
      'നിങ്ങളുടെ വിലയിൽ സാമഗ്രികളുടെ ചെലവും നിങ്ങളുടെ സമയത്തിന്റെ മൂല്യവും ഉൾപ്പെടണം. ഞങ്ങൾ നിങ്ങളോടൊപ്പം അത് കണക്കാക്കുന്നു, പറയാതെ അതിനു താഴെ പോകാൻ ഒരിക്കലും അനുവദിക്കില്ല.';

  @override
  String get helpTopicPriceStep1 =>
      'സാമഗ്രികൾക്ക് എത്ര ചെലവായി എന്ന് കണക്കാക്കുക';

  @override
  String get helpTopicPriceStep2 =>
      'പണിക്ക് എത്ര ദിവസമെടുത്തു എന്ന് കണക്കാക്കുക';

  @override
  String get helpTopicPriceStep3 =>
      'ഞങ്ങൾ നിർദ്ദേശിക്കുന്നത് നോക്കുക, നിങ്ങൾക്ക് കൂടുതൽ അറിയാമെങ്കിൽ മാറ്റുക';

  @override
  String get helpTopicPriceStep4 =>
      'നിങ്ങളുടെ ചെലവിനേക്കാൾ കുറവാണെങ്കിൽ ഞങ്ങൾ പറയും, പക്ഷേ തീരുമാനം നിങ്ങളുടേതാണ്';

  @override
  String get helpTopicSold => 'വിറ്റശേഷം എന്ത് സംഭവിക്കുന്നു';

  @override
  String get helpTopicSoldBody =>
      'വാങ്ങുന്നയാൾ മാർക്കറ്റിൽ പണം നൽകുന്നു. നിങ്ങൾ പാക്ക് ചെയ്ത് കൈമാറുന്നു, പണം നിങ്ങൾക്ക് വരുന്നു.';

  @override
  String get helpTopicSoldStep1 => 'വിറ്റാലുടൻ ഞങ്ങൾ നിങ്ങളെ അറിയിക്കും';

  @override
  String get helpTopicSoldStep2 =>
      'എന്ത്, എത്ര പാക്ക് ചെയ്യണമെന്ന് തുറന്നു നോക്കുക';

  @override
  String get helpTopicSoldStep3 =>
      'ഞങ്ങൾ കാണിക്കുന്ന തീയതിക്ക് മുമ്പ് പാക്ക് ചെയ്യുക';

  @override
  String get helpTopicSoldStep4 => 'കൊണ്ടുപോകാൻ വരുന്നയാൾക്ക് കൈമാറുക';

  @override
  String get helpTopicSoldStep5 => 'അതിനുശേഷം പണം നിങ്ങളിലെത്തും';

  @override
  String get helpVideoComing => 'ഇതിനായി ഒരു ചെറിയ വീഡിയോ ഉടൻ വരുന്നു.';

  @override
  String get helpPractice => 'നല്ല ഫോട്ടോ എങ്ങനെ എടുക്കാം';

  @override
  String get helpPracticeBody =>
      'ഒരേ കലത്തിന്റെ ഒരു നല്ല ഫോട്ടോയും ഒരു മോശം ഫോട്ടോയും.';

  @override
  String get helpFaqEntry => 'ആളുകൾ ചോദിക്കുന്ന ചോദ്യങ്ങൾ';

  @override
  String get helpAboutEntry => 'കീർത്തികറിനെക്കുറിച്ച്';

  @override
  String get helpSupportEntry => 'ഒരാളോട് സംസാരിക്കുക';

  @override
  String get helpTermsEntry => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get faqTitle => 'ആളുകൾ ചോദിക്കുന്ന ചോദ്യങ്ങൾ';

  @override
  String get faqQ1 => 'ഇതിന് എനിക്ക് എന്തെങ്കിലും ചെലവുണ്ടോ?';

  @override
  String get faqA1 =>
      'ഇല്ല. സാധനങ്ങൾ വയ്ക്കുന്നത് സൗജന്യമാണ്. എന്തെങ്കിലും വിറ്റാൽ മാത്രമേ മാർക്കറ്റ് ചെറിയൊരു പങ്ക് എടുക്കൂ.';

  @override
  String get faqQ2 => 'നെറ്റ്‌വർക്ക് ഇല്ലെങ്കിലോ?';

  @override
  String get faqA2 =>
      'എല്ലാം പ്രവർത്തിച്ചുകൊണ്ടിരിക്കും. നിങ്ങൾ ഉണ്ടാക്കുന്നത് ഫോണിൽ സൂക്ഷിക്കും, നെറ്റ്‌വർക്ക് വരുമ്പോൾ സ്വയം അയയ്ക്കും.';

  @override
  String get faqQ3 => 'എന്റെ പണം ആർക്ക് കിട്ടും?';

  @override
  String get faqA3 =>
      'നിങ്ങൾക്ക്. വാങ്ങുന്നയാൾ മാർക്കറ്റിൽ പണം നൽകുന്നു, അത് നിങ്ങളുടെ അക്കൗണ്ടിലേക്ക് വരുന്നു. പണം ഒരിക്കലും ഞങ്ങളിലൂടെ പോകില്ല.';

  @override
  String get faqQ4 => 'വിൽപ്പനയ്ക്ക് വച്ചശേഷം എന്തെങ്കിലും മാറ്റാമോ?';

  @override
  String get faqA4 =>
      'അതെ. നിങ്ങളുടെ സാധനങ്ങളിൽ നിന്ന് തുറക്കുക, വേണ്ടത് മാറ്റുക, അത് വീണ്ടും വിൽപ്പനയ്ക്ക് പോകും.';

  @override
  String get faqQ5 => 'ഞാൻ എന്തെങ്കിലും തെറ്റായി പറഞ്ഞാലോ?';

  @override
  String get faqA5 =>
      'നിങ്ങൾ കേട്ട് ശരിയാണെന്ന് പറയുന്നതുവരെ ഒന്നും വിൽപ്പനയ്ക്ക് പോകില്ല. ഏത് ഭാഗവും പറഞ്ഞ് തിരുത്താം.';

  @override
  String get faqQ6 => 'എനിക്ക് എഴുതാനും വായിക്കാനും അറിയണോ?';

  @override
  String get faqA6 =>
      'വേണ്ട. നിങ്ങൾക്ക് എല്ലാം പറഞ്ഞും അമർത്തിയും ചെയ്യാം. ഓരോ സ്ക്രീനും നിങ്ങളെ വായിച്ചു കേൾപ്പിക്കാം.';

  @override
  String get faqQ7 => 'എന്റെ പേരും ഗ്രാമവും ആര് കാണും?';

  @override
  String get faqA7 =>
      'നിങ്ങൾ അനുവദിച്ചാൽ മാത്രം, ഓരോ സാധനത്തിനും വെവ്വേറെ. എപ്പോൾ വേണമെങ്കിലും തിരിച്ചെടുക്കാം.';

  @override
  String get aboutTitle => 'കീർത്തികറിനെക്കുറിച്ച്';

  @override
  String get aboutWhatTitle => 'ഇത് എന്താണ്';

  @override
  String get aboutWhat =>
      'കീർത്തികർ കൈകൊണ്ട് ഉണ്ടാക്കിയ സാധനങ്ങൾ ONDC-യിൽ, ഇന്ത്യയുടെ തുറന്ന വാങ്ങൽ-വിൽപ്പന ശൃംഖലയിൽ, എത്തിക്കുന്നു, അതിന് ഉണ്ടാക്കുന്നയാൾ ടൈപ്പ് ചെയ്യേണ്ട, സംസാരിച്ചാൽ മതി. നിങ്ങളുടെ സ്വന്തം ഭാഷയിലുള്ള ഫോട്ടോകളും ഒരു ശബ്ദസന്ദേശവും രാജ്യമെമ്പാടുമുള്ള വാങ്ങുന്നവർക്ക് കണ്ടെത്താവുന്ന ഒരു ലിസ്റ്റിംഗ് ആകുന്നു.';

  @override
  String get aboutWhyTitle => 'ഞങ്ങൾ ഇത് എന്തിന് ഉണ്ടാക്കി';

  @override
  String get aboutWhy =>
      'ഇന്ത്യയിൽ ഏകദേശം എഴുപത് ലക്ഷം കരകൗശല വിദഗ്ധർ ആളുകൾ വാങ്ങാൻ ആഗ്രഹിക്കുന്ന സാധനങ്ങൾ ഉണ്ടാക്കുന്നു, അവരിൽ മിക്കവരും ലാഭവ്യത്യാസം കൈക്കലാക്കുന്ന ഇടനിലക്കാരിലൂടെ വിൽക്കുന്നു. തടസ്സം പണിയിലല്ല. ഫോമിലാണ്: ഓൺലൈൻ ലിസ്റ്റിംഗിന് ഇംഗ്ലീഷിൽ ടൈപ്പിംഗ്, ഒരുപാട് കോളങ്ങൾ, കാറ്റലോഗ് പോലെ എടുത്ത ഫോട്ടോ എന്നിവ വേണം. ഈ ആപ്പ് ആ ഫോം തന്നെ ഒഴിവാക്കുന്നു.';

  @override
  String get aboutHowTitle => 'ഇത് എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get aboutHow =>
      'മൂന്ന് ഫോട്ടോ എടുത്ത് ഇത് എന്താണെന്ന് പറയുക. ഞങ്ങളുടെ സംവിധാനം കേൾക്കുന്നു, ലിസ്റ്റിംഗ് എഴുതുന്നു, നിങ്ങളെ വായിച്ചു കേൾപ്പിക്കുന്നു. നിങ്ങൾ കേട്ട് ശരിയാണെന്ന് പറയുന്നതുവരെ ഒന്നും പുറത്തുപോകില്ല.';

  @override
  String get aboutSihTitle => 'സ്മാർട്ട് ഇന്ത്യ ഹാക്കത്തോൺ 2025';

  @override
  String get aboutSih =>
      'പ്രശ്നം 090-നായി നിർമ്മിച്ചത്: കരകൗശല വിദഗ്ധരെയും നെയ്ത്തുകാരെയും ONDC-യിൽ വാങ്ങുന്നവരിലേക്ക് എത്താൻ സഹായിക്കൽ.';

  @override
  String get aboutMissionTitle => 'ഞങ്ങൾ എന്ത് ചെയ്യാൻ ശ്രമിക്കുന്നു';

  @override
  String get aboutMission =>
      'ഒരു പണിയുടെ വില അത് ഉണ്ടാക്കിയ ആളുടെ കൈയിൽ തന്നെ ആകണം.';

  @override
  String get supportTitle => 'ഒരാളോട് സംസാരിക്കുക';

  @override
  String get supportBody =>
      'എന്തെങ്കിലും പ്രവർത്തിക്കുന്നില്ലെങ്കിൽ, അല്ലെങ്കിൽ എന്ത് ചെയ്യണമെന്ന് അറിയില്ലെങ്കിൽ, ഞങ്ങളെ വിളിക്കുക. ഒരാൾ നിങ്ങളുടെ ഭാഷയിൽ മറുപടി നൽകും.';

  @override
  String get supportCall => 'ഞങ്ങളെ വിളിക്കുക';

  @override
  String get supportWhatsApp => 'വാട്ട്‌സ്ആപ്പിൽ സന്ദേശം അയയ്ക്കുക';

  @override
  String get supportHours =>
      'എല്ലാ ദിവസവും, രാവിലെ ഒൻപത് മുതൽ വൈകുന്നേരം ഏഴ് വരെ.';

  @override
  String supportNumber(String number) {
    return 'ഞങ്ങളുടെ നമ്പർ $number';
  }

  @override
  String supportFailed(String number) {
    return 'നിങ്ങളുടെ ഫോണിന് അത് തുറക്കാനായില്ല. ഞങ്ങളുടെ നമ്പർ $number.';
  }

  @override
  String get termsTitle => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get termsSummaryTitle => 'ചുരുക്കത്തിൽ';

  @override
  String get termsSummary1 =>
      'നിങ്ങൾ ഉണ്ടാക്കുന്നത് നിങ്ങളുടേതാണ്. ഞങ്ങൾ നിങ്ങൾക്കായി അത് വിൽപ്പനയ്ക്ക് വയ്ക്കുന്നു, വിൽപ്പനയിൽ നിന്ന് ഒന്നും എടുക്കുന്നില്ല.';

  @override
  String get termsSummary2 =>
      'നിങ്ങളുടെ ഫോട്ടോകളും ശബ്ദവും നിങ്ങളുടെ ലിസ്റ്റിംഗ് എഴുതാൻ മാത്രം ഉപയോഗിക്കുന്നു, മറ്റൊന്നിനുമല്ല.';

  @override
  String get termsSummary3 =>
      'നിങ്ങളുടെ പേര്, ഗ്രാമം, കഥ എന്നിവ നിങ്ങൾ അനുവദിച്ച സാധനങ്ങളിൽ മാത്രം പോകും, നിങ്ങൾക്ക് അത് തിരിച്ചെടുക്കാം.';

  @override
  String get termsSummary4 =>
      'പണം വാങ്ങുന്നയാളിൽ നിന്ന് നേരിട്ട് നിങ്ങൾക്ക് പോകുന്നു. ഒരിക്കലും ഞങ്ങളിലൂടെ പോകില്ല.';

  @override
  String get termsSummary5 =>
      'എപ്പോൾ വേണമെങ്കിലും ഈ ഫോണിൽ നിന്ന് എല്ലാം മായ്ക്കാം.';

  @override
  String get termsFullTitle => 'മുഴുവൻ വാചകം';

  @override
  String get termsFullBody =>
      'ഉപയോഗത്തിന്റെ പൂർണ്ണ നിബന്ധനകളും സ്വകാര്യതാ നയവും ഞങ്ങളുടെ വെബ്സൈറ്റിലുണ്ട്. ഇവിടെ എന്തെങ്കിലും വ്യക്തമല്ലെങ്കിൽ ഞങ്ങളെ വിളിക്കുക, ഒരാൾ വിശദീകരിക്കും.';

  @override
  String get termsOpenFull => 'മുഴുവൻ വാചകം വായിക്കുക';

  @override
  String get termsAgreeTitle => 'തുടങ്ങുന്നതിനു മുൻപ്';

  @override
  String get termsAgreeBody =>
      'ഇവയ്ക്കാണ് നിങ്ങൾ സമ്മതം നൽകുന്നത്. കേൾക്കാൻ സ്പീക്കർ അമർത്തുക.';

  @override
  String get termsAgreeCheck => 'ഞാൻ നിബന്ധനകൾ അംഗീകരിക്കുന്നു';

  @override
  String get termsAgreeContinue => 'തുടരുക';

  @override
  String get termsAgreeNeeded =>
      'ആദ്യം “ഞാൻ നിബന്ധനകൾ അംഗീകരിക്കുന്നു” ടിക്ക് ചെയ്യുക.';

  @override
  String versionNumber(String version) {
    return 'പതിപ്പ് $version';
  }

  @override
  String get versionCheck => 'പുതിയ പതിപ്പ് നോക്കുക';

  @override
  String get versionLicences => 'ലൈസൻസുകൾ';

  @override
  String get versionLicencesWhy =>
      'ഈ ആപ്പ് നിർമ്മിച്ചിരിക്കുന്ന സൗജന്യ സോഫ്റ്റ്‌വെയർ.';

  @override
  String get noNetworkTitle => 'നെറ്റ്‌വർക്ക് ഇല്ല';

  @override
  String get noNetworkBody =>
      'നിങ്ങൾക്ക് ജോലി തുടരാം. എല്ലാം ഫോണിൽ സൂക്ഷിക്കും, നെറ്റ്‌വർക്ക് വരുമ്പോൾ സ്വയം പോകും.';

  @override
  String get noNetworkNeeded =>
      'ഈ ഒരു കാര്യത്തിന് നെറ്റ്‌വർക്ക് വേണം. സിഗ്നൽ ഉള്ളപ്പോൾ വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get serverErrorTitle => 'ഞങ്ങളുടെ ഭാഗത്ത് എത്താനായില്ല';

  @override
  String get serverErrorBody =>
      'നിങ്ങൾ ചെയ്തതൊന്നും നഷ്ടപ്പെട്ടിട്ടില്ല. ദയവായി അൽപ്പം കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get actionTryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get permissionRecoveryTitle => 'ആപ്പിന് നിങ്ങളുടെ അനുമതി വേണം';

  @override
  String get permissionRecoveryBody =>
      'ഫോൺ ഇവ ഉപയോഗിക്കാൻ ആപ്പിനെ അനുവദിക്കുന്നില്ല. ഫോണിന്റെ സെറ്റിംഗ്സിൽ ഇവ ഓൺ ചെയ്ത് ഇവിടെ തിരികെ വരാം.';

  @override
  String get permissionCameraWhy =>
      'നിങ്ങൾ ഉണ്ടാക്കിയതിന്റെ ഫോട്ടോ എടുക്കാൻ. ഇതില്ലാതെ ഒന്നും വിൽപ്പനയ്ക്ക് വയ്ക്കാനാവില്ല.';

  @override
  String get permissionMicWhy =>
      'ടൈപ്പ് ചെയ്യുന്നതിനു പകരം സംസാരിക്കാൻ. ഇതില്ലാതെ എല്ലാം ടൈപ്പ് ചെയ്യേണ്ടിവരും.';

  @override
  String get permissionNotifyTitle => 'അറിയിപ്പുകൾ';

  @override
  String get permissionNotifyWhy =>
      'എന്തെങ്കിലും വിറ്റാൽ ഞങ്ങൾക്ക് അറിയിക്കാൻ. ഇതില്ലാതെ അറിയാൻ നിങ്ങൾ ആപ്പ് തുറക്കേണ്ടിവരും.';

  @override
  String get permissionBlocked => 'അനുവദിച്ചിട്ടില്ല';

  @override
  String get permissionAsk => 'വീണ്ടും ചോദിക്കുക';

  @override
  String get permissionRecheck => 'ഞാൻ ഓൺ ചെയ്തു';

  @override
  String get permissionAllGood => 'ആപ്പിന് വേണ്ടതെല്ലാം അനുവദിച്ചിട്ടുണ്ട്.';

  @override
  String get updateTitle => 'ദയവായി ആപ്പ് അപ്ഡേറ്റ് ചെയ്യുക';

  @override
  String get updateBody =>
      'ഈ പതിപ്പിന് ഇനി ഞങ്ങളുമായി സംസാരിക്കാനാവില്ല. സ്റ്റോറിൽ പുതിയ പതിപ്പുണ്ട്, അപ്ഡേറ്റ് ചെയ്താലും നിങ്ങളുടെ ഫോണിലുള്ളതെല്ലാം അതേപടി ഉണ്ടാകും.';

  @override
  String get updateAction => 'പുതിയ പതിപ്പ് നേടുക';

  @override
  String get updateFailed =>
      'സ്റ്റോർ തുറന്നില്ല. അവിടെ കീർത്തികർ എന്ന് തിരയുക.';

  @override
  String get emptyNudge => 'ഹോമിലെ വലിയ ബട്ടൺ അമർത്തി ആദ്യത്തെ സാധനം ചേർക്കുക.';

  @override
  String get productsInProgress => 'തയ്യാറാകുന്നു';

  @override
  String get productsListed => 'വിൽപ്പനയിൽ';

  @override
  String get productsSold => 'വിറ്റുപോയി';

  @override
  String get voiceTypeInstead => 'എഴുതി പറയുക';

  @override
  String get voiceSpeakInstead => 'സംസാരിച്ച് പറയുക';

  @override
  String get voiceTypeTitle => 'ഇനി ഇത് എന്താണെന്ന് എഴുതുക';

  @override
  String get voiceTypeHint => 'ഇവിടെ എഴുതുക…';

  @override
  String get voiceTypeSave => 'ഈ വിവരണം ഉപയോഗിക്കുക';

  @override
  String get errorNotAllowed =>
      'ഈ അക്കൗണ്ടിന് ഇത് ചെയ്യാൻ കഴിയില്ല. സഹായത്തിന് ഞങ്ങളെ വിളിക്കുക.';

  @override
  String get errorNotFound => 'ഇത് ഇപ്പോൾ ഇവിടെ ഇല്ല.';

  @override
  String get errorConflict =>
      'ഇത് മറ്റെവിടെയോ മാറ്റിയിരിക്കുന്നു. ദയവായി വീണ്ടും തുറന്ന് ഒരിക്കൽ കൂടി ശ്രമിക്കുക.';

  @override
  String get errorInvalid =>
      'ചില വിവരങ്ങൾ സ്വീകരിച്ചില്ല. ദയവായി പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get voiceGuideTitle => 'ഇവയെക്കുറിച്ച് പറയാം';

  @override
  String get voiceGuideWhat => 'സാധനത്തിന്റെ പേര്';

  @override
  String get voiceGuideSize => 'ഉയരം';

  @override
  String get voiceGuideColour => 'നിറം';

  @override
  String get voiceGuideTime => 'ഉണ്ടാക്കാൻ എടുത്ത സമയം';

  @override
  String get voiceGuideCost => 'സാമഗ്രികളുടെ ചെലവ്';
}
