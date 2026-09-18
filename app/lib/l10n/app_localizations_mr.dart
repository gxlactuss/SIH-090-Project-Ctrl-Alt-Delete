import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'कारागीर';

  @override
  String get actionNext => 'पुढे';

  @override
  String get actionBack => 'मागे';

  @override
  String get actionSkip => 'वगळा';

  @override
  String get actionDone => 'झाले';

  @override
  String get actionListen => 'ऐका';

  @override
  String get actionStopListening => 'थांबवा';

  @override
  String stepOfSteps(int current, int total) {
    return 'पायरी $current, एकूण $total';
  }

  @override
  String get splashTagline => 'बोला, आणि तुमची वस्तू विकली जाईल';

  @override
  String get languageTitle => 'तुमची भाषा निवडा';

  @override
  String get languageHint => 'तुम्ही बोलता ती भाषा दाबा';

  @override
  String get welcomeCard1Title => 'तीन फोटो काढा';

  @override
  String get welcomeCard1Body =>
      'तुम्ही बनवलेल्या वस्तूचे तीन फोटो काढा. कसे काढायचे ते ॲप सांगेल.';

  @override
  String get welcomeCard2Title => 'बोलून सांगा';

  @override
  String get welcomeCard2Body =>
      'ही वस्तू काय आहे, कशाची बनली आहे, किंमत किती — फक्त बोला. लिहायची गरज नाही.';

  @override
  String get welcomeCard3Title => 'ती विक्रीला जाते';

  @override
  String get welcomeCard3Body =>
      'आधी तुम्हाला वाचून दाखवले जाईल. तुम्ही होय म्हणाल तेव्हाच ती ऑनलाइन जाईल.';

  @override
  String get welcomeStart => 'सुरू करा';

  @override
  String get permissionsTitle => 'ॲपला तीन गोष्टींची परवानगी हवी';

  @override
  String get permissionCameraTitle => 'कॅमेरा';

  @override
  String get permissionCameraBody =>
      'तुमच्या वस्तूचे फोटो काढण्यासाठी. तुम्ही होय म्हणेपर्यंत फोटो तुमच्याच फोनमध्ये राहतात.';

  @override
  String get permissionMicTitle => 'माइक';

  @override
  String get permissionMicBody =>
      'म्हणजे तुम्ही लिहिण्याऐवजी बोलून सांगू शकाल.';

  @override
  String get permissionNotificationTitle => 'सूचना';

  @override
  String get permissionNotificationBody =>
      'काही विकले गेले की लगेच तुम्हाला कळवता यावे म्हणून.';

  @override
  String get permissionAllow => 'परवानगी द्या';

  @override
  String get permissionNotNow => 'आत्ता नको';

  @override
  String get permissionGranted => 'परवानगी आहे';

  @override
  String get permissionDeniedTitle => 'परवानगी मिळाली नाही';

  @override
  String get permissionDeniedBody =>
      'याशिवाय हे चालणार नाही. फोनच्या सेटिंगमध्ये जाऊन परवानगी द्या.';

  @override
  String get permissionOpenSettings => 'सेटिंग उघडा';

  @override
  String get phoneTitle => 'तुमचा फोन नंबर';

  @override
  String get phoneWhy =>
      'आम्ही या नंबरवर एक कोड पाठवू. हा नंबर दुसऱ्या कोणालाही दिला जात नाही.';

  @override
  String get phoneInvalid => 'दहा अंकी नंबर टाका';

  @override
  String phoneUnknown(String number) {
    return 'हा नंबर या डेमोमध्ये चालणार नाही. $number वापरा.';
  }

  @override
  String get phoneSendCode => 'कोड पाठवा';

  @override
  String get otpTitle => 'आलेला कोड टाका';

  @override
  String otpSentTo(String number) {
    return '$number वर पाठवला';
  }

  @override
  String otpResendIn(int seconds) {
    return 'पुन्हा पाठवा — $seconds सेकंदांनी';
  }

  @override
  String get otpResend => 'कोड पुन्हा पाठवा';

  @override
  String get otpCallMe => 'मला फोन करून सांगा';

  @override
  String get otpCalling => 'थोड्या वेळात फोन येईल आणि कोड बोलून सांगितला जाईल.';

  @override
  String get otpWrong => 'कोड बरोबर नाही. पुन्हा टाका.';

  @override
  String get phoneSendFailed =>
      'कोड पाठवता आला नाही. नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get otpExpired => 'कोडची वेळ संपली. पुन्हा पाठवा.';

  @override
  String get authTooManyTries =>
      'खूप वेळा प्रयत्न झाले. थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get otpChangeNumber => 'नंबर बदला';

  @override
  String get otpAutoRead => 'संदेश आपोआप वाचला गेला';

  @override
  String get profileTitle => 'तुमच्याबद्दल सांगा';

  @override
  String get profileNameLabel => 'तुमचे नाव';

  @override
  String get profileNameHint => 'बोलून सांगा किंवा लिहा';

  @override
  String get profileNameMissing => 'नाव सांगा';

  @override
  String get profileCraftLabel => 'तुम्ही काय बनवता';

  @override
  String get profileCraftMissing => 'एक निवडा';

  @override
  String get profileSpeakToFill => 'बोलून सांगा';

  @override
  String get profileListening => 'ऐकत आहोत…';

  @override
  String get dictationUnavailable =>
      'या फोनवर बोलून लिहिणे चालत नाही. कृपया लिहून टाका.';

  @override
  String get dictationNothingHeard =>
      'काही ऐकू आले नाही. माइक दाबून पुन्हा बोला.';

  @override
  String get craftWeaving => 'विणकाम';

  @override
  String get craftPottery => 'मातीकाम';

  @override
  String get craftWoodwork => 'लाकूडकाम';

  @override
  String get craftMetalwork => 'धातूकाम';

  @override
  String get craftJewellery => 'दागिने';

  @override
  String get craftEmbroidery => 'भरतकाम';

  @override
  String get craftPainting => 'चित्रकला';

  @override
  String get craftLeather => 'चामड्याचे काम';

  @override
  String get craftBamboo => 'बांबू आणि गवत';

  @override
  String get craftOther => 'दुसरे काही';

  @override
  String get ondcTitle => 'तुमचे ओएनडीसी खाते जोडा';

  @override
  String get ondcExplain =>
      'ओएनडीसी ही अशी जागा आहे जिथे ग्राहक तुमची वस्तू बघतात आणि विकत घेतात. पैसे थेट तुम्हाला मिळतात, आमच्याकडे येत नाहीत.';

  @override
  String get ondcMalformed =>
      'हा सेलर आयडी वाटत नाही. कृपया तपासा, किंवा कोड पुन्हा स्कॅन करा.';

  @override
  String get ondcEmailLabel => 'ओएनडीसी ईमेल';

  @override
  String get ondcEmailMalformed =>
      'हा ईमेल पत्ता बरोबर वाटत नाही. कृपया तो तपासा.';

  @override
  String get ondcSellerIdLabel => 'विक्रेता आयडी';

  @override
  String get ondcScan => 'क्यूआर कोड स्कॅन करा';

  @override
  String get ondcLink => 'खाते जोडा';

  @override
  String get ondcLinking => 'जोडत आहोत…';

  @override
  String get ondcFailed => 'हे खाते सापडले नाही. पुन्हा तपासा.';

  @override
  String get ondcNoAccount => 'माझ्याकडे अजून खाते नाही';

  @override
  String get ondcNoAccountExplain =>
      'हरकत नाही. तुम्ही वस्तू तयार करून ठेवू शकता. खाते जोडले की सगळे एकदम पाठवले जाईल.';

  @override
  String get practiceTitle => 'चांगला फोटो कसा काढावा';

  @override
  String get practiceIntro =>
      'एकच मडके, एकदा चांगले आणि एकदा वाईट काढलेले. दोन्ही पाहण्यासाठी सरकवा.';

  @override
  String get practiceGoodBadge => 'असे करा';

  @override
  String get practiceGoodTitle => 'चांगला फोटो';

  @override
  String get practiceGoodTip1 => 'स्पष्ट: फोन स्थिर धरला होता';

  @override
  String get practiceGoodTip2 => 'उजेड: खिडकी किंवा दाराजवळ काढला';

  @override
  String get practiceGoodTip3 => 'संपूर्ण वस्तू फोटोत आहे';

  @override
  String get practiceBadBadge => 'असे करू नका';

  @override
  String get practiceBadTitle => 'वाईट फोटो';

  @override
  String get practiceBadTip1 => 'अस्पष्ट: फोन हलला';

  @override
  String get practiceBadTip2 => 'खरेदीदारांना बारकावे दिसत नाहीत';

  @override
  String get practiceBadTip3 => 'अॅप तुम्हाला पुन्हा फोटो काढायला सांगेल';

  @override
  String get practiceFinish => 'ॲप सुरू करा';

  @override
  String get navHome => 'होम';

  @override
  String get navListings => 'वस्तू';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String homeGreeting(String name) {
    return 'नमस्कार, $name';
  }

  @override
  String get homeAddProduct => 'वस्तू टाका';

  @override
  String get homeAddProductSpoken =>
      'हे मोठे बटण दाबा आणि तुमची वस्तू टाका. तीन फोटो घ्या, ती काय आहे ते बोलून सांगा, आणि ती विक्रीसाठी जाईल.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वस्तू पाठवायच्या बाकी आहेत',
      one: '1 वस्तू पाठवायची बाकी आहे',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count विकल्या',
      one: '1 विकली',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'तुमच्या अलीकडच्या वस्तू';

  @override
  String get homeNextTitle => 'आता हे करायचे आहे';

  @override
  String get homeEmptyTitle => 'इथे अजून काही नाही';

  @override
  String get homeEmptyBody => 'वरचे मोठे बटण दाबून तुमची पहिली वस्तू टाका.';

  @override
  String get offlineNoNetwork => 'आत्ता नेटवर्क नाही';

  @override
  String get offlineNothingLost =>
      'काहीही हरवलेले नाही. नेटवर्क आल्यावर ते आपोआप जाईल.';

  @override
  String get statusQueued => 'पाठवायचे बाकी';

  @override
  String get statusProcessing => 'तयार होत आहे';

  @override
  String get statusNeedsAttention => 'तुमचे उत्तर हवे';

  @override
  String get statusReady => 'पाठवण्यास तयार';

  @override
  String get statusPublished => 'विक्रीवर आहे';

  @override
  String get statusFailed => 'पाठवता आले नाही';

  @override
  String get listingUntitled => 'वस्तू';

  @override
  String get listingNoPrice => 'किंमत सांगितली नाही';

  @override
  String get captureTitle => 'वस्तू टाका';

  @override
  String capturePhotoStep(int current, int total) {
    return 'फोटो $current / $total';
  }

  @override
  String get capturePhotoWhole => 'पूर्ण वस्तू दाखवा';

  @override
  String get capturePhotoDetail => 'जवळून एक फोटो घ्या';

  @override
  String get capturePhotoScale => 'बाजूला हात ठेवा, म्हणजे आकार कळेल';

  @override
  String get captureTakePhoto => 'फोटो घ्या';

  @override
  String get captureFromGallery => 'गॅलरीतून निवडा';

  @override
  String get captureTorchOn => 'उजेड चालू';

  @override
  String get captureTorchOff => 'उजेड बंद';

  @override
  String get captureCameraFailed => 'कॅमेरा उघडला नाही';

  @override
  String get captureCameraRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get captureCameraPermission =>
      'तुमच्या वस्तूचे फोटो घेण्यासाठी ॲपला कॅमेरा लागतो.';

  @override
  String get captureOpenSettings => 'सेटिंग उघडा';

  @override
  String get captureLeaveTitle => 'न साठवता बाहेर जायचे?';

  @override
  String get captureLeaveBody => 'फोटो आणि तुम्ही सांगितलेले पुसले जाईल.';

  @override
  String get captureLeaveConfirm => 'पुसून टाका';

  @override
  String get captureLeaveCancel => 'इथेच थांबा';

  @override
  String get shotReviewChecking => 'फोटो तपासला जात आहे…';

  @override
  String get shotReviewRetake => 'पुन्हा घ्या';

  @override
  String get qualityTooDark =>
      'हा फोटो खूप अंधारा आहे. दाराजवळ उभे राहून घ्या.';

  @override
  String get qualityTooBright => 'यावर खूप उजेड आहे. उन्हाकडे पाठ करून घ्या.';

  @override
  String get qualityBlurry =>
      'हा फोटो स्पष्ट नाही. फोन स्थिर धरून पुन्हा घ्या.';

  @override
  String get qualityUnreadable =>
      'हा फोटो नीट साठवला गेला नाही. कृपया पुन्हा घ्या.';

  @override
  String get qualityNoSubject =>
      'या फोटोत वस्तू दिसत नाही. ती चौकटीत ठेवा आणि जवळ येऊन घ्या.';

  @override
  String get qualityOutOfFrame =>
      'या फोटोत वस्तूचा फक्त एक भाग आहे. पूर्ण वस्तू चौकटीत ठेवा.';

  @override
  String get qualityWarningTitle => 'हा फोटो पुन्हा घ्या';

  @override
  String get qualityKeepAnyway => 'तरीही ठेवा';

  @override
  String get photoSetTitle => 'तुमचे तीन फोटो';

  @override
  String get photoSetBody =>
      'पहिला फोटो खरेदी करणारे सर्वात आधी बघतात. एखादा फोटो दाबून तो पुन्हा घ्या.';

  @override
  String get photoSetMain => 'पहिला फोटो';

  @override
  String get photoSetRetakeThis => 'हा पुन्हा घ्या';

  @override
  String get photoSetConfirm => 'हे फोटो ठीक आहेत';

  @override
  String get photoEditOpen => 'फोटो कापा किंवा फिरवा';

  @override
  String get photoEditTitle => 'फोटो कापा';

  @override
  String get photoEditBody =>
      'कापण्यासाठी चौकटीचा कोपरा किंवा कड ओढा. हलवण्यासाठी चौकटीच्या आतून ओढा.';

  @override
  String get photoEditTurn => 'फिरवा';

  @override
  String get photoEditStraighten => 'सरळ करा';

  @override
  String get photoEditReset => 'पुन्हा सुरू करा';

  @override
  String get photoEditDone => 'हाच फोटो वापरा';

  @override
  String get photoEditCancel => 'मागे जा';

  @override
  String get photoEditFailed => 'हा बदल जतन झाला नाही. पुन्हा प्रयत्न करा.';

  @override
  String get photoIssueTooDark => 'खूप अंधारा आहे, नीट दिसत नाही';

  @override
  String get photoIssueTooBright => 'यावर खूप उजेड आहे';

  @override
  String get photoIssueBlurry => 'अस्पष्ट आहे, नीट दिसत नाही';

  @override
  String get photoIssueNoSubject => 'या फोटोत वस्तू दिसत नाही';

  @override
  String get photoIssueUnreadable => 'हा फोटो साठवला गेला नाही';

  @override
  String get photoIssueOutOfFrame => 'वस्तू पूर्ण फोटोत नाही';

  @override
  String get voiceTitle => 'आता ती काय आहे ते बोलून सांगा';

  @override
  String get voiceBody =>
      'ती काय आहे, कशाची बनली आहे, केवढी आहे, बनवायला किती वेळ लागला, आणि किंमत किती.';

  @override
  String get voiceHoldToSpeak => 'दाबून बोला';

  @override
  String get voiceRecording => 'बोला… बोलणे झाल्यावर सोडा';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total पैकी $seconds सेकंद';
  }

  @override
  String get voiceTooShort => 'हे खूप लहान होते. बटण दाबून पुन्हा बोला.';

  @override
  String get voiceFailed =>
      'माइक सुरू झाला नाही. ॲपला माइकची परवानगी आहे का ते बघा.';

  @override
  String get voiceBackToPhotos => 'फोटोंकडे परत जा';

  @override
  String get playbackPlay => 'ऐका';

  @override
  String get playbackStop => 'थांबवा';

  @override
  String get playbackAgain => 'पुन्हा सांगा';

  @override
  String get playbackAccept => 'हे बरोबर आहे';

  @override
  String get playbackUnavailable =>
      'हा फोन ते ऐकवू शकत नाही. तुम्ही ते पाठवू शकता, किंवा पुन्हा सांगू शकता.';

  @override
  String get savedTitle => 'साठवले';

  @override
  String get savedBody => 'नेटवर्क आल्यावर ते आपोआप जाईल.';

  @override
  String get savedBodyOnline =>
      'ते आत्ता पाठवले जात आहे. तुम्हाला इथे थांबायची गरज नाही.';

  @override
  String get savedAddAnother => 'आणखी एक वस्तू टाका';

  @override
  String get savedGoHome => 'होमवर जा';

  @override
  String get saveFailed =>
      'ते या फोनमध्ये साठवता आले नाही. कदाचित जागा शिल्लक नाही.';

  @override
  String get saveRetry => 'पुन्हा साठवण्याचा प्रयत्न करा';

  @override
  String get queueTitle => 'पाठवायचे बाकी';

  @override
  String get queueBody =>
      'इथे काहीही हरवलेले नाही. नेटवर्क आल्यावर प्रत्येक जाईल.';

  @override
  String get queueEmptyTitle => 'काहीही बाकी नाही';

  @override
  String get queueEmptyBody => 'तुम्ही बनवलेले सर्व पाठवले गेले आहे.';

  @override
  String get queueStateWaiting => 'नेटवर्कची वाट पाहत आहे';

  @override
  String queueStateUploading(int percent) {
    return 'पाठवत आहे… शंभरपैकी $percent';
  }

  @override
  String get queueStateProcessing => 'आता आमच्याकडे आहे. आम्ही ते लिहीत आहोत.';

  @override
  String get queueStateFailed => 'गेले नाही. कारण बघण्यासाठी दाबा.';

  @override
  String get queueItemTitle => 'ही वस्तू';

  @override
  String queueMadeAt(String date) {
    return '$date रोजी बनवली';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वेळा प्रयत्न केला',
      one: 'एकदा प्रयत्न केला',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'आत्ता पाठवण्याचा प्रयत्न करा';

  @override
  String get queueRetryWaiting => 'अजून नेटवर्क नाही. ते आपोआप जाईल.';

  @override
  String get queueDelete => 'ही वस्तू पुसा';

  @override
  String get queueDeleteTitle => 'ही वस्तू पुसायची?';

  @override
  String get queueDeleteBody =>
      'फोटो आणि तुम्ही सांगितलेले पुसले जाईल. हे परत येणार नाही.';

  @override
  String get queueDeleteConfirm => 'होय, पुसून टाका';

  @override
  String get queueDeleteCancel => 'नाही, राहू द्या';

  @override
  String get failureNetwork =>
      'नेटवर्क मध्येच थांबले. सिग्नल आल्यावर ते आपोआप पुन्हा जाईल.';

  @override
  String get failureServer =>
      'आमच्याकडून उत्तर आले नाही. पुन्हा प्रयत्न केला जाईल.';

  @override
  String get failureMissingFiles =>
      'फोटो आता या फोनमध्ये नाहीत, त्यामुळे हे पाठवता येणार नाही. कृपया ते पुन्हा बनवा.';

  @override
  String get failureRejected => 'हे स्वीकारले गेले नाही. कृपया ते पुन्हा बनवा.';

  @override
  String get failureUnknown => 'काहीतरी चुकले. तुम्ही पुन्हा प्रयत्न करू शकता.';

  @override
  String get processingTitle => 'आम्ही ते लिहीत आहोत';

  @override
  String get processingBody =>
      'तुमचे फोटो आणि तुमचे शब्द आमच्याकडे आहेत. याला काही मिनिटे लागतात.';

  @override
  String get processingLeave =>
      'तुम्हाला इथे थांबायची गरज नाही. तयार झाल्यावर आम्ही तुम्हाला सांगू.';

  @override
  String get processingGoHome => 'होमवर जा';

  @override
  String get attentionTitle => 'एक प्रश्न';

  @override
  String get attentionBody => 'बाकी सर्व आम्हाला समजले. फक्त हेच राहिले.';

  @override
  String get attentionHoldToAnswer => 'दाबून उत्तर द्या';

  @override
  String get attentionAnswering => 'तुमचे उत्तर पाठवत आहोत…';

  @override
  String get attentionFailed => 'तुमचे उत्तर गेले नाही. कृपया पुन्हा सांगा.';

  @override
  String get readBackTitle => 'आम्हाला हे समजले';

  @override
  String get readBackListen => 'संपूर्ण ऐका';

  @override
  String get readBackFields => 'आम्ही जे लिहिले';

  @override
  String get readBackCorrect => 'जे चुकीचे असेल ते दाबा';

  @override
  String get readBackApprove => 'हे सर्व बरोबर आहे';

  @override
  String get notSaid => 'सांगितले नाही';

  @override
  String get fieldMaterial => 'कशाची बनली';

  @override
  String get fieldSize => 'आकार';

  @override
  String get fieldColour => 'रंग';

  @override
  String get fieldTechnique => 'कशी बनवली';

  @override
  String get fieldQuantity => 'किती';

  @override
  String get fieldPrice => 'किंमत';

  @override
  String correctTitle(String field) {
    return 'बरोबर $field सांगा';
  }

  @override
  String get correctHoldToSpeak => 'दाबून सांगा';

  @override
  String get correctListening => 'ऐकत आहोत…';

  @override
  String get correctFailedOnce => 'आम्हाला समजले नाही. आणखी एकदा सांगा.';

  @override
  String get correctUseKeypad => 'त्याऐवजी लिहा';

  @override
  String get correctUseVoice => 'त्याऐवजी बोला';

  @override
  String get correctPick => 'किंवा यातून निवडा';

  @override
  String get correctSave => 'हे साठवा';

  @override
  String get correctCancel => 'आहे तसेच राहू द्या';

  @override
  String get colourRed => 'लाल';

  @override
  String get colourBlue => 'निळा';

  @override
  String get colourGreen => 'हिरवा';

  @override
  String get colourYellow => 'पिवळा';

  @override
  String get colourBlack => 'काळा';

  @override
  String get colourWhite => 'पांढरा';

  @override
  String get colourBrown => 'तपकिरी';

  @override
  String get colourMulti => 'अनेक रंग';

  @override
  String get sizeSmall => 'लहान';

  @override
  String get sizeMedium => 'मध्यम';

  @override
  String get sizeLarge => 'मोठा';

  @override
  String get sizeExtraLarge => 'खूप मोठा';

  @override
  String get suggestTitle => 'हे देखील जोडायचे का?';

  @override
  String get suggestYes => 'होय, जोडा';

  @override
  String get suggestNo => 'नाही, राहू द्या';

  @override
  String get suggestSkip => 'मला नक्की माहीत नाही';

  @override
  String suggestProgress(int current, int total) {
    return '$total पैकी $current';
  }

  @override
  String get suggestDone => 'आणखी काही जोडायचे नाही';

  @override
  String get priceTitle => 'किंमत किती?';

  @override
  String get priceBody => 'ही एका नगाची किंमत आहे.';

  @override
  String priceFloor(String amount) {
    return 'तुमचा खर्च: $amount';
  }

  @override
  String get priceFloorExplain =>
      'तुमचे साहित्य आणि तुमचा वेळ मिळून एवढे होते. यापेक्षा कमी किंमतीत विकल्यास तुमचे नुकसान होईल.';

  @override
  String priceBand(String low, String high) {
    return 'अशा वस्तू इतर लोक $low ते $high मध्ये विकतात';
  }

  @override
  String get priceBelowFloor =>
      'ही तुमच्या खर्चापेक्षा कमी आहे. तरीही तुम्ही हीच ठेवू शकता.';

  @override
  String get priceSayIt => 'किंमत सांगा';

  @override
  String get priceConfirm => 'ही किंमत बरोबर आहे';

  @override
  String get stockTitle => 'तुमच्याकडे किती आहेत?';

  @override
  String get stockBody => 'सर्व विकल्यावर आम्ही तुमच्यासाठी ते काढून टाकू.';

  @override
  String get stockOneOfAKind => 'फक्त एकच आहे, आणि दुसरी कधीच बनणार नाही';

  @override
  String get stockMore => 'आणखी एक';

  @override
  String get stockLess => 'एक कमी';

  @override
  String get stockConfirm => 'हे बरोबर आहे';

  @override
  String get photosTitle => 'कोणता फोटो आधी येईल?';

  @override
  String get photosBody => 'खरेदी करणारे पहिला फोटो सर्वात आधी बघतात.';

  @override
  String get photosMakeFirst => 'हा पहिला फोटो करा';

  @override
  String get photosFirst => 'पहिला फोटो';

  @override
  String get photosConfirm => 'हे फोटो बरोबर आहेत';

  @override
  String get previewTitle => 'खरेदी करणारे हे बघतील';

  @override
  String get previewListenAll => 'सर्व ऐका';

  @override
  String get previewNoDescription => 'कोणतेही वर्णन लिहिले गेले नाही.';

  @override
  String get previewConfirm => 'होय, हे बरोबर आहे';

  @override
  String get previewChange => 'काहीतरी बदला';

  @override
  String get consentTitle => 'आम्ही हे विक्रीसाठी ठेवू का?';

  @override
  String get consentPhoto => 'माझे फोटो दाखवा';

  @override
  String get consentPhotoExplain =>
      'तुमच्या वस्तूचे फोटो खरेदी करणाऱ्याच्या स्क्रीनवर जातील.';

  @override
  String get consentStory => 'माझी कारागिरीची गोष्ट दाखवा';

  @override
  String get consentStoryExplain =>
      'तुमचे नाव, तुमचे गाव आणि तुम्ही कसे बनवता हे कारागीर कार्डावर जाईल. नाही म्हणूनही तुम्ही विकू शकता.';

  @override
  String get consentNeeded => 'फोटोंशिवाय आम्ही ते ठेवू शकत नाही.';

  @override
  String get consentPublish => 'विक्रीसाठी ठेवा';

  @override
  String get publishingTitle => 'विक्रीसाठी ठेवत आहोत';

  @override
  String get publishingBody => 'याला थोडा वेळ लागेल. ॲप बंद करू नका.';

  @override
  String get publishedTitle => 'ते विक्रीसाठी लागले';

  @override
  String get publishedBody => 'खरेदी करणारे ते आत्ता बघू शकतात.';

  @override
  String get publishedShare => 'व्हॉट्सॲपवर पाठवा';

  @override
  String get publishedCopyLink => 'दुवा कॉपी करा';

  @override
  String get publishedLinkCopied => 'दुवा कॉपी झाला';

  @override
  String get publishedShowQr => 'स्कॅन करायचा कोड दाखवा';

  @override
  String get publishedQrExplain =>
      'कोणीही आपला फोन यावर धरून तुमची वस्तू उघडू शकतो.';

  @override
  String get publishedAnother => 'असेच आणखी एक बनवा';

  @override
  String get publishedDone => 'होमवर जा';

  @override
  String get publishFailed =>
      'ते ठेवता आले नाही. काहीही हरवलेले नाही — तुम्ही पुन्हा प्रयत्न करू शकता.';

  @override
  String get publishRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get reviewLeaveTitle => 'आत्तापुरते सोडायचे?';

  @override
  String get reviewLeaveBody =>
      'तुम्ही मंजूर केलेले राहील. तुम्ही तुमच्या वस्तूंमधून परत येऊ शकता.';

  @override
  String get reviewLeaveConfirm => 'आत्तापुरते सोडा';

  @override
  String get editLeaveTitle => 'तुमचे बदल अजून विक्रीवर नाहीत';

  @override
  String get editLeaveBody =>
      'तुम्ही केलेले बदल साठवले आहेत, पण खरेदी करणाऱ्यांना अजूनही जुनेच दिसते. शेवटचे बटण दाबल्यावरच ते विक्रीवर जाईल.';

  @override
  String get editLeaveConfirm => 'ठीक आहे, नंतर करतो';

  @override
  String get reviewLeaveCancel => 'पुढे चला';

  @override
  String get statusSoldOut => 'सर्व विकले';

  @override
  String get statusUnpublished => 'काढून टाकले';

  @override
  String get listingsTitle => 'तुमच्या वस्तू';

  @override
  String get listingsEmptyTitle => 'तुम्ही अजून काही बनवले नाही';

  @override
  String get listingsEmptyBody =>
      'होमवरचे मोठे बटण दाबून तुमची पहिली वस्तू टाका.';

  @override
  String get listingsEmptyFilter => 'इथे काही नाही.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शिल्लक',
      one: '1 शिल्लक',
      zero: 'काही शिल्लक नाही',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वेळा बघितले',
      one: 'एकदा बघितले',
      zero: 'अजून कोणी बघितले नाही',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'किती आहेत ते बदला';

  @override
  String get listingTitle => 'ही वस्तू';

  @override
  String get listingOpenPreview => 'खरेदी करणारे जे बघतात ते बघा';

  @override
  String get listingEdit => 'काहीतरी बदला';

  @override
  String get listingDuplicate => 'असेच आणखी एक बनवा';

  @override
  String get listingUnpublish => 'विक्रीतून काढा';

  @override
  String get listingRelist => 'पुन्हा विक्रीवर ठेवा';

  @override
  String get listingFinish => 'हे पूर्ण करा';

  @override
  String get listingSoldOutTitle => 'हे सर्व विकले गेले';

  @override
  String get listingSoldOutBody =>
      'आम्ही ते तुमच्यासाठी विक्रीतून काढले. आणखी बनवल्यावर पुन्हा ठेवा.';

  @override
  String get editTitle => 'ही वस्तू बदला';

  @override
  String get editBody =>
      'तुम्ही ती पुन्हा बघाल, आणि मग ती पुन्हा विक्रीवर जाईल.';

  @override
  String get editRepublishing => 'बदल विक्रीवर ठेवत आहोत…';

  @override
  String get editRepublished => 'तुमचे बदल आता विक्रीवर आहेत';

  @override
  String get editRepublishConfirm => 'बदल पुन्हा विक्रीवर ठेवा';

  @override
  String get quickStockTitle => 'किती शिल्लक आहेत?';

  @override
  String get quickStockMarkSoldOut => 'सर्व विकले गेले आहेत';

  @override
  String get quickStockSave => 'साठवा';

  @override
  String get quickStockSaved => 'साठवले';

  @override
  String get actionUndo => 'पहिल्यासारखे करा';

  @override
  String get unpublishTitle => 'विक्रीतून काढायचे?';

  @override
  String get unpublishBody =>
      'खरेदी करणारे ते आता बघणार नाहीत. काहीही पुसले जाणार नाही, आणि तुम्ही ते कधीही परत ठेवू शकता.';

  @override
  String get unpublishConfirm => 'होय, काढून टाका';

  @override
  String get unpublishCancel => 'नाही, विक्रीवर राहू द्या';

  @override
  String get unpublishDone => 'ते विक्रीतून काढले';

  @override
  String get relistDone => 'ते पुन्हा विक्रीवर आहे';

  @override
  String get duplicateTitle => 'असेच आणखी एक बनवायचे?';

  @override
  String get duplicateBody =>
      'तुम्ही त्याबद्दल जे सांगितले ते आम्ही ठेवू. तुम्हाला फक्त नवीन फोटो घ्यायचे आहेत.';

  @override
  String get duplicateConfirm => 'फोटो घ्या';

  @override
  String get duplicateCancel => 'आत्ता नाही';

  @override
  String get duplicateBanner =>
      'मागच्यासारखे आणखी एक बनवत आहोत. फक्त फोटो नवीन आहेत.';

  @override
  String get listingActionFailed => 'ते झाले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get salesNew => 'नवीन';

  @override
  String get salesEmptyTitle => 'अजून काही विकले नाही';

  @override
  String get salesEmptyBody =>
      'कोणी काही विकत घेतले की ते इथे दिसेल आणि आम्ही तुम्हाला सांगू.';

  @override
  String get salesLoading => 'काय विकले ते बघत आहोत…';

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
    return '$date पर्यंत बांधा';
  }

  @override
  String get salesPackByToday => 'आजच बांधा';

  @override
  String get salesPackByTomorrow => 'उद्यापर्यंत बांधा';

  @override
  String get salesPackedAlready => 'याची तारीख निघून गेली आहे';

  @override
  String get saleTitle => 'ही ऑर्डर';

  @override
  String get saleReadOnly =>
      'हे फक्त तुम्हाला सांगण्यासाठी आहे. ऑर्डरचे सर्व काम बाजारावर होते, या ॲपमध्ये नाही.';

  @override
  String salePaid(String amount) {
    return 'तुम्हाला $amount मिळतील';
  }

  @override
  String salePlaced(String date) {
    return '$date रोजी विकले';
  }

  @override
  String saleGoingTo(String area) {
    return '$area इथे जात आहे';
  }

  @override
  String get saleWhatToPack => 'काय बांधायचे';

  @override
  String get salePackingHelp => 'कसे बांधायचे';

  @override
  String get saleSeeListing => 'ही वस्तू बघा';

  @override
  String get packingTitle => 'कसे बांधायचे';

  @override
  String get packingBody => 'हे एक एक करून करा. जे झाले ते दाबा.';

  @override
  String get packingStep1 =>
      'कापडात किंवा कागदात गुंडाळा, म्हणजे काही घासणार नाही';

  @override
  String get packingStep2 =>
      'चारही बाजूंनी कागद किंवा गवत भरा, म्हणजे खोक्यात हलणार नाही';

  @override
  String get packingStep3 => 'आत हवे तेवढेच नग आहेत ना ते बघा';

  @override
  String get packingStep4 => 'खोके बंद करून चारही बाजूंनी टेप लावा';

  @override
  String get packingStep5 => 'घ्यायला येणाऱ्यासाठी तयार ठेवा';

  @override
  String get packingDone => 'सर्व झाले';

  @override
  String packingProgress(int done, int total) {
    return '$total पैकी $done झाले';
  }

  @override
  String get earningsTitle => 'तुम्ही किती कमावले';

  @override
  String get earningsWeek => 'या आठवड्यात';

  @override
  String get earningsMonth => 'या महिन्यात';

  @override
  String get earningsTotal => 'सुरुवातीपासून';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नग विकले',
      one: '1 नग विकला',
      zero: 'अजून काही विकले नाही',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'बाजाराचा हिस्सा वजा केल्यावर तुम्हाला जे मिळते ते हे आहे.';

  @override
  String get profileVillageLabel => 'गाव किंवा क्लस्टर';

  @override
  String get profileNotSet => 'सांगितले नाही';

  @override
  String get profileEditEntry => 'तुमची माहिती बदला';

  @override
  String get profileStoryEntry => 'तुमची कारागिरीची गोष्ट';

  @override
  String get profileLanguageEntry => 'भाषा';

  @override
  String get profilePhoneEntry => 'फोन नंबर';

  @override
  String get profileOndcEntry => 'तुमचे विक्री खाते';

  @override
  String get profileNotificationsEntry => 'आम्ही तुम्हाला काय सांगावे';

  @override
  String get profileVoiceEntry => 'आवाज आणि ऐकणे';

  @override
  String get profilePrivacyEntry => 'तुमच्याबद्दल काय दिसते';

  @override
  String get profileStorageEntry => 'या फोनमधली जागा';

  @override
  String get profileAccountEntry => 'साइन आउट';

  @override
  String get editProfileTitle => 'तुमची माहिती';

  @override
  String get editProfileAddPhoto => 'तुमचा फोटो टाका';

  @override
  String get editProfileChangePhoto => 'फोटो बदला';

  @override
  String get editProfileRemovePhoto => 'फोटो काढा';

  @override
  String get editProfilePhotoWhy =>
      'तुमची परवानगी असेल तरच खरेदी करणारे तो कारागीर कार्डावर बघतात.';

  @override
  String get editProfileVillageHint => 'बोला किंवा लिहा';

  @override
  String get editProfileSave => 'साठवा';

  @override
  String get editProfileSaved => 'साठवले';

  @override
  String get storyTitle => 'तुमची कारागिरीची गोष्ट';

  @override
  String get storyBody =>
      'खरेदी करणाऱ्यांना सांगा तुम्ही कोण आहात आणि कसे बनवता. तुम्ही बोला, आम्ही लिहून घेऊ.';

  @override
  String get storyHoldToSpeak => 'दाबून तुमची गोष्ट सांगा';

  @override
  String get storyEmpty => 'तुम्ही अजून तुमची गोष्ट सांगितली नाही.';

  @override
  String get storyEditHint => 'तुम्ही याचा कोणताही शब्द बदलू शकता.';

  @override
  String get storyExample =>
      'उदाहरणार्थ: आमच्या घरात तीन पिढ्यांपासून हेच बनते, आणि मी आजही माझ्या आजोबांच्या मागावर काम करतो.';

  @override
  String get changePhoneTitle => 'तुमचा नंबर बदला';

  @override
  String get changePhoneBody =>
      'नंबर तुमचाच आहे याची खात्री करण्यासाठी आम्ही त्यावर एक कोड पाठवू.';

  @override
  String changePhoneCurrent(String number) {
    return 'आत्ता तुमचा नंबर $number आहे';
  }

  @override
  String get changePhoneDone => 'तुमचा नंबर बदलला';

  @override
  String get ondcAccountTitle => 'तुमचे विक्री खाते';

  @override
  String get ondcAccountLinked => 'तुमचे खाते जोडलेले आहे';

  @override
  String get ondcAccountNone => 'अजून कोणतेही खाते जोडलेले नाही';

  @override
  String get ondcAccountNoneBody =>
      'तुम्ही वस्तू बनवत राहा. खाते जोडताच त्या विक्रीवर जातील.';

  @override
  String get ondcAccountLink => 'खाते जोडा';

  @override
  String get ondcAccountUnlink => 'हे खाते काढा';

  @override
  String get ondcUnlinkTitle => 'हे खाते काढायचे?';

  @override
  String get ondcUnlinkBody =>
      'विक्रीवर असलेले सर्व खाली येईल. तुम्ही बनवलेले काहीही पुसले जाणार नाही, आणि तुम्ही ते पुन्हा जोडू शकता.';

  @override
  String get ondcUnlinkConfirm => 'होय, काढून टाका';

  @override
  String get ondcUnlinkCancel => 'नाही, राहू द्या';

  @override
  String get ondcUnlinkDone => 'खाते काढले';

  @override
  String get notificationsTitle => 'आम्ही तुम्हाला काय सांगावे';

  @override
  String get notifySold => 'काही विकले गेल्यावर';

  @override
  String get notifySoldWhy =>
      'खरेदी करणाऱ्याने पैसे दिले की लगेच सांगू, म्हणजे तुम्ही बांधायला सुरुवात करू शकता.';

  @override
  String get notifyAttention => 'आम्हाला तुम्हाला काही विचारायचे असेल तेव्हा';

  @override
  String get notifyAttentionWhy =>
      'कधीकधी वस्तू विक्रीवर जाण्यापूर्वी एक गोष्ट राहून जाते.';

  @override
  String get notifyUpload => 'वस्तू पाठवली गेल्यावर';

  @override
  String get notifyUploadWhy =>
      'तुम्ही फोनवर जे बनवले ते आमच्यापर्यंत पोहोचले की सांगू.';

  @override
  String get notifyPackBy => 'पॅक करायची वेळ झाल्यावर';

  @override
  String get notifyPackByWhy =>
      'विक्री पॅक करायच्या तारखेच्या एक दिवस आधी आणि त्याच दिवशी आम्ही तुम्हाला आठवण करून देऊ.';

  @override
  String get notificationsBlocked =>
      'हा फोन आम्हाला तुम्हाला काही पाठवू देत नाही. तुम्ही ते फोनच्या सेटिंगमध्ये सुरू करू शकता.';

  @override
  String get voiceSettingsTitle => 'आवाज आणि ऐकणे';

  @override
  String get voiceSpeed => 'आम्ही किती वेगाने बोलावे';

  @override
  String get voiceSpeedSlow => 'हळू';

  @override
  String get voiceSpeedFast => 'वेगाने';

  @override
  String get voiceTry => 'आत्ता बोलून दाखवा';

  @override
  String get voiceSample => 'आम्ही तुमच्याशी एवढ्या वेगाने बोलू.';

  @override
  String get voiceAutoRead => 'प्रत्येक स्क्रीन उघडताच वाचून दाखवा';

  @override
  String get voiceAutoReadWhy =>
      'हे बंद असेल तर तुम्ही स्पीकर दाबाल तेव्हाच आम्ही बोलतो.';

  @override
  String get voiceUnavailable =>
      'हा फोन बोलू शकत नाही. सर्व काही चालेल, पण काही वाचून दाखवले जाणार नाही.';

  @override
  String get privacyTitle => 'तुमच्याबद्दल काय दिसते';

  @override
  String get privacyBody =>
      'प्रत्येक वस्तू विक्रीवर ठेवताना तुम्ही यांना होय म्हटले होते. तुम्ही यातले कोणतेही परत घेऊ शकता.';

  @override
  String get privacyPhoto => 'या वस्तूचे फोटो';

  @override
  String get privacyStory => 'तुमचे नाव, गाव आणि गोष्ट';

  @override
  String get privacyNothing => 'आत्ता तुमचे काहीही विक्रीवर नाही.';

  @override
  String get privacyWithdrawTitle => 'हे परत घ्यायचे?';

  @override
  String get privacyWithdrawPhotoBody =>
      'फोटोंशिवाय ही वस्तू विक्रीवर राहू शकत नाही, त्यामुळे ती खाली येईल. काहीही पुसले जाणार नाही.';

  @override
  String get privacyWithdrawStoryBody =>
      'तुमचे नाव, गाव आणि गोष्ट या वस्तूवरून काढली जाईल. ती विक्रीवर राहील.';

  @override
  String get privacyWithdrawConfirm => 'होय, परत घ्या';

  @override
  String get privacyWithdrawCancel => 'नाही, राहू द्या';

  @override
  String get privacyWithdrawn => 'परत घेतले';

  @override
  String get storageTitle => 'या फोनमधली जागा';

  @override
  String get storagePhotos => 'फोटो आणि रेकॉर्डिंग';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोष्टी पाठवायच्या बाकी आहेत',
      one: '1 गोष्ट पाठवायची बाकी आहे',
      zero: 'पाठवायचे काहीही बाकी नाही',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'जे पाठवले गेले आहे ते काढा';

  @override
  String get storageClearWhy =>
      'जे अजून पाठवायचे बाकी आहे त्याला कधीही हात लावला जात नाही.';

  @override
  String storageCleared(String size) {
    return '$size मोकळी झाली';
  }

  @override
  String get storageNothingToClear => 'काढण्यासारखे काही नाही';

  @override
  String get accountTitle => 'साइन आउट';

  @override
  String get accountSignOut => 'या फोनवरून साइन आउट करा';

  @override
  String get accountSignOutTitle => 'साइन आउट करायचे?';

  @override
  String get accountSignOutBody =>
      'पाठवायचे बाकी असलेले निघून जाईल. विक्रीवर असलेले विक्रीवरच राहील.';

  @override
  String get accountSignOutConfirm => 'होय, साइन आउट';

  @override
  String get accountSignOutCancel => 'नाही, राहू द्या';

  @override
  String get accountDelete => 'माझे खाते पुसा';

  @override
  String get accountDeleteTitle => 'तुमचे खाते पुसायचे?';

  @override
  String get accountDeleteBody =>
      'सर्व काही विक्रीतून निघेल आणि या फोनवरचे सर्व पुसले जाईल. हे परत येणार नाही.';

  @override
  String get accountDeleteConfirm => 'होय, सर्व पुसून टाका';

  @override
  String get accountDeleteCancel => 'नाही, माझे खाते राहू द्या';

  @override
  String get accountDeleteHold => 'पुसण्यासाठी बटण दाबून धरा';

  @override
  String get profileHelpEntry => 'मदत';

  @override
  String get helpTitle => 'मदत';

  @override
  String get helpBody =>
      'छोटी उत्तरे, वाचून दाखवली जातात. ऐकण्यासाठी कोणतेही दाबा.';

  @override
  String get helpSteps => 'असे करा';

  @override
  String get helpTopicPhotos => 'चांगले फोटो कसे घ्यायचे';

  @override
  String get helpTopicPhotosBody =>
      'चांगल्या फोटोंमुळे वस्तू विकल्या जातात. खरेदी करणारा वस्तू हातात घेऊ शकत नाही, त्याच्याकडे फक्त फोटो असतो.';

  @override
  String get helpTopicPhotosStep1 =>
      'दाराजवळ किंवा खिडकीजवळ उभे राहा, म्हणजे दिवसाचा उजेड वस्तूवर पडेल';

  @override
  String get helpTopicPhotosStep2 =>
      'वस्तू साध्या कापडावर ठेवा, आजूबाजूला दुसरे काही नको';

  @override
  String get helpTopicPhotosStep3 =>
      'फोटो येईपर्यंत फोन दोन्ही हातांनी स्थिर धरा';

  @override
  String get helpTopicPhotosStep4 =>
      'एक फोटो जवळून घ्या, म्हणजे कारागिरी दिसेल';

  @override
  String get helpTopicPhotosStep5 =>
      'एका फोटोत बाजूला हात ठेवा, म्हणजे आकार कळेल';

  @override
  String get helpTopicVoice => 'तुमच्या वस्तूबद्दल काय सांगायचे';

  @override
  String get helpTopicVoiceBody =>
      'समोर उभ्या गिऱ्हाइकाशी बोलता तसेच बोला. बोलण्याची चुकीची पद्धत अशी काही नाही.';

  @override
  String get helpTopicVoiceStep1 => 'ती काय आहे ते सांगा';

  @override
  String get helpTopicVoiceStep2 => 'ती कशाची बनली आहे ते सांगा';

  @override
  String get helpTopicVoiceStep3 => 'ती केवढी आहे ते इंच किंवा फुटात सांगा';

  @override
  String get helpTopicVoiceStep4 => 'बनवायला किती वेळ लागला ते सांगा';

  @override
  String get helpTopicVoiceStep5 => 'तुम्हाला तिचे किती हवेत ते सांगा';

  @override
  String get helpTopicPrice => 'किंमत कशी ठरवायची';

  @override
  String get helpTopicPriceBody =>
      'किंमतीत तुमचे साहित्य आणि तुमचा वेळ दोन्ही निघाले पाहिजेत. आम्ही ते तुमच्यासोबत मोजतो, आणि त्याहून कमी किंमतीत न सांगता कधीही जाऊ देत नाही.';

  @override
  String get helpTopicPriceStep1 => 'साहित्याला किती खर्च आला ते मोजा';

  @override
  String get helpTopicPriceStep2 => 'कामाला किती दिवस लागले ते मोजा';

  @override
  String get helpTopicPriceStep3 =>
      'आम्ही जे सुचवतो ते बघा, आणि तुम्हाला अधिक माहीत असेल तर बदला';

  @override
  String get helpTopicPriceStep4 =>
      'तुमच्या खर्चापेक्षा कमी असेल तर आम्ही सांगू, पण निवड तुमचीच';

  @override
  String get helpTopicSold => 'विकल्यानंतर काय होते';

  @override
  String get helpTopicSoldBody =>
      'खरेदी करणारा बाजारावर पैसे देतो. तुम्ही ती बांधून देता, आणि पैसे तुमच्यापर्यंत येतात.';

  @override
  String get helpTopicSoldStep1 => 'विकले जाताच आम्ही तुम्हाला सांगू';

  @override
  String get helpTopicSoldStep2 => 'उघडून बघा काय आणि किती बांधायचे';

  @override
  String get helpTopicSoldStep3 => 'आम्ही दाखवलेल्या तारखेच्या आत बांधा';

  @override
  String get helpTopicSoldStep4 => 'घ्यायला येणाऱ्याला देऊन टाका';

  @override
  String get helpTopicSoldStep5 => 'त्यानंतर पैसे तुमच्यापर्यंत पोहोचतात';

  @override
  String get helpVideoComing => 'यासाठी एक छोटा व्हिडिओ लवकरच येत आहे.';

  @override
  String get helpPractice => 'चांगला फोटो कसा काढावा';

  @override
  String get helpPracticeBody => 'एकाच मडक्याचा एक चांगला आणि एक वाईट फोटो.';

  @override
  String get helpFaqEntry => 'लोक जे विचारतात';

  @override
  String get helpAboutEntry => 'कारागीरबद्दल';

  @override
  String get helpSupportEntry => 'माणसाशी बोला';

  @override
  String get helpTermsEntry => 'अटी आणि गोपनीयता';

  @override
  String get faqTitle => 'लोक जे विचारतात';

  @override
  String get faqQ1 => 'याचे मला काही द्यावे लागेल का?';

  @override
  String get faqA1 =>
      'नाही. वस्तू टाकणे मोफत आहे. काही विकले गेल्यावरच बाजार आपला छोटा हिस्सा घेतो.';

  @override
  String get faqQ2 => 'नेटवर्क नसेल तर?';

  @override
  String get faqA2 =>
      'सर्व काही चालू राहते. तुम्ही बनवलेले तुमच्या फोनमध्ये राहते आणि नेटवर्क आल्यावर आपोआप जाते.';

  @override
  String get faqQ3 => 'पैसे कोणाकडे जातात?';

  @override
  String get faqA3 =>
      'तुमच्याकडे. खरेदी करणारा बाजारावर पैसे देतो आणि ते तुमच्या खात्यात येतात. पैसे कधीही आमच्याकडून जात नाहीत.';

  @override
  String get faqQ4 => 'विक्रीवर गेल्यावर काही बदलता येते का?';

  @override
  String get faqA4 =>
      'होय. तुमच्या वस्तूंमधून उघडा, हवे ते बदला, आणि ती पुन्हा विक्रीवर जाईल.';

  @override
  String get faqQ5 => 'मी काही चुकीचे बोललो तर?';

  @override
  String get faqA5 =>
      'तुम्ही ऐकून बरोबर म्हणेपर्यंत काहीही विक्रीवर जात नाही. तुम्ही बोलून त्यातला कोणताही भाग दुरुस्त करू शकता.';

  @override
  String get faqQ6 => 'मला वाचता-लिहिता आले पाहिजे का?';

  @override
  String get faqA6 =>
      'नाही. तुम्ही सर्व काही बोलून आणि दाबून करू शकता. प्रत्येक स्क्रीन तुम्हाला वाचून दाखवली जाऊ शकते.';

  @override
  String get faqQ7 => 'माझे नाव आणि गाव कोण बघते?';

  @override
  String get faqA7 =>
      'तुमची परवानगी असेल तरच, आणि प्रत्येक वस्तूसाठी वेगळी. तुम्ही ती कधीही परत घेऊ शकता.';

  @override
  String get aboutTitle => 'कारागीरबद्दल';

  @override
  String get aboutWhatTitle => 'हे काय आहे';

  @override
  String get aboutWhat =>
      'कारागीर हाताने बनवलेल्या वस्तू ONDC वर पोहोचवतो — भारताचे खुले खरेदी-विक्री जाळे — आणि त्यासाठी बनवणाऱ्याला लिहावे लागत नाही, बोलावे लागते. तुमच्या भाषेतले काही फोटो आणि एक बोलणे यातून अशी नोंद तयार होते जी देशभरातले खरेदीदार बघू शकतात.';

  @override
  String get aboutWhyTitle => 'आम्ही हे का बनवले';

  @override
  String get aboutWhy =>
      'भारतात जवळपास सत्तर लाख कारागीर अशा वस्तू बनवतात ज्या लोकांना विकत घ्यायच्या असतात, आणि त्यातले बहुतेक मध्यस्थामार्फत विकतात जो फरकाचे पैसे ठेवतो. अडचण कामात नाही. अडचण फॉर्ममध्ये आहे: ऑनलाइन नोंद इंग्रजीत टाइप करणे, अनेक रकाने भरणे आणि कॅटलॉगसारखा फोटो मागते. हे ॲप तो फॉर्म काढून टाकते.';

  @override
  String get aboutHowTitle => 'हे कसे चालते';

  @override
  String get aboutHow =>
      'तीन फोटो घ्या आणि ती काय आहे ते बोलून सांगा. आमची यंत्रणा ऐकते, नोंद लिहिते, आणि तुम्हाला वाचून दाखवते. तुम्ही ऐकून बरोबर म्हणेपर्यंत काहीही बाहेर जात नाही.';

  @override
  String get aboutSihTitle => 'स्मार्ट इंडिया हॅकेथॉन 2025';

  @override
  String get aboutSih =>
      'समस्या 090 साठी बनवले: कारागीर आणि विणकरांना ONDC वर खरेदीदारांपर्यंत पोहोचवणे.';

  @override
  String get aboutMissionTitle => 'आम्हाला काय करायचे आहे';

  @override
  String get aboutMission =>
      'एखाद्या कामाची किंमत ते काम करणाऱ्याच्याच हातात असावी.';

  @override
  String get supportTitle => 'माणसाशी बोला';

  @override
  String get supportBody =>
      'काही चालत नसेल, किंवा काय करावे कळत नसेल, तर आम्हाला फोन करा. एक माणूस तुमच्या भाषेत उत्तर देईल.';

  @override
  String get supportCall => 'आम्हाला फोन करा';

  @override
  String get supportWhatsApp => 'व्हॉट्सॲपवर संदेश पाठवा';

  @override
  String get supportHours => 'दररोज, सकाळी नऊ ते संध्याकाळी सात.';

  @override
  String supportNumber(String number) {
    return 'आमचा नंबर $number आहे';
  }

  @override
  String supportFailed(String number) {
    return 'तुमचा फोन ते उघडू शकला नाही. आमचा नंबर $number आहे.';
  }

  @override
  String get termsTitle => 'अटी आणि गोपनीयता';

  @override
  String get termsSummaryTitle => 'थोडक्यात';

  @override
  String get termsSummary1 =>
      'तुम्ही बनवलेले तुमचेच आहे. आम्ही ते तुमच्यासाठी विक्रीवर ठेवतो आणि विक्रीतून काहीही घेत नाही.';

  @override
  String get termsSummary2 =>
      'तुमचे फोटो आणि तुमचा आवाज फक्त तुमची नोंद लिहिण्यासाठी वापरला जातो, दुसऱ्या कशासाठीही नाही.';

  @override
  String get termsSummary3 =>
      'तुमचे नाव, गाव आणि गोष्ट फक्त तुम्ही परवानगी दिलेल्या वस्तूंवर जाते, आणि ती तुम्ही परत घेऊ शकता.';

  @override
  String get termsSummary4 =>
      'पैसे खरेदी करणाऱ्याकडून थेट तुमच्याकडे जातात. ते कधीही आमच्याकडून जात नाहीत.';

  @override
  String get termsSummary5 => 'तुम्ही या फोनवरून सर्व काही कधीही पुसू शकता.';

  @override
  String get termsFullTitle => 'संपूर्ण मजकूर';

  @override
  String get termsFullBody =>
      'वापराच्या संपूर्ण अटी आणि गोपनीयता धोरण आमच्या संकेतस्थळावर आहे. इथे काही कळले नाही तर आम्हाला फोन करा, एक माणूस समजावून सांगेल.';

  @override
  String get termsOpenFull => 'संपूर्ण मजकूर वाचा';

  @override
  String get termsAgreeTitle => 'सुरू करण्यापूर्वी';

  @override
  String get termsAgreeBody =>
      'तुम्ही या गोष्टींना संमती देत आहात. ऐकण्यासाठी स्पीकर दाबा.';

  @override
  String get termsAgreeCheck => 'मला अटी मान्य आहेत';

  @override
  String get termsAgreeContinue => 'पुढे जा';

  @override
  String get termsAgreeNeeded => 'आधी “मला अटी मान्य आहेत” वर खूण करा.';

  @override
  String versionNumber(String version) {
    return 'आवृत्ती $version';
  }

  @override
  String get versionCheck => 'नवी आवृत्ती बघा';

  @override
  String get versionLicences => 'परवाने';

  @override
  String get versionLicencesWhy => 'हे ॲप ज्या मोफत सॉफ्टवेअरवर बनले आहे.';

  @override
  String get noNetworkTitle => 'नेटवर्क नाही';

  @override
  String get noNetworkBody =>
      'तुम्ही काम करत राहा. सर्व काही तुमच्या फोनमध्ये राहते आणि नेटवर्क आल्यावर आपोआप जाते.';

  @override
  String get noNetworkNeeded =>
      'या एका कामासाठी नेटवर्क लागते. सिग्नल आल्यावर पुन्हा प्रयत्न करा.';

  @override
  String get serverErrorTitle => 'आम्ही आमच्या बाजूला पोहोचू शकलो नाही';

  @override
  String get serverErrorBody =>
      'तुम्ही केलेले काहीही हरवलेले नाही. कृपया थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get actionTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get permissionRecoveryTitle => 'ॲपला तुमची परवानगी हवी';

  @override
  String get permissionRecoveryBody =>
      'फोन ॲपला हे वापरू देत नाही. तुम्ही ते फोनच्या सेटिंगमध्ये सुरू करून इथे परत येऊ शकता.';

  @override
  String get permissionCameraWhy =>
      'तुम्ही बनवलेल्याचे फोटो घेण्यासाठी. याशिवाय काहीही विक्रीवर ठेवता येणार नाही.';

  @override
  String get permissionMicWhy =>
      'म्हणजे तुम्ही लिहिण्याऐवजी बोलू शकाल. याशिवाय सर्व काही लिहावे लागेल.';

  @override
  String get permissionNotifyTitle => 'सूचना';

  @override
  String get permissionNotifyWhy =>
      'म्हणजे काही विकले गेल्यावर आम्ही सांगू शकू. याशिवाय तुम्हाला ॲप उघडून बघावे लागेल.';

  @override
  String get permissionBlocked => 'परवानगी नाही';

  @override
  String get permissionAsk => 'पुन्हा विचारा';

  @override
  String get permissionRecheck => 'मी ते सुरू केले';

  @override
  String get permissionAllGood => 'ॲपला जे हवे ते सर्व मंजूर आहे.';

  @override
  String get updateTitle => 'कृपया ॲप अपडेट करा';

  @override
  String get updateBody =>
      'ही आवृत्ती आता आमच्याशी बोलू शकत नाही. स्टोअरमध्ये नवी आवृत्ती आहे, आणि अपडेटनंतर तुमच्या फोनवरचे सर्व तसेच राहील.';

  @override
  String get updateAction => 'नवी आवृत्ती घ्या';

  @override
  String get updateFailed => 'स्टोअर उघडले नाही. तिथे कारागीर शोधा.';

  @override
  String get emptyNudge => 'होमवरचे मोठे बटण दाबून तुमची पहिली वस्तू टाका.';

  @override
  String get productsInProgress => 'तयार होत आहे';

  @override
  String get productsListed => 'विक्रीला';

  @override
  String get productsSold => 'विकले गेले';

  @override
  String get voiceTypeInstead => 'लिहून सांगा';

  @override
  String get voiceSpeakInstead => 'बोलून सांगा';

  @override
  String get voiceTypeTitle => 'आता लिहा की ही वस्तू काय आहे';

  @override
  String get voiceTypeHint => 'येथे लिहा…';

  @override
  String get voiceTypeSave => 'हेच वर्णन ठेवा';

  @override
  String get devSimulateResult => 'Dev: show a finished product';

  @override
  String get errorNotAllowed =>
      'या खात्याला हे करता येत नाही. मदतीसाठी आम्हाला फोन करा.';

  @override
  String get errorNotFound => 'हे आता इथे नाही.';

  @override
  String get errorConflict =>
      'हे दुसरीकडे बदलले गेले आहे. कृपया पुन्हा उघडून परत प्रयत्न करा.';

  @override
  String get errorInvalid =>
      'काही माहिती स्वीकारली गेली नाही. कृपया तपासून पुन्हा प्रयत्न करा.';
}
