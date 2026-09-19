import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appTitle => 'କୀର୍ତ୍ତିକର';

  @override
  String get actionNext => 'ଆଗକୁ';

  @override
  String get actionBack => 'ପଛକୁ';

  @override
  String get actionSkip => 'ଛାଡନ୍ତୁ';

  @override
  String get actionDone => 'ହୋଇଗଲା';

  @override
  String get actionListen => 'ଶୁଣନ୍ତୁ';

  @override
  String get actionStopListening => 'ବନ୍ଦ କରନ୍ତୁ';

  @override
  String stepOfSteps(int current, int total) {
    return 'ପାହାଚ $current, ମୋଟ $total';
  }

  @override
  String get splashTagline => 'କୁହନ୍ତୁ, ଆଉ ଆପଣଙ୍କ ଜିନିଷ ବିକ୍ରି ହୋଇଯିବ';

  @override
  String get languageTitle => 'ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ';

  @override
  String get languageHint => 'ଆପଣ କହୁଥିବା ଭାଷାକୁ ଦବାନ୍ତୁ';

  @override
  String get welcomeCard1Title => 'ତିନୋଟି ଫଟୋ ଉଠାନ୍ତୁ';

  @override
  String get welcomeCard1Body =>
      'ଆପଣ ତିଆରି କରିଥିବା ଜିନିଷର ତିନୋଟି ଫଟୋ ଉଠାନ୍ତୁ। କିପରି ଉଠାଇବେ ଆପ୍ ଦେଖାଇଦେବ।';

  @override
  String get welcomeCard2Title => 'କହି ଦିଅନ୍ତୁ';

  @override
  String get welcomeCard2Body =>
      'ଏହା କ\'ଣ, କେଉଁଥିରେ ତିଆରି, ଦାମ କେତେ — କେବଳ କହିଦିଅନ୍ତୁ। ଲେଖିବା ଦରକାର ନାହିଁ।';

  @override
  String get welcomeCard3Title => 'ଏହା ବିକ୍ରିକୁ ଯାଏ';

  @override
  String get welcomeCard3Body =>
      'ପ୍ରଥମେ ଆପଣଙ୍କୁ ପଢି ଶୁଣାଯିବ। ଆପଣ ହଁ କହିଲେ ହିଁ ଏହା ଅନଲାଇନ୍ ଯିବ।';

  @override
  String get welcomeStart => 'ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get permissionsTitle => 'ଆପ୍‌କୁ ତିନୋଟି ଜିନିଷର ଅନୁମତି ଦରକାର';

  @override
  String get permissionCameraTitle => 'କ୍ୟାମେରା';

  @override
  String get permissionCameraBody =>
      'ଆପଣଙ୍କ ଜିନିଷର ଫଟୋ ଉଠାଇବା ପାଇଁ। ଆପଣ ହଁ ନ କହିବା ପର୍ଯ୍ୟନ୍ତ ଫଟୋ ଆପଣଙ୍କ ଫୋନରେ ହିଁ ରହେ।';

  @override
  String get permissionMicTitle => 'ମାଇକ୍';

  @override
  String get permissionMicBody => 'ଯେପରି ଲେଖିବା ବଦଳରେ କହିପାରିବେ।';

  @override
  String get permissionNotificationTitle => 'ସୂଚନା';

  @override
  String get permissionNotificationBody =>
      'କିଛି ବିକ୍ରି ହେବା ମାତ୍ରେ ଆପଣଙ୍କୁ ଜଣାଇପାରିବା ପାଇଁ।';

  @override
  String get permissionAllow => 'ଅନୁମତି ଦିଅନ୍ତୁ';

  @override
  String get permissionNotNow => 'ଏବେ ନୁହେଁ';

  @override
  String get permissionGranted => 'ଅନୁମତି ଅଛି';

  @override
  String get permissionDeniedTitle => 'ଅନୁମତି ମିଳିଲା ନାହିଁ';

  @override
  String get permissionDeniedBody =>
      'ଏହା ବିନା ଏହା କାମ କରିବ ନାହିଁ। ଫୋନର ସେଟିଂସରେ ଯାଇ ଅନୁମତି ଦିଅନ୍ତୁ।';

  @override
  String get permissionOpenSettings => 'ସେଟିଂସ ଖୋଲନ୍ତୁ';

  @override
  String get phoneTitle => 'ଆପଣଙ୍କ ଫୋନ ନମ୍ବର';

  @override
  String get phoneWhy =>
      'ଆମେ ଏହି ନମ୍ବରକୁ ଗୋଟିଏ କୋଡ୍ ପଠାଇବୁ। ଏହି ନମ୍ବର ଆଉ କାହାକୁ ଦିଆଯାଏ ନାହିଁ।';

  @override
  String get phoneInvalid => 'ଦଶ ଅଙ୍କର ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String phoneUnknown(String number) {
    return 'ଏହି ଡେମୋରେ ଏହି ନମ୍ବର ଚାଲିବ ନାହିଁ। $number ବ୍ୟବହାର କରନ୍ତୁ।';
  }

  @override
  String get phoneSendCode => 'କୋଡ୍ ପଠାନ୍ତୁ';

  @override
  String get otpTitle => 'ଆସିଥିବା କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String otpSentTo(String number) {
    return '$number କୁ ପଠାଗଲା';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds ସେକେଣ୍ଡ ପରେ ପୁଣି ପଠାନ୍ତୁ';
  }

  @override
  String get otpResend => 'କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ';

  @override
  String get otpCallMe => 'ମୋତେ ଫୋନ କରି କୁହନ୍ତୁ';

  @override
  String get otpCalling => 'କିଛି ସମୟରେ ଫୋନ ଆସିବ ଏବଂ କୋଡ୍ ପଢି ଶୁଣାଯିବ।';

  @override
  String get otpWrong => 'କୋଡ୍ ଠିକ୍ ନାହିଁ। ପୁଣି ଦିଅନ୍ତୁ।';

  @override
  String get phoneSendFailed =>
      'କୋଡ୍ ପଠାଯାଇପାରିଲା ନାହିଁ। ନେଟୱର୍କ ଦେଖି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get otpExpired => 'କୋଡ୍‌ର ସମୟ ସରିଗଲା। ପୁଣି ପଠାନ୍ତୁ।';

  @override
  String get authTooManyTries =>
      'ଅନେକ ଥର ଚେଷ୍ଟା ହୋଇଛି। କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get otpChangeNumber => 'ନମ୍ବର ବଦଳାନ୍ତୁ';

  @override
  String get otpAutoRead => 'ମେସେଜ୍ ନିଜେ ପଢାହୋଇଗଲା';

  @override
  String get profileTitle => 'ଆପଣଙ୍କ ବିଷୟରେ କୁହନ୍ତୁ';

  @override
  String get profileNameLabel => 'ଆପଣଙ୍କ ନାମ';

  @override
  String get profileNameHint => 'କୁହନ୍ତୁ କିମ୍ବା ଲେଖନ୍ତୁ';

  @override
  String get profileNameMissing => 'ଆପଣଙ୍କ ନାମ କୁହନ୍ତୁ';

  @override
  String get profileCraftLabel => 'ଆପଣ କ\'ଣ ତିଆରି କରନ୍ତି';

  @override
  String get profileCraftMissing => 'ଗୋଟିଏ ବାଛନ୍ତୁ';

  @override
  String get profileSpeakToFill => 'କୁହନ୍ତୁ';

  @override
  String get profileListening => 'ଶୁଣୁଛୁ…';

  @override
  String get dictationUnavailable =>
      'ଏହି ଫୋନରେ କହି ଲେଖିବା ଚାଲୁନାହିଁ। ଦୟାକରି ଲେଖନ୍ତୁ।';

  @override
  String get dictationNothingHeard =>
      'କିଛି ଶୁଣାଗଲା ନାହିଁ। ମାଇକ୍ ଦବାଇ ପୁଣି କୁହନ୍ତୁ।';

  @override
  String get craftWeaving => 'ବୁଣାକାମ';

  @override
  String get craftPottery => 'ମାଟିକାମ';

  @override
  String get craftWoodwork => 'କାଠକାମ';

  @override
  String get craftMetalwork => 'ଧାତୁକାମ';

  @override
  String get craftJewellery => 'ଗହଣା';

  @override
  String get craftEmbroidery => 'ସୂଚିକାମ';

  @override
  String get craftPainting => 'ଚିତ୍ରକଳା';

  @override
  String get craftLeather => 'ଚମଡାକାମ';

  @override
  String get craftBamboo => 'ବାଉଁଶ ଓ ବେତ';

  @override
  String get craftOther => 'ଅନ୍ୟ କିଛି';

  @override
  String get ondcTitle => 'ଆପଣଙ୍କ ONDC ଆକାଉଣ୍ଟ ଯୋଡନ୍ତୁ';

  @override
  String get ondcExplain =>
      'ONDC ରେ କ୍ରେତାମାନେ ଆପଣଙ୍କ ଜିନିଷ ଦେଖନ୍ତି ଓ କିଣନ୍ତି। ଟଙ୍କା ସିଧା ଆପଣଙ୍କ ପାଖକୁ ଯାଏ, ଆମ ଦେଇ ନୁହେଁ।';

  @override
  String get ondcMalformed =>
      'ଏହା ସେଲର ଆଇଡି ପରି ଲାଗୁନାହିଁ। ଦୟାକରି ଯାଞ୍ଚ କରନ୍ତୁ, କିମ୍ବା କୋଡ୍ ପୁଣି ସ୍କାନ କରନ୍ତୁ।';

  @override
  String get ondcEmailLabel => 'ONDC ଇମେଲ୍';

  @override
  String get ondcEmailMalformed =>
      'ଏହା ଇମେଲ୍ ଠିକଣା ଭଳି ଲାଗୁନାହିଁ। ଦୟାକରି ଏହାକୁ ଯାଞ୍ଚ କରନ୍ତୁ।';

  @override
  String get ondcSellerIdLabel => 'ବିକ୍ରେତା ଆଇଡି';

  @override
  String get ondcScan => 'QR କୋଡ୍ ସ୍କାନ୍ କରନ୍ତୁ';

  @override
  String get ondcLink => 'ଆକାଉଣ୍ଟ ଯୋଡନ୍ତୁ';

  @override
  String get ondcLinking => 'ଯୋଡୁଛୁ…';

  @override
  String get ondcFailed => 'ଏହି ଆକାଉଣ୍ଟ ମିଳିଲା ନାହିଁ। ପୁଣି ଦେଖନ୍ତୁ।';

  @override
  String get ondcNoAccount => 'ମୋର ଏପର୍ଯ୍ୟନ୍ତ ଆକାଉଣ୍ଟ ନାହିଁ';

  @override
  String get ondcNoAccountExplain =>
      'କିଛି ଅସୁବିଧା ନାହିଁ। ଆପଣ ଜିନିଷ ପ୍ରସ୍ତୁତ କରି ରଖିପାରିବେ। ଆକାଉଣ୍ଟ ଯୋଡାହେବା ମାତ୍ରେ ସବୁ ଏକାଥରେ ଚାଲିଯିବ।';

  @override
  String get practiceTitle => 'ଭଲ ଫଟୋ କିପରି ଉଠାଇବେ';

  @override
  String get practiceIntro =>
      'ସେହି ଗୋଟିଏ ହାଣ୍ଡି, ଥରେ ଭଲରେ ଓ ଥରେ ଖରାପରେ ଉଠାଯାଇଛି। ଦୁଇଟି ଦେଖିବାକୁ ଘୁଞ୍ଚାନ୍ତୁ।';

  @override
  String get practiceGoodBadge => 'ଏପରି କରନ୍ତୁ';

  @override
  String get practiceGoodTitle => 'ଭଲ ଫଟୋ';

  @override
  String get practiceGoodTip1 => 'ସ୍ପଷ୍ଟ: ଫୋନ୍ ସ୍ଥିର ରଖାଯାଇଥିଲା';

  @override
  String get practiceGoodTip2 => 'ଆଲୁଅ: ଝରକା ବା କବାଟ ପାଖରେ ଉଠାଯାଇଛି';

  @override
  String get practiceGoodTip3 => 'ପୁରା ଜିନିଷଟି ଫଟୋରେ ଅଛି';

  @override
  String get practiceBadBadge => 'ଏପରି କରନ୍ତୁ ନାହିଁ';

  @override
  String get practiceBadTitle => 'ଖରାପ ଫଟୋ';

  @override
  String get practiceBadTip1 => 'ଅସ୍ପଷ୍ଟ: ଫୋନ୍ ହଲିଗଲା';

  @override
  String get practiceBadTip2 => 'କ୍ରେତା ସୂକ୍ଷ୍ମ ବିବରଣୀ ଦେଖିପାରନ୍ତି ନାହିଁ';

  @override
  String get practiceBadTip3 => 'ଆପ୍ ଆପଣଙ୍କୁ ପୁଣି ଫଟୋ ଉଠାଇବାକୁ କହିବ';

  @override
  String get practiceFinish => 'ଆପ୍ ଖୋଲନ୍ତୁ';

  @override
  String get navHome => 'ହୋମ୍';

  @override
  String get navListings => 'ଜିନିଷ';

  @override
  String get navProfile => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String homeGreeting(String name) {
    return 'ନମସ୍କାର, $name';
  }

  @override
  String get homeAddProduct => 'ଜିନିଷ ଯୋଡନ୍ତୁ';

  @override
  String get homeAddProductSpoken =>
      'ଜିନିଷ ଯୋଡିବାକୁ ଏହି ବଡ ବଟନ୍ ଦବାନ୍ତୁ। ତିନୋଟି ଫଟୋ ଉଠାନ୍ତୁ, କୁହନ୍ତୁ ଏହା କ\'ଣ, ଆଉ ଏହା ବିକ୍ରିକୁ ଯିବ।';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଜିନିଷ ପଠାଇବା ବାକି',
      one: '1ଟି ଜିନିଷ ପଠାଇବା ବାକି',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ବିକ୍ରି ହେଲା',
      one: '1ଟି ବିକ୍ରି ହେଲା',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'ଆପଣଙ୍କ ନୂଆ ଜିନିଷ';

  @override
  String get homeNextTitle => 'ଏବେ ଏହା କରିବାକୁ ଅଛି';

  @override
  String get homeEmptyTitle => 'ଏଠାରେ ଏପର୍ଯ୍ୟନ୍ତ କିଛି ନାହିଁ';

  @override
  String get homeEmptyBody => 'ଉପରର ବଡ ବଟନ୍ ଦବାଇ ଆପଣଙ୍କ ପ୍ରଥମ ଜିନିଷ ଯୋଡନ୍ତୁ।';

  @override
  String get offlineNoNetwork => 'ଏବେ ନେଟୱର୍କ ନାହିଁ';

  @override
  String get offlineNothingLost => 'କିଛି ହଜିନାହିଁ। ନେଟୱର୍କ ଆସିଲେ ନିଜେ ଚାଲିଯିବ।';

  @override
  String get statusQueued => 'ପଠାଇବା ବାକି';

  @override
  String get statusProcessing => 'ପ୍ରସ୍ତୁତ ହେଉଛି';

  @override
  String get statusNeedsAttention => 'ଆପଣଙ୍କ ଉତ୍ତର ଦରକାର';

  @override
  String get statusReady => 'ବିକ୍ରି ପାଇଁ ପ୍ରସ୍ତୁତ';

  @override
  String get statusPublished => 'ବିକ୍ରିରେ ଅଛି';

  @override
  String get statusFailed => 'ପଠାଯାଇପାରିଲା ନାହିଁ';

  @override
  String get listingUntitled => 'ଜିନିଷ';

  @override
  String get listingNoPrice => 'ଦାମ କୁହାଯାଇନାହିଁ';

  @override
  String get captureTitle => 'ଜିନିଷ ଯୋଡନ୍ତୁ';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ଫଟୋ $current / $total';
  }

  @override
  String get capturePhotoWhole => 'ପୂରା ଜିନିଷଟି ଦେଖାନ୍ତୁ';

  @override
  String get capturePhotoDetail => 'ପାଖରୁ ଗୋଟିଏ ଫଟୋ ଉଠାନ୍ତୁ';

  @override
  String get capturePhotoScale => 'ପାଖରେ ହାତ ରଖନ୍ତୁ, ଯେପରି ଆକାର ଜଣାପଡେ';

  @override
  String get captureTakePhoto => 'ଫଟୋ ଉଠାନ୍ତୁ';

  @override
  String get captureFromGallery => 'ଗ୍ୟାଲେରୀରୁ ବାଛନ୍ତୁ';

  @override
  String get captureTorchOn => 'ଆଲୁଅ ଜାଳନ୍ତୁ';

  @override
  String get captureTorchOff => 'ଆଲୁଅ ଲିଭାନ୍ତୁ';

  @override
  String get captureCameraFailed => 'କ୍ୟାମେରା ଖୋଲିଲା ନାହିଁ';

  @override
  String get captureCameraRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get captureCameraPermission =>
      'ଆପଣଙ୍କ ଜିନିଷର ଫଟୋ ଉଠାଇବାକୁ ଆପ୍‌କୁ କ୍ୟାମେରା ଦରକାର।';

  @override
  String get captureOpenSettings => 'ସେଟିଂସ ଖୋଲନ୍ତୁ';

  @override
  String get captureLeaveTitle => 'ସେଭ୍ ନ କରି ବାହାରିଯିବେ?';

  @override
  String get captureLeaveBody => 'ଫଟୋ ଏବଂ ଆପଣ ଯାହା କହିଥିଲେ ସବୁ ଲିଭିଯିବ।';

  @override
  String get captureLeaveConfirm => 'ଲିଭାଇଦିଅନ୍ତୁ';

  @override
  String get captureLeaveCancel => 'ଏଠାରେ ରୁହନ୍ତୁ';

  @override
  String get shotReviewChecking => 'ଫଟୋ ଯାଞ୍ଚ ହେଉଛି…';

  @override
  String get shotReviewRetake => 'ପୁଣି ଉଠାନ୍ତୁ';

  @override
  String get qualityTooDark =>
      'ଏହି ଫଟୋ ବହୁତ ଅନ୍ଧାର। କବାଟ ପାଖରେ ଠିଆ ହୋଇ ଉଠାନ୍ତୁ।';

  @override
  String get qualityTooBright => 'ଏଥିରେ ବହୁତ ଆଲୁଅ। ଖରା ଆଡକୁ ପିଠି କରି ଉଠାନ୍ତୁ।';

  @override
  String get qualityBlurry =>
      'ଏହି ଫଟୋ ସ୍ପଷ୍ଟ ନୁହେଁ। ଫୋନ ସ୍ଥିର ରଖି ପୁଣି ଉଠାନ୍ତୁ।';

  @override
  String get qualityUnreadable =>
      'ଏହି ଫଟୋ ଠିକ୍ ସେଭ୍ ହେଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଉଠାନ୍ତୁ।';

  @override
  String get qualityNoSubject =>
      'ଏହି ଫଟୋରେ ଜିନିଷ ଦେଖାଯାଉନାହିଁ। ତାକୁ ଗାରର ଭିତରେ ରଖି ପାଖକୁ ଆସନ୍ତୁ।';

  @override
  String get qualityOutOfFrame =>
      'ଏହି ଫଟୋରେ ଜିନିଷର କେବଳ ଗୋଟିଏ ଅଂଶ ଅଛି। ପୂରା ଜିନିଷ ଗାରର ଭିତରେ ରଖନ୍ତୁ।';

  @override
  String get qualityWarningTitle => 'ଏହାକୁ ପୁଣି ଉଠାନ୍ତୁ';

  @override
  String get qualityKeepAnyway => 'ତଥାପି ରଖନ୍ତୁ';

  @override
  String get photoSetTitle => 'ଆପଣଙ୍କ ତିନୋଟି ଫଟୋ';

  @override
  String get photoSetBody =>
      'ପ୍ରଥମ ଫଟୋକୁ କ୍ରେତା ସବୁଠୁ ଆଗରୁ ଦେଖନ୍ତି। ଫଟୋ ପୁଣି ଉଠାଇବାକୁ ତାକୁ ଦବାନ୍ତୁ।';

  @override
  String get photoSetMain => 'ପ୍ରଥମ ଫଟୋ';

  @override
  String get photoSetRetakeThis => 'ଏହାକୁ ପୁଣି ଉଠାନ୍ତୁ';

  @override
  String get photoSetConfirm => 'ଏହି ଫଟୋଗୁଡିକ ଠିକ୍ ଅଛି';

  @override
  String get photoEditOpen => 'ଫଟୋ କାଟନ୍ତୁ କିମ୍ବା ବୁଲାନ୍ତୁ';

  @override
  String get photoEditTitle => 'ଫଟୋ କାଟନ୍ତୁ';

  @override
  String get photoEditBody =>
      'କାଟିବାକୁ ବାକ୍ସର କୋଣ କିମ୍ବା ଧାର ଟାଣନ୍ତୁ। ଘୁଞ୍ଚାଇବାକୁ ବାକ୍ସ ଭିତରୁ ଟାଣନ୍ତୁ।';

  @override
  String get photoEditTurn => 'ବୁଲାନ୍ତୁ';

  @override
  String get photoEditStraighten => 'ସିଧା କରନ୍ତୁ';

  @override
  String get photoEditReset => 'ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get photoEditDone => 'ଏହି ଫଟୋ ବ୍ୟବହାର କରନ୍ତୁ';

  @override
  String get photoEditCancel => 'ପଛକୁ ଯାଆନ୍ତୁ';

  @override
  String get photoEditFailed =>
      'ଏହି ପରିବର୍ତ୍ତନ ସେଭ୍ ହେଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get photoIssueTooDark => 'ବହୁତ ଅନ୍ଧାର, ସ୍ପଷ୍ଟ ଦେଖାଯାଉନାହିଁ';

  @override
  String get photoIssueTooBright => 'ଏଥିରେ ବହୁତ ଆଲୁଅ';

  @override
  String get photoIssueBlurry => 'ଝାପସା, ଯଥେଷ୍ଟ ସ୍ପଷ୍ଟ ନୁହେଁ';

  @override
  String get photoIssueNoSubject => 'ଏହି ଫଟୋରେ କୌଣସି ଜିନିଷ ଦେଖାଯାଉନାହିଁ';

  @override
  String get photoIssueUnreadable => 'ଏହି ଫଟୋ ସେଭ୍ ହେଲା ନାହିଁ';

  @override
  String get photoIssueOutOfFrame => 'ଜିନିଷ ପୂରା ଫଟୋରେ ନାହିଁ';

  @override
  String get voiceTitle => 'ଏବେ କୁହନ୍ତୁ ଏହା କ\'ଣ';

  @override
  String get voiceBody =>
      'ଏହା କ\'ଣ, କେଉଁଥିରେ ତିଆରି, କେତେ ବଡ, ତିଆରି କରିବାକୁ କେତେ ସମୟ ଲାଗିଲା, ଏବଂ ଦାମ କେତେ।';

  @override
  String get voiceHoldToSpeak => 'ଦବାଇ ଧରି କୁହନ୍ତୁ';

  @override
  String get voiceRecording => 'କୁହନ୍ତୁ… ସରିଲେ ଛାଡିଦିଅନ୍ତୁ';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total ରୁ $seconds ସେକେଣ୍ଡ';
  }

  @override
  String get voiceTooShort => 'ଏହା ବହୁତ ଛୋଟ ଥିଲା। ବଟନ୍ ଦବାଇ ଧରି ପୁଣି କୁହନ୍ତୁ।';

  @override
  String get voiceFailed =>
      'ମାଇକ୍ ଆରମ୍ଭ ହେଲା ନାହିଁ। ଆପ୍‌କୁ ମାଇକ୍ ଅନୁମତି ଅଛି କି ଦେଖନ୍ତୁ।';

  @override
  String get voiceBackToPhotos => 'ଫଟୋକୁ ଫେରନ୍ତୁ';

  @override
  String get playbackPlay => 'ଶୁଣନ୍ତୁ';

  @override
  String get playbackStop => 'ବନ୍ଦ କରନ୍ତୁ';

  @override
  String get playbackAgain => 'ପୁଣି କୁହନ୍ତୁ';

  @override
  String get playbackAccept => 'ଏହା ଠିକ୍';

  @override
  String get playbackUnavailable =>
      'ଏହି ଫୋନ ଏହାକୁ ଶୁଣାଇପାରୁନାହିଁ। ଆପଣ ତଥାପି ପଠାଇପାରିବେ, କିମ୍ବା ପୁଣି କହିପାରିବେ।';

  @override
  String get savedTitle => 'ସେଭ୍ ହେଲା';

  @override
  String get savedBody => 'ନେଟୱର୍କ ଆସିଲେ ନିଜେ ଚାଲିଯିବ।';

  @override
  String get savedBodyOnline =>
      'ଏବେ ପଠାଯାଉଛି। ଆପଣଙ୍କୁ ଏଠାରେ ଅପେକ୍ଷା କରିବାକୁ ପଡିବ ନାହିଁ।';

  @override
  String get savedAddAnother => 'ଆଉ ଗୋଟିଏ ଜିନିଷ ଯୋଡନ୍ତୁ';

  @override
  String get savedGoHome => 'ହୋମ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get saveFailed => 'ଏହି ଫୋନରେ ସେଭ୍ କରିହେଲା ନାହିଁ। ହୁଏତ ଜାଗା ନାହିଁ।';

  @override
  String get saveRetry => 'ପୁଣି ସେଭ୍ କରିବାକୁ ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get queueTitle => 'ପଠାଇବା ବାକି';

  @override
  String get queueBody =>
      'ଏଠାରେ କିଛି ହଜିନାହିଁ। ନେଟୱର୍କ ଆସିବା ମାତ୍ରେ ପ୍ରତ୍ୟେକ ଚାଲିଯିବ।';

  @override
  String get queueEmptyTitle => 'କିଛି ବାକି ନାହିଁ';

  @override
  String get queueEmptyBody => 'ଆପଣ ତିଆରି କରିଥିବା ସବୁ ପଠାହୋଇସାରିଛି।';

  @override
  String get queueStateWaiting => 'ନେଟୱର୍କ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String queueStateUploading(int percent) {
    return 'ପଠାଯାଉଛି… ଶହେରୁ $percent';
  }

  @override
  String get queueStateProcessing => 'ଏବେ ଆମ ପାଖରେ। ଆମେ ଲେଖୁଛୁ।';

  @override
  String get queueStateFailed => 'ଗଲା ନାହିଁ। କାରଣ ଦେଖିବାକୁ ଦବାନ୍ତୁ।';

  @override
  String get queueItemTitle => 'ଏହି ଜିନିଷ';

  @override
  String queueMadeAt(String date) {
    return '$date ରେ ତିଆରି';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ଥର ଚେଷ୍ଟା ହେଲା',
      one: 'ଥରେ ଚେଷ୍ଟା ହେଲା',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'ଏବେ ପଠାଇବାକୁ ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get queueRetryWaiting => 'ଏପର୍ଯ୍ୟନ୍ତ ନେଟୱର୍କ ନାହିଁ। ନିଜେ ଚାଲିଯିବ।';

  @override
  String get queueDelete => 'ଏହି ଜିନିଷ ଲିଭାନ୍ତୁ';

  @override
  String get queueDeleteTitle => 'ଏହି ଜିନିଷ ଲିଭାଇବେ?';

  @override
  String get queueDeleteBody =>
      'ଫଟୋ ଏବଂ ଆପଣ ଯାହା କହିଥିଲେ ଚାଲିଯିବ। ଏହା ଫେରିବ ନାହିଁ।';

  @override
  String get queueDeleteConfirm => 'ହଁ, ଲିଭାନ୍ତୁ';

  @override
  String get queueDeleteCancel => 'ନା, ରହୁ';

  @override
  String get failureNetwork =>
      'ନେଟୱର୍କ ମଝିରେ ବନ୍ଦ ହୋଇଗଲା। ସିଗନାଲ ଆସିଲେ ନିଜେ ପୁଣି ଯିବ।';

  @override
  String get failureServer => 'ଆମ ପଟରୁ ଉତ୍ତର ଆସିଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରାଯିବ।';

  @override
  String get failureMissingFiles =>
      'ଫଟୋ ଆଉ ଏହି ଫୋନରେ ନାହିଁ, ତେଣୁ ଏହା ପଠାଯାଇପାରିବ ନାହିଁ। ଦୟାକରି ପୁଣି ତିଆରି କରନ୍ତୁ।';

  @override
  String get failureRejected =>
      'ଏହା ଗ୍ରହଣ ହେଲା ନାହିଁ। ଦୟାକରି ପୁଣି ତିଆରି କରନ୍ତୁ।';

  @override
  String get failureUnknown => 'କିଛି ଭୁଲ ହେଲା। ଆପଣ ପୁଣି ଚେଷ୍ଟା କରିପାରିବେ।';

  @override
  String get processingTitle => 'ଆମେ ଲେଖୁଛୁ';

  @override
  String get processingBody =>
      'ଆପଣଙ୍କ ଫଟୋ ଓ କଥା ଆମ ପାଖରେ ଅଛି। ଏଥିରେ କିଛି ମିନିଟ ଲାଗେ।';

  @override
  String get processingLeave =>
      'ଆପଣଙ୍କୁ ଏଠାରେ ଅପେକ୍ଷା କରିବାକୁ ପଡିବ ନାହିଁ। ପ୍ରସ୍ତୁତ ହେଲେ ଆମେ ଜଣାଇବୁ।';

  @override
  String get processingGoHome => 'ହୋମ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get attentionTitle => 'ଗୋଟିଏ ପ୍ରଶ୍ନ';

  @override
  String get attentionBody => 'ବାକି ସବୁ ଆମେ ବୁଝିଲୁ। କେବଳ ଏହା ବାକି।';

  @override
  String get attentionHoldToAnswer => 'ଦବାଇ ଧରି ଉତ୍ତର ଦିଅନ୍ତୁ';

  @override
  String get attentionAnswering => 'ଆପଣଙ୍କ ଉତ୍ତର ପଠାଯାଉଛି…';

  @override
  String get attentionFailed => 'ଆପଣଙ୍କ ଉତ୍ତର ଗଲା ନାହିଁ। ଦୟାକରି ପୁଣି କୁହନ୍ତୁ।';

  @override
  String get attentionRetakePhotos => 'ଫଟୋଗୁଡିକ ପୁଣି ଉଠାନ୍ତୁ';

  @override
  String get attentionRetakeSending => 'ଆପଣଙ୍କ ନୂଆ ଫଟୋ ପଠାଯାଉଛି…';

  @override
  String get attentionRetakeFailed =>
      'ନୂଆ ଫଟୋ ଗଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get readBackTitle => 'ଆମେ ଏହା ବୁଝିଲୁ';

  @override
  String get readBackListen => 'ପୂରା ଶୁଣନ୍ତୁ';

  @override
  String get readBackFields => 'ଆମେ ଯାହା ଲେଖିଲୁ';

  @override
  String get readBackCorrect => 'ଯାହା ଭୁଲ ତାକୁ ଦବାନ୍ତୁ';

  @override
  String get readBackApprove => 'ଏସବୁ ଠିକ୍';

  @override
  String get notSaid => 'କୁହାଯାଇନାହିଁ';

  @override
  String get fieldMaterial => 'କେଉଁଥିରେ ତିଆରି';

  @override
  String get fieldSize => 'ଆକାର';

  @override
  String get fieldColour => 'ରଙ୍ଗ';

  @override
  String get fieldTechnique => 'କିପରି ତିଆରି';

  @override
  String get fieldOrigin => 'କେଉଁଠି ତିଆରି';

  @override
  String get fieldQuantity => 'କେତୋଟି';

  @override
  String get fieldPrice => 'ଦାମ';

  @override
  String correctTitle(String field) {
    return 'ଠିକ୍ $field କୁହନ୍ତୁ';
  }

  @override
  String get correctHoldToSpeak => 'ଦବାଇ ଧରି କୁହନ୍ତୁ';

  @override
  String get correctListening => 'ଶୁଣୁଛୁ…';

  @override
  String get correctFailedOnce => 'ଆମେ ବୁଝିପାରିଲୁ ନାହିଁ। ଆଉ ଥରେ କୁହନ୍ତୁ।';

  @override
  String get correctUseKeypad => 'ବଦଳରେ ଲେଖନ୍ତୁ';

  @override
  String get correctUseVoice => 'ବଦଳରେ କୁହନ୍ତୁ';

  @override
  String get correctPick => 'କିମ୍ବା ଗୋଟିଏ ବାଛନ୍ତୁ';

  @override
  String get correctSave => 'ଏହା ସେଭ୍ କରନ୍ତୁ';

  @override
  String get correctCancel => 'ଯେମିତି ଅଛି ରହୁ';

  @override
  String get correctTypeHint => 'ଉତ୍ତର ଏଠାରେ ଲେଖନ୍ତୁ';

  @override
  String correctHeard(Object text) {
    return 'ଆମେ ଶୁଣିଲୁ “$text”';
  }

  @override
  String get listingCancelAction => 'ଏହି ତାଲିକା ବାତିଲ କରନ୍ତୁ';

  @override
  String get listingCancelTitle => 'ଏହି ତାଲିକା ବାତିଲ କରିବେ?';

  @override
  String get listingCancelBody =>
      'ଫଟୋ, ରେକର୍ଡିଂ ଏବଂ ଆପଣ କହିଥିବା ସବୁ ମୁଛିଯିବ। ଏହା ଫେରିବ ନାହିଁ।';

  @override
  String get listingCancelConfirm => 'ହଁ, ବାତିଲ କରନ୍ତୁ';

  @override
  String get listingCancelKeep => 'ନା, ରହିବାକୁ ଦିଅନ୍ତୁ';

  @override
  String get photoSaveAction => 'ଫଟୋ ସଞ୍ଚୟ କରନ୍ତୁ';

  @override
  String get photoSaved => 'ଆପଣଙ୍କ ଫଟୋରେ ସଞ୍ଚିତ ହେଲା';

  @override
  String get photoSaveFailed => 'ଫଟୋ ସଞ୍ଚୟ କରାଗଲା ନାହିଁ';

  @override
  String get photoSaveDenied => 'ଫଟୋ ସଞ୍ଚୟ କରିବାକୁ ଅନୁମତି ଦିଅନ୍ତୁ';

  @override
  String get colourRed => 'ଲାଲ';

  @override
  String get colourBlue => 'ନୀଳ';

  @override
  String get colourGreen => 'ସବୁଜ';

  @override
  String get colourYellow => 'ହଳଦିଆ';

  @override
  String get colourBlack => 'କଳା';

  @override
  String get colourWhite => 'ଧଳା';

  @override
  String get colourBrown => 'ବାଦାମୀ';

  @override
  String get colourMulti => 'ଅନେକ ରଙ୍ଗ';

  @override
  String get sizeSmall => 'ଛୋଟ';

  @override
  String get sizeMedium => 'ମଧ୍ୟମ';

  @override
  String get sizeLarge => 'ବଡ';

  @override
  String get sizeExtraLarge => 'ବହୁତ ବଡ';

  @override
  String get suggestTitle => 'ଏହା ବି ଯୋଡିବା କି?';

  @override
  String get suggestYes => 'ହଁ, ଯୋଡନ୍ତୁ';

  @override
  String get suggestNo => 'ନା, ଛାଡନ୍ତୁ';

  @override
  String get suggestSkip => 'ମୁଁ ନିଶ୍ଚିତ ନୁହେଁ';

  @override
  String suggestProgress(int current, int total) {
    return '$total ରୁ $current';
  }

  @override
  String get suggestDone => 'ଆଉ କିଛି ଯୋଡିବାର ନାହିଁ';

  @override
  String get priceTitle => 'ଦାମ କେତେ?';

  @override
  String get priceBody => 'ଏହା ଗୋଟିଏର ଦାମ।';

  @override
  String priceFloor(String amount) {
    return 'ଆପଣଙ୍କ ଖର୍ଚ୍ଚ: $amount';
  }

  @override
  String get priceFloorExplain =>
      'ଆପଣଙ୍କ ସାମଗ୍ରୀ ଓ ସମୟ ମିଶି ଏତିକି ହୁଏ। ଏହାଠୁ କମରେ ବିକିଲେ ଆପଣଙ୍କର କ୍ଷତି ହେବ।';

  @override
  String priceBand(String low, String high) {
    return 'ଏପରି ଜିନିଷ ଅନ୍ୟମାନେ $low ରୁ $high ରେ ବିକନ୍ତି';
  }

  @override
  String get priceBelowFloor =>
      'ଏହା ଆପଣଙ୍କ ଖର୍ଚ୍ଚଠୁ କମ। ତଥାପି ଆପଣ ଏହା ବାଛିପାରିବେ।';

  @override
  String get priceSayIt => 'ଦାମ କୁହନ୍ତୁ';

  @override
  String get priceConfirm => 'ଏହି ଦାମ ଠିକ୍';

  @override
  String get stockTitle => 'ଆପଣଙ୍କ ପାଖରେ କେତୋଟି ଅଛି?';

  @override
  String get stockBody => 'ସବୁ ବିକ୍ରି ହୋଇଗଲେ ଆମେ ଆପଣଙ୍କ ପାଇଁ ଏହାକୁ ହଟାଇଦେବୁ।';

  @override
  String get stockOneOfAKind => 'କେବଳ ଗୋଟିଏ ଅଛି, ଆଉ ଏମିତି କେବେ ହେବ ନାହିଁ';

  @override
  String get stockMore => 'ଆଉ ଗୋଟିଏ';

  @override
  String get stockLess => 'ଗୋଟିଏ କମ';

  @override
  String get stockConfirm => 'ଏହା ଠିକ୍';

  @override
  String get photosTitle => 'କେଉଁ ଫଟୋ ଆଗରେ ଆସିବ?';

  @override
  String get photosBody => 'କ୍ରେତା ପ୍ରଥମ ଫଟୋକୁ ସବୁଠୁ ଆଗରୁ ଦେଖନ୍ତି।';

  @override
  String get photosMakeFirst => 'ଏହାକୁ ପ୍ରଥମ ଫଟୋ କରନ୍ତୁ';

  @override
  String get photosFirst => 'ପ୍ରଥମ ଫଟୋ';

  @override
  String get photosConfirm => 'ଏହି ଫଟୋଗୁଡିକ ଠିକ୍';

  @override
  String get previewTitle => 'କ୍ରେତା ଏହା ଦେଖିବେ';

  @override
  String get previewListenAll => 'ସବୁ ଶୁଣନ୍ତୁ';

  @override
  String get previewNoDescription => 'କୌଣସି ବିବରଣୀ ଲେଖାଯାଇନାହିଁ।';

  @override
  String get previewConfirm => 'ହଁ, ଏହା ଠିକ୍';

  @override
  String get previewChange => 'କିଛି ବଦଳାନ୍ତୁ';

  @override
  String get consentTitle => 'ଆମେ ଏହାକୁ ବିକ୍ରିରେ ରଖିବା କି?';

  @override
  String get consentPhoto => 'ମୋ ଫଟୋ ଦେଖାନ୍ତୁ';

  @override
  String get consentPhotoExplain =>
      'ଆପଣଙ୍କ ଜିନିଷର ଫଟୋ କ୍ରେତାଙ୍କ ସ୍କ୍ରିନକୁ ଯିବ।';

  @override
  String get consentStory => 'ମୋ କାରିଗରୀର କାହାଣୀ ଦେଖାନ୍ତୁ';

  @override
  String get consentStoryExplain =>
      'ଆପଣଙ୍କ ନାମ, ଗାଁ ଏବଂ ଆପଣ କିପରି ତିଆରି କରନ୍ତି ତାହା କାରିଗର କାର୍ଡରେ ଯିବ। ନା କହିଲେ ବି ଆପଣ ବିକିପାରିବେ।';

  @override
  String get consentNeeded => 'ଫଟୋ ବିନା ଆମେ ଏହାକୁ ରଖିପାରିବୁ ନାହିଁ।';

  @override
  String get consentPublish => 'ବିକ୍ରିରେ ରଖନ୍ତୁ';

  @override
  String get publishingTitle => 'ବିକ୍ରିରେ ରଖାଯାଉଛି';

  @override
  String get publishingBody => 'ଏଥିରେ ଟିକେ ସମୟ ଲାଗିବ। ଆପ୍ ବନ୍ଦ କରନ୍ତୁ ନାହିଁ।';

  @override
  String get publishedTitle => 'ଏହା ବିକ୍ରିରେ ଅଛି';

  @override
  String get publishedBody => 'କ୍ରେତା ଏବେ ଏହା ଦେଖିପାରିବେ।';

  @override
  String get publishedShare => 'ହ୍ୱାଟସଆପରେ ପଠାନ୍ତୁ';

  @override
  String get publishedCopyLink => 'ଲିଙ୍କ କପି କରନ୍ତୁ';

  @override
  String get publishedLinkCopied => 'ଲିଙ୍କ କପି ହେଲା';

  @override
  String get publishedShowQr => 'ସ୍କାନ୍ କରିବା କୋଡ୍ ଦେଖାନ୍ତୁ';

  @override
  String get publishedQrExplain =>
      'ଯେକେହି ଏହା ଆଡକୁ ଫୋନ ଧରି ଆପଣଙ୍କ ଜିନିଷ ଖୋଲିପାରିବେ।';

  @override
  String get publishedAnother => 'ଏମିତି ଆଉ ଗୋଟିଏ ତିଆରି କରନ୍ତୁ';

  @override
  String get publishedDone => 'ହୋମ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get publishFailed =>
      'ଏହା ରଖାଯାଇପାରିଲା ନାହିଁ। କିଛି ହଜିନାହିଁ — ଆପଣ ପୁଣି ଚେଷ୍ଟା କରିପାରିବେ।';

  @override
  String get publishRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get reviewLeaveTitle => 'ଏବେ ପାଇଁ ଛାଡିବେ?';

  @override
  String get reviewLeaveBody =>
      'ଆପଣ ଯାହା ମଞ୍ଜୁର କରିଛନ୍ତି ରହିବ। ଆପଣଙ୍କ ଜିନିଷରୁ ପୁଣି ଫେରିପାରିବେ।';

  @override
  String get reviewLeaveConfirm => 'ଏବେ ପାଇଁ ଛାଡନ୍ତୁ';

  @override
  String get editLeaveTitle => 'ଆପଣଙ୍କ ବଦଳ ଏପର୍ଯ୍ୟନ୍ତ ବିକ୍ରିରେ ନାହିଁ';

  @override
  String get editLeaveBody =>
      'ଆପଣ ଯାହା ବଦଳାଇଲେ ସେଭ୍ ହୋଇଛି, କିନ୍ତୁ କ୍ରେତା ଏବେବି ପୁରୁଣାଟି ଦେଖୁଛନ୍ତି। ଶେଷ ବଟନ୍ ଦବାଇଲେ ହିଁ ଏହା ପୁଣି ବିକ୍ରିକୁ ଯିବ।';

  @override
  String get editLeaveConfirm => 'ଠିକ୍ ଅଛି, ପରେ କରିବି';

  @override
  String get reviewLeaveCancel => 'ଜାରି ରଖନ୍ତୁ';

  @override
  String get statusSoldOut => 'ସବୁ ବିକ୍ରି ହୋଇଗଲା';

  @override
  String get statusUnpublished => 'ହଟାଯାଇଛି';

  @override
  String get listingsTitle => 'ଆପଣଙ୍କ ଜିନିଷ';

  @override
  String get listingsEmptyTitle => 'ଆପଣ ଏପର୍ଯ୍ୟନ୍ତ କିଛି ତିଆରି କରିନାହାନ୍ତି';

  @override
  String get listingsEmptyBody =>
      'ହୋମ୍‌ର ବଡ ବଟନ୍ ଦବାଇ ଆପଣଙ୍କ ପ୍ରଥମ ଜିନିଷ ଯୋଡନ୍ତୁ।';

  @override
  String get listingsEmptyFilter => 'ଏଠାରେ କିଛି ନାହିଁ।';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ବାକି',
      one: '1ଟି ବାକି',
      zero: 'କିଛି ବାକି ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ଥର ଦେଖାଗଲା',
      one: 'ଥରେ ଦେଖାଗଲା',
      zero: 'ଏପର୍ଯ୍ୟନ୍ତ କେହି ଦେଖିନାହାନ୍ତି',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'କେତୋଟି ଅଛି ବଦଳାନ୍ତୁ';

  @override
  String get listingTitle => 'ଏହି ଜିନିଷ';

  @override
  String get listingOpenPreview => 'କ୍ରେତା ଯାହା ଦେଖନ୍ତି ଦେଖନ୍ତୁ';

  @override
  String get listingEdit => 'କିଛି ବଦଳାନ୍ତୁ';

  @override
  String get listingDuplicate => 'ଏମିତି ଆଉ ଗୋଟିଏ ତିଆରି କରନ୍ତୁ';

  @override
  String get listingUnpublish => 'ବିକ୍ରିରୁ ହଟାନ୍ତୁ';

  @override
  String get listingRelist => 'ପୁଣି ବିକ୍ରିରେ ରଖନ୍ତୁ';

  @override
  String get listingFinish => 'ଏହାକୁ ଶେଷ କରନ୍ତୁ';

  @override
  String get listingSoldOutTitle => 'ଏସବୁ ବିକ୍ରି ହୋଇଗଲା';

  @override
  String get listingSoldOutBody =>
      'ଆମେ ଆପଣଙ୍କ ପାଇଁ ଏହାକୁ ବିକ୍ରିରୁ ହଟାଇଦେଲୁ। ଆହୁରି ତିଆରି କଲେ ପୁଣି ରଖନ୍ତୁ।';

  @override
  String get editTitle => 'ଏହି ଜିନିଷ ବଦଳାନ୍ତୁ';

  @override
  String get editBody =>
      'ଆପଣ ଏହାକୁ ପୁଣି ଦେଖିବେ, ତା\'ପରେ ଏହା ପୁଣି ବିକ୍ରିକୁ ଯିବ।';

  @override
  String get editRepublishing => 'ବଦଳ ବିକ୍ରିରେ ରଖାଯାଉଛି…';

  @override
  String get editRepublished => 'ଆପଣଙ୍କ ବଦଳ ଏବେ ବିକ୍ରିରେ';

  @override
  String get editRepublishConfirm => 'ବଦଳ ପୁଣି ବିକ୍ରିରେ ରଖନ୍ତୁ';

  @override
  String get quickStockTitle => 'କେତୋଟି ବାକି ଅଛି?';

  @override
  String get quickStockMarkSoldOut => 'ସବୁ ବିକ୍ରି ହୋଇଗଲାଣି';

  @override
  String get quickStockSave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get quickStockSaved => 'ସେଭ୍ ହେଲା';

  @override
  String get actionUndo => 'ପୂର୍ବ ପରି କରନ୍ତୁ';

  @override
  String get unpublishTitle => 'ବିକ୍ରିରୁ ହଟାଇବେ?';

  @override
  String get unpublishBody =>
      'କ୍ରେତା ଆଉ ଏହା ଦେଖିବେ ନାହିଁ। କିଛି ଲିଭିବ ନାହିଁ, ଏବଂ ଆପଣ ଯେକୌଣସି ସମୟରେ ପୁଣି ରଖିପାରିବେ।';

  @override
  String get unpublishConfirm => 'ହଁ, ହଟାନ୍ତୁ';

  @override
  String get unpublishCancel => 'ନା, ବିକ୍ରିରେ ରହୁ';

  @override
  String get unpublishDone => 'ଏହା ବିକ୍ରିରୁ ହଟିଗଲା';

  @override
  String get relistDone => 'ଏହା ପୁଣି ବିକ୍ରିରେ';

  @override
  String get duplicateTitle => 'ଏମିତି ଆଉ ଗୋଟିଏ ତିଆରି କରିବେ?';

  @override
  String get duplicateBody =>
      'ଆପଣ ଏହା ବିଷୟରେ ଯାହା କହିଥିଲେ ଆମେ ରଖିବୁ। ଆପଣଙ୍କୁ କେବଳ ନୂଆ ଫଟୋ ଉଠାଇବାକୁ ହେବ।';

  @override
  String get duplicateConfirm => 'ଫଟୋ ଉଠାନ୍ତୁ';

  @override
  String get duplicateCancel => 'ଏବେ ନୁହେଁ';

  @override
  String get duplicateBanner => 'ଆଗଟି ପରି ଆଉ ଗୋଟିଏ ତିଆରି ହେଉଛି। କେବଳ ଫଟୋ ନୂଆ।';

  @override
  String get listingActionFailed =>
      'ଏହା ହେଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get salesNew => 'ନୂଆ';

  @override
  String get salesEmptyTitle => 'ଏପର୍ଯ୍ୟନ୍ତ କିଛି ବିକ୍ରି ହୋଇନାହିଁ';

  @override
  String get salesEmptyBody =>
      'କେହି କିଛି କିଣିଲେ ଏଠାରେ ଦେଖାଯିବ ଏବଂ ଆମେ ଆପଣଙ୍କୁ ଜଣାଇବୁ।';

  @override
  String get salesLoading => 'କ\'ଣ ବିକ୍ରି ହେଲା ଦେଖୁଛୁ…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି',
      one: '1ଟି',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date ସୁଦ୍ଧା ପ୍ୟାକ୍ କରନ୍ତୁ';
  }

  @override
  String get salesPackByToday => 'ଆଜି ହିଁ ପ୍ୟାକ୍ କରନ୍ତୁ';

  @override
  String get salesPackByTomorrow => 'କାଲି ସୁଦ୍ଧା ପ୍ୟାକ୍ କରନ୍ତୁ';

  @override
  String get salesPackedAlready => 'ଏହାର ତାରିଖ ବିତିଗଲାଣି';

  @override
  String get saleTitle => 'ଏହି ଅର୍ଡର';

  @override
  String get saleReadOnly =>
      'ଏହା କେବଳ ଆପଣଙ୍କୁ ଜଣାଇବା ପାଇଁ। ଅର୍ଡରର ସବୁ କାମ ବଜାରରେ ହୁଏ, ଏହି ଆପ୍‌ରେ ନୁହେଁ।';

  @override
  String salePaid(String amount) {
    return 'ଆପଣ $amount ପାଇବେ';
  }

  @override
  String salePlaced(String date) {
    return '$date ରେ ବିକ୍ରି ହେଲା';
  }

  @override
  String saleGoingTo(String area) {
    return '$area କୁ ଯାଉଛି';
  }

  @override
  String get saleWhatToPack => 'କ\'ଣ ପ୍ୟାକ୍ କରିବେ';

  @override
  String get salePackingHelp => 'କିପରି ପ୍ୟାକ୍ କରିବେ';

  @override
  String get saleSeeListing => 'ଏହି ଜିନିଷ ଦେଖନ୍ତୁ';

  @override
  String get packingTitle => 'କିପରି ପ୍ୟାକ୍ କରିବେ';

  @override
  String get packingBody => 'ଗୋଟିଏ ଗୋଟିଏ କରି କରନ୍ତୁ। ଯାହା ହୋଇଗଲା ତାକୁ ଦବାନ୍ତୁ।';

  @override
  String get packingStep1 => 'କପଡା କିମ୍ବା କାଗଜରେ ଗୁଡାନ୍ତୁ, ଯେପରି କିଛି ଘଷି ନହୁଏ';

  @override
  String get packingStep2 =>
      'ଚାରିପାଖେ କାଗଜ କିମ୍ବା ନଡା ଭରନ୍ତୁ, ଯେପରି ବାକ୍ସରେ ହଲଚଲ ନହୁଏ';

  @override
  String get packingStep3 => 'ଭିତରେ ଠିକ୍ ସଂଖ୍ୟା ଅଛି କି ଦେଖନ୍ତୁ';

  @override
  String get packingStep4 => 'ବାକ୍ସ ବନ୍ଦ କରି ଚାରିପାଖେ ଟେପ୍ ଲଗାନ୍ତୁ';

  @override
  String get packingStep5 => 'ନେବାକୁ ଆସୁଥିବା ଲୋକଙ୍କ ପାଇଁ ପ୍ରସ୍ତୁତ ରଖନ୍ତୁ';

  @override
  String get packingDone => 'ସବୁ ହୋଇଗଲା';

  @override
  String packingProgress(int done, int total) {
    return '$total ରୁ $done ହେଲା';
  }

  @override
  String get earningsTitle => 'ଆପଣ କେତେ ରୋଜଗାର କଲେ';

  @override
  String get earningsWeek => 'ଏହି ସପ୍ତାହ';

  @override
  String get earningsMonth => 'ଏହି ମାସ';

  @override
  String get earningsTotal => 'ଆରମ୍ଭରୁ';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ବିକ୍ରି ହେଲା',
      one: '1ଟି ବିକ୍ରି ହେଲା',
      zero: 'ଏପର୍ଯ୍ୟନ୍ତ କିଛି ବିକ୍ରି ହୋଇନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'ବଜାର ନିଜ ଭାଗ ନେବା ପରେ ଆପଣଙ୍କ ପାଖକୁ ଯାହା ଆସେ, ଏହା ତାହା।';

  @override
  String get profileVillageLabel => 'ଗାଁ କିମ୍ବା କ୍ଲଷ୍ଟର';

  @override
  String get profileNotSet => 'ଦିଆଯାଇନାହିଁ';

  @override
  String get profileEditEntry => 'ଆପଣଙ୍କ ବିବରଣୀ ବଦଳାନ୍ତୁ';

  @override
  String get profileStoryEntry => 'ଆପଣଙ୍କ କାରିଗରୀର କାହାଣୀ';

  @override
  String get profileLanguageEntry => 'ଭାଷା';

  @override
  String get profilePhoneEntry => 'ଫୋନ ନମ୍ବର';

  @override
  String get profileOndcEntry => 'ଆପଣଙ୍କ ବିକ୍ରି ଆକାଉଣ୍ଟ';

  @override
  String get profileNotificationsEntry => 'ଆମେ ଆପଣଙ୍କୁ କ\'ଣ ଜଣାଇବୁ';

  @override
  String get profileVoiceEntry => 'ସ୍ୱର ଓ ଶୁଣିବା';

  @override
  String get profilePrivacyEntry => 'ଆପଣଙ୍କ ବିଷୟରେ କ\'ଣ ଦେଖାଯାଏ';

  @override
  String get profileStorageEntry => 'ଏହି ଫୋନରେ ଜାଗା';

  @override
  String get profileAccountEntry => 'ସାଇନ୍ ଆଉଟ୍';

  @override
  String get editProfileTitle => 'ଆପଣଙ୍କ ବିବରଣୀ';

  @override
  String get editProfileAddPhoto => 'ଆପଣଙ୍କ ଫଟୋ ଯୋଡନ୍ତୁ';

  @override
  String get editProfileChangePhoto => 'ଫଟୋ ବଦଳାନ୍ତୁ';

  @override
  String get editProfileRemovePhoto => 'ଫଟୋ ହଟାନ୍ତୁ';

  @override
  String get editProfilePhotoWhy =>
      'ଆପଣ ଅନୁମତି ଦେଲେ ହିଁ କ୍ରେତା ଏହାକୁ କାରିଗର କାର୍ଡରେ ଦେଖିବେ।';

  @override
  String get editProfileVillageHint => 'କୁହନ୍ତୁ କିମ୍ବା ଲେଖନ୍ତୁ';

  @override
  String get editProfileSave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get editProfileSaved => 'ସେଭ୍ ହେଲା';

  @override
  String get storyTitle => 'ଆପଣଙ୍କ କାରିଗରୀର କାହାଣୀ';

  @override
  String get storyBody =>
      'କ୍ରେତାଙ୍କୁ କୁହନ୍ତୁ ଆପଣ କିଏ ଏବଂ କିପରି ତିଆରି କରନ୍ତି। ଆପଣ କୁହନ୍ତୁ, ଆମେ ଲେଖିନେବୁ।';

  @override
  String get storyHoldToSpeak => 'ଦବାଇ ଧରି ଆପଣଙ୍କ କାହାଣୀ କୁହନ୍ତୁ';

  @override
  String get storyEmpty => 'ଆପଣ ଏପର୍ଯ୍ୟନ୍ତ ଆପଣଙ୍କ କାହାଣୀ କହିନାହାନ୍ତି।';

  @override
  String get storyEditHint => 'ଆପଣ ଏହାର ଯେକୌଣସି ଶବ୍ଦ ବଦଳାଇପାରିବେ।';

  @override
  String get storyExample =>
      'ଯେମିତି: ଆମ ପରିବାରରେ ତିନି ପିଢି ଧରି ଏସବୁ ତିଆରି ହେଉଛି, ଆଉ ମୁଁ ଆଜି ବି ମୋ ଜେଜେବାପାଙ୍କ ତନ୍ତରେ କାମ କରେ।';

  @override
  String get changePhoneTitle => 'ଆପଣଙ୍କ ନମ୍ବର ବଦଳାନ୍ତୁ';

  @override
  String get changePhoneBody =>
      'ନମ୍ବରଟି ଆପଣଙ୍କର ବୋଲି ନିଶ୍ଚିତ କରିବାକୁ ଆମେ ନୂଆ ନମ୍ବରକୁ ଗୋଟିଏ କୋଡ୍ ପଠାଇବୁ।';

  @override
  String changePhoneCurrent(String number) {
    return 'ଏବେ ଆପଣଙ୍କ ନମ୍ବର $number';
  }

  @override
  String get changePhoneDone => 'ଆପଣଙ୍କ ନମ୍ବର ବଦଳିଗଲା';

  @override
  String get ondcAccountTitle => 'ଆପଣଙ୍କ ବିକ୍ରି ଆକାଉଣ୍ଟ';

  @override
  String get ondcAccountLinked => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଯୋଡାହୋଇଛି';

  @override
  String get ondcAccountNone => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଆକାଉଣ୍ଟ ଯୋଡାହୋଇନାହିଁ';

  @override
  String get ondcAccountNoneBody =>
      'ଆପଣ ଜିନିଷ ତିଆରି କରୁଥାନ୍ତୁ। ଆକାଉଣ୍ଟ ଯୋଡାହେବା ମାତ୍ରେ ସେଗୁଡିକ ବିକ୍ରିକୁ ଯିବ।';

  @override
  String get ondcAccountLink => 'ଆକାଉଣ୍ଟ ଯୋଡନ୍ତୁ';

  @override
  String get ondcAccountUnlink => 'ଏହି ଆକାଉଣ୍ଟ ହଟାନ୍ତୁ';

  @override
  String get ondcUnlinkTitle => 'ଏହି ଆକାଉଣ୍ଟ ହଟାଇବେ?';

  @override
  String get ondcUnlinkBody =>
      'ବିକ୍ରିରେ ଥିବା ସବୁ ଓହ୍ଲାଇଯିବ। ଆପଣ ତିଆରି କରିଥିବା କିଛି ଲିଭିବ ନାହିଁ, ଏବଂ ଆପଣ ପୁଣି ଯୋଡିପାରିବେ।';

  @override
  String get ondcUnlinkConfirm => 'ହଁ, ହଟାନ୍ତୁ';

  @override
  String get ondcUnlinkCancel => 'ନା, ରହୁ';

  @override
  String get ondcUnlinkDone => 'ଆକାଉଣ୍ଟ ହଟିଗଲା';

  @override
  String get notificationsTitle => 'ଆମେ ଆପଣଙ୍କୁ କ\'ଣ ଜଣାଇବୁ';

  @override
  String get notifySold => 'କିଛି ବିକ୍ରି ହେଲେ';

  @override
  String get notifySoldWhy =>
      'କ୍ରେତା ଟଙ୍କା ଦେବା ମାତ୍ରେ ଆମେ ଜଣାଇବୁ, ଯେପରି ଆପଣ ପ୍ୟାକ୍ କରିବା ଆରମ୍ଭ କରିପାରିବେ।';

  @override
  String get notifyAttention => 'ଆମକୁ ଆପଣଙ୍କୁ କିଛି ପଚାରିବାର ଥିଲେ';

  @override
  String get notifyAttentionWhy =>
      'ବେଳେବେଳେ ଜିନିଷ ବିକ୍ରିକୁ ଯିବା ଆଗରୁ ଗୋଟିଏ କଥା ବାକି ରହେ।';

  @override
  String get notifyUpload => 'ଜିନିଷ ପଠାହୋଇଗଲେ';

  @override
  String get notifyUploadWhy =>
      'ଆପଣ ଫୋନରେ ଯାହା ତିଆରି କଲେ ତାହା ଆମ ପାଖରେ ପହଞ୍ଚିଲେ ଜଣାଇବୁ।';

  @override
  String get notifyPackBy => 'ପ୍ୟାକ୍ କରିବା ସମୟ ହେଲେ';

  @override
  String get notifyPackByWhy =>
      'ଯେଉଁ ବିକ୍ରି ପ୍ୟାକ୍ କରିବାକୁ ଅଛି, ତାର ତାରିଖର ଗୋଟିଏ ଦିନ ଆଗରୁ ଏବଂ ସେହି ଦିନ ଆମେ ଆପଣଙ୍କୁ ମନେ ପକାଇଦେବୁ।';

  @override
  String get notificationsBlocked =>
      'ଏହି ଫୋନ ଆମକୁ ଆପଣଙ୍କୁ କିଛି ପଠାଇବାକୁ ଦେଉନାହିଁ। ଫୋନର ସେଟିଂସରେ ଏହା ଚାଲୁ କରିପାରିବେ।';

  @override
  String get voiceSettingsTitle => 'ସ୍ୱର ଓ ଶୁଣିବା';

  @override
  String get voiceSpeed => 'ଆମେ କେତେ ଜୋରରେ କହିବୁ';

  @override
  String get voiceSpeedSlow => 'ଧୀରେ';

  @override
  String get voiceSpeedFast => 'ଶୀଘ୍ର';

  @override
  String get voiceTry => 'ଏବେ କିଛି କହି ଶୁଣାନ୍ତୁ';

  @override
  String get voiceSample => 'ଆମେ ଆପଣଙ୍କ ସହ ଏହି ଗତିରେ କଥା ହେବୁ।';

  @override
  String get voiceAutoRead => 'ପ୍ରତ୍ୟେକ ସ୍କ୍ରିନ ଖୋଲିଲେ ପଢି ଶୁଣାନ୍ତୁ';

  @override
  String get voiceAutoReadWhy => 'ଏହା ବନ୍ଦ ଥିଲେ ଆପଣ ସ୍ପିକର ଦବାଇଲେ ହିଁ ଆମେ କହୁ।';

  @override
  String get voiceUnavailable =>
      'ଏହି ଫୋନ କହିପାରେ ନାହିଁ। ସବୁ କାମ କରିବ, କିନ୍ତୁ କିଛି ପଢି ଶୁଣାଯିବ ନାହିଁ।';

  @override
  String get privacyTitle => 'ଆପଣଙ୍କ ବିଷୟରେ କ\'ଣ ଦେଖାଯାଏ';

  @override
  String get privacyBody =>
      'ପ୍ରତ୍ୟେକ ଜିନିଷ ବିକ୍ରିରେ ରଖିବା ସମୟରେ ଆପଣ ଏଗୁଡିକୁ ହଁ କହିଥିଲେ। ଆପଣ ଯେକୌଣସିଟି ଫେରାଇନେଇପାରିବେ।';

  @override
  String get privacyPhoto => 'ଏହି ଜିନିଷର ଫଟୋ';

  @override
  String get privacyStory => 'ଆପଣଙ୍କ ନାମ, ଗାଁ ଓ କାହାଣୀ';

  @override
  String get privacyNothing => 'ଏବେ ଆପଣଙ୍କର କିଛି ବିକ୍ରିରେ ନାହିଁ।';

  @override
  String get privacyWithdrawTitle => 'ଏହା ଫେରାଇନେବେ?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ଫଟୋ ବିନା ଏହି ଜିନିଷ ବିକ୍ରିରେ ରହିପାରିବ ନାହିଁ, ତେଣୁ ଏହା ଓହ୍ଲାଇଯିବ। କିଛି ଲିଭିବ ନାହିଁ।';

  @override
  String get privacyWithdrawStoryBody =>
      'ଆପଣଙ୍କ ନାମ, ଗାଁ ଓ କାହାଣୀ ଏହି ଜିନିଷରୁ ହଟାଯିବ। ଏହା ବିକ୍ରିରେ ରହିବ।';

  @override
  String get privacyWithdrawConfirm => 'ହଁ, ଫେରାଇନିଅନ୍ତୁ';

  @override
  String get privacyWithdrawCancel => 'ନା, ରହୁ';

  @override
  String get privacyWithdrawn => 'ଫେରାଇନିଆଗଲା';

  @override
  String get storageTitle => 'ଏହି ଫୋନରେ ଜାଗା';

  @override
  String get storagePhotos => 'ଫଟୋ ଓ ରେକର୍ଡିଂ';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଜିନିଷ ପଠାଇବା ବାକି',
      one: '1ଟି ଜିନିଷ ପଠାଇବା ବାକି',
      zero: 'ପଠାଇବାକୁ କିଛି ବାକି ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'ଯାହା ପଠାହୋଇସାରିଛି ହଟାନ୍ତୁ';

  @override
  String get storageClearWhy =>
      'ଯାହା ଏବେବି ପଠାଇବା ବାକି, ତାକୁ କେବେ ଛୁଆଁଯାଏ ନାହିଁ।';

  @override
  String storageCleared(String size) {
    return '$size ଖାଲି ହେଲା';
  }

  @override
  String get storageNothingToClear => 'ହଟାଇବାକୁ କିଛି ନାହିଁ';

  @override
  String get accountTitle => 'ସାଇନ୍ ଆଉଟ୍';

  @override
  String get accountSignOut => 'ଏହି ଫୋନରୁ ସାଇନ୍ ଆଉଟ୍ କରନ୍ତୁ';

  @override
  String get accountSignOutTitle => 'ସାଇନ୍ ଆଉଟ୍ କରିବେ?';

  @override
  String get accountSignOutBody =>
      'ପଠାଇବା ବାକି ଥିବା ସବୁ ହଜିଯିବ। ଯାହା ବିକ୍ରିରେ ଅଛି ବିକ୍ରିରେ ହିଁ ରହିବ।';

  @override
  String get accountSignOutConfirm => 'ହଁ, ସାଇନ୍ ଆଉଟ୍';

  @override
  String get accountSignOutCancel => 'ନା, ସାଇନ୍ ଇନ୍ ରହୁ';

  @override
  String get accountDelete => 'ମୋ ଆକାଉଣ୍ଟ ଲିଭାନ୍ତୁ';

  @override
  String get accountDeleteTitle => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଲିଭାଇବେ?';

  @override
  String get accountDeleteBody =>
      'ସବୁ ବିକ୍ରିରୁ ଓହ୍ଲାଇଯିବ ଏବଂ ଏହି ଫୋନର ସବୁ ଲିଭିଯିବ। ଏହା ଫେରିବ ନାହିଁ।';

  @override
  String get accountDeleteConfirm => 'ହଁ, ସବୁ ଲିଭାନ୍ତୁ';

  @override
  String get accountDeleteCancel => 'ନା, ମୋ ଆକାଉଣ୍ଟ ରହୁ';

  @override
  String get accountDeleteHold => 'ଲିଭାଇବାକୁ ବଟନ୍ ଦବାଇ ଧରନ୍ତୁ';

  @override
  String get profileHelpEntry => 'ସାହାଯ୍ୟ';

  @override
  String get helpTitle => 'ସାହାଯ୍ୟ';

  @override
  String get helpBody =>
      'ଛୋଟ ଉତ୍ତର, ପଢି ଶୁଣାଯାଏ। ଶୁଣିବାକୁ ଯେକୌଣସିଟିକୁ ଦବାନ୍ତୁ।';

  @override
  String get helpSteps => 'ଏମିତି କରନ୍ତୁ';

  @override
  String get helpTopicPhotos => 'ଭଲ ଫଟୋ କିପରି ଉଠାଇବେ';

  @override
  String get helpTopicPhotosBody =>
      'ଭଲ ଫଟୋରେ ଜିନିଷ ବିକ୍ରି ହୁଏ। କ୍ରେତା ଜିନିଷ ହାତରେ ଧରିପାରନ୍ତି ନାହିଁ, ତାଙ୍କ ପାଖରେ କେବଳ ଫଟୋ ଥାଏ।';

  @override
  String get helpTopicPhotosStep1 =>
      'କବାଟ କିମ୍ବା ଝରକା ପାଖରେ ଠିଆ ହୁଅନ୍ତୁ, ଯେପରି ଦିନର ଆଲୁଅ ଜିନିଷ ଉପରେ ପଡେ';

  @override
  String get helpTopicPhotosStep2 =>
      'ଜିନିଷଟିକୁ ସାଦା କପଡା ଉପରେ ରଖନ୍ତୁ, ଚାରିପାଖେ ଆଉ କିଛି ନଥାଉ';

  @override
  String get helpTopicPhotosStep3 =>
      'ଫଟୋ ଉଠିବା ପର୍ଯ୍ୟନ୍ତ ଦୁଇ ହାତରେ ଫୋନ ସ୍ଥିର ଧରନ୍ତୁ';

  @override
  String get helpTopicPhotosStep4 =>
      'ପାଖରୁ ଗୋଟିଏ ଫଟୋ ଉଠାନ୍ତୁ, ଯେପରି କାମ ଦେଖାଯାଏ';

  @override
  String get helpTopicPhotosStep5 =>
      'ଗୋଟିଏ ଫଟୋରେ ପାଖରେ ହାତ ରଖନ୍ତୁ, ଯେପରି ଆକାର ଜଣାପଡେ';

  @override
  String get helpTopicVoice => 'ଆପଣଙ୍କ ଜିନିଷ ବିଷୟରେ କ\'ଣ କହିବେ';

  @override
  String get helpTopicVoiceBody =>
      'ସାମ୍ନାରେ ଠିଆ ଗ୍ରାହକଙ୍କ ସହ ଯେମିତି କଥା ହୁଅନ୍ତି, ସେମିତି କୁହନ୍ତୁ। କହିବାର କୌଣସି ଭୁଲ ଉପାୟ ନାହିଁ।';

  @override
  String get helpTopicVoiceStep1 => 'କୁହନ୍ତୁ ଏହା କ\'ଣ';

  @override
  String get helpTopicVoiceStep2 => 'କୁହନ୍ତୁ ଏହା କେଉଁଥିରେ ତିଆରି';

  @override
  String get helpTopicVoiceStep3 => 'କୁହନ୍ତୁ ଏହା କେତେ ବଡ, ଇଞ୍ଚ କିମ୍ବା ଫୁଟରେ';

  @override
  String get helpTopicVoiceStep4 => 'କୁହନ୍ତୁ ତିଆରି କରିବାକୁ କେତେ ସମୟ ଲାଗିଲା';

  @override
  String get helpTopicVoiceStep5 => 'କୁହନ୍ତୁ ଏହା ପାଇଁ ଆପଣ କେତେ ଚାହାଁନ୍ତି';

  @override
  String get helpTopicPrice => 'ଦାମ କିପରି ସ୍ଥିର କରିବେ';

  @override
  String get helpTopicPriceBody =>
      'ଆପଣଙ୍କ ଦାମରେ ସାମଗ୍ରୀର ଖର୍ଚ୍ଚ ଏବଂ ଆପଣଙ୍କ ସମୟର ମୂଲ୍ୟ ଦୁହେଁ ଉଠିବା ଦରକାର। ଆମେ ଆପଣଙ୍କ ସହ ଏହା ହିସାବ କରୁ, ଏବଂ ନ କହି କେବେ ତା\'ଠୁ ତଳକୁ ଯିବାକୁ ଦେଉନାହୁଁ।';

  @override
  String get helpTopicPriceStep1 => 'ସାମଗ୍ରୀରେ କେତେ ଖର୍ଚ୍ଚ ହେଲା ଗଣନ୍ତୁ';

  @override
  String get helpTopicPriceStep2 => 'କାମରେ କେତେ ଦିନ ଲାଗିଲା ଗଣନ୍ତୁ';

  @override
  String get helpTopicPriceStep3 =>
      'ଆମେ ଯାହା କହୁ ଦେଖନ୍ତୁ, ଆପଣ ଭଲ ଜାଣିଲେ ବଦଳାନ୍ତୁ';

  @override
  String get helpTopicPriceStep4 =>
      'ଆପଣଙ୍କ ଖର୍ଚ୍ଚଠୁ କମ ହେଲେ ଆମେ କହିବୁ, କିନ୍ତୁ ନିଷ୍ପତ୍ତି ଆପଣଙ୍କର';

  @override
  String get helpTopicSold => 'ବିକ୍ରି ପରେ କ\'ଣ ହୁଏ';

  @override
  String get helpTopicSoldBody =>
      'କ୍ରେତା ବଜାରରେ ଟଙ୍କା ଦିଅନ୍ତି। ଆପଣ ପ୍ୟାକ୍ କରି ଦେଇଦିଅନ୍ତି, ଆଉ ଟଙ୍କା ଆପଣଙ୍କ ପାଖକୁ ଆସେ।';

  @override
  String get helpTopicSoldStep1 => 'ବିକ୍ରି ହେବା ମାତ୍ରେ ଆମେ ଆପଣଙ୍କୁ ଜଣାଇବୁ';

  @override
  String get helpTopicSoldStep2 => 'ଖୋଲି ଦେଖନ୍ତୁ କ\'ଣ ଏବଂ କେତୋଟି ପ୍ୟାକ୍ କରିବେ';

  @override
  String get helpTopicSoldStep3 => 'ଆମେ ଦେଖାଇଥିବା ତାରିଖ ଆଗରୁ ପ୍ୟାକ୍ କରନ୍ତୁ';

  @override
  String get helpTopicSoldStep4 => 'ନେବାକୁ ଆସୁଥିବା ଲୋକଙ୍କୁ ଦେଇଦିଅନ୍ତୁ';

  @override
  String get helpTopicSoldStep5 => 'ତା\'ପରେ ଟଙ୍କା ଆପଣଙ୍କ ପାଖରେ ପହଞ୍ଚେ';

  @override
  String get helpVideoComing => 'ଏଥିପାଇଁ ଗୋଟିଏ ଛୋଟ ଭିଡିଓ ଶୀଘ୍ର ଆସୁଛି।';

  @override
  String get helpPractice => 'ଭଲ ଫଟୋ କିପରି ଉଠାଇବେ';

  @override
  String get helpPracticeBody =>
      'ସେହି ଗୋଟିଏ ହାଣ୍ଡିର ଗୋଟିଏ ଭଲ ଓ ଗୋଟିଏ ଖରାପ ଫଟୋ।';

  @override
  String get helpFaqEntry => 'ଲୋକେ ପଚାରୁଥିବା ପ୍ରଶ୍ନ';

  @override
  String get helpAboutEntry => 'କୀର୍ତ୍ତିକର ବିଷୟରେ';

  @override
  String get helpSupportEntry => 'ଜଣେ ମଣିଷଙ୍କ ସହ କଥା ହୁଅନ୍ତୁ';

  @override
  String get helpTermsEntry => 'ସର୍ତ୍ତ ଓ ଗୋପନୀୟତା';

  @override
  String get faqTitle => 'ଲୋକେ ପଚାରୁଥିବା ପ୍ରଶ୍ନ';

  @override
  String get faqQ1 => 'ଏଥିପାଇଁ ମୋତେ କିଛି ଦେବାକୁ ପଡିବ କି?';

  @override
  String get faqA1 =>
      'ନା। ଜିନିଷ ରଖିବା ମାଗଣା। କିଛି ବିକ୍ରି ହେଲେ ହିଁ ବଜାର ଛୋଟ ଭାଗ ନିଏ।';

  @override
  String get faqQ2 => 'ନେଟୱର୍କ ନଥିଲେ କ\'ଣ?';

  @override
  String get faqA2 =>
      'ସବୁ କାମ କରୁଥାଏ। ଆପଣ ଯାହା ତିଆରି କରନ୍ତି ଫୋନରେ ରହେ ଏବଂ ନେଟୱର୍କ ଆସିଲେ ନିଜେ ଚାଲିଯାଏ।';

  @override
  String get faqQ3 => 'ମୋ ଟଙ୍କା କିଏ ପାଏ?';

  @override
  String get faqA3 =>
      'ଆପଣ। କ୍ରେତା ବଜାରରେ ଟଙ୍କା ଦିଅନ୍ତି ଏବଂ ତାହା ଆପଣଙ୍କ ଆକାଉଣ୍ଟକୁ ଆସେ। ଟଙ୍କା କେବେ ଆମ ଦେଇ ଯାଏ ନାହିଁ।';

  @override
  String get faqQ4 => 'ବିକ୍ରିରେ ରଖିବା ପରେ କିଛି ବଦଳାଯାଇପାରିବ କି?';

  @override
  String get faqA4 =>
      'ହଁ। ଆପଣଙ୍କ ଜିନିଷରୁ ଖୋଲନ୍ତୁ, ଯାହା ଚାହାଁନ୍ତି ବଦଳାନ୍ତୁ, ଏହା ପୁଣି ବିକ୍ରିକୁ ଯିବ।';

  @override
  String get faqQ5 => 'ମୁଁ କିଛି ଭୁଲ କହିଦେଲେ?';

  @override
  String get faqA5 =>
      'ଆପଣ ଶୁଣି ଠିକ୍ ନ କହିବା ପର୍ଯ୍ୟନ୍ତ କିଛି ବିକ୍ରିକୁ ଯାଏ ନାହିଁ। କହି ଯେକୌଣସି ଅଂଶ ଠିକ୍ କରିପାରିବେ।';

  @override
  String get faqQ6 => 'ମୋତେ ପଢିବା-ଲେଖିବା ଜାଣିବା ଦରକାର କି?';

  @override
  String get faqA6 =>
      'ନା। ଆପଣ ସବୁ କହି ଏବଂ ଦବାଇ କରିପାରିବେ। ପ୍ରତ୍ୟେକ ସ୍କ୍ରିନ ଆପଣଙ୍କୁ ପଢି ଶୁଣାଯାଇପାରିବ।';

  @override
  String get faqQ7 => 'ମୋ ନାମ ଓ ଗାଁ କିଏ ଦେଖେ?';

  @override
  String get faqA7 =>
      'ଆପଣ ଅନୁମତି ଦେଲେ ହିଁ, ପ୍ରତ୍ୟେକ ଜିନିଷ ପାଇଁ ଅଲଗା। ଆପଣ ଯେକୌଣସି ସମୟରେ ଫେରାଇନେଇପାରିବେ।';

  @override
  String get aboutTitle => 'କୀର୍ତ୍ତିକର ବିଷୟରେ';

  @override
  String get aboutWhatTitle => 'ଏହା କ\'ଣ';

  @override
  String get aboutWhat =>
      'କୀର୍ତ୍ତିକର ହାତତିଆରି ଜିନିଷକୁ ONDC ରେ — ଭାରତର କିଣାବିକାର ଖୋଲା ନେଟୱର୍କରେ — ପହଞ୍ଚାଏ, ଏବଂ ସେଥିପାଇଁ ତିଆରିକାରୀଙ୍କୁ ଲେଖିବାକୁ ପଡେ ନାହିଁ, କହିଲେ ଚଳେ। ଆପଣଙ୍କ ନିଜ ଭାଷାରେ କିଛି ଫଟୋ ଓ ଗୋଟିଏ ଭଏସ୍ ନୋଟ୍‌ରୁ ଏମିତି ତାଲିକା ତିଆରି ହୁଏ ଯାହା ଦେଶସାରା କ୍ରେତା ଖୋଜିପାରନ୍ତି।';

  @override
  String get aboutWhyTitle => 'ଆମେ ଏହା କାହିଁକି ତିଆରି କଲୁ';

  @override
  String get aboutWhy =>
      'ଭାରତରେ ପ୍ରାୟ ସତୁରି ଲକ୍ଷ କାରିଗର ଏମିତି ଜିନିଷ ତିଆରି କରନ୍ତି ଯାହା ଲୋକେ କିଣିବାକୁ ଚାହାଁନ୍ତି, ଏବଂ ସେମାନଙ୍କ ମଧ୍ୟରୁ ଅଧିକାଂଶ ଦଲାଲ ଦେଇ ବିକନ୍ତି ଯିଏ ଫରକ ଟଙ୍କା ରଖିନିଏ। ବାଧା କାମରେ ନାହିଁ। ବାଧା ଫର୍ମରେ: ଅନଲାଇନ୍ ତାଲିକା ଇଂରାଜୀରେ ଟାଇପ୍, ଅନେକ ଘର ଏବଂ କ୍ୟାଟାଲଗ୍ ପରି ଉଠାଯାଇଥିବା ଫଟୋ ମାଗେ। ଏହି ଆପ୍ ସେହି ଫର୍ମକୁ ହିଁ ହଟାଇଦିଏ।';

  @override
  String get aboutHowTitle => 'ଏହା କିପରି କାମ କରେ';

  @override
  String get aboutHow =>
      'ତିନୋଟି ଫଟୋ ଉଠାନ୍ତୁ ଏବଂ କୁହନ୍ତୁ ଏହା କ\'ଣ। ଆମ ବ୍ୟବସ୍ଥା ଶୁଣେ, ତାଲିକା ଲେଖେ, ଏବଂ ଆପଣଙ୍କୁ ପଢି ଶୁଣାଏ। ଆପଣ ଶୁଣି ଠିକ୍ ନ କହିବା ପର୍ଯ୍ୟନ୍ତ କିଛି ବାହାରକୁ ଯାଏ ନାହିଁ।';

  @override
  String get aboutSihTitle => 'ସ୍ମାର୍ଟ ଇଣ୍ଡିଆ ହ୍ୟାକାଥନ୍ 2025';

  @override
  String get aboutSih =>
      'ସମସ୍ୟା 090 ପାଇଁ ତିଆରି: କାରିଗର ଓ ବୁଣାକାରଙ୍କୁ ONDC ରେ କ୍ରେତାଙ୍କ ପାଖରେ ପହଞ୍ଚିବାରେ ସାହାଯ୍ୟ।';

  @override
  String get aboutMissionTitle => 'ଆମେ କ\'ଣ କରିବାକୁ ଚାହୁଁ';

  @override
  String get aboutMission =>
      'ଗୋଟିଏ କାମର ଦାମ ସେହି କାମ କରିଥିବା ଲୋକଙ୍କ ହାତରେ ହିଁ ରହୁ।';

  @override
  String get supportTitle => 'ଜଣେ ମଣିଷଙ୍କ ସହ କଥା ହୁଅନ୍ତୁ';

  @override
  String get supportBody =>
      'କିଛି କାମ ନକଲେ, କିମ୍ବା କ\'ଣ କରିବେ ବୁଝିପାରୁନଥିଲେ, ଆମକୁ ଫୋନ କରନ୍ତୁ। ଜଣେ ମଣିଷ ଆପଣଙ୍କ ଭାଷାରେ ଉତ୍ତର ଦେବେ।';

  @override
  String get supportCall => 'ଆମକୁ ଫୋନ କରନ୍ତୁ';

  @override
  String get supportWhatsApp => 'ହ୍ୱାଟସଆପରେ ମେସେଜ୍ କରନ୍ତୁ';

  @override
  String get supportHours => 'ପ୍ରତିଦିନ, ସକାଳ ନଅଟାରୁ ସନ୍ଧ୍ୟା ସାତଟା ପର୍ଯ୍ୟନ୍ତ।';

  @override
  String supportNumber(String number) {
    return 'ଆମ ନମ୍ବର $number';
  }

  @override
  String supportFailed(String number) {
    return 'ଆପଣଙ୍କ ଫୋନ ଏହା ଖୋଲିପାରିଲା ନାହିଁ। ଆମ ନମ୍ବର $number।';
  }

  @override
  String get termsTitle => 'ସର୍ତ୍ତ ଓ ଗୋପନୀୟତା';

  @override
  String get termsSummaryTitle => 'ସଂକ୍ଷେପରେ';

  @override
  String get termsSummary1 =>
      'ଆପଣ ଯାହା ତିଆରି କରନ୍ତି ଆପଣଙ୍କର। ଆମେ ଆପଣଙ୍କ ପାଇଁ ଏହାକୁ ବିକ୍ରିରେ ରଖୁ ଏବଂ ବିକ୍ରିରୁ କିଛି ନେଉନାହୁଁ।';

  @override
  String get termsSummary2 =>
      'ଆପଣଙ୍କ ଫଟୋ ଓ ସ୍ୱର କେବଳ ଆପଣଙ୍କ ତାଲିକା ଲେଖିବା ପାଇଁ ବ୍ୟବହାର ହୁଏ, ଆଉ କିଛି ପାଇଁ ନୁହେଁ।';

  @override
  String get termsSummary3 =>
      'ଆପଣଙ୍କ ନାମ, ଗାଁ ଓ କାହାଣୀ କେବଳ ଆପଣ ଅନୁମତି ଦେଇଥିବା ଜିନିଷରେ ଯାଏ, ଏବଂ ଆପଣ ତାହା ଫେରାଇନେଇପାରିବେ।';

  @override
  String get termsSummary4 =>
      'ଟଙ୍କା କ୍ରେତାଙ୍କଠାରୁ ସିଧା ଆପଣଙ୍କ ପାଖକୁ ଯାଏ। କେବେ ଆମ ଦେଇ ଯାଏ ନାହିଁ।';

  @override
  String get termsSummary5 => 'ଆପଣ ଯେକୌଣସି ସମୟରେ ଏହି ଫୋନରୁ ସବୁ ଲିଭାଇପାରିବେ।';

  @override
  String get termsFullTitle => 'ପୂରା ଲେଖା';

  @override
  String get termsFullBody =>
      'ବ୍ୟବହାରର ପୂରା ସର୍ତ୍ତ ଓ ଗୋପନୀୟତା ନୀତି ଆମ ୱେବସାଇଟରେ ଅଛି। ଏଠାରେ କିଛି ନ ବୁଝିଲେ ଆମକୁ ଫୋନ କରନ୍ତୁ, ଜଣେ ମଣିଷ ବୁଝାଇଦେବେ।';

  @override
  String get termsOpenFull => 'ପୂରା ଲେଖା ପଢନ୍ତୁ';

  @override
  String get termsAgreeTitle => 'ଆରମ୍ଭ କରିବା ପୂର୍ବରୁ';

  @override
  String get termsAgreeBody =>
      'ଆପଣ ଏହି କଥାଗୁଡ଼ିକରେ ସହମତି ଦେଉଛନ୍ତି। ଶୁଣିବାକୁ ସ୍ପିକର ଦବାନ୍ତୁ।';

  @override
  String get termsAgreeCheck => 'ମୁଁ ସର୍ତ୍ତରେ ସହମତ';

  @override
  String get termsAgreeContinue => 'ଆଗକୁ ଯାଆନ୍ତୁ';

  @override
  String get termsAgreeNeeded => 'ପ୍ରଥମେ “ମୁଁ ସର୍ତ୍ତରେ ସହମତ” ରେ ଟିକ୍ ଦିଅନ୍ତୁ।';

  @override
  String versionNumber(String version) {
    return 'ସଂସ୍କରଣ $version';
  }

  @override
  String get versionCheck => 'ନୂଆ ସଂସ୍କରଣ ଦେଖନ୍ତୁ';

  @override
  String get versionLicences => 'ଲାଇସେନ୍ସ';

  @override
  String get versionLicencesWhy => 'ଯେଉଁ ମାଗଣା ସଫ୍ଟୱେର୍ ଉପରେ ଏହି ଆପ୍ ତିଆରି।';

  @override
  String get noNetworkTitle => 'ନେଟୱର୍କ ନାହିଁ';

  @override
  String get noNetworkBody =>
      'ଆପଣ କାମ ଜାରି ରଖନ୍ତୁ। ସବୁ ଆପଣଙ୍କ ଫୋନରେ ରହେ ଏବଂ ନେଟୱର୍କ ଆସିଲେ ନିଜେ ଚାଲିଯାଏ।';

  @override
  String get noNetworkNeeded =>
      'ଏହି କାମ ପାଇଁ ନେଟୱର୍କ ଦରକାର। ସିଗନାଲ ଆସିଲେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get serverErrorTitle => 'ଆମେ ଆମ ପଟେ ପହଞ୍ଚିପାରିଲୁ ନାହିଁ';

  @override
  String get serverErrorBody =>
      'ଆପଣ କରିଥିବା କିଛି ହଜିନାହିଁ। ଦୟାକରି ଟିକେ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get actionTryAgain => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get permissionRecoveryTitle => 'ଆପ୍‌କୁ ଆପଣଙ୍କ ଅନୁମତି ଦରକାର';

  @override
  String get permissionRecoveryBody =>
      'ଫୋନ ଆପ୍‌କୁ ଏଗୁଡିକ ବ୍ୟବହାର କରିବାକୁ ଦେଉନାହିଁ। ଫୋନର ସେଟିଂସରେ ଚାଲୁ କରି ଏଠାକୁ ଫେରିପାରିବେ।';

  @override
  String get permissionCameraWhy =>
      'ଆପଣ ତିଆରି କରିଥିବା ଜିନିଷର ଫଟୋ ଉଠାଇବା ପାଇଁ। ଏହା ବିନା କିଛି ବିକ୍ରିରେ ରଖାଯାଇପାରିବ ନାହିଁ।';

  @override
  String get permissionMicWhy =>
      'ଯେପରି ଲେଖିବା ବଦଳରେ କହିପାରିବେ। ଏହା ବିନା ସବୁ ଲେଖିବାକୁ ପଡିବ।';

  @override
  String get permissionNotifyTitle => 'ସୂଚନା';

  @override
  String get permissionNotifyWhy =>
      'ଯେପରି କିଛି ବିକ୍ରି ହେଲେ ଆମେ ଜଣାଇପାରିବୁ। ଏହା ବିନା ଆପଣଙ୍କୁ ଆପ୍ ଖୋଲି ଦେଖିବାକୁ ପଡିବ।';

  @override
  String get permissionBlocked => 'ଅନୁମତି ନାହିଁ';

  @override
  String get permissionAsk => 'ପୁଣି ପଚାରନ୍ତୁ';

  @override
  String get permissionRecheck => 'ମୁଁ ଚାଲୁ କରିଦେଲି';

  @override
  String get permissionAllGood => 'ଆପ୍‌କୁ ଯାହା ଦରକାର ସବୁ ଅନୁମତି ଅଛି।';

  @override
  String get updateTitle => 'ଦୟାକରି ଆପ୍ ଅପଡେଟ୍ କରନ୍ତୁ';

  @override
  String get updateBody =>
      'ଏହି ସଂସ୍କରଣ ଆଉ ଆମ ସହ କଥା ହୋଇପାରୁନାହିଁ। ଷ୍ଟୋରରେ ନୂଆ ସଂସ୍କରଣ ଅଛି, ଏବଂ ଅପଡେଟ୍ ପରେ ବି ଆପଣଙ୍କ ଫୋନର ସବୁ ଯେମିତି ଅଛି ରହିବ।';

  @override
  String get updateAction => 'ନୂଆ ସଂସ୍କରଣ ନିଅନ୍ତୁ';

  @override
  String get updateFailed => 'ଷ୍ଟୋର ଖୋଲିଲା ନାହିଁ। ସେଠାରେ କୀର୍ତ୍ତିକର ଖୋଜନ୍ତୁ।';

  @override
  String get emptyNudge => 'ହୋମ୍‌ର ବଡ ବଟନ୍ ଦବାଇ ଆପଣଙ୍କ ପ୍ରଥମ ଜିନିଷ ଯୋଡନ୍ତୁ।';

  @override
  String get productsInProgress => 'ପ୍ରସ୍ତୁତ ହେଉଛି';

  @override
  String get productsListed => 'ବିକ୍ରିରେ';

  @override
  String get productsSold => 'ବିକ୍ରି ହେଲା';

  @override
  String get voiceTypeInstead => 'ଲେଖି କୁହନ୍ତୁ';

  @override
  String get voiceSpeakInstead => 'କହି କୁହନ୍ତୁ';

  @override
  String get voiceTypeTitle => 'ଏବେ ଲେଖନ୍ତୁ ଏହା କ\'ଣ';

  @override
  String get voiceTypeHint => 'ଏଠାରେ ଲେଖନ୍ତୁ…';

  @override
  String get voiceTypeSave => 'ଏହି ବିବରଣୀ ରଖନ୍ତୁ';

  @override
  String get errorNotAllowed =>
      'ଏହି ଖାତା ଏହା କରିପାରିବ ନାହିଁ। ସାହାଯ୍ୟ ପାଇଁ ଆମକୁ ଫୋନ କରନ୍ତୁ।';

  @override
  String get errorNotFound => 'ଏହା ଆଉ ଏଠାରେ ନାହିଁ।';

  @override
  String get errorConflict =>
      'ଏହା ଅନ୍ୟ କେଉଁଠି ବଦଳାଯାଇଛି। ଦୟାକରି ପୁଣି ଖୋଲି ଆଉ ଥରେ ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorInvalid =>
      'କିଛି ବିବରଣୀ ଗ୍ରହଣ ହେଲା ନାହିଁ। ଦୟାକରି ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get voiceGuideTitle => 'ଆପଣ ଏହି ବିଷଯରେ କହିପାରିବେ';

  @override
  String get voiceGuideWhat => 'ଜିନିଷ କ\'ଣ — ମାଠିଆ, ଶାଲ, ହାର';

  @override
  String get voiceGuideMaterial => 'କେଉଁଥିରେ ତିଆରି — ମାଟି, ରୂପା, କପା, କାଠ';

  @override
  String get voiceGuideSize => 'କେତେ ବଡ — ଇଞ୍ଚ କିମ୍ବା ସେଣ୍ଟିମିଟରରେ';

  @override
  String get voiceGuideColour => 'ଏହାର ରଙ୍ଗ ଓ କାମ';

  @override
  String get voiceGuideTime => 'ତିଆରି କରିବାକୁ କେତେ ସମଯ ଲାଗିଲା';

  @override
  String get voiceGuideCraft => 'ଏହା କେଉଁ କଳା, ଏବଂ ଆପଣଙ୍କୁ କିଏ ଶିଖାଇଲେ';

  @override
  String get voiceGuidePrice => 'ଆପଣ କେତେ ଦାମ ଚାହୁଁଛନ୍ତି';
}
