import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'కారీగర్';

  @override
  String get actionNext => 'తర్వాత';

  @override
  String get actionBack => 'వెనక్కి';

  @override
  String get actionSkip => 'దాటవేయండి';

  @override
  String get actionDone => 'అయిపోయింది';

  @override
  String get actionListen => 'వినండి';

  @override
  String get actionStopListening => 'ఆపండి';

  @override
  String stepOfSteps(int current, int total) {
    return 'దశ $current, మొత్తం $total';
  }

  @override
  String get splashTagline => 'మాట్లాడండి, మీ వస్తువు అమ్ముడవుతుంది';

  @override
  String get languageTitle => 'మీ భాషను ఎంచుకోండి';

  @override
  String get languageHint => 'మీరు మాట్లాడే భాషను నొక్కండి';

  @override
  String get welcomeCard1Title => 'మూడు ఫోటోలు తీయండి';

  @override
  String get welcomeCard1Body =>
      'మీరు తయారుచేసిన వస్తువు మూడు ఫోటోలు తీయండి. ఎలా తీయాలో యాప్ చూపిస్తుంది.';

  @override
  String get welcomeCard2Title => 'మాటల్లో చెప్పండి';

  @override
  String get welcomeCard2Body =>
      'ఇది ఏమిటి, దేనితో చేసింది, ధర ఎంత — చెబితే చాలు. రాయాల్సిన అవసరం లేదు.';

  @override
  String get welcomeCard3Title => 'ఇది అమ్మకానికి వెళ్తుంది';

  @override
  String get welcomeCard3Body =>
      'ముందుగా మీకు చదివి వినిపిస్తాం. మీరు అవును అంటేనే ఆన్‌లైన్‌కి వెళ్తుంది.';

  @override
  String get welcomeStart => 'ప్రారంభించండి';

  @override
  String get permissionsTitle => 'యాప్‌కి మూడు విషయాలకు అనుమతి కావాలి';

  @override
  String get permissionCameraTitle => 'కెమెరా';

  @override
  String get permissionCameraBody =>
      'మీ వస్తువు ఫోటోలు తీయడానికి. మీరు అవును అనేవరకు ఫోటోలు మీ ఫోన్‌లోనే ఉంటాయి.';

  @override
  String get permissionMicTitle => 'మైక్';

  @override
  String get permissionMicBody => 'రాయడానికి బదులు మాట్లాడటానికి.';

  @override
  String get permissionNotificationTitle => 'నోటిఫికేషన్లు';

  @override
  String get permissionNotificationBody =>
      'ఏదైనా అమ్ముడవగానే మీకు చెప్పడానికి.';

  @override
  String get permissionAllow => 'అనుమతించండి';

  @override
  String get permissionNotNow => 'ఇప్పుడు వద్దు';

  @override
  String get permissionGranted => 'అనుమతి ఉంది';

  @override
  String get permissionDeniedTitle => 'అనుమతి రాలేదు';

  @override
  String get permissionDeniedBody =>
      'ఇది లేకుండా ఇది పనిచేయదు. ఫోన్ సెట్టింగ్స్‌లోకి వెళ్ళి అనుమతించండి.';

  @override
  String get permissionOpenSettings => 'సెట్టింగ్స్ తెరవండి';

  @override
  String get phoneTitle => 'మీ ఫోన్ నంబర్';

  @override
  String get phoneWhy =>
      'ఈ నంబర్‌కు ఒక కోడ్ పంపుతాం. ఈ నంబర్ మరెవరికీ ఇవ్వబడదు.';

  @override
  String get phoneInvalid => 'పది అంకెల నంబర్ ఇవ్వండి';

  @override
  String phoneUnknown(String number) {
    return 'ఈ డెమోలో ఈ నంబర్ పనిచేయదు. $number వాడండి.';
  }

  @override
  String get phoneSendCode => 'కోడ్ పంపండి';

  @override
  String get otpTitle => 'వచ్చిన కోడ్ ఇవ్వండి';

  @override
  String otpSentTo(String number) {
    return '$number కు పంపాం';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds సెకన్లలో మళ్ళీ పంపండి';
  }

  @override
  String get otpResend => 'కోడ్ మళ్ళీ పంపండి';

  @override
  String get otpCallMe => 'నాకు ఫోన్ చేసి చెప్పండి';

  @override
  String get otpCalling =>
      'కొద్దిసేపట్లో కాల్ వస్తుంది, కోడ్ చదివి వినిపిస్తారు.';

  @override
  String get otpWrong => 'కోడ్ సరిగ్గా లేదు. మళ్ళీ ఇవ్వండి.';

  @override
  String get phoneSendFailed =>
      'కోడ్ పంపలేకపోయాం. నెట్‌వర్క్ చూసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get otpExpired => 'కోడ్ గడువు ముగిసింది. మళ్ళీ పంపండి.';

  @override
  String get authTooManyTries =>
      'చాలా సార్లు ప్రయత్నించారు. కొంతసేపు ఆగి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get otpChangeNumber => 'నంబర్ మార్చండి';

  @override
  String get otpAutoRead => 'సందేశం దానంతట అదే చదవబడింది';

  @override
  String get profileTitle => 'మీ గురించి చెప్పండి';

  @override
  String get profileNameLabel => 'మీ పేరు';

  @override
  String get profileNameHint => 'చెప్పండి లేదా రాయండి';

  @override
  String get profileNameMissing => 'మీ పేరు చెప్పండి';

  @override
  String get profileCraftLabel => 'మీరు ఏం తయారుచేస్తారు';

  @override
  String get profileCraftMissing => 'ఒకటి ఎంచుకోండి';

  @override
  String get profileSpeakToFill => 'చెప్పండి';

  @override
  String get profileListening => 'వింటున్నాం…';

  @override
  String get dictationUnavailable =>
      'ఈ ఫోన్‌లో మాట్లాడి రాయడం పనిచేయడం లేదు. దయచేసి రాయండి.';

  @override
  String get dictationNothingHeard =>
      'ఏమీ వినిపించలేదు. మైక్ నొక్కి మళ్ళీ మాట్లాడండి.';

  @override
  String get craftWeaving => 'నేత';

  @override
  String get craftPottery => 'కుమ్మరి పని';

  @override
  String get craftWoodwork => 'చెక్క పని';

  @override
  String get craftMetalwork => 'లోహపు పని';

  @override
  String get craftJewellery => 'నగలు';

  @override
  String get craftEmbroidery => 'ఎంబ్రాయిడరీ';

  @override
  String get craftPainting => 'చిత్రలేఖనం';

  @override
  String get craftLeather => 'తోలు పని';

  @override
  String get craftBamboo => 'వెదురు మరియు బెత్తం';

  @override
  String get craftOther => 'మరేదైనా';

  @override
  String get ondcTitle => 'మీ ONDC ఖాతాను జోడించండి';

  @override
  String get ondcExplain =>
      'ONDC లో కొనుగోలుదారులు మీరు చేసినవి చూసి కొంటారు. డబ్బు నేరుగా మీకే వస్తుంది, మా ద్వారా కాదు.';

  @override
  String get ondcMalformed =>
      'ఇది సెల్లర్ ఐడీలా కనిపించడం లేదు. దయచేసి సరిచూడండి, లేదా కోడ్‌ను మళ్ళీ స్కాన్ చేయండి.';

  @override
  String get ondcEmailLabel => 'ONDC ఈమెయిల్';

  @override
  String get ondcEmailMalformed =>
      'ఇది ఈమెయిల్ చిరునామాలా అనిపించడం లేదు. దయచేసి దాన్ని తనిఖీ చేయండి.';

  @override
  String get ondcSellerIdLabel => 'విక్రేత ఐడి';

  @override
  String get ondcScan => 'QR కోడ్ స్కాన్ చేయండి';

  @override
  String get ondcLink => 'ఖాతా జోడించండి';

  @override
  String get ondcLinking => 'జోడిస్తున్నాం…';

  @override
  String get ondcFailed => 'ఆ ఖాతా దొరకలేదు. దయచేసి సరిచూడండి.';

  @override
  String get ondcNoAccount => 'నాకు ఇంకా ఖాతా లేదు';

  @override
  String get ondcNoAccountExplain =>
      'పర్వాలేదు. మీరు వస్తువులు సిద్ధం చేసి ఉంచవచ్చు. ఖాతా జోడించగానే అన్నీ కలిసి వెళ్తాయి.';

  @override
  String get practiceTitle => 'మంచి ఫోటో ఎలా తీయాలి';

  @override
  String get practiceIntro =>
      'అదే కుండ, ఒకసారి బాగా మరియు ఒకసారి చెడుగా తీసినది. రెండూ చూడటానికి జరపండి.';

  @override
  String get practiceGoodBadge => 'ఇలా చేయండి';

  @override
  String get practiceGoodTitle => 'మంచి ఫోటో';

  @override
  String get practiceGoodTip1 => 'స్పష్టం: ఫోన్ కదలకుండా పట్టుకున్నారు';

  @override
  String get practiceGoodTip2 => 'వెలుతురు: కిటికీ లేదా తలుపు దగ్గర తీసినది';

  @override
  String get practiceGoodTip3 => 'వస్తువు మొత్తం ఫోటోలో ఉంది';

  @override
  String get practiceBadBadge => 'ఇలా చేయకండి';

  @override
  String get practiceBadTitle => 'చెడ్డ ఫోటో';

  @override
  String get practiceBadTip1 => 'మసక: ఫోన్ కదిలింది';

  @override
  String get practiceBadTip2 => 'కొనేవారికి వివరాలు కనిపించవు';

  @override
  String get practiceBadTip3 => 'యాప్ మిమ్మల్ని మళ్ళీ ఫోటో తీయమంటుంది';

  @override
  String get practiceFinish => 'యాప్ తెరవండి';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navListings => 'వస్తువులు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String homeGreeting(String name) {
    return 'నమస్కారం, $name';
  }

  @override
  String get homeAddProduct => 'వస్తువు జోడించండి';

  @override
  String get homeAddProductSpoken =>
      'వస్తువు జోడించడానికి ఈ పెద్ద బటన్ నొక్కండి. మూడు ఫోటోలు తీయండి, ఇది ఏమిటో చెప్పండి, అది అమ్మకానికి వెళ్తుంది.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count వస్తువులు పంపాల్సి ఉన్నాయి',
      one: '1 వస్తువు పంపాల్సి ఉంది',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count అమ్ముడయ్యాయి',
      one: '1 అమ్ముడైంది',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'మీ ఇటీవలి వస్తువులు';

  @override
  String get homeNextTitle => 'ఇప్పుడు చేయాల్సింది';

  @override
  String get homeEmptyTitle => 'ఇక్కడ ఇంకా ఏమీ లేదు';

  @override
  String get homeEmptyBody =>
      'పైన ఉన్న పెద్ద బటన్ నొక్కి మీ మొదటి వస్తువును జోడించండి.';

  @override
  String get offlineNoNetwork => 'ఇప్పుడు నెట్‌వర్క్ లేదు';

  @override
  String get offlineNothingLost =>
      'ఏమీ పోలేదు. నెట్‌వర్క్ రాగానే దానంతట అదే వెళ్తుంది.';

  @override
  String get statusQueued => 'పంపాల్సి ఉంది';

  @override
  String get statusProcessing => 'సిద్ధమవుతోంది';

  @override
  String get statusNeedsAttention => 'మీ సమాధానం కావాలి';

  @override
  String get statusReady => 'అమ్మకానికి సిద్ధం';

  @override
  String get statusPublished => 'అమ్మకంలో ఉంది';

  @override
  String get statusFailed => 'పంపలేకపోయాం';

  @override
  String get listingUntitled => 'వస్తువు';

  @override
  String get listingNoPrice => 'ధర చెప్పలేదు';

  @override
  String get captureTitle => 'వస్తువు జోడించండి';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ఫోటో $current / $total';
  }

  @override
  String get capturePhotoWhole => 'మొత్తం వస్తువును చూపించండి';

  @override
  String get capturePhotoDetail => 'దగ్గరి నుంచి ఒకటి తీయండి';

  @override
  String get capturePhotoScale => 'పరిమాణం తెలిసేలా పక్కన చేయి ఉంచండి';

  @override
  String get captureTakePhoto => 'ఫోటో తీయండి';

  @override
  String get captureFromGallery => 'గ్యాలరీ నుంచి ఎంచుకోండి';

  @override
  String get captureTorchOn => 'లైట్ ఆన్';

  @override
  String get captureTorchOff => 'లైట్ ఆఫ్';

  @override
  String get captureCameraFailed => 'కెమెరా తెరుచుకోలేదు';

  @override
  String get captureCameraRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get captureCameraPermission =>
      'మీ వస్తువు ఫోటోలు తీయడానికి యాప్‌కి కెమెరా కావాలి.';

  @override
  String get captureOpenSettings => 'సెట్టింగ్స్ తెరవండి';

  @override
  String get captureLeaveTitle => 'సేవ్ చేయకుండా వెళ్ళిపోవాలా?';

  @override
  String get captureLeaveBody => 'ఫోటోలు, మీరు చెప్పినది తొలగిపోతాయి.';

  @override
  String get captureLeaveConfirm => 'తొలగించండి';

  @override
  String get captureLeaveCancel => 'ఇక్కడే ఉండండి';

  @override
  String get shotReviewChecking => 'ఫోటోను పరిశీలిస్తున్నాం…';

  @override
  String get shotReviewRetake => 'మళ్ళీ తీయండి';

  @override
  String get qualityTooDark =>
      'ఈ ఫోటో చాలా చీకటిగా ఉంది. తలుపు దగ్గర నిలబడి తీయండి.';

  @override
  String get qualityTooBright =>
      'దీనిపై వెలుతురు ఎక్కువగా ఉంది. ఎండకు వీపు పెట్టి తీయండి.';

  @override
  String get qualityBlurry =>
      'ఈ ఫోటో స్పష్టంగా లేదు. ఫోన్ కదలకుండా పట్టుకుని మళ్ళీ తీయండి.';

  @override
  String get qualityUnreadable =>
      'ఈ ఫోటో సరిగ్గా సేవ్ కాలేదు. దయచేసి మళ్ళీ తీయండి.';

  @override
  String get qualityNoSubject =>
      'ఈ ఫోటోలో వస్తువు కనిపించడం లేదు. దాన్ని గీత లోపల ఉంచి దగ్గరికి రండి.';

  @override
  String get qualityOutOfFrame =>
      'ఈ ఫోటోలో వస్తువులో ఒక భాగమే ఉంది. మొత్తం వస్తువును గీత లోపల ఉంచండి.';

  @override
  String get qualityWarningTitle => 'దీన్ని మళ్ళీ తీయండి';

  @override
  String get qualityKeepAnyway => 'అయినా ఉంచండి';

  @override
  String get photoSetTitle => 'మీ మూడు ఫోటోలు';

  @override
  String get photoSetBody =>
      'కొనుగోలుదారులు ముందుగా చూసేది మొదటి ఫోటోనే. ఒక ఫోటోను మళ్ళీ తీయాలంటే దాన్ని నొక్కండి.';

  @override
  String get photoSetMain => 'మొదటి ఫోటో';

  @override
  String get photoSetRetakeThis => 'దీన్ని మళ్ళీ తీయండి';

  @override
  String get photoSetConfirm => 'ఈ ఫోటోలు బాగున్నాయి';

  @override
  String get photoEditOpen => 'ఫోటో కత్తిరించండి లేదా తిప్పండి';

  @override
  String get photoEditTitle => 'ఫోటో కత్తిరించండి';

  @override
  String get photoEditBody =>
      'కత్తిరించడానికి పెట్టె మూల లేదా అంచును లాగండి. జరపడానికి పెట్టె లోపల నుండి లాగండి.';

  @override
  String get photoEditTurn => 'తిప్పండి';

  @override
  String get photoEditStraighten => 'నేరుగా చేయండి';

  @override
  String get photoEditReset => 'మళ్ళీ మొదలుపెట్టండి';

  @override
  String get photoEditDone => 'ఈ ఫోటో వాడండి';

  @override
  String get photoEditCancel => 'వెనక్కి వెళ్ళండి';

  @override
  String get photoEditFailed => 'ఈ మార్పు సేవ్ కాలేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get photoIssueTooDark => 'చాలా చీకటి, స్పష్టంగా కనిపించడం లేదు';

  @override
  String get photoIssueTooBright => 'దీనిపై వెలుతురు ఎక్కువ';

  @override
  String get photoIssueBlurry => 'మసకగా ఉంది, తగినంత స్పష్టంగా లేదు';

  @override
  String get photoIssueNoSubject => 'ఈ ఫోటోలో ఏ వస్తువూ కనిపించడం లేదు';

  @override
  String get photoIssueUnreadable => 'ఈ ఫోటో సేవ్ కాలేదు';

  @override
  String get photoIssueOutOfFrame => 'వస్తువు పూర్తిగా ఫోటోలో లేదు';

  @override
  String get voiceTitle => 'ఇప్పుడు ఇది ఏమిటో చెప్పండి';

  @override
  String get voiceBody =>
      'ఇది ఏమిటి, దేనితో చేసింది, ఎంత పెద్దది, చేయడానికి ఎంత సమయం పట్టింది, ధర ఎంత.';

  @override
  String get voiceHoldToSpeak => 'నొక్కి పట్టి మాట్లాడండి';

  @override
  String get voiceRecording => 'మాట్లాడండి… అయిపోయాక వదలండి';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total లో $seconds సెకన్లు';
  }

  @override
  String get voiceTooShort =>
      'అది చాలా చిన్నది. బటన్ నొక్కి పట్టి మళ్ళీ మాట్లాడండి.';

  @override
  String get voiceFailed =>
      'మైక్ మొదలవలేదు. యాప్‌కి మైక్ అనుమతి ఉందో లేదో చూడండి.';

  @override
  String get voiceBackToPhotos => 'ఫోటోలకు తిరిగి వెళ్ళండి';

  @override
  String get playbackPlay => 'వినండి';

  @override
  String get playbackStop => 'ఆపండి';

  @override
  String get playbackAgain => 'మళ్ళీ చెప్పండి';

  @override
  String get playbackAccept => 'ఇది సరైనది';

  @override
  String get playbackUnavailable =>
      'ఈ ఫోన్ దాన్ని వినిపించలేదు. అయినా పంపవచ్చు, లేదా మళ్ళీ చెప్పవచ్చు.';

  @override
  String get savedTitle => 'సేవ్ అయింది';

  @override
  String get savedBody => 'నెట్‌వర్క్ ఉన్నప్పుడు దానంతట అదే వెళ్తుంది.';

  @override
  String get savedBodyOnline =>
      'ఇప్పుడు పంపుతున్నాం. మీరు ఇక్కడ వేచి ఉండాల్సిన అవసరం లేదు.';

  @override
  String get savedAddAnother => 'ఇంకో వస్తువు జోడించండి';

  @override
  String get savedGoHome => 'హోమ్‌కి వెళ్ళండి';

  @override
  String get saveFailed => 'ఈ ఫోన్‌లో సేవ్ చేయలేకపోయాం. బహుశా స్థలం లేదేమో.';

  @override
  String get saveRetry => 'మళ్ళీ సేవ్ చేయడానికి ప్రయత్నించండి';

  @override
  String get queueTitle => 'పంపాల్సినవి';

  @override
  String get queueBody =>
      'ఇక్కడ ఏమీ పోలేదు. నెట్‌వర్క్ రాగానే ఒక్కొక్కటి వెళ్తుంది.';

  @override
  String get queueEmptyTitle => 'ఏమీ మిగిలి లేదు';

  @override
  String get queueEmptyBody => 'మీరు చేసినవన్నీ పంపబడ్డాయి.';

  @override
  String get queueStateWaiting => 'నెట్‌వర్క్ కోసం వేచి ఉంది';

  @override
  String queueStateUploading(int percent) {
    return 'పంపుతున్నాం… వందలో $percent';
  }

  @override
  String get queueStateProcessing => 'ఇప్పుడు మా దగ్గర ఉంది. రాస్తున్నాం.';

  @override
  String get queueStateFailed => 'వెళ్ళలేదు. కారణం చూడటానికి నొక్కండి.';

  @override
  String get queueItemTitle => 'ఈ వస్తువు';

  @override
  String queueMadeAt(String date) {
    return '$date న చేసింది';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count సార్లు ప్రయత్నించాం',
      one: 'ఒకసారి ప్రయత్నించాం',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'ఇప్పుడే పంపడానికి ప్రయత్నించండి';

  @override
  String get queueRetryWaiting => 'ఇంకా నెట్‌వర్క్ లేదు. దానంతట అదే వెళ్తుంది.';

  @override
  String get queueDelete => 'ఈ వస్తువును తొలగించండి';

  @override
  String get queueDeleteTitle => 'ఈ వస్తువును తొలగించాలా?';

  @override
  String get queueDeleteBody =>
      'ఫోటోలు, మీరు చెప్పినది పోతాయి. దీన్ని తిరిగి పొందలేరు.';

  @override
  String get queueDeleteConfirm => 'అవును, తొలగించండి';

  @override
  String get queueDeleteCancel => 'వద్దు, ఉంచండి';

  @override
  String get failureNetwork =>
      'నెట్‌వర్క్ మధ్యలో ఆగిపోయింది. సిగ్నల్ రాగానే దానంతట అదే మళ్ళీ వెళ్తుంది.';

  @override
  String get failureServer =>
      'మా వైపు నుంచి సమాధానం రాలేదు. మళ్ళీ ప్రయత్నిస్తాం.';

  @override
  String get failureMissingFiles =>
      'ఫోటోలు ఇప్పుడు ఈ ఫోన్‌లో లేవు, కాబట్టి దీన్ని పంపలేం. దయచేసి మళ్ళీ చేయండి.';

  @override
  String get failureRejected => 'ఇది అంగీకరించబడలేదు. దయచేసి మళ్ళీ చేయండి.';

  @override
  String get failureUnknown => 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించవచ్చు.';

  @override
  String get processingTitle => 'మేం రాస్తున్నాం';

  @override
  String get processingBody =>
      'మీ ఫోటోలు, మీ మాటలు మా దగ్గర ఉన్నాయి. దీనికి కొన్ని నిమిషాలు పడుతుంది.';

  @override
  String get processingLeave =>
      'మీరు ఇక్కడ వేచి ఉండాల్సిన అవసరం లేదు. సిద్ధమయ్యాక చెబుతాం.';

  @override
  String get processingGoHome => 'హోమ్‌కి వెళ్ళండి';

  @override
  String get attentionTitle => 'ఒక ప్రశ్న';

  @override
  String get attentionBody => 'మిగతావన్నీ అర్థమయ్యాయి. ఇది ఒక్కటే మిగిలింది.';

  @override
  String get attentionHoldToAnswer => 'నొక్కి పట్టి సమాధానం చెప్పండి';

  @override
  String get attentionAnswering => 'మీ సమాధానం పంపుతున్నాం…';

  @override
  String get attentionFailed => 'మీ సమాధానం వెళ్ళలేదు. దయచేసి మళ్ళీ చెప్పండి.';

  @override
  String get readBackTitle => 'మాకు అర్థమైనది ఇది';

  @override
  String get readBackListen => 'మొత్తం వినండి';

  @override
  String get readBackFields => 'మేం రాసుకున్నది';

  @override
  String get readBackCorrect => 'తప్పుగా ఉన్నదాన్ని నొక్కండి';

  @override
  String get readBackApprove => 'ఇదంతా సరైనది';

  @override
  String get notSaid => 'చెప్పలేదు';

  @override
  String get fieldMaterial => 'దేనితో చేసింది';

  @override
  String get fieldSize => 'పరిమాణం';

  @override
  String get fieldColour => 'రంగు';

  @override
  String get fieldTechnique => 'ఎలా చేసింది';

  @override
  String get fieldQuantity => 'ఎన్ని';

  @override
  String get fieldPrice => 'ధర';

  @override
  String correctTitle(String field) {
    return 'సరైన $field చెప్పండి';
  }

  @override
  String get correctHoldToSpeak => 'నొక్కి పట్టి చెప్పండి';

  @override
  String get correctListening => 'వింటున్నాం…';

  @override
  String get correctFailedOnce => 'మాకు అర్థం కాలేదు. ఇంకోసారి చెప్పండి.';

  @override
  String get correctUseKeypad => 'బదులుగా రాయండి';

  @override
  String get correctUseVoice => 'బదులుగా చెప్పండి';

  @override
  String get correctPick => 'లేదా ఒకటి ఎంచుకోండి';

  @override
  String get correctSave => 'దీన్ని సేవ్ చేయండి';

  @override
  String get correctCancel => 'ఉన్నట్టే ఉండనివ్వండి';

  @override
  String get colourRed => 'ఎరుపు';

  @override
  String get colourBlue => 'నీలం';

  @override
  String get colourGreen => 'ఆకుపచ్చ';

  @override
  String get colourYellow => 'పసుపు';

  @override
  String get colourBlack => 'నలుపు';

  @override
  String get colourWhite => 'తెలుపు';

  @override
  String get colourBrown => 'గోధుమ';

  @override
  String get colourMulti => 'చాలా రంగులు';

  @override
  String get sizeSmall => 'చిన్నది';

  @override
  String get sizeMedium => 'మధ్యస్థం';

  @override
  String get sizeLarge => 'పెద్దది';

  @override
  String get sizeExtraLarge => 'చాలా పెద్దది';

  @override
  String get suggestTitle => 'దీన్ని కూడా జోడించాలా?';

  @override
  String get suggestYes => 'అవును, జోడించండి';

  @override
  String get suggestNo => 'వద్దు, వదిలేయండి';

  @override
  String get suggestSkip => 'నాకు ఖచ్చితంగా తెలియదు';

  @override
  String suggestProgress(int current, int total) {
    return '$total లో $current';
  }

  @override
  String get suggestDone => 'ఇంకేమీ జోడించాల్సింది లేదు';

  @override
  String get priceTitle => 'ధర ఎంత?';

  @override
  String get priceBody => 'ఇది ఒక్క వస్తువు ధర.';

  @override
  String priceFloor(String amount) {
    return 'మీకు అయిన ఖర్చు: $amount';
  }

  @override
  String get priceFloorExplain =>
      'మీ సామగ్రి, మీ సమయం కలిపి ఇంత అవుతుంది. దీనికంటే తక్కువకు అమ్మితే మీకు నష్టం.';

  @override
  String priceBand(String low, String high) {
    return 'ఇలాంటి వస్తువులను ఇతరులు $low నుంచి $high కు అమ్ముతారు';
  }

  @override
  String get priceBelowFloor =>
      'ఇది మీ ఖర్చు కంటే తక్కువ. అయినా మీరు ఇదే ఎంచుకోవచ్చు.';

  @override
  String get priceSayIt => 'ధర చెప్పండి';

  @override
  String get priceConfirm => 'ఈ ధర సరైనది';

  @override
  String get stockTitle => 'మీ దగ్గర ఎన్ని ఉన్నాయి?';

  @override
  String get stockBody => 'అన్నీ అమ్ముడయ్యాక మీ కోసం దీన్ని తీసేస్తాం.';

  @override
  String get stockOneOfAKind => 'ఒక్కటే ఉంది, ఇలాంటిది మళ్ళీ ఎప్పటికీ రాదు';

  @override
  String get stockMore => 'ఇంకొకటి';

  @override
  String get stockLess => 'ఒకటి తక్కువ';

  @override
  String get stockConfirm => 'ఇది సరైనది';

  @override
  String get photosTitle => 'ఏ ఫోటో ముందు రావాలి?';

  @override
  String get photosBody =>
      'కొనుగోలుదారులు అన్నిటికంటే ముందు మొదటి ఫోటోనే చూస్తారు.';

  @override
  String get photosMakeFirst => 'దీన్ని మొదటి ఫోటోగా చేయండి';

  @override
  String get photosFirst => 'మొదటి ఫోటో';

  @override
  String get photosConfirm => 'ఈ ఫోటోలు సరైనవి';

  @override
  String get previewTitle => 'కొనుగోలుదారులు ఇది చూస్తారు';

  @override
  String get previewListenAll => 'అంతా వినండి';

  @override
  String get previewNoDescription => 'ఏ వివరణా రాయలేదు.';

  @override
  String get previewConfirm => 'అవును, ఇది సరైనది';

  @override
  String get previewChange => 'ఏదైనా మార్చండి';

  @override
  String get consentTitle => 'దీన్ని అమ్మకానికి పెట్టమంటారా?';

  @override
  String get consentPhoto => 'నా ఫోటోలు చూపించండి';

  @override
  String get consentPhotoExplain =>
      'మీ వస్తువు ఫోటోలు కొనుగోలుదారు స్క్రీన్‌పై కనిపిస్తాయి.';

  @override
  String get consentStory => 'నా కళ కథను చూపించండి';

  @override
  String get consentStoryExplain =>
      'మీ పేరు, మీ ఊరు, మీరు ఎలా తయారుచేస్తారో అది కారీగర్ కార్డ్‌పై వెళ్తుంది. వద్దన్నా మీరు అమ్మవచ్చు.';

  @override
  String get consentNeeded => 'ఫోటోలు లేకుండా దీన్ని పెట్టలేం.';

  @override
  String get consentPublish => 'అమ్మకానికి పెట్టండి';

  @override
  String get publishingTitle => 'అమ్మకానికి పెడుతున్నాం';

  @override
  String get publishingBody => 'దీనికి కొంత సమయం పడుతుంది. యాప్ మూసేయకండి.';

  @override
  String get publishedTitle => 'ఇది అమ్మకంలో ఉంది';

  @override
  String get publishedBody => 'కొనుగోలుదారులు ఇప్పుడు దీన్ని చూడవచ్చు.';

  @override
  String get publishedShare => 'వాట్సాప్‌లో పంపండి';

  @override
  String get publishedCopyLink => 'లింక్ కాపీ చేయండి';

  @override
  String get publishedLinkCopied => 'లింక్ కాపీ అయింది';

  @override
  String get publishedShowQr => 'స్కాన్ చేసే కోడ్ చూపించండి';

  @override
  String get publishedQrExplain =>
      'ఎవరైనా దీని వైపు ఫోన్ పెట్టి మీ వస్తువును తెరవవచ్చు.';

  @override
  String get publishedAnother => 'ఇలాంటిదే ఇంకొకటి చేయండి';

  @override
  String get publishedDone => 'హోమ్‌కి వెళ్ళండి';

  @override
  String get publishFailed =>
      'దీన్ని పెట్టలేకపోయాం. ఏమీ పోలేదు — మళ్ళీ ప్రయత్నించవచ్చు.';

  @override
  String get publishRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get reviewLeaveTitle => 'ప్రస్తుతానికి వదిలేయాలా?';

  @override
  String get reviewLeaveBody =>
      'మీరు ఆమోదించినవి ఉంటాయి. మీ వస్తువుల నుంచి తిరిగి రావచ్చు.';

  @override
  String get reviewLeaveConfirm => 'ప్రస్తుతానికి వదిలేయండి';

  @override
  String get editLeaveTitle => 'మీ మార్పులు ఇంకా అమ్మకంలో లేవు';

  @override
  String get editLeaveBody =>
      'మీరు మార్చినది సేవ్ అయింది, కానీ కొనుగోలుదారులు ఇంకా పాతదే చూస్తున్నారు. చివరి బటన్ నొక్కితేనే మళ్ళీ అమ్మకానికి వెళ్తుంది.';

  @override
  String get editLeaveConfirm => 'సరే, తర్వాత చేస్తాను';

  @override
  String get reviewLeaveCancel => 'కొనసాగించండి';

  @override
  String get statusSoldOut => 'అన్నీ అమ్ముడయ్యాయి';

  @override
  String get statusUnpublished => 'తీసేశాం';

  @override
  String get listingsTitle => 'మీ వస్తువులు';

  @override
  String get listingsEmptyTitle => 'మీరు ఇంకా ఏమీ చేయలేదు';

  @override
  String get listingsEmptyBody =>
      'హోమ్‌లోని పెద్ద బటన్ నొక్కి మీ మొదటి వస్తువును జోడించండి.';

  @override
  String get listingsEmptyFilter => 'ఇక్కడ ఏమీ లేదు.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మిగిలాయి',
      one: '1 మిగిలింది',
      zero: 'ఏమీ మిగలలేదు',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count సార్లు చూశారు',
      one: 'ఒకసారి చూశారు',
      zero: 'ఇంకా ఎవరూ చూడలేదు',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'సంఖ్య మార్చండి';

  @override
  String get listingTitle => 'ఈ వస్తువు';

  @override
  String get listingOpenPreview => 'కొనుగోలుదారులు చూసేది చూడండి';

  @override
  String get listingEdit => 'ఏదైనా మార్చండి';

  @override
  String get listingDuplicate => 'ఇలాంటిదే ఇంకొకటి చేయండి';

  @override
  String get listingUnpublish => 'అమ్మకం నుంచి తీసేయండి';

  @override
  String get listingRelist => 'మళ్ళీ అమ్మకానికి పెట్టండి';

  @override
  String get listingFinish => 'దీన్ని పూర్తిచేయండి';

  @override
  String get listingSoldOutTitle => 'ఇవన్నీ అమ్ముడయ్యాయి';

  @override
  String get listingSoldOutBody =>
      'మీ కోసం దీన్ని అమ్మకం నుంచి తీసేశాం. ఇంకా చేశాక మళ్ళీ పెట్టండి.';

  @override
  String get editTitle => 'ఈ వస్తువును మార్చండి';

  @override
  String get editBody =>
      'మీరు దీన్ని మళ్ళీ చూస్తారు, ఆ తర్వాత ఇది మళ్ళీ అమ్మకానికి వెళ్తుంది.';

  @override
  String get editRepublishing => 'మార్పులను అమ్మకానికి పెడుతున్నాం…';

  @override
  String get editRepublished => 'మీ మార్పులు ఇప్పుడు అమ్మకంలో ఉన్నాయి';

  @override
  String get editRepublishConfirm => 'మార్పును మళ్ళీ అమ్మకానికి పెట్టండి';

  @override
  String get quickStockTitle => 'ఎన్ని మిగిలాయి?';

  @override
  String get quickStockMarkSoldOut => 'అన్నీ అమ్ముడయ్యాయి';

  @override
  String get quickStockSave => 'సేవ్ చేయండి';

  @override
  String get quickStockSaved => 'సేవ్ అయింది';

  @override
  String get actionUndo => 'మునుపటిలా చేయండి';

  @override
  String get unpublishTitle => 'అమ్మకం నుంచి తీసేయాలా?';

  @override
  String get unpublishBody =>
      'కొనుగోలుదారులు ఇక దీన్ని చూడరు. ఏదీ తొలగించబడదు, ఎప్పుడైనా మళ్ళీ పెట్టవచ్చు.';

  @override
  String get unpublishConfirm => 'అవును, తీసేయండి';

  @override
  String get unpublishCancel => 'వద్దు, అమ్మకంలో ఉండనివ్వండి';

  @override
  String get unpublishDone => 'అమ్మకం నుంచి తీసేశాం';

  @override
  String get relistDone => 'ఇది మళ్ళీ అమ్మకంలో ఉంది';

  @override
  String get duplicateTitle => 'ఇలాంటిదే ఇంకొకటి చేయాలా?';

  @override
  String get duplicateBody =>
      'దీని గురించి మీరు చెప్పింది ఉంచుతాం. మీరు కొత్త ఫోటోలు మాత్రమే తీయాలి.';

  @override
  String get duplicateConfirm => 'ఫోటోలు తీయండి';

  @override
  String get duplicateCancel => 'ఇప్పుడు వద్దు';

  @override
  String get duplicateBanner =>
      'పోయినసారిలాంటిదే ఇంకొకటి చేస్తున్నాం. ఫోటోలు మాత్రమే కొత్తవి.';

  @override
  String get listingActionFailed => 'అది జరగలేదు. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get salesNew => 'కొత్తది';

  @override
  String get salesEmptyTitle => 'ఇంకా ఏమీ అమ్ముడవలేదు';

  @override
  String get salesEmptyBody =>
      'ఎవరైనా ఏదైనా కొంటే ఇక్కడ కనిపిస్తుంది, మేం మీకు చెబుతాం.';

  @override
  String get salesLoading => 'ఏం అమ్ముడైందో చూస్తున్నాం…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count వస్తువులు',
      one: '1 వస్తువు',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date లోపు ప్యాక్ చేయండి';
  }

  @override
  String get salesPackByToday => 'ఈరోజే ప్యాక్ చేయండి';

  @override
  String get salesPackByTomorrow => 'రేపటిలోపు ప్యాక్ చేయండి';

  @override
  String get salesPackedAlready => 'దీని తేదీ దాటిపోయింది';

  @override
  String get saleTitle => 'ఈ ఆర్డర్';

  @override
  String get saleReadOnly =>
      'ఇది మీకు తెలియజేయడానికి మాత్రమే. ఆర్డర్ పని అంతా మార్కెట్‌లో జరుగుతుంది, ఈ యాప్‌లో కాదు.';

  @override
  String salePaid(String amount) {
    return 'మీకు $amount వస్తాయి';
  }

  @override
  String salePlaced(String date) {
    return '$date న అమ్ముడైంది';
  }

  @override
  String saleGoingTo(String area) {
    return '$area కు వెళ్తోంది';
  }

  @override
  String get saleWhatToPack => 'ఏం ప్యాక్ చేయాలి';

  @override
  String get salePackingHelp => 'ఎలా ప్యాక్ చేయాలి';

  @override
  String get saleSeeListing => 'ఈ వస్తువును చూడండి';

  @override
  String get packingTitle => 'ఎలా ప్యాక్ చేయాలి';

  @override
  String get packingBody => 'ఒక్కొక్కటిగా చేయండి. అయినదాన్ని నొక్కండి.';

  @override
  String get packingStep1 => 'ఏదీ రాసుకోకుండా బట్టలో లేదా కాగితంలో చుట్టండి';

  @override
  String get packingStep2 =>
      'పెట్టెలో కదలకుండా చుట్టూ కాగితం లేదా గడ్డి నింపండి';

  @override
  String get packingStep3 => 'లోపల సరైన సంఖ్యలో ఉన్నాయో చూడండి';

  @override
  String get packingStep4 => 'పెట్టె మూసి చుట్టూ టేప్ వేయండి';

  @override
  String get packingStep5 =>
      'తీసుకెళ్ళడానికి వచ్చే వ్యక్తి కోసం సిద్ధంగా ఉంచండి';

  @override
  String get packingDone => 'అంతా అయిపోయింది';

  @override
  String packingProgress(int done, int total) {
    return '$total లో $done అయ్యాయి';
  }

  @override
  String get earningsTitle => 'మీరు ఎంత సంపాదించారు';

  @override
  String get earningsWeek => 'ఈ వారం';

  @override
  String get earningsMonth => 'ఈ నెల';

  @override
  String get earningsTotal => 'మొదటి నుంచి';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count వస్తువులు అమ్ముడయ్యాయి',
      one: '1 వస్తువు అమ్ముడైంది',
      zero: 'ఇంకా ఏమీ అమ్ముడవలేదు',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote => 'మార్కెట్ తన వాటా తీసుకున్నాక మీకు వచ్చేది ఇది.';

  @override
  String get profileVillageLabel => 'ఊరు లేదా క్లస్టర్';

  @override
  String get profileNotSet => 'ఇవ్వలేదు';

  @override
  String get profileEditEntry => 'మీ వివరాలు మార్చండి';

  @override
  String get profileStoryEntry => 'మీ కళ కథ';

  @override
  String get profileLanguageEntry => 'భాష';

  @override
  String get profilePhoneEntry => 'ఫోన్ నంబర్';

  @override
  String get profileOndcEntry => 'మీ అమ్మకాల ఖాతా';

  @override
  String get profileNotificationsEntry => 'మేం మీకు ఏం చెప్పాలి';

  @override
  String get profileVoiceEntry => 'స్వరం మరియు ధ్వని';

  @override
  String get profilePrivacyEntry => 'మీ గురించి ఏం కనిపిస్తుంది';

  @override
  String get profileStorageEntry => 'ఈ ఫోన్‌లో స్థలం';

  @override
  String get profileAccountEntry => 'సైన్ అవుట్';

  @override
  String get editProfileTitle => 'మీ వివరాలు';

  @override
  String get editProfileAddPhoto => 'మీ ఫోటో జోడించండి';

  @override
  String get editProfileChangePhoto => 'ఫోటో మార్చండి';

  @override
  String get editProfileRemovePhoto => 'ఫోటో తీసేయండి';

  @override
  String get editProfilePhotoWhy =>
      'మీరు అనుమతిస్తేనే కొనుగోలుదారులు దీన్ని కారీగర్ కార్డ్‌పై చూస్తారు.';

  @override
  String get editProfileVillageHint => 'చెప్పండి లేదా రాయండి';

  @override
  String get editProfileSave => 'సేవ్ చేయండి';

  @override
  String get editProfileSaved => 'సేవ్ అయింది';

  @override
  String get storyTitle => 'మీ కళ కథ';

  @override
  String get storyBody =>
      'మీరు ఎవరు, ఎలా తయారుచేస్తారో కొనుగోలుదారులకు చెప్పండి. మీరు మాట్లాడండి, మేం రాసుకుంటాం.';

  @override
  String get storyHoldToSpeak => 'నొక్కి పట్టి మీ కథ చెప్పండి';

  @override
  String get storyEmpty => 'మీరు ఇంకా మీ కథ చెప్పలేదు.';

  @override
  String get storyEditHint => 'దీనిలో ఏ పదాన్నైనా మార్చవచ్చు.';

  @override
  String get storyExample =>
      'ఉదాహరణకు: మా కుటుంబం మూడు తరాలుగా ఇవి తయారుచేస్తోంది, నేను ఇప్పటికీ మా తాతగారి మగ్గంపై పనిచేస్తాను.';

  @override
  String get changePhoneTitle => 'మీ నంబర్ మార్చండి';

  @override
  String get changePhoneBody =>
      'నంబర్ మీదేనని నిర్ధారించడానికి కొత్త నంబర్‌కు ఒక కోడ్ పంపుతాం.';

  @override
  String changePhoneCurrent(String number) {
    return 'ఇప్పుడు మీ నంబర్ $number';
  }

  @override
  String get changePhoneDone => 'మీ నంబర్ మారింది';

  @override
  String get ondcAccountTitle => 'మీ అమ్మకాల ఖాతా';

  @override
  String get ondcAccountLinked => 'మీ ఖాతా జోడించబడింది';

  @override
  String get ondcAccountNone => 'ఇంకా ఏ ఖాతా జోడించలేదు';

  @override
  String get ondcAccountNoneBody =>
      'మీరు వస్తువులు చేస్తూ ఉండండి. ఖాతా జోడించగానే అవి అమ్మకానికి వెళ్తాయి.';

  @override
  String get ondcAccountLink => 'ఖాతా జోడించండి';

  @override
  String get ondcAccountUnlink => 'ఈ ఖాతాను తీసేయండి';

  @override
  String get ondcUnlinkTitle => 'ఈ ఖాతాను తీసేయాలా?';

  @override
  String get ondcUnlinkBody =>
      'అమ్మకంలో ఉన్నవన్నీ దిగిపోతాయి. మీరు చేసినవేవీ తొలగించబడవు, మళ్ళీ జోడించవచ్చు.';

  @override
  String get ondcUnlinkConfirm => 'అవును, తీసేయండి';

  @override
  String get ondcUnlinkCancel => 'వద్దు, ఉంచండి';

  @override
  String get ondcUnlinkDone => 'ఖాతా తీసేశాం';

  @override
  String get notificationsTitle => 'మేం మీకు ఏం చెప్పాలి';

  @override
  String get notifySold => 'ఏదైనా అమ్ముడైనప్పుడు';

  @override
  String get notifySoldWhy =>
      'కొనుగోలుదారు డబ్బు చెల్లించగానే చెబుతాం, మీరు ప్యాక్ చేయడం మొదలుపెట్టవచ్చు.';

  @override
  String get notifyAttention => 'మేం మిమ్మల్ని ఏదైనా అడగాల్సినప్పుడు';

  @override
  String get notifyAttentionWhy =>
      'కొన్నిసార్లు వస్తువు అమ్మకానికి వెళ్ళే ముందు ఒక విషయం మిగిలిపోతుంది.';

  @override
  String get notifyUpload => 'వస్తువు పంపబడినప్పుడు';

  @override
  String get notifyUploadWhy => 'మీరు ఫోన్‌లో చేసినది మాకు చేరగానే చెబుతాం.';

  @override
  String get notifyPackBy => 'ప్యాక్ చేసే సమయం వచ్చినప్పుడు';

  @override
  String get notifyPackByWhy =>
      'ఒక అమ్మకాన్ని ప్యాక్ చేయాల్సిన తేదీకి ఒక రోజు ముందు, ఆ రోజున మేము మీకు గుర్తు చేస్తాం.';

  @override
  String get notificationsBlocked =>
      'ఈ ఫోన్ మీకు ఏదీ పంపడానికి మమ్మల్ని అనుమతించడం లేదు. ఫోన్ సెట్టింగ్స్‌లో దీన్ని ఆన్ చేయవచ్చు.';

  @override
  String get voiceSettingsTitle => 'స్వరం మరియు ధ్వని';

  @override
  String get voiceSpeed => 'మేం ఎంత వేగంగా మాట్లాడాలి';

  @override
  String get voiceSpeedSlow => 'నెమ్మదిగా';

  @override
  String get voiceSpeedFast => 'వేగంగా';

  @override
  String get voiceTry => 'ఇప్పుడు ఏదైనా చెప్పి వినిపించండి';

  @override
  String get voiceSample => 'మేం మీతో ఈ వేగంలో మాట్లాడతాం.';

  @override
  String get voiceAutoRead => 'ప్రతి స్క్రీన్ తెరవగానే చదివి వినిపించండి';

  @override
  String get voiceAutoReadWhy =>
      'ఇది ఆఫ్‌లో ఉంటే, మీరు స్పీకర్ నొక్కినప్పుడు మాత్రమే మాట్లాడతాం.';

  @override
  String get voiceUnavailable =>
      'ఈ ఫోన్ మాట్లాడలేదు. అన్నీ పనిచేస్తాయి, కానీ ఏదీ చదివి వినిపించదు.';

  @override
  String get privacyTitle => 'మీ గురించి ఏం కనిపిస్తుంది';

  @override
  String get privacyBody =>
      'ప్రతి వస్తువును అమ్మకానికి పెట్టినప్పుడు మీరు వీటికి అవును అన్నారు. వీటిలో దేన్నైనా వెనక్కి తీసుకోవచ్చు.';

  @override
  String get privacyPhoto => 'ఈ వస్తువు ఫోటోలు';

  @override
  String get privacyStory => 'మీ పేరు, ఊరు, కథ';

  @override
  String get privacyNothing => 'ఇప్పుడు మీదేదీ అమ్మకంలో లేదు.';

  @override
  String get privacyWithdrawTitle => 'దీన్ని వెనక్కి తీసుకోవాలా?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ఫోటోలు లేకుండా ఈ వస్తువు అమ్మకంలో ఉండలేదు, కాబట్టి దిగిపోతుంది. ఏదీ తొలగించబడదు.';

  @override
  String get privacyWithdrawStoryBody =>
      'మీ పేరు, ఊరు, కథ ఈ వస్తువు నుంచి తీసేస్తాం. ఇది అమ్మకంలోనే ఉంటుంది.';

  @override
  String get privacyWithdrawConfirm => 'అవును, వెనక్కి తీసుకోండి';

  @override
  String get privacyWithdrawCancel => 'వద్దు, ఉండనివ్వండి';

  @override
  String get privacyWithdrawn => 'వెనక్కి తీసుకున్నాం';

  @override
  String get storageTitle => 'ఈ ఫోన్‌లో స్థలం';

  @override
  String get storagePhotos => 'ఫోటోలు మరియు రికార్డింగ్‌లు';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count వస్తువులు పంపాల్సి ఉన్నాయి',
      one: '1 వస్తువు పంపాల్సి ఉంది',
      zero: 'పంపాల్సింది ఏమీ లేదు',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'ఇప్పటికే పంపినవి తీసేయండి';

  @override
  String get storageClearWhy => 'ఇంకా పంపాల్సినవాటిని ఎప్పుడూ ముట్టుకోం.';

  @override
  String storageCleared(String size) {
    return '$size ఖాళీ అయింది';
  }

  @override
  String get storageNothingToClear => 'తీసేయడానికి ఏమీ లేదు';

  @override
  String get accountTitle => 'సైన్ అవుట్';

  @override
  String get accountSignOut => 'ఈ ఫోన్ నుంచి సైన్ అవుట్ చేయండి';

  @override
  String get accountSignOutTitle => 'సైన్ అవుట్ చేయాలా?';

  @override
  String get accountSignOutBody =>
      'పంపాల్సినవి పోతాయి. అమ్మకంలో ఉన్నవి అమ్మకంలోనే ఉంటాయి.';

  @override
  String get accountSignOutConfirm => 'అవును, సైన్ అవుట్';

  @override
  String get accountSignOutCancel => 'వద్దు, సైన్ ఇన్‌లోనే ఉంచండి';

  @override
  String get accountDelete => 'నా ఖాతా తొలగించండి';

  @override
  String get accountDeleteTitle => 'మీ ఖాతా తొలగించాలా?';

  @override
  String get accountDeleteBody =>
      'అన్నీ అమ్మకం నుంచి దిగిపోతాయి, ఈ ఫోన్‌లోని అంతా తుడిచిపెట్టబడుతుంది. దీన్ని తిరిగి పొందలేరు.';

  @override
  String get accountDeleteConfirm => 'అవును, అంతా తొలగించండి';

  @override
  String get accountDeleteCancel => 'వద్దు, నా ఖాతా ఉంచండి';

  @override
  String get accountDeleteHold => 'తొలగించడానికి బటన్ నొక్కి పట్టండి';

  @override
  String get profileHelpEntry => 'సహాయం';

  @override
  String get helpTitle => 'సహాయం';

  @override
  String get helpBody =>
      'చిన్న సమాధానాలు, చదివి వినిపిస్తాం. వినడానికి దేన్నైనా నొక్కండి.';

  @override
  String get helpSteps => 'ఇలా చేయండి';

  @override
  String get helpTopicPhotos => 'మంచి ఫోటోలు తీయడం';

  @override
  String get helpTopicPhotosBody =>
      'మంచి ఫోటోలు అమ్ముడవుతాయి. కొనుగోలుదారు వస్తువును చేతిలోకి తీసుకోలేరు, వారి దగ్గర ఫోటో మాత్రమే ఉంటుంది.';

  @override
  String get helpTopicPhotosStep1 =>
      'పగటి వెలుతురు వస్తువుపై పడేలా తలుపు లేదా కిటికీ దగ్గర నిలబడండి';

  @override
  String get helpTopicPhotosStep2 =>
      'చుట్టూ మరేమీ లేకుండా వస్తువును సాధారణ బట్టపై ఉంచండి';

  @override
  String get helpTopicPhotosStep3 =>
      'ఫోటో తీసేవరకు రెండు చేతులతో ఫోన్ కదలకుండా పట్టుకోండి';

  @override
  String get helpTopicPhotosStep4 =>
      'పనితనం కనిపించేలా దగ్గరి నుంచి ఒకటి తీయండి';

  @override
  String get helpTopicPhotosStep5 =>
      'పరిమాణం తెలిసేలా ఒక ఫోటోలో పక్కన చేయి ఉంచండి';

  @override
  String get helpTopicVoice => 'మీ వస్తువు గురించి ఏం చెప్పాలి';

  @override
  String get helpTopicVoiceBody =>
      'ఎదురుగా నిలబడిన కస్టమర్‌తో మాట్లాడినట్టే మాట్లాడండి. చెప్పడంలో తప్పు పద్ధతి అంటూ లేదు.';

  @override
  String get helpTopicVoiceStep1 => 'ఇది ఏమిటో చెప్పండి';

  @override
  String get helpTopicVoiceStep2 => 'ఇది దేనితో చేసిందో చెప్పండి';

  @override
  String get helpTopicVoiceStep3 =>
      'ఇది ఎంత పెద్దదో అంగుళాల్లో లేదా అడుగుల్లో చెప్పండి';

  @override
  String get helpTopicVoiceStep4 => 'చేయడానికి ఎంత సమయం పట్టిందో చెప్పండి';

  @override
  String get helpTopicVoiceStep5 => 'దీనికి మీకు ఎంత కావాలో చెప్పండి';

  @override
  String get helpTopicPrice => 'ధర నిర్ణయించడం';

  @override
  String get helpTopicPriceBody =>
      'మీ ధరలో సామగ్రి ఖర్చు, మీ సమయం విలువ రెండూ రావాలి. మీతో కలిసి దాన్ని లెక్కిస్తాం, చెప్పకుండా దానికంటే కిందకు ఎప్పుడూ వెళ్ళనివ్వం.';

  @override
  String get helpTopicPriceStep1 => 'సామగ్రికి ఎంత ఖర్చయిందో లెక్కించండి';

  @override
  String get helpTopicPriceStep2 => 'పనికి ఎన్ని రోజులు పట్టిందో లెక్కించండి';

  @override
  String get helpTopicPriceStep3 =>
      'మేం సూచించేది చూడండి, మీకు బాగా తెలిస్తే మార్చండి';

  @override
  String get helpTopicPriceStep4 =>
      'మీ ఖర్చు కంటే తక్కువైతే చెబుతాం, కానీ నిర్ణయం మీదే';

  @override
  String get helpTopicSold => 'అమ్ముడయ్యాక ఏం జరుగుతుంది';

  @override
  String get helpTopicSoldBody =>
      'కొనుగోలుదారు మార్కెట్‌లో డబ్బు చెల్లిస్తారు. మీరు ప్యాక్ చేసి అప్పగిస్తారు, డబ్బు మీకు వస్తుంది.';

  @override
  String get helpTopicSoldStep1 => 'అమ్ముడవగానే మీకు చెబుతాం';

  @override
  String get helpTopicSoldStep2 => 'ఏం, ఎన్ని ప్యాక్ చేయాలో తెరిచి చూడండి';

  @override
  String get helpTopicSoldStep3 => 'మేం చూపించే తేదీకి ముందు ప్యాక్ చేయండి';

  @override
  String get helpTopicSoldStep4 =>
      'తీసుకెళ్ళడానికి వచ్చే వ్యక్తికి అప్పగించండి';

  @override
  String get helpTopicSoldStep5 => 'ఆ తర్వాత డబ్బు మీకు చేరుతుంది';

  @override
  String get helpVideoComing => 'దీనికోసం ఒక చిన్న వీడియో త్వరలో వస్తోంది.';

  @override
  String get helpPractice => 'మంచి ఫోటో ఎలా తీయాలి';

  @override
  String get helpPracticeBody => 'ఒకే కుండకు ఒక మంచి ఫోటో, ఒక చెడ్డ ఫోటో.';

  @override
  String get helpFaqEntry => 'ప్రజలు అడిగే ప్రశ్నలు';

  @override
  String get helpAboutEntry => 'కారీగర్ గురించి';

  @override
  String get helpSupportEntry => 'ఒక వ్యక్తితో మాట్లాడండి';

  @override
  String get helpTermsEntry => 'నిబంధనలు మరియు గోప్యత';

  @override
  String get faqTitle => 'ప్రజలు అడిగే ప్రశ్నలు';

  @override
  String get faqQ1 => 'దీనికి నాకు ఏమైనా ఖర్చవుతుందా?';

  @override
  String get faqA1 =>
      'లేదు. వస్తువులు పెట్టడం ఉచితం. ఏదైనా అమ్ముడైనప్పుడు మాత్రమే మార్కెట్ చిన్న వాటా తీసుకుంటుంది.';

  @override
  String get faqQ2 => 'నెట్‌వర్క్ లేకపోతే?';

  @override
  String get faqA2 =>
      'అన్నీ పనిచేస్తూనే ఉంటాయి. మీరు చేసినది ఫోన్‌లో ఉంటుంది, నెట్‌వర్క్ రాగానే దానంతట అదే పంపబడుతుంది.';

  @override
  String get faqQ3 => 'నా డబ్బు ఎవరికి వెళ్తుంది?';

  @override
  String get faqA3 =>
      'మీకే. కొనుగోలుదారు మార్కెట్‌లో చెల్లిస్తారు, అది మీ ఖాతాకు వస్తుంది. డబ్బు ఎప్పుడూ మా ద్వారా వెళ్ళదు.';

  @override
  String get faqQ4 => 'అమ్మకానికి పెట్టాక ఏదైనా మార్చవచ్చా?';

  @override
  String get faqA4 =>
      'అవును. మీ వస్తువుల నుంచి తెరవండి, కావలసినది మార్చండి, అది మళ్ళీ అమ్మకానికి వెళ్తుంది.';

  @override
  String get faqQ5 => 'నేను ఏదైనా తప్పు చెబితే?';

  @override
  String get faqA5 =>
      'మీరు విని సరైనదని చెప్పేవరకు ఏదీ అమ్మకానికి వెళ్ళదు. ఏ భాగాన్నైనా మాట్లాడి సరిచేయవచ్చు.';

  @override
  String get faqQ6 => 'నాకు చదవడం, రాయడం రావాలా?';

  @override
  String get faqA6 =>
      'అవసరం లేదు. అన్నీ మాట్లాడి, నొక్కి చేయవచ్చు. ప్రతి స్క్రీన్‌ను మీకు చదివి వినిపించవచ్చు.';

  @override
  String get faqQ7 => 'నా పేరు, ఊరు ఎవరు చూస్తారు?';

  @override
  String get faqA7 =>
      'మీరు అనుమతిస్తేనే, ప్రతి వస్తువుకు విడిగా. ఎప్పుడైనా వెనక్కి తీసుకోవచ్చు.';

  @override
  String get aboutTitle => 'కారీగర్ గురించి';

  @override
  String get aboutWhatTitle => 'ఇది ఏమిటి';

  @override
  String get aboutWhat =>
      'కారీగర్ చేతితో చేసిన వస్తువులను ONDC కి — భారతదేశపు బహిరంగ కొనుగోలు-అమ్మకాల నెట్‌వర్క్‌కి — చేరుస్తుంది, దానికోసం తయారీదారు టైప్ చేయాల్సిన అవసరం లేదు, మాట్లాడితే చాలు. మీ సొంత భాషలో కొన్ని ఫోటోలు, ఒక వాయిస్ నోట్ దేశవ్యాప్తంగా కొనుగోలుదారులు కనుగొనగల జాబితాగా మారుతాయి.';

  @override
  String get aboutWhyTitle => 'మేం దీన్ని ఎందుకు తయారుచేశాం';

  @override
  String get aboutWhy =>
      'భారతదేశంలో దాదాపు డెబ్బై లక్షల కళాకారులు ప్రజలు కొనాలనుకునే వస్తువులు తయారుచేస్తారు, వారిలో చాలామంది తేడా డబ్బును ఉంచుకునే మధ్యవర్తి ద్వారా అమ్ముతారు. అడ్డంకి పనిలో లేదు. ఫారంలో ఉంది: ఆన్‌లైన్ జాబితా ఇంగ్లీష్ టైపింగ్, చాలా ఖాళీలు, క్యాటలాగ్ లాంటి ఫోటో అడుగుతుంది. ఈ యాప్ ఆ ఫారంనే తీసేస్తుంది.';

  @override
  String get aboutHowTitle => 'ఇది ఎలా పనిచేస్తుంది';

  @override
  String get aboutHow =>
      'మూడు ఫోటోలు తీసి ఇది ఏమిటో చెప్పండి. మా వ్యవస్థ వింటుంది, జాబితా రాస్తుంది, మీకు చదివి వినిపిస్తుంది. మీరు విని సరైనదని చెప్పేవరకు ఏదీ బయటికి వెళ్ళదు.';

  @override
  String get aboutSihTitle => 'స్మార్ట్ ఇండియా హ్యాకథాన్ 2025';

  @override
  String get aboutSih =>
      'సమస్య 090 కోసం తయారుచేశాం: కళాకారులు, నేతకారులు ONDC లో కొనుగోలుదారులను చేరుకోవడానికి సహాయం.';

  @override
  String get aboutMissionTitle => 'మేం ఏం చేయాలనుకుంటున్నాం';

  @override
  String get aboutMission => 'ఒక పని ధర దాన్ని చేసిన వ్యక్తి చేతిలోనే ఉండాలి.';

  @override
  String get supportTitle => 'ఒక వ్యక్తితో మాట్లాడండి';

  @override
  String get supportBody =>
      'ఏదైనా పనిచేయకపోతే, లేదా ఏం చేయాలో తెలియకపోతే, మాకు కాల్ చేయండి. ఒక వ్యక్తి మీ భాషలో సమాధానం ఇస్తారు.';

  @override
  String get supportCall => 'మాకు కాల్ చేయండి';

  @override
  String get supportWhatsApp => 'వాట్సాప్‌లో సందేశం పంపండి';

  @override
  String get supportHours =>
      'ప్రతిరోజూ, ఉదయం తొమ్మిది నుంచి సాయంత్రం ఏడు వరకు.';

  @override
  String supportNumber(String number) {
    return 'మా నంబర్ $number';
  }

  @override
  String supportFailed(String number) {
    return 'మీ ఫోన్ దాన్ని తెరవలేకపోయింది. మా నంబర్ $number.';
  }

  @override
  String get termsTitle => 'నిబంధనలు మరియు గోప్యత';

  @override
  String get termsSummaryTitle => 'సంక్షిప్తంగా';

  @override
  String get termsSummary1 =>
      'మీరు చేసినది మీదే. మీ కోసం దాన్ని అమ్మకానికి పెడతాం, అమ్మకం నుంచి ఏమీ తీసుకోం.';

  @override
  String get termsSummary2 =>
      'మీ ఫోటోలు, మీ స్వరం మీ జాబితా రాయడానికి మాత్రమే వాడతాం, మరి దేనికీ కాదు.';

  @override
  String get termsSummary3 =>
      'మీ పేరు, ఊరు, కథ మీరు అనుమతించిన వస్తువులపై మాత్రమే వెళ్తాయి, దాన్ని వెనక్కి తీసుకోవచ్చు.';

  @override
  String get termsSummary4 =>
      'డబ్బు కొనుగోలుదారు నుంచి నేరుగా మీకే వెళ్తుంది. ఎప్పుడూ మా ద్వారా వెళ్ళదు.';

  @override
  String get termsSummary5 => 'ఎప్పుడైనా ఈ ఫోన్ నుంచి అంతా తొలగించవచ్చు.';

  @override
  String get termsFullTitle => 'పూర్తి పాఠం';

  @override
  String get termsFullBody =>
      'వాడకపు పూర్తి నిబంధనలు, గోప్యతా విధానం మా వెబ్‌సైట్‌లో ఉన్నాయి. ఇక్కడ ఏదైనా అర్థం కాకపోతే మాకు కాల్ చేయండి, ఒక వ్యక్తి వివరిస్తారు.';

  @override
  String get termsOpenFull => 'పూర్తి పాఠం చదవండి';

  @override
  String get termsAgreeTitle => 'మొదలుపెట్టే ముందు';

  @override
  String get termsAgreeBody =>
      'మీరు వీటికి అంగీకరిస్తున్నారు. వినడానికి స్పీకర్ నొక్కండి.';

  @override
  String get termsAgreeCheck => 'నేను నిబంధనలకు అంగీకరిస్తున్నాను';

  @override
  String get termsAgreeContinue => 'కొనసాగించండి';

  @override
  String get termsAgreeNeeded =>
      'ముందుగా “నేను నిబంధనలకు అంగీకరిస్తున్నాను” టిక్ చేయండి.';

  @override
  String versionNumber(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get versionCheck => 'కొత్త వెర్షన్ కోసం చూడండి';

  @override
  String get versionLicences => 'లైసెన్సులు';

  @override
  String get versionLicencesWhy => 'ఈ యాప్ ఆధారపడిన ఉచిత సాఫ్ట్‌వేర్.';

  @override
  String get noNetworkTitle => 'నెట్‌వర్క్ లేదు';

  @override
  String get noNetworkBody =>
      'మీరు పని కొనసాగించవచ్చు. అన్నీ మీ ఫోన్‌లో ఉంటాయి, నెట్‌వర్క్ రాగానే దానంతట అదే వెళ్తాయి.';

  @override
  String get noNetworkNeeded =>
      'ఈ ఒక్క పనికి నెట్‌వర్క్ కావాలి. సిగ్నల్ వచ్చాక మళ్ళీ ప్రయత్నించండి.';

  @override
  String get serverErrorTitle => 'మా వైపుకు చేరుకోలేకపోయాం';

  @override
  String get serverErrorBody =>
      'మీరు చేసినదేదీ పోలేదు. కొద్దిసేపటి తర్వాత మళ్ళీ ప్రయత్నించండి.';

  @override
  String get actionTryAgain => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get permissionRecoveryTitle => 'యాప్‌కి మీ అనుమతి కావాలి';

  @override
  String get permissionRecoveryBody =>
      'ఫోన్ వీటిని వాడటానికి యాప్‌ని అనుమతించడం లేదు. ఫోన్ సెట్టింగ్స్‌లో వీటిని ఆన్ చేసి ఇక్కడికి తిరిగి రావచ్చు.';

  @override
  String get permissionCameraWhy =>
      'మీరు చేసినవాటి ఫోటోలు తీయడానికి. ఇది లేకుండా ఏదీ అమ్మకానికి పెట్టలేం.';

  @override
  String get permissionMicWhy =>
      'టైప్ చేయడానికి బదులు మాట్లాడటానికి. ఇది లేకుండా అంతా టైప్ చేయాలి.';

  @override
  String get permissionNotifyTitle => 'నోటిఫికేషన్లు';

  @override
  String get permissionNotifyWhy =>
      'ఏదైనా అమ్ముడైనప్పుడు చెప్పడానికి. ఇది లేకుండా తెలుసుకోవడానికి యాప్ తెరవాలి.';

  @override
  String get permissionBlocked => 'అనుమతి లేదు';

  @override
  String get permissionAsk => 'మళ్ళీ అడగండి';

  @override
  String get permissionRecheck => 'నేను ఆన్ చేశాను';

  @override
  String get permissionAllGood => 'యాప్‌కి కావలసిన అన్నింటికీ అనుమతి ఉంది.';

  @override
  String get updateTitle => 'దయచేసి యాప్‌ను అప్‌డేట్ చేయండి';

  @override
  String get updateBody =>
      'ఈ వెర్షన్ ఇక మాతో మాట్లాడలేదు. స్టోర్‌లో కొత్త వెర్షన్ ఉంది, అప్‌డేట్ చేశాక కూడా మీ ఫోన్‌లోని అంతా అలాగే ఉంటుంది.';

  @override
  String get updateAction => 'కొత్త వెర్షన్ పొందండి';

  @override
  String get updateFailed => 'స్టోర్ తెరుచుకోలేదు. అక్కడ కారీగర్ కోసం వెతకండి.';

  @override
  String get emptyNudge =>
      'హోమ్‌లోని పెద్ద బటన్ నొక్కి మీ మొదటి వస్తువును జోడించండి.';

  @override
  String get productsInProgress => 'సిద్ధమవుతోంది';

  @override
  String get productsListed => 'అమ్మకంలో';

  @override
  String get productsSold => 'అమ్ముడైంది';

  @override
  String get voiceTypeInstead => 'రాసి చెప్పండి';

  @override
  String get voiceSpeakInstead => 'మాట్లాడి చెప్పండి';

  @override
  String get voiceTypeTitle => 'ఇప్పుడు ఇది ఏమిటో రాయండి';

  @override
  String get voiceTypeHint => 'ఇక్కడ రాయండి…';

  @override
  String get voiceTypeSave => 'ఈ వివరణనే ఉంచండి';

  @override
  String get devSimulateResult => 'Dev: show a finished product';

  @override
  String get errorNotAllowed =>
      'ఈ ఖాతాతో ఇది చేయలేరు. సహాయం కోసం మాకు ఫోన్ చేయండి.';

  @override
  String get errorNotFound => 'ఇది ఇప్పుడు ఇక్కడ లేదు.';

  @override
  String get errorConflict =>
      'ఇది వేరే చోట మార్చబడింది. దయచేసి మళ్ళీ తెరిచి ఇంకోసారి ప్రయత్నించండి.';

  @override
  String get errorInvalid =>
      'కొన్ని వివరాలు అంగీకరించబడలేదు. దయచేసి సరిచూసి మళ్ళీ ప్రయత్నించండి.';
}
