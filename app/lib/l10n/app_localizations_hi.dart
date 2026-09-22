import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कीर्तिकर';

  @override
  String get actionNext => 'आगे';

  @override
  String get actionBack => 'पीछे';

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get actionDone => 'हो गया';

  @override
  String get actionListen => 'सुनें';

  @override
  String get actionStopListening => 'रोकें';

  @override
  String stepOfSteps(int current, int total) {
    return 'चरण $current, कुल $total';
  }

  @override
  String get splashTagline => 'बोलिए, और आपका सामान बिक जाएगा';

  @override
  String get languageTitle => 'अपनी भाषा चुनिए';

  @override
  String get languageHint => 'जो भाषा आप बोलते हैं, उस पर दबाइए';

  @override
  String get welcomeCard1Title => 'तीन फ़ोटो लीजिए';

  @override
  String get welcomeCard1Body =>
      'अपने बनाए सामान की तीन फ़ोटो लीजिए। ऐप बताएगा कि कैसे लेनी हैं।';

  @override
  String get welcomeCard2Title => 'बोलकर बताइए';

  @override
  String get welcomeCard2Body =>
      'यह क्या है, किस चीज़ का बना है, कितना दाम है, बस बोल दीजिए। लिखने की ज़रूरत नहीं।';

  @override
  String get welcomeCard3Title => 'यह बिकने चला जाता है';

  @override
  String get welcomeCard3Body =>
      'आपको सुनाकर पूछा जाएगा। आपकी हाँ के बाद ही सामान ऑनलाइन जाएगा।';

  @override
  String get welcomeStart => 'शुरू करें';

  @override
  String get permissionsTitle => 'ऐप को तीन चीज़ों की अनुमति चाहिए';

  @override
  String get permissionCameraTitle => 'कैमरा';

  @override
  String get permissionCameraBody =>
      'आपके सामान की फ़ोटो लेने के लिए। फ़ोटो आपके फ़ोन में ही रहती हैं, जब तक आप हाँ न कहें।';

  @override
  String get permissionMicTitle => 'माइक';

  @override
  String get permissionMicBody =>
      'ताकि आप बोलकर बता सकें कि सामान क्या है। लिखने की ज़रूरत न पड़े।';

  @override
  String get permissionNotificationTitle => 'सूचनाएँ';

  @override
  String get permissionNotificationBody =>
      'जब कुछ बिक जाए, तो हम आपको तुरंत बता सकें।';

  @override
  String get permissionAllow => 'अनुमति दें';

  @override
  String get permissionNotNow => 'अभी नहीं';

  @override
  String get permissionGranted => 'इजाज़त है';

  @override
  String get permissionDeniedTitle => 'अनुमति नहीं मिली';

  @override
  String get permissionDeniedBody =>
      'इसके बिना यह काम नहीं करेगा। फ़ोन की सेटिंग में जाकर अनुमति दीजिए।';

  @override
  String get permissionOpenSettings => 'सेटिंग खोलें';

  @override
  String get phoneTitle => 'आपका फ़ोन नंबर';

  @override
  String get phoneWhy =>
      'हम इस नंबर पर एक कोड भेजेंगे। और किसी को यह नंबर नहीं दिया जाएगा।';

  @override
  String get phoneInvalid => 'दस अंक का नंबर डालिए';

  @override
  String phoneUnknown(String number) {
    return 'यह नंबर इस डेमो में नहीं चलेगा। $number डालिए।';
  }

  @override
  String get phoneSendCode => 'कोड भेजिए';

  @override
  String get otpTitle => 'आया हुआ कोड डालिए';

  @override
  String otpSentTo(String number) {
    return '$number पर भेजा गया';
  }

  @override
  String otpResendIn(int seconds) {
    return 'दोबारा भेजें, $seconds सेकंड बाद';
  }

  @override
  String get otpResend => 'कोड दोबारा भेजें';

  @override
  String get otpCallMe => 'मुझे फ़ोन करके बताइए';

  @override
  String get otpCalling => 'थोड़ी देर में फ़ोन आएगा और कोड बोलकर बताया जाएगा।';

  @override
  String get otpWrong => 'कोड ठीक नहीं है। फिर से डालिए।';

  @override
  String get phoneSendFailed =>
      'कोड नहीं भेजा जा सका। नेटवर्क देखिए और फिर से कोशिश कीजिए।';

  @override
  String get otpExpired => 'कोड की समय सीमा खत्म हो गई। फिर से भेजिए।';

  @override
  String get authTooManyTries =>
      'बहुत बार कोशिश हो गई। थोड़ी देर रुककर फिर कोशिश कीजिए।';

  @override
  String get otpChangeNumber => 'नंबर बदलें';

  @override
  String get otpAutoRead => 'संदेश अपने आप पढ़ लिया गया';

  @override
  String get profileTitle => 'अपने बारे में बताइए';

  @override
  String get profileNameLabel => 'आपका नाम';

  @override
  String get profileNameHint => 'बोलकर बताइए या लिखिए';

  @override
  String get profileNameMissing => 'नाम बताइए';

  @override
  String get profileCraftLabel => 'आप क्या बनाते हैं';

  @override
  String get profileCraftMissing => 'एक चुनिए';

  @override
  String get profileSpeakToFill => 'बोलकर भरिए';

  @override
  String get profileListening => 'सुन रहे हैं…';

  @override
  String get dictationUnavailable =>
      'इस फ़ोन पर बोलकर लिखना नहीं चल रहा। कृपया लिखकर डालिए।';

  @override
  String get dictationNothingHeard =>
      'कुछ सुनाई नहीं दिया। माइक दबाकर फिर बोलिए।';

  @override
  String get craftWeaving => 'बुनाई';

  @override
  String get craftPottery => 'मिट्टी का काम';

  @override
  String get craftWoodwork => 'लकड़ी का काम';

  @override
  String get craftMetalwork => 'धातु का काम';

  @override
  String get craftJewellery => 'गहने';

  @override
  String get craftEmbroidery => 'कढ़ाई';

  @override
  String get craftPainting => 'चित्रकारी';

  @override
  String get craftLeather => 'चमड़े का काम';

  @override
  String get craftBamboo => 'बाँस और घास';

  @override
  String get craftOther => 'कुछ और';

  @override
  String get ondcTitle => 'अपना ओएनडीसी खाता जोड़िए';

  @override
  String get ondcExplain =>
      'ओएनडीसी वह जगह है जहाँ ग्राहक आपका सामान देखते और खरीदते हैं। पैसा सीधे आपको मिलता है, हमारे पास नहीं आता।';

  @override
  String get ondcMalformed =>
      'यह सेलर आईडी जैसा नहीं लगता। कृपया इसे जाँचिए, या कोड फिर से स्कैन कीजिए।';

  @override
  String get ondcEmailLabel => 'ओएनडीसी की ईमेल';

  @override
  String get ondcEmailMalformed =>
      'यह ईमेल पता सही नहीं लगता। कृपया इसे जाँचिए।';

  @override
  String get ondcSellerIdLabel => 'विक्रेता आईडी';

  @override
  String get ondcScan => 'क्यूआर कोड स्कैन कीजिए';

  @override
  String get ondcLink => 'खाता जोड़िए';

  @override
  String get ondcLinking => 'जोड़ा जा रहा है…';

  @override
  String get ondcFailed => 'यह खाता नहीं मिला। दोबारा देखिए।';

  @override
  String get ondcNoAccount => 'मेरे पास अभी खाता नहीं है';

  @override
  String get ondcNoAccountExplain =>
      'कोई बात नहीं। आप सामान तैयार करके रख सकते हैं। खाता जुड़ते ही सब एक साथ चला जाएगा।';

  @override
  String get practiceTitle => 'अच्छी फ़ोटो कैसे लें';

  @override
  String get practiceIntro =>
      'एक ही मटका, एक बार अच्छे से और एक बार ख़राब तरीक़े से लिया गया। दोनों देखने के लिए सरकाइए।';

  @override
  String get practiceGoodBadge => 'ऐसा कीजिए';

  @override
  String get practiceGoodTitle => 'अच्छी फ़ोटो';

  @override
  String get practiceGoodTip1 => 'साफ़: फ़ोन स्थिर रखा गया';

  @override
  String get practiceGoodTip2 => 'रोशनी: खिड़की या दरवाज़े के पास ली गई';

  @override
  String get practiceGoodTip3 => 'पूरा सामान फ़ोटो में है';

  @override
  String get practiceBadBadge => 'ऐसा मत कीजिए';

  @override
  String get practiceBadTitle => 'ख़राब फ़ोटो';

  @override
  String get practiceBadTip1 => 'धुंधली: फ़ोन हिल गया';

  @override
  String get practiceBadTip2 => 'ख़रीदने वाले बारीकी नहीं देख पाते';

  @override
  String get practiceBadTip3 => 'ऐप आपसे फिर से फ़ोटो लेने को कहेगा';

  @override
  String get practiceFinish => 'ऐप चालू कीजिए';

  @override
  String get navHome => 'होम';

  @override
  String get navListings => 'सामान';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get homeAddProduct => 'सामान डालिए';

  @override
  String get homeAddProductSpoken =>
      'यह बड़ा बटन दबाइए और अपना सामान डालिए। तीन फ़ोटो लीजिए, बोलकर बताइए कि यह क्या है, और यह बिकने के लिए चला जाएगा।';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सामान भेजे जाने बाकी हैं',
      one: '1 सामान भेजा जाना बाकी है',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिके',
      one: '1 बिका',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'आपका हाल का सामान';

  @override
  String get homeNextTitle => 'अब यह करना है';

  @override
  String get homeEmptyTitle => 'अभी यहाँ कुछ नहीं है';

  @override
  String get homeEmptyBody => 'ऊपर वाला बड़ा बटन दबाकर अपना पहला सामान डालिए।';

  @override
  String get offlineNoNetwork => 'अभी नेटवर्क नहीं है';

  @override
  String get offlineNothingLost =>
      'कुछ भी खोया नहीं है। नेटवर्क आते ही अपने आप चला जाएगा।';

  @override
  String get statusQueued => 'भेजा जाना बाकी';

  @override
  String get statusProcessing => 'तैयार हो रहा है';

  @override
  String get statusNeedsAttention => 'आपका जवाब चाहिए';

  @override
  String get statusReady => 'भेजने के लिए तैयार';

  @override
  String get statusPublished => 'बिक्री पर है';

  @override
  String get statusFailed => 'नहीं भेजा जा सका';

  @override
  String get listingUntitled => 'सामान';

  @override
  String get listingNoPrice => 'दाम नहीं बताया';

  @override
  String get captureTitle => 'सामान डालिए';

  @override
  String capturePhotoStep(int current, int total) {
    return 'फ़ोटो $current / $total';
  }

  @override
  String get capturePhotoWhole => 'पूरा सामान दिखाइए';

  @override
  String get capturePhotoDetail => 'पास से एक फ़ोटो लीजिए';

  @override
  String get capturePhotoScale => 'बगल में हाथ रखिए, जिससे नाप पता चले';

  @override
  String get captureTakePhoto => 'फ़ोटो लीजिए';

  @override
  String get captureFromGallery => 'गैलरी से चुनिए';

  @override
  String get captureTorchOn => 'रोशनी चालू';

  @override
  String get captureTorchOff => 'रोशनी बंद';

  @override
  String get captureCameraFailed => 'कैमरा नहीं खुला';

  @override
  String get captureCameraRetry => 'फिर कोशिश कीजिए';

  @override
  String get captureCameraPermission =>
      'आपके सामान की फ़ोटो लेने के लिए ऐप को कैमरे की ज़रूरत है।';

  @override
  String get captureOpenSettings => 'सेटिंग खोलिए';

  @override
  String get captureLeaveTitle => 'बिना सहेजे बाहर जाएँ?';

  @override
  String get captureLeaveBody => 'फ़ोटो और आपकी बात मिटा दी जाएगी।';

  @override
  String get captureLeaveConfirm => 'मिटा दीजिए';

  @override
  String get captureLeaveCancel => 'यहीं रहिए';

  @override
  String get shotReviewChecking => 'फ़ोटो देखी जा रही है…';

  @override
  String get shotReviewRetake => 'फिर से लीजिए';

  @override
  String get qualityTooDark =>
      'यह फ़ोटो बहुत अँधेरी है। दरवाज़े के पास खड़े होकर लीजिए।';

  @override
  String get qualityTooBright =>
      'इस पर बहुत रोशनी है। धूप से मुँह घुमाकर लीजिए।';

  @override
  String get qualityBlurry =>
      'यह फ़ोटो साफ़ नहीं है। फ़ोन को स्थिर रखकर फिर से लीजिए।';

  @override
  String get qualityUnreadable =>
      'यह फ़ोटो ठीक से सहेजी नहीं गई। कृपया फिर से लीजिए।';

  @override
  String get qualityNoSubject =>
      'इस फ़ोटो में सामान नहीं दिख रहा। उसे घेरे के अंदर रखिए और पास आकर लीजिए।';

  @override
  String get qualityOutOfFrame =>
      'इस फ़ोटो में सामान का सिर्फ़ एक हिस्सा है। पूरा सामान घेरे के अंदर रखिए।';

  @override
  String get qualityWarningTitle => 'यह फ़ोटो फिर से लीजिए';

  @override
  String get qualityKeepAnyway => 'फिर भी रख लीजिए';

  @override
  String get photoSetTitle => 'आपकी तीन फ़ोटो';

  @override
  String get photoSetBody =>
      'पहली फ़ोटो वही है जो ख़रीदने वाले सबसे पहले देखते हैं। किसी फ़ोटो को दबाकर उसे फिर से लीजिए।';

  @override
  String get photoSetMain => 'पहली फ़ोटो';

  @override
  String get photoSetRetakeThis => 'यह फिर से लीजिए';

  @override
  String get photoSetConfirm => 'ये फ़ोटो ठीक हैं';

  @override
  String get photoEditOpen => 'फ़ोटो काटिए या घुमाइए';

  @override
  String get photoEditTitle => 'फ़ोटो काटिए';

  @override
  String get photoEditBody =>
      'काटने के लिए डिब्बे का कोना या किनारा खींचिए। खिसकाने के लिए डिब्बे के अंदर से खींचिए।';

  @override
  String get photoEditTurn => 'घुमाइए';

  @override
  String get photoEditStraighten => 'सीधा कीजिए';

  @override
  String get photoEditReset => 'फिर से शुरू कीजिए';

  @override
  String get photoEditDone => 'यही फ़ोटो रखिए';

  @override
  String get photoEditCancel => 'वापस जाइए';

  @override
  String get photoEditFailed =>
      'यह बदलाव सहेजा नहीं जा सका। फिर से कोशिश कीजिए।';

  @override
  String get photoIssueTooDark => 'बहुत अँधेरी है, साफ़ नहीं दिखती';

  @override
  String get photoIssueTooBright => 'इस पर बहुत रोशनी है';

  @override
  String get photoIssueBlurry => 'धुंधली है, साफ़ नहीं है';

  @override
  String get photoIssueNoSubject => 'इस फ़ोटो में सामान नहीं दिखता';

  @override
  String get photoIssueUnreadable => 'यह फ़ोटो सहेजी नहीं गई';

  @override
  String get photoIssueOutOfFrame => 'सामान पूरा फ़ोटो में नहीं है';

  @override
  String get voiceTitle => 'अब बोलकर बताइए यह क्या है';

  @override
  String get voiceBody =>
      'यह क्या है, किस चीज़ का बना है, कितना बड़ा है, बनाने में कितना समय लगा, और दाम कितना है।';

  @override
  String get voiceHoldToSpeak => 'दबाकर बोलिए';

  @override
  String get voiceRecording => 'बोलिए… बात पूरी होने पर छोड़ दीजिए';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total में से $seconds सेकंड';
  }

  @override
  String get voiceTooShort => 'यह बहुत छोटा था। बटन दबाकर फिर से बोलिए।';

  @override
  String get voiceFailed =>
      'माइक चालू नहीं हुआ। देखिए कि ऐप को माइक की इजाज़त है या नहीं।';

  @override
  String get voiceBackToPhotos => 'फ़ोटो पर वापस जाइए';

  @override
  String get playbackPlay => 'सुनिए';

  @override
  String get playbackStop => 'रोकिए';

  @override
  String get playbackAgain => 'फिर से बोलिए';

  @override
  String get playbackAccept => 'यह सही है';

  @override
  String get playbackUnavailable =>
      'यह फ़ोन इसे सुना नहीं सकता। आप इसे भेज सकते हैं, या फिर से बोल सकते हैं।';

  @override
  String get savedTitle => 'सहेज लिया गया';

  @override
  String get savedBody => 'नेटवर्क आते ही यह अपने आप चला जाएगा।';

  @override
  String get savedBodyOnline =>
      'यह अभी भेजा जा रहा है। आपको यहाँ रुकना नहीं है।';

  @override
  String get savedAddAnother => 'एक और सामान डालिए';

  @override
  String get savedGoHome => 'होम पर जाइए';

  @override
  String get saveFailed =>
      'इसे इस फ़ोन में सहेजा नहीं जा सका। शायद जगह नहीं बची है।';

  @override
  String get saveRetry => 'फिर से सहेजने की कोशिश कीजिए';

  @override
  String get queueTitle => 'भेजा जाना बाकी';

  @override
  String get queueBody =>
      'यहाँ कुछ भी खोया नहीं है। नेटवर्क आते ही हर एक चला जाएगा।';

  @override
  String get queueEmptyTitle => 'कुछ भी बाकी नहीं है';

  @override
  String get queueEmptyBody => 'आपने जो बनाया, वह सब भेजा जा चुका है।';

  @override
  String get queueStateWaiting => 'नेटवर्क का इंतज़ार है';

  @override
  String queueStateUploading(int percent) {
    return 'भेजा जा रहा है… सौ में से $percent';
  }

  @override
  String get queueStateProcessing => 'अब हमारे पास है। हम इसे लिख रहे हैं।';

  @override
  String get queueStateFailed => 'नहीं गया। कारण देखने के लिए दबाइए।';

  @override
  String get queueItemTitle => 'यह सामान';

  @override
  String queueMadeAt(String date) {
    return '$date को बनाया';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बार कोशिश की',
      one: 'एक बार कोशिश की',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'अभी भेजने की कोशिश कीजिए';

  @override
  String get queueRetryWaiting => 'अभी नेटवर्क नहीं है। यह अपने आप चला जाएगा।';

  @override
  String get queueDelete => 'यह सामान मिटाइए';

  @override
  String get queueDeleteTitle => 'यह सामान मिटाएँ?';

  @override
  String get queueDeleteBody =>
      'फ़ोटो और आपकी बात मिट जाएगी। यह वापस नहीं आएगा।';

  @override
  String get queueDeleteConfirm => 'हाँ, मिटा दीजिए';

  @override
  String get queueDeleteCancel => 'नहीं, रहने दीजिए';

  @override
  String get failureNetwork =>
      'नेटवर्क बीच में रुक गया। सिग्नल आते ही यह अपने आप फिर जाएगा।';

  @override
  String get failureServer =>
      'हमारी तरफ़ से जवाब नहीं आया। फिर कोशिश की जाएगी।';

  @override
  String get failureMissingFiles =>
      'फ़ोटो अब इस फ़ोन में नहीं हैं, इसलिए यह नहीं भेजा जा सकता। कृपया इसे फिर से बनाइए।';

  @override
  String get failureRejected =>
      'यह स्वीकार नहीं हो सका। कृपया इसे फिर से बनाइए।';

  @override
  String get failureUnknown => 'कुछ गड़बड़ हुई। आप फिर कोशिश कर सकते हैं।';

  @override
  String get processingTitle => 'हम इसे लिख रहे हैं';

  @override
  String get processingBody =>
      'आपकी फ़ोटो और आपकी बात हमारे पास है। इसमें कुछ मिनट लगते हैं।';

  @override
  String get processingLeave =>
      'आपको यहाँ रुकना नहीं है। तैयार होने पर हम आपको बता देंगे।';

  @override
  String get processingGoHome => 'होम पर जाइए';

  @override
  String get attentionTitle => 'एक सवाल';

  @override
  String get attentionBody => 'बाकी सब हमें समझ आ गया। सिर्फ़ यह बात रह गई।';

  @override
  String get attentionHoldToAnswer => 'दबाकर जवाब दीजिए';

  @override
  String get attentionAnswering => 'आपका जवाब भेजा जा रहा है…';

  @override
  String get attentionFailed => 'आपका जवाब नहीं गया। कृपया फिर से बोलिए।';

  @override
  String get attentionRetakePhotos => 'फ़ोटो फिर से लीजिए';

  @override
  String get attentionRetakeSending => 'आपकी नई फ़ोटो भेजी जा रही हैं…';

  @override
  String get attentionRetakeFailed =>
      'नई फ़ोटो नहीं गईं। कृपया फिर से कोशिश कीजिए।';

  @override
  String get readBackTitle => 'हमें यह समझ आया';

  @override
  String get readBackListen => 'पूरा सुनिए';

  @override
  String get readBackFields => 'हमने जो लिखा';

  @override
  String get readBackCorrect => 'जो गलत हो, उसे दबाइए';

  @override
  String get readBackApprove => 'यह सब सही है';

  @override
  String get notSaid => 'नहीं बताया';

  @override
  String get fieldMaterial => 'किस चीज़ का';

  @override
  String get fieldSize => 'नाप';

  @override
  String get fieldColour => 'रंग';

  @override
  String get fieldTechnique => 'कैसे बनाया';

  @override
  String get fieldOrigin => 'कहाँ बनाया';

  @override
  String get fieldQuantity => 'कितने';

  @override
  String get fieldPrice => 'दाम';

  @override
  String correctTitle(String field) {
    return 'सही $field बोलिए';
  }

  @override
  String get correctHoldToSpeak => 'दबाकर बोलिए';

  @override
  String get correctListening => 'सुन रहे हैं…';

  @override
  String get correctFailedOnce => 'हम समझ नहीं पाए। एक बार और कहिए।';

  @override
  String get correctUseKeypad => 'इसके बजाय लिखिए';

  @override
  String get correctUseVoice => 'इसके बजाय बोलिए';

  @override
  String get correctPick => 'या इनमें से चुनिए';

  @override
  String get correctSave => 'यह सहेजिए';

  @override
  String get correctCancel => 'जैसा है वैसा रहने दीजिए';

  @override
  String get correctTypeHint => 'उत्तर यहाँ लिखिए';

  @override
  String correctHeard(Object text) {
    return 'हमने सुना “$text”';
  }

  @override
  String get listingCancelAction => 'यह सामान रद्द कीजिए';

  @override
  String get listingCancelTitle => 'यह सामान रद्द करें?';

  @override
  String get listingCancelBody =>
      'फ़ोटो, रिकॉर्डिंग और आपकी कही हुई सब बातें मिट जाएँगी। यह वापस नहीं आएगा।';

  @override
  String get listingCancelConfirm => 'हाँ, रद्द कीजिए';

  @override
  String get listingCancelKeep => 'नहीं, रहने दीजिए';

  @override
  String get photoSaveAction => 'फ़ोटो सहेजिए';

  @override
  String get photoSaved => 'आपकी फ़ोटो में सहेज दिया';

  @override
  String get photoSaveFailed => 'फ़ोटो सहेजी नहीं जा सकी';

  @override
  String get photoSaveDenied => 'फ़ोटो सहेजने के लिए अनुमति दीजिए';

  @override
  String get colourRed => 'लाल';

  @override
  String get colourBlue => 'नीला';

  @override
  String get colourGreen => 'हरा';

  @override
  String get colourYellow => 'पीला';

  @override
  String get colourBlack => 'काला';

  @override
  String get colourWhite => 'सफ़ेद';

  @override
  String get colourBrown => 'भूरा';

  @override
  String get colourMulti => 'कई रंग';

  @override
  String get sizeSmall => 'छोटा';

  @override
  String get sizeMedium => 'मझोला';

  @override
  String get sizeLarge => 'बड़ा';

  @override
  String get sizeExtraLarge => 'बहुत बड़ा';

  @override
  String get suggestTitle => 'क्या यह भी जोड़ दें?';

  @override
  String get suggestYes => 'हाँ, जोड़ दीजिए';

  @override
  String get suggestNo => 'नहीं, रहने दीजिए';

  @override
  String get suggestSkip => 'मुझे पक्का पता नहीं';

  @override
  String suggestProgress(int current, int total) {
    return '$total में से $current';
  }

  @override
  String get suggestDone => 'और कुछ जोड़ना नहीं है';

  @override
  String get priceTitle => 'दाम कितना है?';

  @override
  String get priceBody => 'यह एक नग का दाम है।';

  @override
  String priceBand(String low, String high) {
    return 'ऐसी चीज़ें दूसरे लोग $low से $high में बेचते हैं';
  }

  @override
  String get priceBelowFloor =>
      'यह आपकी लागत से कम है। फिर भी आप यही रख सकते हैं।';

  @override
  String get priceSayIt => 'दाम बोलिए';

  @override
  String get priceConfirm => 'यह दाम सही है';

  @override
  String get stockTitle => 'आपके पास कितने हैं?';

  @override
  String get stockBody => 'सब बिक जाने पर हम आपकी तरफ़ से यह हटा देंगे।';

  @override
  String get stockOneOfAKind => 'सिर्फ़ एक ही है, और दूसरा कभी नहीं बनेगा';

  @override
  String get stockMore => 'एक और';

  @override
  String get stockLess => 'एक कम';

  @override
  String get stockConfirm => 'यह सही है';

  @override
  String get photosTitle => 'कौन सी फ़ोटो पहले आएगी?';

  @override
  String get photosBody => 'ख़रीदने वाले सबसे पहले पहली फ़ोटो देखते हैं।';

  @override
  String get photosMakeFirst => 'इसे पहली फ़ोटो बनाइए';

  @override
  String get photosFirst => 'पहली फ़ोटो';

  @override
  String get photosConfirm => 'ये फ़ोटो सही हैं';

  @override
  String get previewTitle => 'ख़रीदने वाले यह देखेंगे';

  @override
  String get previewListenAll => 'पूरा सुनिए';

  @override
  String get previewNoDescription => 'कोई ब्यौरा नहीं लिखा गया।';

  @override
  String get previewConfirm => 'हाँ, यह सही है';

  @override
  String get previewChange => 'कुछ बदलिए';

  @override
  String get consentTitle => 'क्या हम इसे बिक्री पर लगा दें?';

  @override
  String get consentPhoto => 'मेरी फ़ोटो दिखाइए';

  @override
  String get consentPhotoExplain =>
      'आपके सामान की फ़ोटो ख़रीदने वाले की स्क्रीन पर जाएँगी।';

  @override
  String get consentStory => 'मेरी कारीगरी की कहानी दिखाइए';

  @override
  String get consentStoryExplain =>
      'आपका नाम, आपका गाँव और आप कैसे बनाते हैं, यह कारीगर कार्ड पर जाएगा। मना करके भी आप बेच सकते हैं।';

  @override
  String get consentNeeded => 'फ़ोटो के बिना हम इसे नहीं लगा सकते।';

  @override
  String get consentPublish => 'बिक्री पर लगाइए';

  @override
  String get publishingTitle => 'बिक्री पर लगाया जा रहा है';

  @override
  String get publishingBody => 'इसमें थोड़ा समय लगेगा। ऐप बंद मत कीजिए।';

  @override
  String get publishedTitle => 'यह बिक्री पर लग गया';

  @override
  String get publishedBody => 'ख़रीदने वाले इसे अभी देख सकते हैं।';

  @override
  String get publishedShare => 'व्हाट्सएप पर भेजिए';

  @override
  String get publishedCopyLink => 'लिंक कॉपी कीजिए';

  @override
  String get publishedLinkCopied => 'लिंक कॉपी हो गया';

  @override
  String get publishedShowQr => 'स्कैन करने वाला कोड दिखाइए';

  @override
  String get publishedQrExplain =>
      'कोई भी अपना फ़ोन इस पर रखकर आपका सामान खोल सकता है।';

  @override
  String get publishedAnother => 'ऐसा एक और बनाइए';

  @override
  String get publishedDone => 'होम पर जाइए';

  @override
  String get publishFailed =>
      'यह नहीं लग सका। कुछ खोया नहीं है, आप फिर कोशिश कर सकते हैं।';

  @override
  String get publishRetry => 'फिर कोशिश कीजिए';

  @override
  String get reviewLeaveTitle => 'अभी के लिए छोड़ दें?';

  @override
  String get reviewLeaveBody =>
      'आपने जो मंज़ूर किया है वह रखा रहेगा। आप अपने सामान में जाकर फिर आ सकते हैं।';

  @override
  String get reviewLeaveConfirm => 'अभी के लिए छोड़िए';

  @override
  String get editLeaveTitle => 'बदलाव अभी बिक्री पर नहीं गए हैं';

  @override
  String get editLeaveBody =>
      'आपके बदलाव सहेज लिए गए हैं, लेकिन ख़रीदने वालों को अभी भी पुराना ही दिख रहा है। इन्हें लगाने के लिए आपको आख़िरी बटन दबाना होगा।';

  @override
  String get editLeaveConfirm => 'ठीक है, बाद में लगाऊँगा';

  @override
  String get reviewLeaveCancel => 'आगे बढ़िए';

  @override
  String get statusSoldOut => 'सब बिक गए';

  @override
  String get statusUnpublished => 'हटा दिया गया';

  @override
  String get listingsTitle => 'आपका सामान';

  @override
  String get listingsEmptyTitle => 'आपने अभी कुछ नहीं बनाया';

  @override
  String get listingsEmptyBody =>
      'होम पर बड़ा बटन दबाकर अपना पहला सामान डालिए।';

  @override
  String get listingsEmptyFilter => 'यहाँ कुछ नहीं है।';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बचे',
      one: '1 बचा',
      zero: 'कुछ नहीं बचा',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बार देखा गया',
      one: 'एक बार देखा गया',
      zero: 'अभी किसी ने नहीं देखा',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'कितने हैं, बदलिए';

  @override
  String get listingTitle => 'यह सामान';

  @override
  String get listingOpenPreview => 'ख़रीदने वाले जो देखते हैं, वह देखिए';

  @override
  String get listingEdit => 'कुछ बदलिए';

  @override
  String get listingDuplicate => 'ऐसा एक और बनाइए';

  @override
  String get listingUnpublish => 'बिक्री से हटाइए';

  @override
  String get listingRelist => 'फिर बिक्री पर लगाइए';

  @override
  String get listingFinish => 'इसे पूरा कीजिए';

  @override
  String get listingSoldOutTitle => 'ये सब बिक गए';

  @override
  String get listingSoldOutBody =>
      'हमने इसे आपके लिए बिक्री से हटा दिया। और बना लें तो फिर लगा दीजिए।';

  @override
  String get editTitle => 'यह सामान बदलिए';

  @override
  String get editBody =>
      'आप इसे फिर से देखेंगे, और उसके बाद यह वापस बिक्री पर चला जाएगा।';

  @override
  String get editRepublishing => 'बदलाव बिक्री पर लगाए जा रहे हैं…';

  @override
  String get editRepublished => 'आपके बदलाव अब बिक्री पर हैं';

  @override
  String get editRepublishConfirm => 'बदलाव वापस बिक्री पर लगाइए';

  @override
  String get quickStockTitle => 'कितने बचे हैं?';

  @override
  String get quickStockMarkSoldOut => 'सब बिक गए हैं';

  @override
  String get quickStockSave => 'सहेजिए';

  @override
  String get quickStockSaved => 'सहेज लिया';

  @override
  String get actionUndo => 'पहले जैसा करें';

  @override
  String get unpublishTitle => 'बिक्री से हटाएँ?';

  @override
  String get unpublishBody =>
      'ख़रीदने वाले इसे अब नहीं देखेंगे। कुछ मिटेगा नहीं, और आप इसे कभी भी वापस लगा सकते हैं।';

  @override
  String get unpublishConfirm => 'हाँ, हटा दीजिए';

  @override
  String get unpublishCancel => 'नहीं, बिक्री पर रहने दीजिए';

  @override
  String get unpublishDone => 'यह बिक्री से हट गया';

  @override
  String get relistDone => 'यह फिर बिक्री पर है';

  @override
  String get duplicateTitle => 'ऐसा एक और बनाएँ?';

  @override
  String get duplicateBody =>
      'आपने इसके बारे में जो बताया था, वह हम रख लेंगे। आपको सिर्फ़ नई फ़ोटो लेनी हैं।';

  @override
  String get duplicateConfirm => 'फ़ोटो लीजिए';

  @override
  String get duplicateCancel => 'अभी नहीं';

  @override
  String get duplicateBanner =>
      'पिछले जैसा एक और बनाया जा रहा है। सिर्फ़ फ़ोटो नई हैं।';

  @override
  String get listingActionFailed => 'यह नहीं हो सका। कृपया फिर कोशिश कीजिए।';

  @override
  String get salesNew => 'नया';

  @override
  String get salesEmptyTitle => 'अभी कुछ नहीं बिका';

  @override
  String get salesEmptyBody =>
      'जब कोई कुछ ख़रीदेगा, वह यहाँ दिखेगा और हम आपको बता देंगे।';

  @override
  String get salesLoading => 'देख रहे हैं क्या बिका…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नग',
      one: '1 नग',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date तक बाँधिए';
  }

  @override
  String get salesPackByToday => 'आज ही बाँधिए';

  @override
  String get salesPackByTomorrow => 'कल तक बाँधिए';

  @override
  String get salesPackedAlready => 'इसकी तारीख़ निकल चुकी है';

  @override
  String get saleTitle => 'यह ऑर्डर';

  @override
  String get saleReadOnly =>
      'यह सिर्फ़ आपको बताने के लिए है। ऑर्डर का सारा काम बाज़ार पर होता है, इस ऐप में नहीं।';

  @override
  String salePaid(String amount) {
    return 'आपको $amount मिलेंगे';
  }

  @override
  String salePlaced(String date) {
    return '$date को बिका';
  }

  @override
  String saleGoingTo(String area) {
    return '$area जा रहा है';
  }

  @override
  String get saleWhatToPack => 'क्या बाँधना है';

  @override
  String get salePackingHelp => 'कैसे बाँधें';

  @override
  String get saleSeeListing => 'यह सामान देखिए';

  @override
  String get packingTitle => 'कैसे बाँधें';

  @override
  String get packingBody =>
      'इन्हें एक-एक करके कीजिए। जो हो जाए, उसे दबा दीजिए।';

  @override
  String get packingStep1 => 'कपड़े या काग़ज़ में लपेटिए, जिससे कुछ रगड़े नहीं';

  @override
  String get packingStep2 =>
      'चारों तरफ़ काग़ज़ या भूसा भरिए, जिससे डिब्बे के अंदर हिले नहीं';

  @override
  String get packingStep3 => 'देख लीजिए कि अंदर उतने ही नग हैं जितने चाहिए';

  @override
  String get packingStep4 => 'डिब्बा बंद करके चारों तरफ़ टेप लगाइए';

  @override
  String get packingStep5 => 'लेने आने वाले के लिए तैयार रखिए';

  @override
  String get packingDone => 'सब हो गया';

  @override
  String packingProgress(int done, int total) {
    return '$total में से $done हो गए';
  }

  @override
  String get earningsTitle => 'आपने कितना कमाया';

  @override
  String get earningsWeek => 'इस हफ़्ते';

  @override
  String get earningsMonth => 'इस महीने';

  @override
  String get earningsTotal => 'शुरू से अब तक';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नग बिके',
      one: '1 नग बिका',
      zero: 'अभी कुछ नहीं बिका',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'यह वह है जो आपको मिलता है, बाज़ार का हिस्सा निकलने के बाद।';

  @override
  String get profileVillageLabel => 'गाँव या क्लस्टर';

  @override
  String get profileNotSet => 'नहीं बताया';

  @override
  String get profileEditEntry => 'अपनी जानकारी बदलिए';

  @override
  String get profileStoryEntry => 'आपकी कारीगरी की कहानी';

  @override
  String get profileLanguageEntry => 'भाषा';

  @override
  String get profilePhoneEntry => 'फ़ोन नंबर';

  @override
  String get profileOndcEntry => 'आपका बिक्री खाता';

  @override
  String get profileNotificationsEntry => 'हम आपको क्या बताएँ';

  @override
  String get profileVoiceEntry => 'आवाज़ और सुनाई';

  @override
  String get profilePrivacyEntry => 'आपके बारे में क्या दिखता है';

  @override
  String get profileStorageEntry => 'इस फ़ोन में जगह';

  @override
  String get profileAccountEntry => 'साइन आउट';

  @override
  String get editProfileTitle => 'आपकी जानकारी';

  @override
  String get editProfileAddPhoto => 'अपनी फ़ोटो डालिए';

  @override
  String get editProfileChangePhoto => 'फ़ोटो बदलिए';

  @override
  String get editProfileRemovePhoto => 'फ़ोटो हटाइए';

  @override
  String get editProfilePhotoWhy =>
      'आपकी इजाज़त हो तभी ख़रीदने वाले इसे कारीगर कार्ड पर देखते हैं।';

  @override
  String get editProfileVillageHint => 'बोलिए या लिखिए';

  @override
  String get editProfileSave => 'सहेजिए';

  @override
  String get editProfileSaved => 'सहेज लिया';

  @override
  String get storyTitle => 'आपकी कारीगरी की कहानी';

  @override
  String get storyBody =>
      'ख़रीदने वालों को बताइए कि आप कौन हैं और कैसे बनाते हैं। आप बोलिए, हम लिख लेंगे।';

  @override
  String get storyHoldToSpeak => 'दबाकर अपनी कहानी सुनाइए';

  @override
  String get storyEmpty => 'आपने अभी अपनी कहानी नहीं बताई।';

  @override
  String get storyEditHint => 'आप इसका कोई भी शब्द बदल सकते हैं।';

  @override
  String get storyExample =>
      'जैसे: हमारे घर में तीन पीढ़ियों से यही बनता आया है, और मैं आज भी अपने दादा के करघे पर काम करता हूँ।';

  @override
  String get changePhoneTitle => 'अपना नंबर बदलिए';

  @override
  String get changePhoneBody =>
      'नंबर आपका ही है, यह पक्का करने के लिए हम उस पर एक कोड भेजेंगे।';

  @override
  String changePhoneCurrent(String number) {
    return 'अभी आपका नंबर $number है';
  }

  @override
  String get changePhoneDone => 'आपका नंबर बदल गया';

  @override
  String get ondcAccountTitle => 'आपका बिक्री खाता';

  @override
  String get ondcAccountLinked => 'आपका खाता जुड़ा हुआ है';

  @override
  String get ondcAccountNone => 'अभी कोई खाता नहीं जुड़ा';

  @override
  String get ondcAccountNoneBody =>
      'आप सामान बनाते रहिए। खाता जुड़ते ही वह बिक्री पर चला जाएगा।';

  @override
  String get ondcAccountLink => 'खाता जोड़िए';

  @override
  String get ondcAccountUnlink => 'यह खाता हटाइए';

  @override
  String get ondcUnlinkTitle => 'यह खाता हटाएँ?';

  @override
  String get ondcUnlinkBody =>
      'जो बिक्री पर है वह हट जाएगा। आपका बनाया कुछ भी मिटेगा नहीं, और आप इसे फिर जोड़ सकते हैं।';

  @override
  String get ondcUnlinkConfirm => 'हाँ, हटा दीजिए';

  @override
  String get ondcUnlinkCancel => 'नहीं, रहने दीजिए';

  @override
  String get ondcUnlinkDone => 'खाता हट गया';

  @override
  String get notificationsTitle => 'हम आपको क्या बताएँ';

  @override
  String get notifySold => 'जब कुछ बिके';

  @override
  String get notifySoldWhy =>
      'ख़रीदने वाले के पैसे देते ही हम बता देंगे, जिससे आप बाँधना शुरू कर सकें।';

  @override
  String get notifyAttention => 'जब हमें आपसे कुछ पूछना हो';

  @override
  String get notifyAttentionWhy =>
      'कभी-कभी सामान बिक्री पर जाने से पहले एक बात रह जाती है।';

  @override
  String get notifyUpload => 'जब सामान भेजा जा चुके';

  @override
  String get notifyUploadWhy =>
      'आपने फ़ोन पर जो बनाया वह हम तक पहुँच जाए, तब हम बता देंगे।';

  @override
  String get notifyPackBy => 'जब पैक करने का समय हो';

  @override
  String get notifyPackByWhy =>
      'जिस बिक्री को पैक करना है, उसकी तारीख से एक दिन पहले और उसी दिन हम आपको याद दिलाएँगे।';

  @override
  String get notificationsBlocked =>
      'यह फ़ोन हमें आपको कुछ भेजने नहीं दे रहा। आप इसे फ़ोन की सेटिंग में चालू कर सकते हैं।';

  @override
  String get voiceSettingsTitle => 'आवाज़ और सुनाई';

  @override
  String get voiceSpeed => 'हम कितनी तेज़ बोलें';

  @override
  String get voiceSpeedSlow => 'धीरे';

  @override
  String get voiceSpeedFast => 'तेज़';

  @override
  String get voiceTry => 'अभी बोलकर सुनाइए';

  @override
  String get voiceSample => 'हम आपसे इतनी तेज़ बोलेंगे।';

  @override
  String get voiceAutoRead => 'हर स्क्रीन खुलते ही पढ़कर सुनाइए';

  @override
  String get voiceAutoReadWhy =>
      'यह बंद हो तो हम तभी बोलते हैं जब आप स्पीकर दबाते हैं।';

  @override
  String get voiceUnavailable =>
      'यह फ़ोन बोल नहीं सकता। सब कुछ चलेगा, पर कुछ पढ़कर नहीं सुनाया जाएगा।';

  @override
  String get privacyTitle => 'आपके बारे में क्या दिखता है';

  @override
  String get privacyBody =>
      'हर सामान बिक्री पर लगाते समय आपने इनके लिए हाँ कहा था। आप इनमें से कोई भी वापस ले सकते हैं।';

  @override
  String get privacyPhoto => 'इस सामान की फ़ोटो';

  @override
  String get privacyStory => 'आपका नाम, गाँव और कहानी';

  @override
  String get privacyNothing => 'अभी आपका कुछ भी बिक्री पर नहीं है।';

  @override
  String get privacyWithdrawTitle => 'यह वापस लें?';

  @override
  String get privacyWithdrawPhotoBody =>
      'फ़ोटो के बिना यह सामान बिक्री पर नहीं रह सकता, इसलिए यह हट जाएगा। कुछ मिटेगा नहीं।';

  @override
  String get privacyWithdrawStoryBody =>
      'आपका नाम, गाँव और कहानी इस सामान से हटा दी जाएगी। यह बिक्री पर बना रहेगा।';

  @override
  String get privacyWithdrawConfirm => 'हाँ, वापस लीजिए';

  @override
  String get privacyWithdrawCancel => 'नहीं, रहने दीजिए';

  @override
  String get privacyWithdrawn => 'वापस ले लिया';

  @override
  String get storageTitle => 'इस फ़ोन में जगह';

  @override
  String get storagePhotos => 'फ़ोटो और रिकॉर्डिंग';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चीज़ें भेजी जानी बाकी हैं',
      one: '1 चीज़ भेजी जानी बाकी है',
      zero: 'भेजा जाना कुछ भी बाकी नहीं',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'जो भेजा जा चुका है, उसे हटाइए';

  @override
  String get storageClearWhy =>
      'जो अभी भेजा जाना बाकी है, उसे कभी नहीं छुआ जाता।';

  @override
  String storageCleared(String size) {
    return '$size खाली हुई';
  }

  @override
  String get storageNothingToClear => 'हटाने के लिए कुछ नहीं है';

  @override
  String get accountTitle => 'साइन आउट';

  @override
  String get accountSignOut => 'इस फ़ोन से साइन आउट कीजिए';

  @override
  String get accountSignOutTitle => 'साइन आउट करें?';

  @override
  String get accountSignOutBody =>
      'जो भेजा जाना बाकी है वह चला जाएगा। जो बिक्री पर है वह बिक्री पर ही रहेगा।';

  @override
  String get accountSignOutConfirm => 'हाँ, साइन आउट';

  @override
  String get accountSignOutCancel => 'नहीं, बने रहिए';

  @override
  String get accountDelete => 'मेरा खाता मिटाइए';

  @override
  String get accountDeleteTitle => 'अपना खाता मिटाएँ?';

  @override
  String get accountDeleteBody =>
      'सब कुछ बिक्री से हट जाएगा और इस फ़ोन का सारा सामान मिट जाएगा। यह वापस नहीं आएगा।';

  @override
  String get accountDeleteConfirm => 'हाँ, सब कुछ मिटा दीजिए';

  @override
  String get accountDeleteCancel => 'नहीं, मेरा खाता रहने दीजिए';

  @override
  String get accountDeleteHold => 'मिटाने के लिए बटन दबाए रखिए';

  @override
  String get profileHelpEntry => 'मदद';

  @override
  String get helpTitle => 'मदद';

  @override
  String get helpBody =>
      'छोटे जवाब, पढ़कर सुनाए जाते हैं। सुनने के लिए किसी को भी दबाइए।';

  @override
  String get helpSteps => 'ऐसे कीजिए';

  @override
  String get helpTopicPhotos => 'अच्छी फ़ोटो कैसे लें';

  @override
  String get helpTopicPhotosBody =>
      'अच्छी फ़ोटो से सामान बिकता है। ख़रीदने वाला सामान हाथ में नहीं ले सकता, उसके पास सिर्फ़ फ़ोटो होती है।';

  @override
  String get helpTopicPhotosStep1 =>
      'दरवाज़े या खिड़की के पास खड़े होइए, जिससे दिन की रोशनी सामान पर पड़े';

  @override
  String get helpTopicPhotosStep2 =>
      'सामान को सादे कपड़े पर रखिए, आसपास और कुछ न हो';

  @override
  String get helpTopicPhotosStep3 =>
      'फ़ोटो आने तक फ़ोन को दोनों हाथों से स्थिर पकड़िए';

  @override
  String get helpTopicPhotosStep4 =>
      'एक फ़ोटो पास से लीजिए, जिससे कारीगरी दिखे';

  @override
  String get helpTopicPhotosStep5 =>
      'एक फ़ोटो में बगल में हाथ रखिए, जिससे नाप पता चले';

  @override
  String get helpTopicVoice => 'अपने सामान के बारे में क्या बोलें';

  @override
  String get helpTopicVoiceBody =>
      'जैसे सामने खड़े ग्राहक से बोलते हैं, वैसे ही बोलिए। बोलने का कोई ग़लत तरीक़ा नहीं है।';

  @override
  String get helpTopicVoiceStep1 => 'बताइए यह क्या है';

  @override
  String get helpTopicVoiceStep2 => 'बताइए यह किस चीज़ का बना है';

  @override
  String get helpTopicVoiceStep3 => 'बताइए यह कितना बड़ा है, इंच या फुट में';

  @override
  String get helpTopicVoiceStep4 => 'बताइए बनाने में कितना समय लगा';

  @override
  String get helpTopicVoiceStep5 => 'बताइए आप इसके कितने चाहते हैं';

  @override
  String get helpTopicPrice => 'दाम कैसे तय करें';

  @override
  String get helpTopicPriceBody =>
      'दाम में आपका सामान और आपका समय, दोनों निकलने चाहिए। हम आपके साथ यह जोड़ते हैं, और उससे कम पर बिना बताए कभी नहीं जाने देते।';

  @override
  String get helpTopicPriceStep1 => 'जोड़िए कि सामान में कितना लगा';

  @override
  String get helpTopicPriceStep2 => 'जोड़िए कि काम में कितने दिन लगे';

  @override
  String get helpTopicPriceStep3 =>
      'हम जो बताते हैं वह देखिए, और आप बेहतर जानते हों तो बदल दीजिए';

  @override
  String get helpTopicPriceStep4 =>
      'लागत से कम हुआ तो हम बता देंगे, पर चुनना आपका ही है';

  @override
  String get helpTopicSold => 'बिकने के बाद क्या होता है';

  @override
  String get helpTopicSoldBody =>
      'ख़रीदने वाला बाज़ार पर पैसे देता है। आप सामान बाँधकर दे देते हैं, और पैसे आप तक आ जाते हैं।';

  @override
  String get helpTopicSoldStep1 => 'बिकते ही हम आपको बता देंगे';

  @override
  String get helpTopicSoldStep2 => 'खोलकर देखिए क्या और कितना बाँधना है';

  @override
  String get helpTopicSoldStep3 => 'हम जो तारीख़ बताएँ, उससे पहले बाँध लीजिए';

  @override
  String get helpTopicSoldStep4 => 'लेने आने वाले को दे दीजिए';

  @override
  String get helpTopicSoldStep5 => 'उसके बाद पैसे आप तक पहुँच जाते हैं';

  @override
  String get helpVideoComing => 'इसके लिए एक छोटा वीडियो जल्दी आ रहा है।';

  @override
  String get helpPractice => 'अच्छी फ़ोटो कैसे लें';

  @override
  String get helpPracticeBody => 'एक ही मटके की एक अच्छी और एक ख़राब फ़ोटो।';

  @override
  String get helpFaqEntry => 'लोग जो पूछते हैं';

  @override
  String get helpAboutEntry => 'कीर्तिकर के बारे में';

  @override
  String get helpSupportEntry => 'किसी व्यक्ति से बात कीजिए';

  @override
  String get helpTermsEntry => 'शर्तें और निजता';

  @override
  String get faqTitle => 'लोग जो पूछते हैं';

  @override
  String get faqQ1 => 'क्या इसका मुझे कुछ देना पड़ेगा?';

  @override
  String get faqA1 =>
      'नहीं। सामान डालना मुफ़्त है। कुछ बिकने पर ही बाज़ार अपना थोड़ा हिस्सा लेता है।';

  @override
  String get faqQ2 => 'नेटवर्क न हो तो?';

  @override
  String get faqA2 =>
      'सब कुछ चलता रहेगा। आपका बनाया आपके फ़ोन में रखा रहता है और नेटवर्क आते ही अपने आप चला जाता है।';

  @override
  String get faqQ3 => 'पैसे किसके पास जाते हैं?';

  @override
  String get faqA3 =>
      'आपके। ख़रीदने वाला बाज़ार पर पैसे देता है और वे आपके खाते में आते हैं। पैसे कभी हमारे पास से नहीं जाते।';

  @override
  String get faqQ4 => 'बिक्री पर लगने के बाद कुछ बदल सकते हैं?';

  @override
  String get faqA4 =>
      'हाँ। अपने सामान में जाकर खोलिए, जो बदलना हो बदलिए, और वह फिर बिक्री पर चला जाएगा।';

  @override
  String get faqQ5 => 'मैंने कुछ ग़लत बोल दिया तो?';

  @override
  String get faqA5 =>
      'जब तक आप सुनकर सही न कहें, कुछ भी बिक्री पर नहीं जाता। आप बोलकर उसका कोई भी हिस्सा सुधार सकते हैं।';

  @override
  String get faqQ6 => 'क्या मुझे पढ़ना-लिखना आना चाहिए?';

  @override
  String get faqA6 =>
      'नहीं। आप सब कुछ बोलकर और दबाकर कर सकते हैं। हर स्क्रीन आपको पढ़कर सुनाई जा सकती है।';

  @override
  String get faqQ7 => 'मेरा नाम और गाँव कौन देखता है?';

  @override
  String get faqA7 =>
      'आपकी इजाज़त हो तभी, और हर सामान के लिए अलग से। आप इसे कभी भी वापस ले सकते हैं।';

  @override
  String get aboutTitle => 'कीर्तिकर के बारे में';

  @override
  String get aboutWhatTitle => 'यह क्या है';

  @override
  String get aboutWhat =>
      'कीर्तिकर हाथ से बने सामान को ONDC पर पहुँचाता है, भारत का खुला ख़रीद-बिक्री नेटवर्क, और इसके लिए बनाने वाले को लिखना नहीं, बोलना होता है। आपकी भाषा में कुछ फ़ोटो और एक बात से ऐसी लिस्टिंग बनती है जो देश भर के ख़रीदार देख सकते हैं।';

  @override
  String get aboutWhyTitle => 'हमने यह क्यों बनाया';

  @override
  String get aboutWhy =>
      'भारत में लगभग सत्तर लाख कारीगर ऐसा सामान बनाते हैं जो लोग ख़रीदना चाहते हैं, और उनमें से ज़्यादातर बिचौलिए के ज़रिए बेचते हैं जो अंतर का पैसा रख लेता है। रुकावट काम में नहीं है। रुकावट फ़ॉर्म में है: ऑनलाइन लिस्टिंग अंग्रेज़ी में टाइप करना, ढेरों ख़ाने भरना और कैटलॉग जैसी फ़ोटो माँगती है। यह ऐप वह फ़ॉर्म हटा देता है।';

  @override
  String get aboutHowTitle => 'यह कैसे काम करता है';

  @override
  String get aboutHow =>
      'तीन फ़ोटो लीजिए और बोलकर बताइए कि यह क्या है। हमारी व्यवस्था सुनती है, लिस्टिंग लिखती है, और आपको पढ़कर सुनाती है। जब तक आप सुनकर सही न कहें, कुछ भी बाहर नहीं जाता।';

  @override
  String get aboutSihTitle => 'स्मार्ट इंडिया हैकाथॉन 2025';

  @override
  String get aboutSih =>
      'समस्या 090 के लिए बनाया गया: कारीगरों और बुनकरों को ONDC पर ख़रीदारों तक पहुँचाना।';

  @override
  String get aboutMissionTitle => 'हम क्या करना चाहते हैं';

  @override
  String get aboutMission =>
      'किसी काम का दाम उसी के हाथ में हो जिसने वह काम किया है।';

  @override
  String get supportTitle => 'किसी व्यक्ति से बात कीजिए';

  @override
  String get supportBody =>
      'कुछ काम न कर रहा हो, या समझ न आ रहा हो कि क्या करें, तो हमें फ़ोन कीजिए। कोई व्यक्ति आपकी भाषा में जवाब देगा।';

  @override
  String get supportCall => 'हमें फ़ोन कीजिए';

  @override
  String get supportWhatsApp => 'व्हाट्सएप पर संदेश भेजिए';

  @override
  String get supportHours => 'हर दिन, सुबह नौ से शाम सात बजे तक।';

  @override
  String supportNumber(String number) {
    return 'हमारा नंबर $number है';
  }

  @override
  String supportFailed(String number) {
    return 'आपका फ़ोन इसे खोल नहीं सका। हमारा नंबर $number है।';
  }

  @override
  String get termsTitle => 'शर्तें और निजता';

  @override
  String get termsSummaryTitle => 'छोटी बात';

  @override
  String get termsSummary1 =>
      'आपका बनाया आपका ही है। हम उसे आपके लिए बिक्री पर लगाते हैं और बिक्री में से कुछ नहीं लेते।';

  @override
  String get termsSummary2 =>
      'आपकी फ़ोटो और आपकी आवाज़ सिर्फ़ आपकी लिस्टिंग लिखने के लिए इस्तेमाल होती है, और किसी काम के लिए नहीं।';

  @override
  String get termsSummary3 =>
      'आपका नाम, गाँव और कहानी सिर्फ़ उन्हीं सामानों पर जाती है जिनकी आपने इजाज़त दी, और आप वह वापस ले सकते हैं।';

  @override
  String get termsSummary4 =>
      'पैसे ख़रीदने वाले से सीधे आप तक जाते हैं। वे कभी हमारे पास से नहीं जाते।';

  @override
  String get termsSummary5 => 'आप इस फ़ोन से सब कुछ कभी भी मिटा सकते हैं।';

  @override
  String get termsFullTitle => 'पूरी बात';

  @override
  String get termsFullBody =>
      'इस्तेमाल की पूरी शर्तें और निजता नीति हमारी वेबसाइट पर हैं। यहाँ कुछ समझ न आए तो हमें फ़ोन कीजिए, कोई व्यक्ति समझा देगा।';

  @override
  String get termsOpenFull => 'पूरी बात पढ़िए';

  @override
  String get termsAgreeTitle => 'शुरू करने से पहले';

  @override
  String get termsAgreeBody =>
      'आप इन बातों पर सहमति दे रहे हैं। सुनने के लिए स्पीकर दबाइए।';

  @override
  String get termsAgreeCheck => 'मैं शर्तों से सहमत हूँ';

  @override
  String get termsAgreeContinue => 'आगे बढ़िए';

  @override
  String get termsAgreeNeeded =>
      'पहले “मैं शर्तों से सहमत हूँ” पर निशान लगाइए।';

  @override
  String versionNumber(String version) {
    return 'संस्करण $version';
  }

  @override
  String get versionCheck => 'नया संस्करण देखिए';

  @override
  String get versionLicences => 'लाइसेंस';

  @override
  String get versionLicencesWhy => 'यह ऐप जिस मुफ़्त सॉफ़्टवेयर पर बना है।';

  @override
  String get noNetworkTitle => 'नेटवर्क नहीं है';

  @override
  String get noNetworkBody =>
      'आप काम करते रहिए। सब कुछ आपके फ़ोन में रखा रहता है और नेटवर्क आते ही अपने आप चला जाता है।';

  @override
  String get noNetworkNeeded =>
      'इस एक काम के लिए नेटवर्क चाहिए। सिग्नल आने पर फिर कोशिश कीजिए।';

  @override
  String get serverErrorTitle => 'हम अपनी तरफ़ नहीं पहुँच सके';

  @override
  String get serverErrorBody =>
      'आपका किया कुछ भी खोया नहीं है। कृपया थोड़ी देर में फिर कोशिश कीजिए।';

  @override
  String get actionTryAgain => 'फिर कोशिश कीजिए';

  @override
  String get permissionRecoveryTitle => 'ऐप को आपकी इजाज़त चाहिए';

  @override
  String get permissionRecoveryBody =>
      'फ़ोन ऐप को ये इस्तेमाल नहीं करने दे रहा। आप इन्हें फ़ोन की सेटिंग में चालू करके यहाँ वापस आ सकते हैं।';

  @override
  String get permissionCameraWhy =>
      'आपने जो बनाया है उसकी फ़ोटो लेने के लिए। इसके बिना कुछ भी बिक्री पर नहीं लग सकता।';

  @override
  String get permissionMicWhy =>
      'जिससे आप लिखने की जगह बोल सकें। इसके बिना सब कुछ लिखना पड़ेगा।';

  @override
  String get permissionNotifyTitle => 'सूचनाएँ';

  @override
  String get permissionNotifyWhy =>
      'जिससे कुछ बिकने पर हम आपको बता सकें। इसके बिना आपको ऐप खोलकर देखना पड़ेगा।';

  @override
  String get permissionBlocked => 'इजाज़त नहीं है';

  @override
  String get permissionAsk => 'फिर पूछिए';

  @override
  String get permissionRecheck => 'मैंने चालू कर दिया';

  @override
  String get permissionAllGood => 'ऐप को जो चाहिए, सब की इजाज़त है।';

  @override
  String get updateTitle => 'कृपया ऐप अपडेट कीजिए';

  @override
  String get updateBody =>
      'यह संस्करण अब हमसे बात नहीं कर सकता। स्टोर में नया संस्करण मौजूद है, और अपडेट के बाद आपके फ़ोन का सब कुछ वैसा ही रहेगा।';

  @override
  String get updateAction => 'नया संस्करण लीजिए';

  @override
  String get updateFailed => 'स्टोर नहीं खुला। वहाँ कीर्तिकर खोजिए।';

  @override
  String get emptyNudge => 'होम पर बड़ा बटन दबाकर अपना पहला सामान डालिए।';

  @override
  String get productsInProgress => 'तैयार हो रहा है';

  @override
  String get productsListed => 'बिक्री पर';

  @override
  String get productsSold => 'बिक गया';

  @override
  String get voiceTypeInstead => 'लिखकर बताइए';

  @override
  String get voiceSpeakInstead => 'बोलकर बताइए';

  @override
  String get voiceTypeTitle => 'अब लिखिए कि यह क्या है';

  @override
  String get voiceTypeHint => 'यहाँ लिखिए…';

  @override
  String get voiceTypeSave => 'यही विवरण रखिए';

  @override
  String get errorNotAllowed =>
      'यह खाता ऐसा नहीं कर सकता। मदद के लिए हमें फ़ोन कीजिए।';

  @override
  String get errorNotFound => 'यह अब यहाँ नहीं है।';

  @override
  String get errorConflict =>
      'इसे कहीं और बदला गया है। कृपया इसे फिर से खोलकर दोबारा कोशिश कीजिए।';

  @override
  String get errorInvalid =>
      'कुछ जानकारी स्वीकार नहीं हुई। कृपया जाँचकर फिर कोशिश कीजिए।';

  @override
  String get voiceGuideTitle => 'आप इन बातों के बारे में बता सकते हैं';

  @override
  String get voiceGuideWhat => 'चीज़ का नाम';

  @override
  String get voiceGuideSize => 'ऊँचाई';

  @override
  String get voiceGuideColour => 'रंग';

  @override
  String get voiceGuideTime => 'बनाने में लगा समय';

  @override
  String get voiceGuideCost => 'सामान की लागत';
}
