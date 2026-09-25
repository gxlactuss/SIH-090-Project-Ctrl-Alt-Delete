import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'કીર્તિકર';

  @override
  String get actionNext => 'આગળ';

  @override
  String get actionBack => 'પાછળ';

  @override
  String get actionSkip => 'છોડો';

  @override
  String get actionDone => 'થઈ ગયું';

  @override
  String get actionListen => 'સાંભળો';

  @override
  String get actionStopListening => 'રોકો';

  @override
  String stepOfSteps(int current, int total) {
    return 'પગલું $current, કુલ $total';
  }

  @override
  String get splashTagline => 'બોલો, અને તમારી વસ્તુ વેચાઈ જશે';

  @override
  String get languageTitle => 'તમારી ભાષા પસંદ કરો';

  @override
  String get languageHint => 'તમે જે ભાષા બોલો છો તેના પર દબાવો';

  @override
  String get welcomeCard1Title => 'ત્રણ ફોટા પાડો';

  @override
  String get welcomeCard1Body =>
      'તમે બનાવેલી વસ્તુના ત્રણ ફોટા પાડો. કેવી રીતે પાડવા તે ઍપ બતાવશે.';

  @override
  String get welcomeCard2Title => 'બોલીને કહો';

  @override
  String get welcomeCard2Body =>
      'આ શું છે, શેનું બનેલું છે, કિંમત કેટલી, બસ બોલી દો. લખવાની જરૂર નથી.';

  @override
  String get welcomeCard3Title => 'તે વેચાણ પર જાય છે';

  @override
  String get welcomeCard3Body =>
      'પહેલાં તમને વાંચીને સંભળાવવામાં આવશે. તમે હા કહેશો ત્યારે જ તે ઓનલાઇન જશે.';

  @override
  String get welcomeStart => 'શરૂ કરો';

  @override
  String get permissionsTitle => 'ઍપને ત્રણ વસ્તુની પરવાનગી જોઈએ';

  @override
  String get permissionCameraTitle => 'કૅમેરા';

  @override
  String get permissionCameraBody =>
      'તમારી વસ્તુના ફોટા પાડવા માટે. તમે હા ન કહો ત્યાં સુધી ફોટા તમારા ફોનમાં જ રહે છે.';

  @override
  String get permissionMicTitle => 'માઇક';

  @override
  String get permissionMicBody => 'જેથી તમે લખવાને બદલે બોલીને કહી શકો.';

  @override
  String get permissionNotificationTitle => 'સૂચનાઓ';

  @override
  String get permissionNotificationBody =>
      'કંઈ વેચાય કે તરત તમને જણાવી શકીએ એ માટે.';

  @override
  String get permissionAllow => 'પરવાનગી આપો';

  @override
  String get permissionNotNow => 'હમણાં નહીં';

  @override
  String get permissionGranted => 'પરવાનગી છે';

  @override
  String get permissionDeniedTitle => 'પરવાનગી મળી નથી';

  @override
  String get permissionDeniedBody =>
      'આના વગર આ નહીં ચાલે. ફોનના સેટિંગ્સમાં જઈને પરવાનગી આપો.';

  @override
  String get permissionOpenSettings => 'સેટિંગ્સ ખોલો';

  @override
  String get phoneTitle => 'તમારો ફોન નંબર';

  @override
  String get phoneWhy =>
      'અમે આ નંબર પર એક કોડ મોકલીશું. આ નંબર બીજા કોઈને આપવામાં આવતો નથી.';

  @override
  String get phoneInvalid => 'દસ અંકનો નંબર લખો';

  @override
  String get phoneSendCode => 'કોડ મોકલો';

  @override
  String get otpTitle => 'આવેલો કોડ લખો';

  @override
  String otpSentTo(String number) {
    return '$number પર મોકલ્યો';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds સેકન્ડ પછી ફરી મોકલો';
  }

  @override
  String get otpResend => 'કોડ ફરી મોકલો';

  @override
  String get otpWrong => 'કોડ સાચો નથી. ફરી લખો.';

  @override
  String get phoneSendFailed =>
      'કોડ મોકલી શકાયો નહીં. નેટવર્ક તપાસો અને ફરી પ્રયત્ન કરો.';

  @override
  String get otpExpired => 'કોડનો સમય પૂરો થઈ ગયો. ફરી મોકલો.';

  @override
  String get authTooManyTries =>
      'ઘણી વાર પ્રયત્ન થયો. થોડી વાર પછી ફરી પ્રયત્ન કરો.';

  @override
  String get otpChangeNumber => 'નંબર બદલો';

  @override
  String get otpAutoRead => 'સંદેશ આપમેળે વંચાઈ ગયો';

  @override
  String get profileTitle => 'તમારા વિશે જણાવો';

  @override
  String get profileNameLabel => 'તમારું નામ';

  @override
  String get profileNameHint => 'બોલીને કહો અથવા લખો';

  @override
  String get profileNameMissing => 'તમારું નામ કહો';

  @override
  String get profileCraftLabel => 'તમે શું બનાવો છો';

  @override
  String get profileCraftMissing => 'એક પસંદ કરો';

  @override
  String get profileSpeakToFill => 'બોલીને કહો';

  @override
  String get profileListening => 'સાંભળીએ છીએ…';

  @override
  String get dictationUnavailable =>
      'આ ફોન પર બોલીને લખવાનું ચાલતું નથી. કૃપા કરીને લખો.';

  @override
  String get dictationNothingHeard =>
      'કંઈ સંભળાયું નહીં. માઇક દબાવીને ફરી બોલો.';

  @override
  String get craftWeaving => 'વણાટ';

  @override
  String get craftPottery => 'માટીકામ';

  @override
  String get craftWoodwork => 'લાકડાકામ';

  @override
  String get craftMetalwork => 'ધાતુકામ';

  @override
  String get craftJewellery => 'ઘરેણાં';

  @override
  String get craftEmbroidery => 'ભરતકામ';

  @override
  String get craftPainting => 'ચિત્રકામ';

  @override
  String get craftLeather => 'ચામડાનું કામ';

  @override
  String get craftBamboo => 'વાંસ અને નેતર';

  @override
  String get craftOther => 'બીજું કંઈક';

  @override
  String get ondcTitle => 'તમારું ONDC ખાતું જોડો';

  @override
  String get ondcExplain =>
      'ONDC એ જગ્યા છે જ્યાં ગ્રાહકો તમારી વસ્તુ જુએ છે અને ખરીદે છે. પૈસા સીધા તમને મળે છે, અમારી પાસે થઈને નહીં.';

  @override
  String get ondcMalformed =>
      'આ સેલર આઈડી જેવું લાગતું નથી. કૃપા કરીને તપાસો, અથવા કોડ ફરી સ્કેન કરો.';

  @override
  String get ondcEmailLabel => 'ONDC ઇમેઇલ';

  @override
  String get ondcEmailMalformed =>
      'આ ઇમેઇલ સરનામું હોય એવું લાગતું નથી. કૃપા કરીને તે તપાસો.';

  @override
  String get ondcSellerIdLabel => 'વેચનાર આઇડી';

  @override
  String get ondcScan => 'QR કોડ સ્કૅન કરો';

  @override
  String get ondcLink => 'ખાતું જોડો';

  @override
  String get ondcLinking => 'જોડી રહ્યા છીએ…';

  @override
  String get ondcFailed => 'આ ખાતું મળ્યું નહીં. ફરી તપાસો.';

  @override
  String get ondcNoAccount => 'મારી પાસે હજી ખાતું નથી';

  @override
  String get ondcNoAccountExplain =>
      'કોઈ વાંધો નહીં. તમે વસ્તુઓ તૈયાર કરી રાખી શકો છો. ખાતું જોડાતાં જ બધું એકસાથે મોકલાઈ જશે.';

  @override
  String get practiceTitle => 'સારો ફોટો કેવી રીતે લેવો';

  @override
  String get practiceIntro =>
      'એક જ માટલું, એક વાર સારી રીતે અને એક વાર ખરાબ રીતે લીધેલું. બંને જોવા સરકાવો.';

  @override
  String get practiceGoodBadge => 'આવું કરો';

  @override
  String get practiceGoodTitle => 'સારો ફોટો';

  @override
  String get practiceGoodTip1 => 'સ્પષ્ટ: ફોન સ્થિર રાખ્યો હતો';

  @override
  String get practiceGoodTip2 => 'અજવાળું: બારી કે દરવાજા પાસે લીધેલો';

  @override
  String get practiceGoodTip3 => 'આખી વસ્તુ ફોટામાં છે';

  @override
  String get practiceBadBadge => 'આવું ન કરો';

  @override
  String get practiceBadTitle => 'ખરાબ ફોટો';

  @override
  String get practiceBadTip1 => 'ઝાંખો: ફોન હલી ગયો';

  @override
  String get practiceBadTip2 => 'ખરીદનાર બારીકાઈ જોઈ શકતા નથી';

  @override
  String get practiceBadTip3 => 'એપ તમને ફરીથી ફોટો લેવા કહેશે';

  @override
  String get practiceFinish => 'ઍપ ખોલો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navListings => 'વસ્તુઓ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String homeGreeting(String name) {
    return 'નમસ્તે, $name';
  }

  @override
  String get homeAddProduct => 'વસ્તુ ઉમેરો';

  @override
  String get homeAddProductSpoken =>
      'વસ્તુ ઉમેરવા આ મોટું બટન દબાવો. ત્રણ ફોટા પાડો, બોલીને કહો કે તે શું છે, અને તે વેચાણ પર જશે.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વસ્તુઓ મોકલવાની બાકી છે',
      one: '1 વસ્તુ મોકલવાની બાકી છે',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વેચાઈ',
      one: '1 વેચાઈ',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'તમારી તાજેતરની વસ્તુઓ';

  @override
  String get homeNextTitle => 'હવે આ કરવાનું છે';

  @override
  String get homeEmptyTitle => 'અહીં હજી કંઈ નથી';

  @override
  String get homeEmptyBody =>
      'ઉપરનું મોટું બટન દબાવીને તમારી પહેલી વસ્તુ ઉમેરો.';

  @override
  String get offlineNoNetwork => 'અત્યારે નેટવર્ક નથી';

  @override
  String get offlineNothingLost =>
      'કંઈ ખોવાયું નથી. નેટવર્ક આવતાં જ તે આપમેળે જશે.';

  @override
  String get statusQueued => 'મોકલવાનું બાકી';

  @override
  String get statusProcessing => 'તૈયાર થઈ રહ્યું છે';

  @override
  String get statusNeedsAttention => 'તમારો જવાબ જોઈએ';

  @override
  String get statusReady => 'વેચાણ માટે તૈયાર';

  @override
  String get statusPublished => 'વેચાણ પર છે';

  @override
  String get statusFailed => 'મોકલી શકાયું નહીં';

  @override
  String get listingUntitled => 'વસ્તુ';

  @override
  String get listingNoPrice => 'કિંમત કહી નથી';

  @override
  String get captureTitle => 'વસ્તુ ઉમેરો';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ફોટો $current / $total';
  }

  @override
  String get capturePhotoWhole => 'આખી વસ્તુ બતાવો';

  @override
  String get capturePhotoDetail => 'નજીકથી એક ફોટો પાડો';

  @override
  String get capturePhotoScale => 'બાજુમાં હાથ મૂકો, જેથી માપ ખબર પડે';

  @override
  String get captureTakePhoto => 'ફોટો પાડો';

  @override
  String get captureFromGallery => 'ગૅલેરીમાંથી પસંદ કરો';

  @override
  String get captureTorchOn => 'લાઇટ ચાલુ';

  @override
  String get captureTorchOff => 'લાઇટ બંધ';

  @override
  String get captureCameraFailed => 'કૅમેરા ખૂલ્યો નહીં';

  @override
  String get captureCameraRetry => 'ફરી પ્રયત્ન કરો';

  @override
  String get captureCameraPermission =>
      'તમારી વસ્તુના ફોટા પાડવા ઍપને કૅમેરા જોઈએ.';

  @override
  String get captureOpenSettings => 'સેટિંગ્સ ખોલો';

  @override
  String get captureLeaveTitle => 'સાચવ્યા વગર બહાર જવું છે?';

  @override
  String get captureLeaveBody => 'ફોટા અને તમે જે કહ્યું તે ભૂંસાઈ જશે.';

  @override
  String get captureLeaveConfirm => 'ભૂંસી નાખો';

  @override
  String get captureLeaveCancel => 'અહીં જ રહો';

  @override
  String get shotReviewChecking => 'ફોટો તપાસી રહ્યા છીએ…';

  @override
  String get shotReviewRetake => 'ફરી પાડો';

  @override
  String get qualityTooDark =>
      'આ ફોટો બહુ અંધારો છે. દરવાજા પાસે ઊભા રહીને પાડો.';

  @override
  String get qualityTooBright =>
      'આના પર બહુ પ્રકાશ છે. તડકા તરફ પીઠ કરીને પાડો.';

  @override
  String get qualityBlurry => 'આ ફોટો સ્પષ્ટ નથી. ફોન સ્થિર રાખીને ફરી પાડો.';

  @override
  String get qualityUnreadable =>
      'આ ફોટો બરાબર સચવાયો નહીં. કૃપા કરીને ફરી પાડો.';

  @override
  String get qualityNoSubject =>
      'આ ફોટામાં વસ્તુ દેખાતી નથી. તેને ખાનાની અંદર રાખો અને નજીક આવો.';

  @override
  String get qualityOutOfFrame =>
      'આ ફોટામાં વસ્તુનો ફક્ત એક ભાગ છે. આખી વસ્તુ ખાનાની અંદર રાખો.';

  @override
  String get qualityWarningTitle => 'આ ફરી પાડો';

  @override
  String get qualityKeepAnyway => 'તો પણ રાખો';

  @override
  String get photoSetTitle => 'તમારા ત્રણ ફોટા';

  @override
  String get photoSetBody =>
      'પહેલો ફોટો ખરીદનાર સૌથી પહેલાં જુએ છે. કોઈ ફોટો ફરી પાડવા તેના પર દબાવો.';

  @override
  String get photoSetMain => 'પહેલો ફોટો';

  @override
  String get photoSetRetakeThis => 'આ ફરી પાડો';

  @override
  String get photoSetConfirm => 'આ ફોટા બરાબર છે';

  @override
  String get photoEditOpen => 'ફોટો કાપો અથવા ફેરવો';

  @override
  String get photoEditTitle => 'ફોટો કાપો';

  @override
  String get photoEditBody =>
      'કાપવા માટે ચોકઠાનો ખૂણો કે કિનારી ખેંચો. ખસેડવા માટે ચોકઠાની અંદરથી ખેંચો.';

  @override
  String get photoEditTurn => 'ફેરવો';

  @override
  String get photoEditStraighten => 'સીધો કરો';

  @override
  String get photoEditReset => 'ફરી શરૂ કરો';

  @override
  String get photoEditDone => 'આ ફોટો વાપરો';

  @override
  String get photoEditCancel => 'પાછા જાઓ';

  @override
  String get photoEditFailed => 'આ ફેરફાર સાચવી શકાયો નહીં. ફરી પ્રયત્ન કરો.';

  @override
  String get photoIssueTooDark => 'બહુ અંધારો, બરાબર દેખાતો નથી';

  @override
  String get photoIssueTooBright => 'આના પર બહુ પ્રકાશ છે';

  @override
  String get photoIssueBlurry => 'ઝાંખો, પૂરતો સ્પષ્ટ નથી';

  @override
  String get photoIssueNoSubject => 'આ ફોટામાં કોઈ વસ્તુ દેખાતી નથી';

  @override
  String get photoIssueUnreadable => 'આ ફોટો સચવાયો નહીં';

  @override
  String get photoIssueOutOfFrame => 'વસ્તુ આખી ફોટામાં નથી';

  @override
  String get voiceTitle => 'હવે બોલીને કહો કે આ શું છે';

  @override
  String get voiceBody =>
      'આ શું છે, શેનું બનેલું છે, કેટલું મોટું છે, બનાવવામાં કેટલો સમય લાગ્યો, અને કિંમત કેટલી.';

  @override
  String get voiceHoldToSpeak => 'દબાવીને બોલો';

  @override
  String get voiceRecording => 'બોલો… બોલવાનું પૂરું થાય એટલે છોડી દો';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total માંથી $seconds સેકન્ડ';
  }

  @override
  String get voiceTooShort => 'આ બહુ ટૂંકું હતું. બટન દબાવી રાખીને ફરી બોલો.';

  @override
  String get voiceFailed =>
      'માઇક શરૂ થયું નહીં. ઍપને માઇકની પરવાનગી છે કે નહીં તે જુઓ.';

  @override
  String get voiceBackToPhotos => 'ફોટા પર પાછા જાઓ';

  @override
  String get playbackPlay => 'સાંભળો';

  @override
  String get playbackStop => 'રોકો';

  @override
  String get playbackAgain => 'ફરી કહો';

  @override
  String get playbackAccept => 'આ બરાબર છે';

  @override
  String get playbackUnavailable =>
      'આ ફોન તે સંભળાવી શકતો નથી. તમે તો પણ મોકલી શકો છો, અથવા ફરી કહી શકો છો.';

  @override
  String get savedTitle => 'સાચવ્યું';

  @override
  String get savedBody => 'નેટવર્ક આવતાં જ તે આપમેળે જશે.';

  @override
  String get savedBodyOnline =>
      'તે અત્યારે મોકલાઈ રહ્યું છે. તમારે અહીં રાહ જોવાની જરૂર નથી.';

  @override
  String get savedAddAnother => 'બીજી વસ્તુ ઉમેરો';

  @override
  String get savedGoHome => 'હોમ પર જાઓ';

  @override
  String get saveFailed =>
      'તે આ ફોનમાં સાચવી શકાયું નહીં. કદાચ જગ્યા બાકી નથી.';

  @override
  String get saveRetry => 'ફરી સાચવવાનો પ્રયત્ન કરો';

  @override
  String get queueTitle => 'મોકલવાનું બાકી';

  @override
  String get queueBody => 'અહીં કંઈ ખોવાયું નથી. નેટવર્ક આવતાં જ દરેક જશે.';

  @override
  String get queueEmptyTitle => 'કંઈ બાકી નથી';

  @override
  String get queueEmptyBody => 'તમે બનાવેલું બધું મોકલાઈ ગયું છે.';

  @override
  String get queueStateWaiting => 'નેટવર્કની રાહ જોઈએ છીએ';

  @override
  String queueStateUploading(int percent) {
    return 'મોકલી રહ્યા છીએ… સોમાંથી $percent';
  }

  @override
  String get queueStateProcessing => 'હવે અમારી પાસે છે. અમે તે લખી રહ્યા છીએ.';

  @override
  String get queueStateFailed => 'ગયું નહીં. કારણ જોવા દબાવો.';

  @override
  String get queueItemTitle => 'આ વસ્તુ';

  @override
  String queueMadeAt(String date) {
    return '$date ના રોજ બનાવી';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વાર પ્રયત્ન કર્યો',
      one: 'એક વાર પ્રયત્ન કર્યો',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'હમણાં મોકલવાનો પ્રયત્ન કરો';

  @override
  String get queueRetryWaiting => 'હજી નેટવર્ક નથી. તે આપમેળે જશે.';

  @override
  String get queueDelete => 'આ વસ્તુ ભૂંસી નાખો';

  @override
  String get queueDeleteTitle => 'આ વસ્તુ ભૂંસી નાખવી છે?';

  @override
  String get queueDeleteBody =>
      'ફોટા અને તમે જે કહ્યું તે ભૂંસાઈ જશે. આ પાછું નહીં આવે.';

  @override
  String get queueDeleteConfirm => 'હા, ભૂંસી નાખો';

  @override
  String get queueDeleteCancel => 'ના, રહેવા દો';

  @override
  String get failureNetwork =>
      'નેટવર્ક વચ્ચે જ અટકી ગયું. સિગ્નલ આવતાં જ તે આપમેળે ફરી જશે.';

  @override
  String get failureServer =>
      'અમારી તરફથી જવાબ ન આવ્યો. ફરી પ્રયત્ન કરવામાં આવશે.';

  @override
  String get failureMissingFiles =>
      'ફોટા હવે આ ફોનમાં નથી, તેથી આ મોકલી શકાશે નહીં. કૃપા કરીને ફરી બનાવો.';

  @override
  String get failureRejected => 'આ સ્વીકારાયું નહીં. કૃપા કરીને ફરી બનાવો.';

  @override
  String get failureUnknown => 'કંઈક ખોટું થયું. તમે ફરી પ્રયત્ન કરી શકો છો.';

  @override
  String get processingTitle => 'અમે તે લખી રહ્યા છીએ';

  @override
  String get processingBody =>
      'તમારા ફોટા અને તમારા શબ્દો અમારી પાસે છે. આમાં થોડી મિનિટ લાગે છે.';

  @override
  String get processingLeave =>
      'તમારે અહીં રાહ જોવાની જરૂર નથી. તૈયાર થતાં અમે તમને જણાવીશું.';

  @override
  String get processingGoHome => 'હોમ પર જાઓ';

  @override
  String get attentionTitle => 'એક પ્રશ્ન';

  @override
  String get attentionBody => 'બાકી બધું અમે સમજી ગયા. ફક્ત આ જ બાકી છે.';

  @override
  String get attentionHoldToAnswer => 'દબાવીને જવાબ આપો';

  @override
  String get attentionAnswering => 'તમારો જવાબ મોકલી રહ્યા છીએ…';

  @override
  String get attentionFailed => 'તમારો જવાબ ગયો નહીં. કૃપા કરીને ફરી કહો.';

  @override
  String get readBackTitle => 'અમે આ સમજ્યા';

  @override
  String get readBackListen => 'આખું સાંભળો';

  @override
  String get readBackFields => 'અમે જે લખ્યું';

  @override
  String get readBackCorrect => 'જે ખોટું હોય તેના પર દબાવો';

  @override
  String get readBackApprove => 'આ બધું બરાબર છે';

  @override
  String get notSaid => 'કહ્યું નથી';

  @override
  String get fieldMaterial => 'શેનું બનેલું';

  @override
  String get fieldSize => 'માપ';

  @override
  String get fieldColour => 'રંગ';

  @override
  String get fieldQuantity => 'કેટલા';

  @override
  String get fieldPrice => 'કિંમત';

  @override
  String correctTitle(String field) {
    return 'સાચું $field કહો';
  }

  @override
  String get correctHoldToSpeak => 'દબાવીને કહો';

  @override
  String get correctListening => 'સાંભળીએ છીએ…';

  @override
  String get correctFailedOnce => 'અમને સમજાયું નહીં. ફરી એક વાર કહો.';

  @override
  String get correctUseKeypad => 'તેના બદલે લખો';

  @override
  String get correctUseVoice => 'તેના બદલે બોલો';

  @override
  String get correctPick => 'અથવા આમાંથી પસંદ કરો';

  @override
  String get correctSave => 'આ સાચવો';

  @override
  String get correctCancel => 'જેમ છે તેમ રહેવા દો';

  @override
  String get correctTypeHint => 'જવાબ અહીં લખો';

  @override
  String correctHeard(Object text) {
    return 'અમે સાંભળ્યું “$text”';
  }

  @override
  String get listingCancelAction => 'આ વસ્તુ રદ કરો';

  @override
  String get listingCancelTitle => 'આ વસ્તુ રદ કરવી છે?';

  @override
  String get listingCancelBody =>
      'ફોટા, રેકોર્ડિંગ અને તમે કહેલું બધું ભૂંસાઈ જશે. આ પાછું નહીં આવે.';

  @override
  String get listingCancelConfirm => 'હા, રદ કરો';

  @override
  String get listingCancelKeep => 'ના, રહેવા દો';

  @override
  String get photoSaveAction => 'ફોટા સાચવો';

  @override
  String get photoSaved => 'તમારા ફોટામાં સાચવ્યું';

  @override
  String get photoSaveFailed => 'ફોટો સાચવી શકાયો નહીં';

  @override
  String get photoSaveDenied => 'ફોટો સાચવવા પરવાનગી આપો';

  @override
  String get colourRed => 'લાલ';

  @override
  String get colourBlue => 'વાદળી';

  @override
  String get colourGreen => 'લીલો';

  @override
  String get colourYellow => 'પીળો';

  @override
  String get colourBlack => 'કાળો';

  @override
  String get colourWhite => 'સફેદ';

  @override
  String get colourBrown => 'કથ્થઈ';

  @override
  String get colourMulti => 'ઘણા રંગ';

  @override
  String get sizeSmall => 'નાનું';

  @override
  String get sizeMedium => 'મધ્યમ';

  @override
  String get sizeLarge => 'મોટું';

  @override
  String get sizeExtraLarge => 'બહુ મોટું';

  @override
  String get suggestTitle => 'આ પણ ઉમેરીએ?';

  @override
  String get suggestYes => 'હા, ઉમેરો';

  @override
  String get suggestNo => 'ના, રહેવા દો';

  @override
  String get suggestSkip => 'મને ખાતરી નથી';

  @override
  String suggestProgress(int current, int total) {
    return '$total માંથી $current';
  }

  @override
  String get suggestDone => 'બીજું કંઈ ઉમેરવાનું નથી';

  @override
  String get priceTitle => 'કિંમત કેટલી?';

  @override
  String get priceBody => 'આ એક નંગની કિંમત છે.';

  @override
  String priceBand(String low, String high) {
    return 'આવી વસ્તુઓ બીજા લોકો $low થી $high માં વેચે છે';
  }

  @override
  String get priceBelowFloor =>
      'આ તમારા ખર્ચ કરતાં ઓછી છે. તો પણ તમે આ જ રાખી શકો છો.';

  @override
  String get priceSayIt => 'કિંમત કહો';

  @override
  String get priceConfirm => 'આ કિંમત બરાબર છે';

  @override
  String get stockTitle => 'તમારી પાસે કેટલા છે?';

  @override
  String get stockBody => 'બધા વેચાઈ જાય એટલે અમે તમારા માટે તે હટાવી દઈશું.';

  @override
  String get stockOneOfAKind => 'ફક્ત એક જ છે, અને આવું બીજું ક્યારેય નહીં બને';

  @override
  String get stockMore => 'એક વધુ';

  @override
  String get stockLess => 'એક ઓછું';

  @override
  String get stockConfirm => 'આ બરાબર છે';

  @override
  String get photosTitle => 'કયો ફોટો પહેલાં આવશે?';

  @override
  String get photosBody => 'ખરીદનાર પહેલો ફોટો સૌથી પહેલાં જુએ છે.';

  @override
  String get photosMakeFirst => 'આને પહેલો ફોટો બનાવો';

  @override
  String get photosFirst => 'પહેલો ફોટો';

  @override
  String get photosConfirm => 'આ ફોટા બરાબર છે';

  @override
  String get previewTitle => 'ખરીદનાર આ જોશે';

  @override
  String get previewListenAll => 'બધું સાંભળો';

  @override
  String get previewNoDescription => 'કોઈ વર્ણન લખાયું નથી.';

  @override
  String get previewConfirm => 'હા, આ બરાબર છે';

  @override
  String get previewChange => 'કંઈક બદલો';

  @override
  String get consentTitle => 'અમે આ વેચાણ માટે મૂકીએ?';

  @override
  String get consentPhoto => 'મારા ફોટા બતાવો';

  @override
  String get consentPhotoExplain =>
      'તમારી વસ્તુના ફોટા ખરીદનારની સ્ક્રીન પર જશે.';

  @override
  String get consentStory => 'મારી કારીગરીની વાર્તા બતાવો';

  @override
  String get consentStoryExplain =>
      'તમારું નામ, તમારું ગામ અને તમે કેવી રીતે બનાવો છો તે કારીગર કાર્ડ પર જશે. ના કહીને પણ તમે વેચી શકો છો.';

  @override
  String get consentNeeded => 'ફોટા વગર અમે તે મૂકી શકતા નથી.';

  @override
  String get consentPublish => 'વેચાણ માટે મૂકો';

  @override
  String get publishingTitle => 'વેચાણ માટે મૂકી રહ્યા છીએ';

  @override
  String get publishingBody => 'આમાં થોડો સમય લાગશે. ઍપ બંધ ન કરો.';

  @override
  String get publishedTitle => 'તે વેચાણ પર મુકાઈ ગયું';

  @override
  String get publishedBody => 'ખરીદનાર તે હમણાં જોઈ શકે છે.';

  @override
  String get publishedShare => 'વૉટ્સઍપ પર મોકલો';

  @override
  String get publishedCopyLink => 'લિંક કૉપિ કરો';

  @override
  String get publishedLinkCopied => 'લિંક કૉપિ થઈ ગઈ';

  @override
  String get publishedShowQr => 'સ્કૅન કરવાનો કોડ બતાવો';

  @override
  String get publishedQrExplain =>
      'કોઈ પણ આના તરફ ફોન ધરીને તમારી વસ્તુ ખોલી શકે છે.';

  @override
  String get publishedAnother => 'આવું બીજું બનાવો';

  @override
  String get publishedDone => 'હોમ પર જાઓ';

  @override
  String get publishFailed =>
      'તે મૂકી શકાયું નહીં. કંઈ ખોવાયું નથી, તમે ફરી પ્રયત્ન કરી શકો છો.';

  @override
  String get publishRetry => 'ફરી પ્રયત્ન કરો';

  @override
  String get reviewLeaveTitle => 'હમણાં માટે છોડી દેવું છે?';

  @override
  String get reviewLeaveBody =>
      'તમે જે મંજૂર કર્યું તે રહેશે. તમે તમારી વસ્તુઓમાંથી પાછા આવી શકો છો.';

  @override
  String get reviewLeaveConfirm => 'હમણાં માટે છોડી દો';

  @override
  String get editLeaveTitle => 'તમારા ફેરફાર હજી વેચાણ પર નથી';

  @override
  String get editLeaveBody =>
      'તમે કરેલા ફેરફાર સાચવ્યા છે, પણ ખરીદનારને હજી જૂનું જ દેખાય છે. છેલ્લું બટન દબાવશો ત્યારે જ તે ફરી વેચાણ પર જશે.';

  @override
  String get editLeaveConfirm => 'ઠીક છે, પછી કરીશ';

  @override
  String get reviewLeaveCancel => 'આગળ વધો';

  @override
  String get statusSoldOut => 'બધું વેચાઈ ગયું';

  @override
  String get statusUnpublished => 'હટાવી લીધું';

  @override
  String get listingsTitle => 'તમારી વસ્તુઓ';

  @override
  String get listingsEmptyTitle => 'તમે હજી કંઈ બનાવ્યું નથી';

  @override
  String get listingsEmptyBody =>
      'હોમ પરનું મોટું બટન દબાવીને તમારી પહેલી વસ્તુ ઉમેરો.';

  @override
  String get listingsEmptyFilter => 'અહીં કંઈ નથી.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count બાકી',
      one: '1 બાકી',
      zero: 'કંઈ બાકી નથી',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વાર જોવાયું',
      one: 'એક વાર જોવાયું',
      zero: 'હજી કોઈએ જોયું નથી',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'કેટલા છે તે બદલો';

  @override
  String get listingTitle => 'આ વસ્તુ';

  @override
  String get listingOpenPreview => 'ખરીદનાર જે જુએ છે તે જુઓ';

  @override
  String get listingEdit => 'કંઈક બદલો';

  @override
  String get listingDuplicate => 'આવું બીજું બનાવો';

  @override
  String get listingUnpublish => 'વેચાણમાંથી હટાવો';

  @override
  String get listingRelist => 'ફરી વેચાણ પર મૂકો';

  @override
  String get listingFinish => 'આ પૂરું કરો';

  @override
  String get listingSoldOutTitle => 'આ બધા વેચાઈ ગયા';

  @override
  String get listingSoldOutBody =>
      'અમે તમારા માટે તે વેચાણમાંથી હટાવી લીધું. વધુ બનાવો ત્યારે ફરી મૂકો.';

  @override
  String get editTitle => 'આ વસ્તુ બદલો';

  @override
  String get editBody => 'તમે તે ફરી જોશો, અને પછી તે ફરી વેચાણ પર જશે.';

  @override
  String get editRepublishing => 'ફેરફાર વેચાણ પર મૂકી રહ્યા છીએ…';

  @override
  String get editRepublished => 'તમારા ફેરફાર હવે વેચાણ પર છે';

  @override
  String get editRepublishConfirm => 'ફેરફાર ફરી વેચાણ પર મૂકો';

  @override
  String get quickStockTitle => 'કેટલા બાકી છે?';

  @override
  String get quickStockMarkSoldOut => 'બધા વેચાઈ ગયા છે';

  @override
  String get quickStockSave => 'સાચવો';

  @override
  String get quickStockSaved => 'સાચવ્યું';

  @override
  String get actionUndo => 'પહેલાં જેવું કરો';

  @override
  String get unpublishTitle => 'વેચાણમાંથી હટાવવું છે?';

  @override
  String get unpublishBody =>
      'ખરીદનાર હવે તે જોઈ શકશે નહીં. કંઈ ભૂંસાશે નહીં, અને તમે ગમે ત્યારે તે ફરી મૂકી શકો છો.';

  @override
  String get unpublishConfirm => 'હા, હટાવી દો';

  @override
  String get unpublishCancel => 'ના, વેચાણ પર રહેવા દો';

  @override
  String get unpublishDone => 'તે વેચાણમાંથી હટાવી લીધું';

  @override
  String get relistDone => 'તે ફરી વેચાણ પર છે';

  @override
  String get duplicateTitle => 'આવું બીજું બનાવવું છે?';

  @override
  String get duplicateBody =>
      'તમે તેના વિશે જે કહ્યું તે અમે રાખીશું. તમારે ફક્ત નવા ફોટા પાડવાના છે.';

  @override
  String get duplicateConfirm => 'ફોટા પાડો';

  @override
  String get duplicateCancel => 'હમણાં નહીં';

  @override
  String get duplicateBanner =>
      'છેલ્લી વસ્તુ જેવી બીજી બનાવી રહ્યા છીએ. ફક્ત ફોટા નવા છે.';

  @override
  String get listingActionFailed => 'તે થયું નહીં. કૃપા કરીને ફરી પ્રયત્ન કરો.';

  @override
  String get salesNew => 'નવું';

  @override
  String get salesEmptyTitle => 'હજી કંઈ વેચાયું નથી';

  @override
  String get salesEmptyBody =>
      'કોઈ કંઈ ખરીદશે ત્યારે તે અહીં દેખાશે અને અમે તમને જણાવીશું.';

  @override
  String get salesLoading => 'શું વેચાયું તે જોઈ રહ્યા છીએ…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count નંગ',
      one: '1 નંગ',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date સુધીમાં પૅક કરો';
  }

  @override
  String get salesPackByToday => 'આજે જ પૅક કરો';

  @override
  String get salesPackByTomorrow => 'કાલ સુધીમાં પૅક કરો';

  @override
  String get salesPackedAlready => 'આની તારીખ વીતી ગઈ છે';

  @override
  String get saleTitle => 'આ ઑર્ડર';

  @override
  String get saleReadOnly =>
      'આ ફક્ત તમને જણાવવા માટે છે. ઑર્ડરનું બધું કામ બજાર પર થાય છે, આ ઍપમાં નહીં.';

  @override
  String salePaid(String amount) {
    return 'તમને $amount મળશે';
  }

  @override
  String salePlaced(String date) {
    return '$date ના રોજ વેચાયું';
  }

  @override
  String saleGoingTo(String area) {
    return '$area જઈ રહ્યું છે';
  }

  @override
  String get saleWhatToPack => 'શું પૅક કરવું';

  @override
  String get salePackingHelp => 'કેવી રીતે પૅક કરવું';

  @override
  String get saleSeeListing => 'આ વસ્તુ જુઓ';

  @override
  String get packingTitle => 'કેવી રીતે પૅક કરવું';

  @override
  String get packingBody => 'એક પછી એક કરો. જે થઈ જાય તેના પર દબાવો.';

  @override
  String get packingStep1 => 'કપડામાં અથવા કાગળમાં લપેટો, જેથી કંઈ ઘસાય નહીં';

  @override
  String get packingStep2 =>
      'ચારે બાજુ કાગળ અથવા ઘાસ ભરો, જેથી ખોખામાં હલે નહીં';

  @override
  String get packingStep3 => 'અંદર જોઈએ એટલા નંગ છે કે નહીં તે જુઓ';

  @override
  String get packingStep4 => 'ખોખું બંધ કરીને ચારે બાજુ ટેપ લગાવો';

  @override
  String get packingStep5 => 'લેવા આવનાર માટે તૈયાર રાખો';

  @override
  String get packingDone => 'બધું થઈ ગયું';

  @override
  String packingProgress(int done, int total) {
    return '$total માંથી $done થયું';
  }

  @override
  String get earningsTitle => 'તમે કેટલું કમાયા';

  @override
  String get earningsWeek => 'આ અઠવાડિયે';

  @override
  String get earningsMonth => 'આ મહિને';

  @override
  String get earningsTotal => 'શરૂઆતથી';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count નંગ વેચાયા',
      one: '1 નંગ વેચાયો',
      zero: 'હજી કંઈ વેચાયું નથી',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'બજાર પોતાનો હિસ્સો લીધા પછી તમને જે મળે છે તે આ છે.';

  @override
  String get profileVillageLabel => 'ગામ અથવા ક્લસ્ટર';

  @override
  String get profileNotSet => 'આપ્યું નથી';

  @override
  String get profileEditEntry => 'તમારી માહિતી બદલો';

  @override
  String get profileStoryEntry => 'તમારી કારીગરીની વાર્તા';

  @override
  String get profileLanguageEntry => 'ભાષા';

  @override
  String get profilePhoneEntry => 'ફોન નંબર';

  @override
  String get profileOndcEntry => 'તમારું વેચાણ ખાતું';

  @override
  String get profileNotificationsEntry => 'અમે તમને શું જણાવીએ';

  @override
  String get profileVoiceEntry => 'અવાજ અને સાંભળવું';

  @override
  String get profilePrivacyEntry => 'તમારા વિશે શું દેખાય છે';

  @override
  String get profileStorageEntry => 'આ ફોનમાં જગ્યા';

  @override
  String get profileAccountEntry => 'સાઇન આઉટ';

  @override
  String get editProfileTitle => 'તમારી માહિતી';

  @override
  String get editProfileAddPhoto => 'તમારો ફોટો ઉમેરો';

  @override
  String get editProfileChangePhoto => 'ફોટો બદલો';

  @override
  String get editProfileRemovePhoto => 'ફોટો હટાવો';

  @override
  String get editProfilePhotoWhy =>
      'તમારી પરવાનગી હોય તો જ ખરીદનાર તે કારીગર કાર્ડ પર જુએ છે.';

  @override
  String get editProfileVillageHint => 'બોલો અથવા લખો';

  @override
  String get editProfileSave => 'સાચવો';

  @override
  String get editProfileSaved => 'સાચવ્યું';

  @override
  String get storyTitle => 'તમારી કારીગરીની વાર્તા';

  @override
  String get storyBody =>
      'ખરીદનારને કહો કે તમે કોણ છો અને કેવી રીતે બનાવો છો. તમે બોલો, અમે લખી લઈશું.';

  @override
  String get storyHoldToSpeak => 'દબાવીને તમારી વાર્તા કહો';

  @override
  String get storyEmpty => 'તમે હજી તમારી વાર્તા કહી નથી.';

  @override
  String get storyEditHint => 'તમે આનો કોઈ પણ શબ્દ બદલી શકો છો.';

  @override
  String get storyExample =>
      'જેમ કે: અમારા ઘરમાં ત્રણ પેઢીથી આ બને છે, અને હું આજે પણ મારા દાદાની સાળ પર કામ કરું છું.';

  @override
  String get changePhoneTitle => 'તમારો નંબર બદલો';

  @override
  String get changePhoneBody =>
      'નંબર તમારો જ છે તેની ખાતરી કરવા અમે નવા નંબર પર એક કોડ મોકલીશું.';

  @override
  String changePhoneCurrent(String number) {
    return 'અત્યારે તમારો નંબર $number છે';
  }

  @override
  String get changePhoneDone => 'તમારો નંબર બદલાઈ ગયો';

  @override
  String get ondcAccountTitle => 'તમારું વેચાણ ખાતું';

  @override
  String get ondcAccountLinked => 'તમારું ખાતું જોડાયેલું છે';

  @override
  String get ondcAccountNone => 'હજી કોઈ ખાતું જોડાયું નથી';

  @override
  String get ondcAccountNoneBody =>
      'તમે વસ્તુઓ બનાવતા રહો. ખાતું જોડાતાં જ તે વેચાણ પર જશે.';

  @override
  String get ondcAccountLink => 'ખાતું જોડો';

  @override
  String get ondcAccountUnlink => 'આ ખાતું હટાવો';

  @override
  String get ondcUnlinkTitle => 'આ ખાતું હટાવવું છે?';

  @override
  String get ondcUnlinkBody =>
      'વેચાણ પર જે છે તે બધું ઊતરી જશે. તમે બનાવેલું કંઈ ભૂંસાશે નહીં, અને તમે તે ફરી જોડી શકો છો.';

  @override
  String get ondcUnlinkConfirm => 'હા, હટાવી દો';

  @override
  String get ondcUnlinkCancel => 'ના, રહેવા દો';

  @override
  String get ondcUnlinkDone => 'ખાતું હટાવી દીધું';

  @override
  String get notificationsTitle => 'અમે તમને શું જણાવીએ';

  @override
  String get notifySold => 'કંઈ વેચાય ત્યારે';

  @override
  String get notifySoldWhy =>
      'ખરીદનાર પૈસા ચૂકવે કે તરત અમે જણાવીશું, જેથી તમે પૅકિંગ શરૂ કરી શકો.';

  @override
  String get notifyAttention => 'અમારે તમને કંઈ પૂછવું હોય ત્યારે';

  @override
  String get notifyAttentionWhy =>
      'ક્યારેક વસ્તુ વેચાણ પર જાય તે પહેલાં એક વાત બાકી રહી જાય છે.';

  @override
  String get notifyUpload => 'વસ્તુ મોકલાઈ જાય ત્યારે';

  @override
  String get notifyUploadWhy =>
      'તમે ફોન પર જે બનાવ્યું તે અમારી પાસે પહોંચે ત્યારે જણાવીશું.';

  @override
  String get notifyPackBy => 'જ્યારે પેક કરવાનો સમય થાય';

  @override
  String get notifyPackByWhy =>
      'જે વેચાણ પેક કરવાનું છે, તેની તારીખના એક દિવસ પહેલાં અને તે જ દિવસે અમે તમને યાદ અપાવીશું.';

  @override
  String get notificationsBlocked =>
      'આ ફોન અમને તમને કંઈ મોકલવા દેતો નથી. તમે ફોનના સેટિંગ્સમાં તે ચાલુ કરી શકો છો.';

  @override
  String get voiceSettingsTitle => 'અવાજ અને સાંભળવું';

  @override
  String get voiceSpeed => 'અમે કેટલી ઝડપે બોલીએ';

  @override
  String get voiceSpeedSlow => 'ધીમે';

  @override
  String get voiceSpeedFast => 'ઝડપથી';

  @override
  String get voiceTry => 'હમણાં બોલીને બતાવો';

  @override
  String get voiceSample => 'અમે તમારી સાથે આટલી ઝડપે બોલીશું.';

  @override
  String get voiceAutoRead => 'દરેક સ્ક્રીન ખૂલતાં જ વાંચીને સંભળાવો';

  @override
  String get voiceAutoReadWhy =>
      'આ બંધ હોય તો તમે સ્પીકર દબાવો ત્યારે જ અમે બોલીએ છીએ.';

  @override
  String get voiceUnavailable =>
      'આ ફોન બોલી શકતો નથી. બધું ચાલશે, પણ કંઈ વાંચીને સંભળાવાશે નહીં.';

  @override
  String get privacyTitle => 'તમારા વિશે શું દેખાય છે';

  @override
  String get privacyBody =>
      'દરેક વસ્તુ વેચાણ પર મૂકતી વખતે તમે આને હા કહી હતી. તમે આમાંથી કોઈ પણ પાછું લઈ શકો છો.';

  @override
  String get privacyPhoto => 'આ વસ્તુના ફોટા';

  @override
  String get privacyStory => 'તમારું નામ, ગામ અને વાર્તા';

  @override
  String get privacyNothing => 'અત્યારે તમારું કંઈ વેચાણ પર નથી.';

  @override
  String get privacyWithdrawTitle => 'આ પાછું લેવું છે?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ફોટા વગર આ વસ્તુ વેચાણ પર રહી શકતી નથી, તેથી તે ઊતરી જશે. કંઈ ભૂંસાશે નહીં.';

  @override
  String get privacyWithdrawStoryBody =>
      'તમારું નામ, ગામ અને વાર્તા આ વસ્તુ પરથી હટાવી દેવાશે. તે વેચાણ પર રહેશે.';

  @override
  String get privacyWithdrawConfirm => 'હા, પાછું લો';

  @override
  String get privacyWithdrawCancel => 'ના, રહેવા દો';

  @override
  String get privacyWithdrawn => 'પાછું લીધું';

  @override
  String get storageTitle => 'આ ફોનમાં જગ્યા';

  @override
  String get storagePhotos => 'ફોટા અને રેકૉર્ડિંગ';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વસ્તુઓ મોકલવાની બાકી છે',
      one: '1 વસ્તુ મોકલવાની બાકી છે',
      zero: 'મોકલવાનું કંઈ બાકી નથી',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'જે મોકલાઈ ગયું છે તે હટાવો';

  @override
  String get storageClearWhy =>
      'જે હજી મોકલવાનું બાકી છે તેને ક્યારેય અડવામાં આવતું નથી.';

  @override
  String storageCleared(String size) {
    return '$size ખાલી થઈ';
  }

  @override
  String get storageNothingToClear => 'હટાવવા જેવું કંઈ નથી';

  @override
  String get accountTitle => 'સાઇન આઉટ';

  @override
  String get accountSignOut => 'આ ફોન પરથી સાઇન આઉટ કરો';

  @override
  String get accountSignOutTitle => 'સાઇન આઉટ કરવું છે?';

  @override
  String get accountSignOutBody =>
      'મોકલવાનું બાકી હોય તે ખોવાઈ જશે. વેચાણ પર જે છે તે વેચાણ પર જ રહેશે.';

  @override
  String get accountSignOutConfirm => 'હા, સાઇન આઉટ';

  @override
  String get accountSignOutCancel => 'ના, સાઇન ઇન રહેવા દો';

  @override
  String get accountDelete => 'મારું ખાતું ભૂંસી નાખો';

  @override
  String get accountDeleteTitle => 'તમારું ખાતું ભૂંસી નાખવું છે?';

  @override
  String get accountDeleteBody =>
      'બધું વેચાણમાંથી ઊતરી જશે અને આ ફોન પરનું બધું ભૂંસાઈ જશે. આ પાછું નહીં આવે.';

  @override
  String get accountDeleteConfirm => 'હા, બધું ભૂંસી નાખો';

  @override
  String get accountDeleteCancel => 'ના, મારું ખાતું રહેવા દો';

  @override
  String get accountDeleteHold => 'ભૂંસવા માટે બટન દબાવી રાખો';

  @override
  String get profileHelpEntry => 'મદદ';

  @override
  String get helpTitle => 'મદદ';

  @override
  String get helpBody =>
      'ટૂંકા જવાબ, વાંચીને સંભળાવાય છે. સાંભળવા કોઈ પણ પર દબાવો.';

  @override
  String get helpSteps => 'આ રીતે કરો';

  @override
  String get helpTopicPhotos => 'સારા ફોટા કેવી રીતે પાડવા';

  @override
  String get helpTopicPhotosBody =>
      'સારા ફોટાથી વસ્તુ વેચાય છે. ખરીદનાર વસ્તુ હાથમાં લઈ શકતો નથી, તેની પાસે ફક્ત ફોટો જ હોય છે.';

  @override
  String get helpTopicPhotosStep1 =>
      'દરવાજા અથવા બારી પાસે ઊભા રહો, જેથી દિવસનો પ્રકાશ વસ્તુ પર પડે';

  @override
  String get helpTopicPhotosStep2 =>
      'વસ્તુને સાદા કપડા પર મૂકો, આસપાસ બીજું કંઈ નહીં';

  @override
  String get helpTopicPhotosStep3 =>
      'ફોટો પડે ત્યાં સુધી બંને હાથે ફોન સ્થિર રાખો';

  @override
  String get helpTopicPhotosStep4 => 'નજીકથી એક ફોટો પાડો, જેથી કારીગરી દેખાય';

  @override
  String get helpTopicPhotosStep5 =>
      'એક ફોટામાં બાજુમાં હાથ મૂકો, જેથી માપ ખબર પડે';

  @override
  String get helpTopicVoice => 'તમારી વસ્તુ વિશે શું કહેવું';

  @override
  String get helpTopicVoiceBody =>
      'સામે ઊભેલા ગ્રાહક સાથે જેમ વાત કરો તેમ જ બોલો. બોલવાની કોઈ ખોટી રીત નથી.';

  @override
  String get helpTopicVoiceStep1 => 'કહો કે આ શું છે';

  @override
  String get helpTopicVoiceStep2 => 'કહો કે આ શેનું બનેલું છે';

  @override
  String get helpTopicVoiceStep3 => 'કહો કે આ કેટલું મોટું છે, ઇંચ અથવા ફૂટમાં';

  @override
  String get helpTopicVoiceStep4 => 'કહો કે બનાવવામાં કેટલો સમય લાગ્યો';

  @override
  String get helpTopicVoiceStep5 => 'કહો કે તમને આના કેટલા જોઈએ છે';

  @override
  String get helpTopicPrice => 'કિંમત કેવી રીતે નક્કી કરવી';

  @override
  String get helpTopicPriceBody =>
      'કિંમતમાં તમારો માલસામાન અને તમારો સમય બંને વસૂલ થવા જોઈએ. અમે તમારી સાથે તે ગણીએ છીએ, અને જણાવ્યા વગર ક્યારેય તેનાથી નીચે જવા દેતા નથી.';

  @override
  String get helpTopicPriceStep1 => 'માલસામાનમાં કેટલો ખર્ચ થયો તે ગણો';

  @override
  String get helpTopicPriceStep2 => 'કામમાં કેટલા દિવસ લાગ્યા તે ગણો';

  @override
  String get helpTopicPriceStep3 =>
      'અમે જે સૂચવીએ તે જુઓ, અને તમને વધુ ખબર હોય તો બદલો';

  @override
  String get helpTopicPriceStep4 =>
      'તમારા ખર્ચથી ઓછું હશે તો અમે જણાવીશું, પણ પસંદગી તમારી જ';

  @override
  String get helpTopicSold => 'વેચાયા પછી શું થાય છે';

  @override
  String get helpTopicSoldBody =>
      'ખરીદનાર બજાર પર પૈસા ચૂકવે છે. તમે પૅક કરીને આપી દો છો, અને પૈસા તમારી પાસે આવે છે.';

  @override
  String get helpTopicSoldStep1 => 'વેચાતાં જ અમે તમને જણાવીશું';

  @override
  String get helpTopicSoldStep2 => 'ખોલીને જુઓ કે શું અને કેટલું પૅક કરવું';

  @override
  String get helpTopicSoldStep3 => 'અમે બતાવેલી તારીખ પહેલાં પૅક કરો';

  @override
  String get helpTopicSoldStep4 => 'લેવા આવનારને આપી દો';

  @override
  String get helpTopicSoldStep5 => 'ત્યાર પછી પૈસા તમારી પાસે પહોંચે છે';

  @override
  String get helpVideoComing => 'આ માટે એક નાનો વીડિયો જલ્દી આવી રહ્યો છે.';

  @override
  String get helpPractice => 'સારો ફોટો કેવી રીતે લેવો';

  @override
  String get helpPracticeBody => 'એક જ માટલાનો એક સારો અને એક ખરાબ ફોટો.';

  @override
  String get helpFaqEntry => 'લોકો જે પૂછે છે';

  @override
  String get helpAboutEntry => 'કીર્તિકર વિશે';

  @override
  String get helpSupportEntry => 'માણસ સાથે વાત કરો';

  @override
  String get helpTermsEntry => 'શરતો અને ગોપનીયતા';

  @override
  String get faqTitle => 'લોકો જે પૂછે છે';

  @override
  String get faqQ1 => 'શું આ માટે મારે કંઈ ચૂકવવું પડશે?';

  @override
  String get faqA1 =>
      'ના. વસ્તુઓ મૂકવી મફત છે. કંઈ વેચાય ત્યારે જ બજાર પોતાનો નાનો હિસ્સો લે છે.';

  @override
  String get faqQ2 => 'નેટવર્ક ન હોય તો?';

  @override
  String get faqA2 =>
      'બધું ચાલતું રહે છે. તમે જે બનાવો તે તમારા ફોનમાં રહે છે અને નેટવર્ક આવતાં જ આપમેળે જાય છે.';

  @override
  String get faqQ3 => 'મારા પૈસા કોને મળે છે?';

  @override
  String get faqA3 =>
      'તમને. ખરીદનાર બજાર પર પૈસા ચૂકવે છે અને તે તમારા ખાતામાં આવે છે. પૈસા ક્યારેય અમારી પાસે થઈને જતા નથી.';

  @override
  String get faqQ4 => 'વેચાણ પર મૂક્યા પછી કંઈ બદલી શકાય?';

  @override
  String get faqA4 =>
      'હા. તમારી વસ્તુઓમાંથી ખોલો, જે જોઈએ તે બદલો, અને તે ફરી વેચાણ પર જશે.';

  @override
  String get faqQ5 => 'મેં કંઈ ખોટું કહી દીધું હોય તો?';

  @override
  String get faqA5 =>
      'તમે સાંભળીને બરાબર છે એમ ન કહો ત્યાં સુધી કંઈ વેચાણ પર જતું નથી. તમે બોલીને તેનો કોઈ પણ ભાગ સુધારી શકો છો.';

  @override
  String get faqQ6 => 'શું મને વાંચતા-લખતા આવડવું જોઈએ?';

  @override
  String get faqA6 =>
      'ના. તમે બધું બોલીને અને દબાવીને કરી શકો છો. દરેક સ્ક્રીન તમને વાંચીને સંભળાવી શકાય છે.';

  @override
  String get faqQ7 => 'મારું નામ અને ગામ કોણ જુએ છે?';

  @override
  String get faqA7 =>
      'તમારી પરવાનગી હોય તો જ, અને દરેક વસ્તુ માટે અલગ. તમે તે ગમે ત્યારે પાછી લઈ શકો છો.';

  @override
  String get aboutTitle => 'કીર્તિકર વિશે';

  @override
  String get aboutWhatTitle => 'આ શું છે';

  @override
  String get aboutWhat =>
      'કીર્તિકર હાથથી બનેલી વસ્તુઓને ONDC પર પહોંચાડે છે, ભારતનું ખરીદ-વેચાણનું ખુલ્લું નેટવર્ક, અને તે માટે બનાવનારે લખવું પડતું નથી, બોલવું પડે છે. તમારી પોતાની ભાષામાં થોડા ફોટા અને એક વૉઇસ નોટમાંથી એવી યાદી બને છે જે દેશભરના ખરીદનાર શોધી શકે.';

  @override
  String get aboutWhyTitle => 'અમે આ કેમ બનાવ્યું';

  @override
  String get aboutWhy =>
      'ભારતમાં લગભગ સિત્તેર લાખ કારીગરો એવી વસ્તુઓ બનાવે છે જે લોકો ખરીદવા માગે છે, અને તેમાંના મોટા ભાગના વચેટિયા દ્વારા વેચે છે જે ફરકના પૈસા રાખી લે છે. અડચણ કામમાં નથી. અડચણ ફૉર્મમાં છે: ઓનલાઇન યાદી અંગ્રેજીમાં ટાઇપ કરવાનું, ઘણાં ખાનાં ભરવાનું અને કૅટલૉગ જેવો ફોટો માગે છે. આ ઍપ એ ફૉર્મ જ હટાવી દે છે.';

  @override
  String get aboutHowTitle => 'આ કેવી રીતે ચાલે છે';

  @override
  String get aboutHow =>
      'ત્રણ ફોટા પાડો અને બોલીને કહો કે આ શું છે. અમારી વ્યવસ્થા સાંભળે છે, યાદી લખે છે, અને તમને વાંચીને સંભળાવે છે. તમે સાંભળીને બરાબર છે એમ ન કહો ત્યાં સુધી કંઈ બહાર જતું નથી.';

  @override
  String get aboutSihTitle => 'સ્માર્ટ ઇન્ડિયા હૅકાથૉન 2025';

  @override
  String get aboutSih =>
      'સમસ્યા 090 માટે બનાવ્યું: કારીગરો અને વણકરોને ONDC પર ખરીદનાર સુધી પહોંચાડવા.';

  @override
  String get aboutMissionTitle => 'અમે શું કરવા માગીએ છીએ';

  @override
  String get aboutMission => 'કોઈ કામની કિંમત તે કામ કરનારના હાથમાં જ રહે.';

  @override
  String get supportTitle => 'માણસ સાથે વાત કરો';

  @override
  String get supportBody =>
      'કંઈ ચાલતું ન હોય, અથવા શું કરવું તે ખબર ન પડે, તો અમને ફોન કરો. એક માણસ તમારી ભાષામાં જવાબ આપશે.';

  @override
  String get supportCall => 'અમને ફોન કરો';

  @override
  String get supportWhatsApp => 'વૉટ્સઍપ પર સંદેશ મોકલો';

  @override
  String get supportHours => 'દરરોજ, સવારે નવથી સાંજે સાત.';

  @override
  String supportNumber(String number) {
    return 'અમારો નંબર $number છે';
  }

  @override
  String supportFailed(String number) {
    return 'તમારો ફોન તે ખોલી શક્યો નહીં. અમારો નંબર $number છે.';
  }

  @override
  String get termsTitle => 'શરતો અને ગોપનીયતા';

  @override
  String get termsSummaryTitle => 'ટૂંકમાં';

  @override
  String get termsSummary1 =>
      'તમે જે બનાવો છો તે તમારું જ છે. અમે તે તમારા માટે વેચાણ પર મૂકીએ છીએ અને વેચાણમાંથી કંઈ લેતા નથી.';

  @override
  String get termsSummary2 =>
      'તમારા ફોટા અને તમારો અવાજ ફક્ત તમારી યાદી લખવા માટે વપરાય છે, બીજા કશા માટે નહીં.';

  @override
  String get termsSummary3 =>
      'તમારું નામ, ગામ અને વાર્તા ફક્ત તમે પરવાનગી આપેલી વસ્તુઓ પર જ જાય છે, અને તમે તે પાછી લઈ શકો છો.';

  @override
  String get termsSummary4 =>
      'પૈસા ખરીદનાર પાસેથી સીધા તમારી પાસે જાય છે. ક્યારેય અમારી પાસે થઈને જતા નથી.';

  @override
  String get termsSummary5 => 'તમે ગમે ત્યારે આ ફોન પરથી બધું ભૂંસી શકો છો.';

  @override
  String get termsFullTitle => 'પૂરું લખાણ';

  @override
  String get termsFullBody =>
      'ઉપયોગની પૂરી શરતો અને ગોપનીયતા નીતિ અમારી વેબસાઇટ પર છે. અહીં કંઈ સમજાય નહીં તો અમને ફોન કરો, એક માણસ સમજાવશે.';

  @override
  String get termsOpenFull => 'પૂરું લખાણ વાંચો';

  @override
  String get termsAgreeTitle => 'શરૂ કરતા પહેલાં';

  @override
  String get termsAgreeBody =>
      'તમે આ વાતો માટે સંમતિ આપો છો. સાંભળવા માટે સ્પીકર દબાવો.';

  @override
  String get termsAgreeCheck => 'હું શરતો સાથે સંમત છું';

  @override
  String get termsAgreeContinue => 'આગળ વધો';

  @override
  String get termsAgreeNeeded => 'પહેલાં “હું શરતો સાથે સંમત છું” પર ટિક કરો.';

  @override
  String versionNumber(String version) {
    return 'આવૃત્તિ $version';
  }

  @override
  String get versionCheck => 'નવી આવૃત્તિ જુઓ';

  @override
  String get versionLicences => 'લાઇસન્સ';

  @override
  String get versionLicencesWhy => 'જે મફત સૉફ્ટવેર પર આ ઍપ બની છે.';

  @override
  String get noNetworkTitle => 'નેટવર્ક નથી';

  @override
  String get noNetworkBody =>
      'તમે કામ ચાલુ રાખો. બધું તમારા ફોનમાં રહે છે અને નેટવર્ક આવતાં જ આપમેળે જાય છે.';

  @override
  String get noNetworkNeeded =>
      'આ એક કામ માટે નેટવર્ક જોઈએ. સિગ્નલ આવે ત્યારે ફરી પ્રયત્ન કરો.';

  @override
  String get serverErrorTitle => 'અમે અમારી તરફ પહોંચી શક્યા નહીં';

  @override
  String get serverErrorBody =>
      'તમે કરેલું કંઈ ખોવાયું નથી. કૃપા કરીને થોડી વાર પછી ફરી પ્રયત્ન કરો.';

  @override
  String get actionTryAgain => 'ફરી પ્રયત્ન કરો';

  @override
  String get permissionRecoveryTitle => 'ઍપને તમારી પરવાનગી જોઈએ';

  @override
  String get permissionRecoveryBody =>
      'ફોન ઍપને આ વાપરવા દેતો નથી. તમે ફોનના સેટિંગ્સમાં તે ચાલુ કરીને અહીં પાછા આવી શકો છો.';

  @override
  String get permissionCameraWhy =>
      'તમે બનાવેલી વસ્તુના ફોટા પાડવા માટે. આના વગર કંઈ વેચાણ પર મૂકી શકાશે નહીં.';

  @override
  String get permissionMicWhy =>
      'જેથી તમે લખવાને બદલે બોલી શકો. આના વગર બધું લખવું પડશે.';

  @override
  String get permissionNotifyTitle => 'સૂચનાઓ';

  @override
  String get permissionNotifyWhy =>
      'જેથી કંઈ વેચાય ત્યારે અમે જણાવી શકીએ. આના વગર તમારે ઍપ ખોલીને જોવું પડશે.';

  @override
  String get permissionBlocked => 'પરવાનગી નથી';

  @override
  String get permissionAsk => 'ફરી પૂછો';

  @override
  String get permissionRecheck => 'મેં ચાલુ કરી દીધું';

  @override
  String get permissionAllGood => 'ઍપને જે જોઈએ તે બધું મંજૂર છે.';

  @override
  String get updateTitle => 'કૃપા કરીને ઍપ અપડેટ કરો';

  @override
  String get updateBody =>
      'આ આવૃત્તિ હવે અમારી સાથે વાત કરી શકતી નથી. સ્ટોરમાં નવી આવૃત્તિ છે, અને અપડેટ પછી પણ તમારા ફોનમાંનું બધું એમ જ રહેશે.';

  @override
  String get updateAction => 'નવી આવૃત્તિ લો';

  @override
  String get updateFailed => 'સ્ટોર ખૂલ્યો નહીં. ત્યાં કીર્તિકર શોધો.';

  @override
  String get emptyNudge =>
      'હોમ પરનું મોટું બટન દબાવીને તમારી પહેલી વસ્તુ ઉમેરો.';

  @override
  String get productsInProgress => 'તૈયાર થઈ રહી છે';

  @override
  String get productsListed => 'વેચાણ પર';

  @override
  String get productsSold => 'વેચાઈ ગઈ';

  @override
  String get voiceTypeInstead => 'લખીને કહો';

  @override
  String get voiceSpeakInstead => 'બોલીને કહો';

  @override
  String get voiceTypeTitle => 'હવે લખો કે આ વસ્તુ શું છે';

  @override
  String get voiceTypeHint => 'અહીં લખો…';

  @override
  String get voiceTypeSave => 'આ જ વર્ણન રાખો';

  @override
  String get errorNotAllowed =>
      'આ ખાતું આ કરી શકતું નથી. મદદ માટે અમને ફોન કરો.';

  @override
  String get errorNotFound => 'આ હવે અહીં નથી.';

  @override
  String get errorConflict =>
      'આ બીજે ક્યાંક બદલાયું છે. કૃપા કરીને ફરી ખોલીને ફરી પ્રયત્ન કરો.';

  @override
  String get errorInvalid =>
      'કેટલીક વિગતો સ્વીકારાઈ નહીં. કૃપા કરીને તપાસીને ફરી પ્રયત્ન કરો.';

  @override
  String get voiceGuideTitle => 'તમે આ બાબતો વિશે કહી શકો છો';

  @override
  String get voiceGuideWhat => 'વસ્તુનું નામ';

  @override
  String get voiceGuideSize => 'ઊંચાઈ';

  @override
  String get voiceGuideColour => 'રંગ';

  @override
  String get voiceGuideTime => 'બનાવવામાં લાગેલો સમય';

  @override
  String get voiceGuideCost => 'સામગ્રીનો ખર્ચ';
}
