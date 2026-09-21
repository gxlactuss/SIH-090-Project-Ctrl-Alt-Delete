import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'কীর্তিকর';

  @override
  String get actionNext => 'পরের';

  @override
  String get actionBack => 'পিছনে';

  @override
  String get actionSkip => 'বাদ দিন';

  @override
  String get actionDone => 'হয়ে গেছে';

  @override
  String get actionListen => 'শুনুন';

  @override
  String get actionStopListening => 'থামান';

  @override
  String stepOfSteps(int current, int total) {
    return 'ধাপ $current, মোট $total';
  }

  @override
  String get splashTagline => 'বলুন, আর আপনার জিনিস বিক্রি হয়ে যাবে';

  @override
  String get languageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get languageHint => 'যে ভাষায় কথা বলেন, সেটিতে চাপ দিন';

  @override
  String get welcomeCard1Title => 'তিনটে ছবি তুলুন';

  @override
  String get welcomeCard1Body =>
      'আপনার বানানো জিনিসের তিনটে ছবি তুলুন। কীভাবে তুলতে হবে, অ্যাপ দেখিয়ে দেবে।';

  @override
  String get welcomeCard2Title => 'মুখে বলুন';

  @override
  String get welcomeCard2Body =>
      'এটা কী, কী দিয়ে তৈরি, দাম কত, শুধু মুখে বলুন। লেখার দরকার নেই।';

  @override
  String get welcomeCard3Title => 'এটা বিক্রিতে চলে যায়';

  @override
  String get welcomeCard3Body =>
      'আগে আপনাকে পড়ে শোনানো হবে। আপনি হ্যাঁ বললে তবেই অনলাইনে যাবে।';

  @override
  String get welcomeStart => 'শুরু করুন';

  @override
  String get permissionsTitle => 'অ্যাপের তিনটে জিনিসের অনুমতি লাগবে';

  @override
  String get permissionCameraTitle => 'ক্যামেরা';

  @override
  String get permissionCameraBody =>
      'আপনার জিনিসের ছবি তোলার জন্য। আপনি হ্যাঁ না বলা পর্যন্ত ছবি আপনার ফোনেই থাকে।';

  @override
  String get permissionMicTitle => 'মাইক';

  @override
  String get permissionMicBody => 'যাতে লেখার বদলে মুখে বলতে পারেন।';

  @override
  String get permissionNotificationTitle => 'বিজ্ঞপ্তি';

  @override
  String get permissionNotificationBody =>
      'কিছু বিক্রি হলেই যাতে সঙ্গে সঙ্গে জানাতে পারি।';

  @override
  String get permissionAllow => 'অনুমতি দিন';

  @override
  String get permissionNotNow => 'এখন না';

  @override
  String get permissionGranted => 'অনুমতি আছে';

  @override
  String get permissionDeniedTitle => 'অনুমতি পাওয়া যায়নি';

  @override
  String get permissionDeniedBody =>
      'এটা ছাড়া কাজ হবে না। ফোনের সেটিংসে গিয়ে অনুমতি দিন।';

  @override
  String get permissionOpenSettings => 'সেটিংস খুলুন';

  @override
  String get phoneTitle => 'আপনার ফোন নম্বর';

  @override
  String get phoneWhy =>
      'এই নম্বরে আমরা একটা কোড পাঠাব। এই নম্বর আর কাউকে দেওয়া হয় না।';

  @override
  String get phoneInvalid => 'দশ অঙ্কের নম্বর দিন';

  @override
  String phoneUnknown(String number) {
    return 'এই ডেমোতে এই নম্বর চলবে না। $number ব্যবহার করুন।';
  }

  @override
  String get phoneSendCode => 'কোড পাঠান';

  @override
  String get otpTitle => 'আসা কোডটা লিখুন';

  @override
  String otpSentTo(String number) {
    return '$number-এ পাঠানো হয়েছে';
  }

  @override
  String otpResendIn(int seconds) {
    return '$seconds সেকেন্ড পরে আবার পাঠান';
  }

  @override
  String get otpResend => 'কোড আবার পাঠান';

  @override
  String get otpCallMe => 'আমাকে ফোন করে বলে দিন';

  @override
  String get otpCalling => 'কিছুক্ষণের মধ্যে ফোন আসবে আর কোড পড়ে শোনানো হবে।';

  @override
  String get otpWrong => 'কোডটা ঠিক নয়। আবার লিখুন।';

  @override
  String get phoneSendFailed =>
      'কোড পাঠানো গেল না। নেটওয়ার্ক দেখে আবার চেষ্টা করুন।';

  @override
  String get otpExpired => 'কোডের সময় শেষ হয়ে গেছে। আবার পাঠান।';

  @override
  String get authTooManyTries =>
      'অনেকবার চেষ্টা হয়েছে। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get otpChangeNumber => 'নম্বর বদলান';

  @override
  String get otpAutoRead => 'মেসেজ নিজে থেকেই পড়ে নেওয়া হয়েছে';

  @override
  String get profileTitle => 'আপনার সম্পর্কে বলুন';

  @override
  String get profileNameLabel => 'আপনার নাম';

  @override
  String get profileNameHint => 'মুখে বলুন বা লিখুন';

  @override
  String get profileNameMissing => 'আপনার নাম বলুন';

  @override
  String get profileCraftLabel => 'আপনি কী বানান';

  @override
  String get profileCraftMissing => 'একটা বেছে নিন';

  @override
  String get profileSpeakToFill => 'মুখে বলুন';

  @override
  String get profileListening => 'শুনছি…';

  @override
  String get dictationUnavailable =>
      'এই ফোনে বলে লেখা চলছে না। দয়া করে লিখে দিন।';

  @override
  String get dictationNothingHeard => 'কিছু শোনা যায়নি। মাইক চেপে আবার বলুন।';

  @override
  String get craftWeaving => 'তাঁত বোনা';

  @override
  String get craftPottery => 'মাটির কাজ';

  @override
  String get craftWoodwork => 'কাঠের কাজ';

  @override
  String get craftMetalwork => 'ধাতুর কাজ';

  @override
  String get craftJewellery => 'গয়না';

  @override
  String get craftEmbroidery => 'সূচিকাজ';

  @override
  String get craftPainting => 'ছবি আঁকা';

  @override
  String get craftLeather => 'চামড়ার কাজ';

  @override
  String get craftBamboo => 'বাঁশ ও বেত';

  @override
  String get craftOther => 'অন্য কিছু';

  @override
  String get ondcTitle => 'আপনার ONDC অ্যাকাউন্ট যোগ করুন';

  @override
  String get ondcExplain =>
      'ONDC-তে ক্রেতারা আপনার জিনিস দেখেন আর কেনেন। টাকা সরাসরি আপনার কাছে যায়, আমাদের হাত দিয়ে নয়।';

  @override
  String get ondcMalformed =>
      'এটা সেলার আইডির মতো দেখাচ্ছে না। একবার দেখে নিন, বা কোডটি আবার স্ক্যান করুন।';

  @override
  String get ondcEmailLabel => 'ONDC ইমেল';

  @override
  String get ondcEmailMalformed =>
      'এটি ইমেল ঠিকানার মতো মনে হচ্ছে না। অনুগ্রহ করে এটি দেখে নিন।';

  @override
  String get ondcSellerIdLabel => 'বিক্রেতা আইডি';

  @override
  String get ondcScan => 'QR কোড স্ক্যান করুন';

  @override
  String get ondcLink => 'অ্যাকাউন্ট যোগ করুন';

  @override
  String get ondcLinking => 'যোগ করা হচ্ছে…';

  @override
  String get ondcFailed => 'এই অ্যাকাউন্ট খুঁজে পাওয়া যায়নি। আবার দেখে নিন।';

  @override
  String get ondcNoAccount => 'আমার এখনও অ্যাকাউন্ট নেই';

  @override
  String get ondcNoAccountExplain =>
      'কোনো অসুবিধা নেই। আপনি জিনিস তৈরি করে রাখতে পারেন। অ্যাকাউন্ট যোগ হলেই সব একসঙ্গে চলে যাবে।';

  @override
  String get practiceTitle => 'ভালো ছবি কীভাবে তুলবেন';

  @override
  String get practiceIntro =>
      'একই হাঁড়ি, একবার ভালোভাবে আর একবার খারাপভাবে তোলা। দুটোই দেখতে সরান।';

  @override
  String get practiceGoodBadge => 'এমন করুন';

  @override
  String get practiceGoodTitle => 'ভালো ছবি';

  @override
  String get practiceGoodTip1 => 'পরিষ্কার: ফোন স্থির রাখা হয়েছিল';

  @override
  String get practiceGoodTip2 => 'আলো: জানালা বা দরজার কাছে তোলা';

  @override
  String get practiceGoodTip3 => 'পুরো জিনিসটা ছবিতে আছে';

  @override
  String get practiceBadBadge => 'এমন করবেন না';

  @override
  String get practiceBadTitle => 'খারাপ ছবি';

  @override
  String get practiceBadTip1 => 'ঝাপসা: ফোন নড়ে গেছে';

  @override
  String get practiceBadTip2 => 'ক্রেতারা খুঁটিনাটি দেখতে পান না';

  @override
  String get practiceBadTip3 => 'অ্যাপ আপনাকে আবার ছবি তুলতে বলবে';

  @override
  String get practiceFinish => 'অ্যাপ খুলুন';

  @override
  String get navHome => 'হোম';

  @override
  String get navListings => 'জিনিস';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String homeGreeting(String name) {
    return 'নমস্কার, $name';
  }

  @override
  String get homeAddProduct => 'জিনিস যোগ করুন';

  @override
  String get homeAddProductSpoken =>
      'জিনিস যোগ করতে এই বড় বোতামটা চাপুন। তিনটে ছবি তুলুন, মুখে বলুন এটা কী, আর এটা বিক্রিতে চলে যাবে।';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি জিনিস পাঠানো বাকি',
      one: '১টি জিনিস পাঠানো বাকি',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বিক্রি হয়েছে',
      one: '১টি বিক্রি হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'আপনার সাম্প্রতিক জিনিস';

  @override
  String get homeNextTitle => 'এখন এটা করতে হবে';

  @override
  String get homeEmptyTitle => 'এখানে এখনও কিছু নেই';

  @override
  String get homeEmptyBody =>
      'উপরের বড় বোতাম চেপে আপনার প্রথম জিনিস যোগ করুন।';

  @override
  String get offlineNoNetwork => 'এখন নেটওয়ার্ক নেই';

  @override
  String get offlineNothingLost =>
      'কিছুই হারায়নি। নেটওয়ার্ক এলে নিজে থেকেই চলে যাবে।';

  @override
  String get statusQueued => 'পাঠানো বাকি';

  @override
  String get statusProcessing => 'তৈরি হচ্ছে';

  @override
  String get statusNeedsAttention => 'আপনার উত্তর দরকার';

  @override
  String get statusReady => 'বিক্রির জন্য তৈরি';

  @override
  String get statusPublished => 'বিক্রিতে আছে';

  @override
  String get statusFailed => 'পাঠানো যায়নি';

  @override
  String get listingUntitled => 'জিনিস';

  @override
  String get listingNoPrice => 'দাম বলা হয়নি';

  @override
  String get captureTitle => 'জিনিস যোগ করুন';

  @override
  String capturePhotoStep(int current, int total) {
    return 'ছবি $current / $total';
  }

  @override
  String get capturePhotoWhole => 'পুরো জিনিসটা দেখান';

  @override
  String get capturePhotoDetail => 'কাছ থেকে একটা ছবি তুলুন';

  @override
  String get capturePhotoScale => 'পাশে হাত রাখুন, যাতে মাপ বোঝা যায়';

  @override
  String get captureTakePhoto => 'ছবি তুলুন';

  @override
  String get captureFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get captureTorchOn => 'আলো জ্বালান';

  @override
  String get captureTorchOff => 'আলো নেভান';

  @override
  String get captureCameraFailed => 'ক্যামেরা খোলেনি';

  @override
  String get captureCameraRetry => 'আবার চেষ্টা করুন';

  @override
  String get captureCameraPermission =>
      'আপনার জিনিসের ছবি তুলতে অ্যাপের ক্যামেরা লাগবে।';

  @override
  String get captureOpenSettings => 'সেটিংস খুলুন';

  @override
  String get captureLeaveTitle => 'সেভ না করে বেরিয়ে যাবেন?';

  @override
  String get captureLeaveBody => 'ছবি আর আপনি যা বলেছেন সব মুছে যাবে।';

  @override
  String get captureLeaveConfirm => 'মুছে ফেলুন';

  @override
  String get captureLeaveCancel => 'এখানেই থাকুন';

  @override
  String get shotReviewChecking => 'ছবিটা দেখা হচ্ছে…';

  @override
  String get shotReviewRetake => 'আবার তুলুন';

  @override
  String get qualityTooDark => 'ছবিটা খুব অন্ধকার। দরজার কাছে দাঁড়িয়ে তুলুন।';

  @override
  String get qualityTooBright => 'এতে খুব বেশি আলো। রোদের দিকে পিঠ করে তুলুন।';

  @override
  String get qualityBlurry => 'ছবিটা পরিষ্কার নয়। ফোন স্থির রেখে আবার তুলুন।';

  @override
  String get qualityUnreadable =>
      'ছবিটা ঠিকমতো সেভ হয়নি। দয়া করে আবার তুলুন।';

  @override
  String get qualityNoSubject =>
      'এই ছবিতে জিনিসটা দেখা যাচ্ছে না। ওটাকে দাগের ভিতরে রাখুন আর কাছে আসুন।';

  @override
  String get qualityOutOfFrame =>
      'এই ছবিতে জিনিসের শুধু একটা অংশ আছে। পুরো জিনিসটা দাগের ভিতরে রাখুন।';

  @override
  String get qualityWarningTitle => 'এটা আবার তুলুন';

  @override
  String get qualityKeepAnyway => 'তবুও রাখুন';

  @override
  String get photoSetTitle => 'আপনার তিনটে ছবি';

  @override
  String get photoSetBody =>
      'প্রথম ছবিটাই ক্রেতারা সবার আগে দেখেন। কোনো ছবি আবার তুলতে সেটায় চাপ দিন।';

  @override
  String get photoSetMain => 'প্রথম ছবি';

  @override
  String get photoSetRetakeThis => 'এটা আবার তুলুন';

  @override
  String get photoSetConfirm => 'এই ছবিগুলো ঠিক আছে';

  @override
  String get photoEditOpen => 'ছবি কাটুন বা ঘোরান';

  @override
  String get photoEditTitle => 'ছবি কাটুন';

  @override
  String get photoEditBody =>
      'কাটতে বাক্সের কোণ বা ধার টানুন। সরাতে বাক্সের ভেতর থেকে টানুন।';

  @override
  String get photoEditTurn => 'ঘোরান';

  @override
  String get photoEditStraighten => 'সোজা করুন';

  @override
  String get photoEditReset => 'আবার শুরু করুন';

  @override
  String get photoEditDone => 'এই ছবিটা নিন';

  @override
  String get photoEditCancel => 'ফিরে যান';

  @override
  String get photoEditFailed => 'এই বদলটা রাখা গেল না। আবার চেষ্টা করুন।';

  @override
  String get photoIssueTooDark => 'খুব অন্ধকার, ঠিকমতো দেখা যায় না';

  @override
  String get photoIssueTooBright => 'এতে খুব বেশি আলো';

  @override
  String get photoIssueBlurry => 'ঝাপসা, যথেষ্ট পরিষ্কার নয়';

  @override
  String get photoIssueNoSubject => 'এই ছবিতে কোনো জিনিস দেখা যাচ্ছে না';

  @override
  String get photoIssueUnreadable => 'এই ছবিটা সেভ হয়নি';

  @override
  String get photoIssueOutOfFrame => 'জিনিসটা পুরোটা ছবিতে নেই';

  @override
  String get voiceTitle => 'এবার মুখে বলুন এটা কী';

  @override
  String get voiceBody =>
      'এটা কী, কী দিয়ে তৈরি, কত বড়, বানাতে কত সময় লেগেছে, আর দাম কত।';

  @override
  String get voiceHoldToSpeak => 'চেপে ধরে বলুন';

  @override
  String get voiceRecording => 'বলুন… বলা শেষ হলে ছেড়ে দিন';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$total সেকেন্ডের মধ্যে $seconds';
  }

  @override
  String get voiceTooShort => 'এটা খুব ছোট ছিল। বোতাম চেপে ধরে আবার বলুন।';

  @override
  String get voiceFailed =>
      'মাইক চালু হয়নি। অ্যাপের মাইক ব্যবহারের অনুমতি আছে কিনা দেখুন।';

  @override
  String get voiceBackToPhotos => 'ছবিতে ফিরে যান';

  @override
  String get playbackPlay => 'শুনুন';

  @override
  String get playbackStop => 'থামান';

  @override
  String get playbackAgain => 'আবার বলুন';

  @override
  String get playbackAccept => 'এটা ঠিক আছে';

  @override
  String get playbackUnavailable =>
      'এই ফোন এটা বাজাতে পারছে না। আপনি তবুও পাঠাতে পারেন, অথবা আবার বলতে পারেন।';

  @override
  String get savedTitle => 'সেভ হয়েছে';

  @override
  String get savedBody => 'নেটওয়ার্ক এলে নিজে থেকেই চলে যাবে।';

  @override
  String get savedBodyOnline =>
      'এখন পাঠানো হচ্ছে। আপনাকে এখানে অপেক্ষা করতে হবে না।';

  @override
  String get savedAddAnother => 'আরেকটা জিনিস যোগ করুন';

  @override
  String get savedGoHome => 'হোমে যান';

  @override
  String get saveFailed => 'এই ফোনে সেভ করা যায়নি। হয়তো জায়গা নেই।';

  @override
  String get saveRetry => 'আবার সেভ করার চেষ্টা করুন';

  @override
  String get queueTitle => 'পাঠানো বাকি';

  @override
  String get queueBody =>
      'এখানে কিছুই হারায়নি। নেটওয়ার্ক এলেই প্রতিটি চলে যাবে।';

  @override
  String get queueEmptyTitle => 'কিছুই বাকি নেই';

  @override
  String get queueEmptyBody => 'আপনার বানানো সব পাঠানো হয়ে গেছে।';

  @override
  String get queueStateWaiting => 'নেটওয়ার্কের অপেক্ষায়';

  @override
  String queueStateUploading(int percent) {
    return 'পাঠানো হচ্ছে… একশোর মধ্যে $percent';
  }

  @override
  String get queueStateProcessing => 'এখন আমাদের কাছে। আমরা লিখে নিচ্ছি।';

  @override
  String get queueStateFailed => 'যায়নি। কারণ দেখতে চাপ দিন।';

  @override
  String get queueItemTitle => 'এই জিনিস';

  @override
  String queueMadeAt(String date) {
    return '$date তারিখে বানানো';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার চেষ্টা হয়েছে',
      one: 'একবার চেষ্টা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'এখনই পাঠানোর চেষ্টা করুন';

  @override
  String get queueRetryWaiting => 'এখনও নেটওয়ার্ক নেই। নিজে থেকেই চলে যাবে।';

  @override
  String get queueDelete => 'এই জিনিস মুছে ফেলুন';

  @override
  String get queueDeleteTitle => 'এই জিনিস মুছে ফেলবেন?';

  @override
  String get queueDeleteBody =>
      'ছবি আর আপনি যা বলেছেন সব মুছে যাবে। এটা আর ফেরত আসবে না।';

  @override
  String get queueDeleteConfirm => 'হ্যাঁ, মুছে ফেলুন';

  @override
  String get queueDeleteCancel => 'না, রেখে দিন';

  @override
  String get failureNetwork =>
      'নেটওয়ার্ক মাঝপথে থেমে গেছে। সিগন্যাল এলে নিজে থেকেই আবার যাবে।';

  @override
  String get failureServer =>
      'আমাদের দিক থেকে উত্তর আসেনি। আবার চেষ্টা করা হবে।';

  @override
  String get failureMissingFiles =>
      'ছবিগুলো আর এই ফোনে নেই, তাই এটা পাঠানো যাবে না। দয়া করে আবার বানান।';

  @override
  String get failureRejected => 'এটা গ্রহণ করা যায়নি। দয়া করে আবার বানান।';

  @override
  String get failureUnknown =>
      'কিছু একটা ভুল হয়েছে। আপনি আবার চেষ্টা করতে পারেন।';

  @override
  String get processingTitle => 'আমরা লিখে নিচ্ছি';

  @override
  String get processingBody =>
      'আপনার ছবি আর কথা আমাদের কাছে আছে। এতে কয়েক মিনিট লাগে।';

  @override
  String get processingLeave =>
      'আপনাকে এখানে অপেক্ষা করতে হবে না। তৈরি হলে আমরা জানাব।';

  @override
  String get processingGoHome => 'হোমে যান';

  @override
  String get attentionTitle => 'একটা প্রশ্ন';

  @override
  String get attentionBody => 'বাকি সব আমরা বুঝেছি। শুধু এটাই বাকি।';

  @override
  String get attentionHoldToAnswer => 'চেপে ধরে উত্তর দিন';

  @override
  String get attentionAnswering => 'আপনার উত্তর পাঠানো হচ্ছে…';

  @override
  String get attentionFailed => 'আপনার উত্তর যায়নি। দয়া করে আবার বলুন।';

  @override
  String get attentionRetakePhotos => 'ছবিগুলো আবার তুলুন';

  @override
  String get attentionRetakeSending => 'আপনার নতুন ছবি পাঠানো হচ্ছে…';

  @override
  String get attentionRetakeFailed =>
      'নতুন ছবি যায়নি। দয়া করে আবার চেষ্টা করুন।';

  @override
  String get readBackTitle => 'আমরা এটা বুঝেছি';

  @override
  String get readBackListen => 'পুরোটা শুনুন';

  @override
  String get readBackFields => 'আমরা যা লিখেছি';

  @override
  String get readBackCorrect => 'যা ভুল তাতে চাপ দিন';

  @override
  String get readBackApprove => 'এসব ঠিক আছে';

  @override
  String get notSaid => 'বলা হয়নি';

  @override
  String get fieldMaterial => 'কী দিয়ে তৈরি';

  @override
  String get fieldSize => 'মাপ';

  @override
  String get fieldColour => 'রং';

  @override
  String get fieldTechnique => 'কীভাবে বানানো';

  @override
  String get fieldOrigin => 'কোথায় বানানো';

  @override
  String get fieldQuantity => 'কতগুলো';

  @override
  String get fieldPrice => 'দাম';

  @override
  String correctTitle(String field) {
    return 'সঠিক $field বলুন';
  }

  @override
  String get correctHoldToSpeak => 'চেপে ধরে বলুন';

  @override
  String get correctListening => 'শুনছি…';

  @override
  String get correctFailedOnce => 'আমরা বুঝতে পারিনি। আরেকবার বলুন।';

  @override
  String get correctUseKeypad => 'বদলে লিখুন';

  @override
  String get correctUseVoice => 'বদলে মুখে বলুন';

  @override
  String get correctPick => 'অথবা একটা বেছে নিন';

  @override
  String get correctSave => 'এটা সেভ করুন';

  @override
  String get correctCancel => 'যেমন আছে থাক';

  @override
  String get correctTypeHint => 'উত্তর এখানে লিখুন';

  @override
  String correctHeard(Object text) {
    return 'আমরা শুনলাম “$text”';
  }

  @override
  String get listingCancelAction => 'এই তালিকাটি বাতিল করুন';

  @override
  String get listingCancelTitle => 'এই তালিকাটি বাতিল করবেন?';

  @override
  String get listingCancelBody =>
      'ছবি, রেকর্ডিং আর আপনার বলা সব কিছু মুছে যাবে। এটি আর ফিরবে না।';

  @override
  String get listingCancelConfirm => 'হ্যাঁ, বাতিল করুন';

  @override
  String get listingCancelKeep => 'না, থাক';

  @override
  String get photoSaveAction => 'ছবি সংরক্ষণ করুন';

  @override
  String get photoSaved => 'আপনার ছবিতে সংরক্ষণ হয়েছে';

  @override
  String get photoSaveFailed => 'ছবি সংরক্ষণ করা গেল না';

  @override
  String get photoSaveDenied => 'ছবি সংরক্ষণ করতে অনুমতি দিন';

  @override
  String get colourRed => 'লাল';

  @override
  String get colourBlue => 'নীল';

  @override
  String get colourGreen => 'সবুজ';

  @override
  String get colourYellow => 'হলুদ';

  @override
  String get colourBlack => 'কালো';

  @override
  String get colourWhite => 'সাদা';

  @override
  String get colourBrown => 'বাদামি';

  @override
  String get colourMulti => 'অনেক রং';

  @override
  String get sizeSmall => 'ছোট';

  @override
  String get sizeMedium => 'মাঝারি';

  @override
  String get sizeLarge => 'বড়';

  @override
  String get sizeExtraLarge => 'খুব বড়';

  @override
  String get suggestTitle => 'এটাও যোগ করব?';

  @override
  String get suggestYes => 'হ্যাঁ, যোগ করুন';

  @override
  String get suggestNo => 'না, বাদ দিন';

  @override
  String get suggestSkip => 'আমি ঠিক জানি না';

  @override
  String suggestProgress(int current, int total) {
    return '$total-এর মধ্যে $current';
  }

  @override
  String get suggestDone => 'আর কিছু যোগ করার নেই';

  @override
  String get priceTitle => 'দাম কত?';

  @override
  String get priceBody => 'এটা একটা জিনিসের দাম।';

  @override
  String priceFloor(String amount) {
    return 'আপনার খরচ: $amount';
  }

  @override
  String get priceFloorExplain =>
      'আপনার জিনিসপত্র আর আপনার সময় মিলিয়ে এত হয়। এর কমে বিক্রি করলে আপনার লোকসান হবে।';

  @override
  String priceBand(String low, String high) {
    return 'এমন জিনিস অন্যরা $low থেকে $high-এ বিক্রি করেন';
  }

  @override
  String get priceBelowFloor =>
      'এটা আপনার খরচের চেয়ে কম। তবুও আপনি এটাই রাখতে পারেন।';

  @override
  String get priceSayIt => 'দাম বলুন';

  @override
  String get priceConfirm => 'এই দাম ঠিক আছে';

  @override
  String get stockTitle => 'আপনার কাছে কতগুলো আছে?';

  @override
  String get stockBody => 'সব বিক্রি হয়ে গেলে আমরা আপনার হয়ে এটা সরিয়ে দেব।';

  @override
  String get stockOneOfAKind => 'একটাই আছে, আর এমন আর কখনো হবে না';

  @override
  String get stockMore => 'আরেকটা বেশি';

  @override
  String get stockLess => 'একটা কম';

  @override
  String get stockConfirm => 'এটা ঠিক আছে';

  @override
  String get photosTitle => 'কোন ছবিটা আগে আসবে?';

  @override
  String get photosBody => 'ক্রেতারা প্রথম ছবিটাই সবার আগে দেখেন।';

  @override
  String get photosMakeFirst => 'এটাকে প্রথম ছবি করুন';

  @override
  String get photosFirst => 'প্রথম ছবি';

  @override
  String get photosConfirm => 'এই ছবিগুলো ঠিক আছে';

  @override
  String get previewTitle => 'ক্রেতারা এটা দেখবেন';

  @override
  String get previewListenAll => 'সবটা শুনুন';

  @override
  String get previewNoDescription => 'কোনো বিবরণ লেখা হয়নি।';

  @override
  String get previewConfirm => 'হ্যাঁ, এটা ঠিক আছে';

  @override
  String get previewChange => 'কিছু বদলান';

  @override
  String get consentTitle => 'আমরা কি এটা বিক্রিতে তুলব?';

  @override
  String get consentPhoto => 'আমার ছবি দেখান';

  @override
  String get consentPhotoExplain => 'আপনার জিনিসের ছবি ক্রেতার স্ক্রিনে যাবে।';

  @override
  String get consentStory => 'আমার কারিগরির গল্প দেখান';

  @override
  String get consentStoryExplain =>
      'আপনার নাম, আপনার গ্রাম আর আপনি কীভাবে বানান, তা কারিগর কার্ডে যাবে। না বললেও আপনি বিক্রি করতে পারবেন।';

  @override
  String get consentNeeded => 'ছবি ছাড়া আমরা এটা তুলতে পারব না।';

  @override
  String get consentPublish => 'বিক্রিতে তুলুন';

  @override
  String get publishingTitle => 'বিক্রিতে তোলা হচ্ছে';

  @override
  String get publishingBody => 'একটু সময় লাগবে। অ্যাপ বন্ধ করবেন না।';

  @override
  String get publishedTitle => 'এটা বিক্রিতে উঠেছে';

  @override
  String get publishedBody => 'ক্রেতারা এখন এটা দেখতে পাচ্ছেন।';

  @override
  String get publishedShare => 'হোয়াটসঅ্যাপে পাঠান';

  @override
  String get publishedCopyLink => 'লিঙ্ক কপি করুন';

  @override
  String get publishedLinkCopied => 'লিঙ্ক কপি হয়েছে';

  @override
  String get publishedShowQr => 'স্ক্যান করার কোড দেখান';

  @override
  String get publishedQrExplain =>
      'যে কেউ এর দিকে ফোন ধরে আপনার জিনিস খুলতে পারবেন।';

  @override
  String get publishedAnother => 'এরকম আরেকটা বানান';

  @override
  String get publishedDone => 'হোমে যান';

  @override
  String get publishFailed =>
      'এটা তোলা যায়নি। কিছুই হারায়নি, আপনি আবার চেষ্টা করতে পারেন।';

  @override
  String get publishRetry => 'আবার চেষ্টা করুন';

  @override
  String get reviewLeaveTitle => 'এখনকার মতো ছেড়ে দেবেন?';

  @override
  String get reviewLeaveBody =>
      'আপনি যা মঞ্জুর করেছেন তা থাকবে। আপনার জিনিসের তালিকা থেকে আবার ফিরে আসতে পারবেন।';

  @override
  String get reviewLeaveConfirm => 'এখনকার মতো ছেড়ে দিন';

  @override
  String get editLeaveTitle => 'আপনার বদল এখনও বিক্রিতে নেই';

  @override
  String get editLeaveBody =>
      'আপনার বদল সেভ হয়েছে, কিন্তু ক্রেতারা এখনও পুরনোটাই দেখছেন। শেষ বোতামটা চাপলে তবেই এটা আবার বিক্রিতে যাবে।';

  @override
  String get editLeaveConfirm => 'ঠিক আছে, পরে করব';

  @override
  String get reviewLeaveCancel => 'চালিয়ে যান';

  @override
  String get statusSoldOut => 'সব বিক্রি হয়ে গেছে';

  @override
  String get statusUnpublished => 'সরিয়ে নেওয়া হয়েছে';

  @override
  String get listingsTitle => 'আপনার জিনিস';

  @override
  String get listingsEmptyTitle => 'আপনি এখনও কিছু বানাননি';

  @override
  String get listingsEmptyBody =>
      'হোমের বড় বোতাম চেপে আপনার প্রথম জিনিস যোগ করুন।';

  @override
  String get listingsEmptyFilter => 'এখানে কিছু নেই।';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বাকি',
      one: '১টি বাকি',
      zero: 'কিছুই বাকি নেই',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার দেখা হয়েছে',
      one: 'একবার দেখা হয়েছে',
      zero: 'এখনও কেউ দেখেননি',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'কতগুলো আছে বদলান';

  @override
  String get listingTitle => 'এই জিনিস';

  @override
  String get listingOpenPreview => 'ক্রেতারা যা দেখেন দেখুন';

  @override
  String get listingEdit => 'কিছু বদলান';

  @override
  String get listingDuplicate => 'এরকম আরেকটা বানান';

  @override
  String get listingUnpublish => 'বিক্রি থেকে সরান';

  @override
  String get listingRelist => 'আবার বিক্রিতে তুলুন';

  @override
  String get listingFinish => 'এটা শেষ করুন';

  @override
  String get listingSoldOutTitle => 'এগুলো সব বিক্রি হয়ে গেছে';

  @override
  String get listingSoldOutBody =>
      'আমরা আপনার হয়ে এটা বিক্রি থেকে সরিয়ে দিয়েছি। আরও বানালে আবার তুলুন।';

  @override
  String get editTitle => 'এই জিনিস বদলান';

  @override
  String get editBody =>
      'আপনি আবার এটা দেখে নেবেন, তারপর এটা আবার বিক্রিতে যাবে।';

  @override
  String get editRepublishing => 'বদল বিক্রিতে তোলা হচ্ছে…';

  @override
  String get editRepublished => 'আপনার বদল এখন বিক্রিতে';

  @override
  String get editRepublishConfirm => 'বদল আবার বিক্রিতে তুলুন';

  @override
  String get quickStockTitle => 'কতগুলো বাকি আছে?';

  @override
  String get quickStockMarkSoldOut => 'সব বিক্রি হয়ে গেছে';

  @override
  String get quickStockSave => 'সেভ করুন';

  @override
  String get quickStockSaved => 'সেভ হয়েছে';

  @override
  String get actionUndo => 'আগের মতো করুন';

  @override
  String get unpublishTitle => 'বিক্রি থেকে সরাবেন?';

  @override
  String get unpublishBody =>
      'ক্রেতারা আর এটা দেখতে পাবেন না। কিছুই মোছা হবে না, আর আপনি যখন খুশি আবার তুলতে পারবেন।';

  @override
  String get unpublishConfirm => 'হ্যাঁ, সরিয়ে দিন';

  @override
  String get unpublishCancel => 'না, বিক্রিতে থাক';

  @override
  String get unpublishDone => 'বিক্রি থেকে সরানো হয়েছে';

  @override
  String get relistDone => 'এটা আবার বিক্রিতে';

  @override
  String get duplicateTitle => 'এরকম আরেকটা বানাবেন?';

  @override
  String get duplicateBody =>
      'আপনি এটা নিয়ে যা বলেছেন আমরা রেখে দেব। আপনাকে শুধু নতুন ছবি তুলতে হবে।';

  @override
  String get duplicateConfirm => 'ছবি তুলুন';

  @override
  String get duplicateCancel => 'এখন না';

  @override
  String get duplicateBanner =>
      'আগেরটার মতো আরেকটা বানানো হচ্ছে। শুধু ছবিগুলো নতুন।';

  @override
  String get listingActionFailed => 'এটা হয়নি। দয়া করে আবার চেষ্টা করুন।';

  @override
  String get salesNew => 'নতুন';

  @override
  String get salesEmptyTitle => 'এখনও কিছু বিক্রি হয়নি';

  @override
  String get salesEmptyBody =>
      'কেউ কিছু কিনলে এখানে দেখা যাবে আর আমরা আপনাকে জানাব।';

  @override
  String get salesLoading => 'কী বিক্রি হয়েছে দেখা হচ্ছে…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি',
      one: '১টি',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return '$date-এর মধ্যে প্যাক করুন';
  }

  @override
  String get salesPackByToday => 'আজই প্যাক করুন';

  @override
  String get salesPackByTomorrow => 'কালকের মধ্যে প্যাক করুন';

  @override
  String get salesPackedAlready => 'এটার তারিখ পেরিয়ে গেছে';

  @override
  String get saleTitle => 'এই অর্ডার';

  @override
  String get saleReadOnly =>
      'এটা শুধু আপনাকে জানানোর জন্য। অর্ডারের সব কাজ বাজারে হয়, এই অ্যাপে নয়।';

  @override
  String salePaid(String amount) {
    return 'আপনি $amount পাবেন';
  }

  @override
  String salePlaced(String date) {
    return '$date তারিখে বিক্রি হয়েছে';
  }

  @override
  String saleGoingTo(String area) {
    return '$area-তে যাচ্ছে';
  }

  @override
  String get saleWhatToPack => 'কী প্যাক করবেন';

  @override
  String get salePackingHelp => 'কীভাবে প্যাক করবেন';

  @override
  String get saleSeeListing => 'এই জিনিস দেখুন';

  @override
  String get packingTitle => 'কীভাবে প্যাক করবেন';

  @override
  String get packingBody => 'একটা একটা করে করুন। যেটা হয়ে যাবে তাতে চাপ দিন।';

  @override
  String get packingStep1 => 'কাপড়ে বা কাগজে মুড়ে দিন, যাতে কিছু ঘষা না লাগে';

  @override
  String get packingStep2 =>
      'চারপাশে কাগজ বা খড় ভরে দিন, যাতে বাক্সে নড়াচড়া না করে';

  @override
  String get packingStep3 => 'ভিতরে ঠিক সংখ্যক জিনিস আছে কিনা দেখুন';

  @override
  String get packingStep4 => 'বাক্স বন্ধ করে চারদিকে টেপ লাগান';

  @override
  String get packingStep5 => 'যিনি নিতে আসবেন তাঁর জন্য তৈরি রাখুন';

  @override
  String get packingDone => 'সব হয়ে গেছে';

  @override
  String packingProgress(int done, int total) {
    return '$total-এর মধ্যে $done হয়েছে';
  }

  @override
  String get earningsTitle => 'আপনি কত আয় করেছেন';

  @override
  String get earningsWeek => 'এই সপ্তাহে';

  @override
  String get earningsMonth => 'এই মাসে';

  @override
  String get earningsTotal => 'শুরু থেকে';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বিক্রি হয়েছে',
      one: '১টি বিক্রি হয়েছে',
      zero: 'এখনও কিছু বিক্রি হয়নি',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'বাজার তার ভাগ নেওয়ার পরে আপনার কাছে যা আসে, এটা তাই।';

  @override
  String get profileVillageLabel => 'গ্রাম বা ক্লাস্টার';

  @override
  String get profileNotSet => 'দেওয়া হয়নি';

  @override
  String get profileEditEntry => 'আপনার তথ্য বদলান';

  @override
  String get profileStoryEntry => 'আপনার কারিগরির গল্প';

  @override
  String get profileLanguageEntry => 'ভাষা';

  @override
  String get profilePhoneEntry => 'ফোন নম্বর';

  @override
  String get profileOndcEntry => 'আপনার বিক্রির অ্যাকাউন্ট';

  @override
  String get profileNotificationsEntry => 'আমরা আপনাকে কী জানাব';

  @override
  String get profileVoiceEntry => 'আওয়াজ ও শোনা';

  @override
  String get profilePrivacyEntry => 'আপনার সম্পর্কে কী দেখা যায়';

  @override
  String get profileStorageEntry => 'এই ফোনের জায়গা';

  @override
  String get profileAccountEntry => 'সাইন আউট';

  @override
  String get editProfileTitle => 'আপনার তথ্য';

  @override
  String get editProfileAddPhoto => 'আপনার একটা ছবি দিন';

  @override
  String get editProfileChangePhoto => 'ছবি বদলান';

  @override
  String get editProfileRemovePhoto => 'ছবি সরান';

  @override
  String get editProfilePhotoWhy =>
      'আপনি অনুমতি দিলে তবেই ক্রেতারা এটা কারিগর কার্ডে দেখবেন।';

  @override
  String get editProfileVillageHint => 'মুখে বলুন বা লিখুন';

  @override
  String get editProfileSave => 'সেভ করুন';

  @override
  String get editProfileSaved => 'সেভ হয়েছে';

  @override
  String get storyTitle => 'আপনার কারিগরির গল্প';

  @override
  String get storyBody =>
      'ক্রেতাদের বলুন আপনি কে আর কীভাবে বানান। আপনি মুখে বলুন, আমরা লিখে নেব।';

  @override
  String get storyHoldToSpeak => 'চেপে ধরে আপনার গল্প বলুন';

  @override
  String get storyEmpty => 'আপনি এখনও আপনার গল্প বলেননি।';

  @override
  String get storyEditHint => 'আপনি এর যেকোনো শব্দ বদলাতে পারেন।';

  @override
  String get storyExample =>
      'যেমন: আমাদের পরিবারে তিন পুরুষ ধরে এগুলো বানানো হয়, আর আমি আজও আমার দাদুর তাঁতে কাজ করি।';

  @override
  String get changePhoneTitle => 'আপনার নম্বর বদলান';

  @override
  String get changePhoneBody =>
      'নম্বরটা যে আপনারই, তা নিশ্চিত করতে আমরা নতুন নম্বরে একটা কোড পাঠাব।';

  @override
  String changePhoneCurrent(String number) {
    return 'এখন আপনার নম্বর $number';
  }

  @override
  String get changePhoneDone => 'আপনার নম্বর বদলে গেছে';

  @override
  String get ondcAccountTitle => 'আপনার বিক্রির অ্যাকাউন্ট';

  @override
  String get ondcAccountLinked => 'আপনার অ্যাকাউন্ট যোগ করা আছে';

  @override
  String get ondcAccountNone => 'এখনও কোনো অ্যাকাউন্ট যোগ হয়নি';

  @override
  String get ondcAccountNoneBody =>
      'আপনি জিনিস বানাতে থাকুন। অ্যাকাউন্ট যোগ হলেই সেগুলো বিক্রিতে চলে যাবে।';

  @override
  String get ondcAccountLink => 'অ্যাকাউন্ট যোগ করুন';

  @override
  String get ondcAccountUnlink => 'এই অ্যাকাউন্ট সরান';

  @override
  String get ondcUnlinkTitle => 'এই অ্যাকাউন্ট সরাবেন?';

  @override
  String get ondcUnlinkBody =>
      'বিক্রিতে থাকা সব নেমে যাবে। আপনার বানানো কিছুই মোছা হবে না, আর আপনি আবার যোগ করতে পারবেন।';

  @override
  String get ondcUnlinkConfirm => 'হ্যাঁ, সরিয়ে দিন';

  @override
  String get ondcUnlinkCancel => 'না, রেখে দিন';

  @override
  String get ondcUnlinkDone => 'অ্যাকাউন্ট সরানো হয়েছে';

  @override
  String get notificationsTitle => 'আমরা আপনাকে কী জানাব';

  @override
  String get notifySold => 'কিছু বিক্রি হলে';

  @override
  String get notifySoldWhy =>
      'ক্রেতা টাকা দিলেই আমরা জানাব, যাতে আপনি প্যাক করা শুরু করতে পারেন।';

  @override
  String get notifyAttention => 'আপনাকে কিছু জিজ্ঞেস করার দরকার হলে';

  @override
  String get notifyAttentionWhy =>
      'কখনো কখনো জিনিস বিক্রিতে যাওয়ার আগে একটা কথা বাকি থাকে।';

  @override
  String get notifyUpload => 'জিনিস পাঠানো হয়ে গেলে';

  @override
  String get notifyUploadWhy =>
      'ফোনে যা বানিয়েছেন তা আমাদের কাছে পৌঁছলে জানাব।';

  @override
  String get notifyPackBy => 'যখন প্যাক করার সময় হবে';

  @override
  String get notifyPackByWhy =>
      'যে বিক্রি প্যাক করতে হবে, তার তারিখের এক দিন আগে আর সেই দিন আমরা আপনাকে মনে করিয়ে দেব।';

  @override
  String get notificationsBlocked =>
      'এই ফোন আমাদের কিছু পাঠাতে দিচ্ছে না। ফোনের সেটিংসে গিয়ে এটা চালু করতে পারেন।';

  @override
  String get voiceSettingsTitle => 'আওয়াজ ও শোনা';

  @override
  String get voiceSpeed => 'আমরা কত তাড়াতাড়ি বলব';

  @override
  String get voiceSpeedSlow => 'ধীরে';

  @override
  String get voiceSpeedFast => 'তাড়াতাড়ি';

  @override
  String get voiceTry => 'এখন কিছু বলে শোনান';

  @override
  String get voiceSample => 'আমরা আপনার সঙ্গে এই গতিতে কথা বলব।';

  @override
  String get voiceAutoRead => 'প্রতিটি স্ক্রিন খুললেই পড়ে শোনান';

  @override
  String get voiceAutoReadWhy =>
      'এটা বন্ধ থাকলে আপনি স্পিকারে চাপ দিলে তবেই আমরা বলি।';

  @override
  String get voiceUnavailable =>
      'এই ফোন কথা বলতে পারে না। সব কাজ চলবে, কিন্তু কিছু পড়ে শোনানো হবে না।';

  @override
  String get privacyTitle => 'আপনার সম্পর্কে কী দেখা যায়';

  @override
  String get privacyBody =>
      'প্রতিটি জিনিস বিক্রিতে তোলার সময় আপনি এগুলোতে হ্যাঁ বলেছিলেন। আপনি যেকোনোটা ফিরিয়ে নিতে পারেন।';

  @override
  String get privacyPhoto => 'এই জিনিসের ছবি';

  @override
  String get privacyStory => 'আপনার নাম, গ্রাম আর গল্প';

  @override
  String get privacyNothing => 'এখন আপনার কিছুই বিক্রিতে নেই।';

  @override
  String get privacyWithdrawTitle => 'এটা ফিরিয়ে নেবেন?';

  @override
  String get privacyWithdrawPhotoBody =>
      'ছবি ছাড়া এই জিনিস বিক্রিতে থাকতে পারবে না, তাই এটা নেমে যাবে। কিছুই মোছা হবে না।';

  @override
  String get privacyWithdrawStoryBody =>
      'আপনার নাম, গ্রাম আর গল্প এই জিনিস থেকে সরিয়ে দেওয়া হবে। এটা বিক্রিতে থাকবে।';

  @override
  String get privacyWithdrawConfirm => 'হ্যাঁ, ফিরিয়ে নিন';

  @override
  String get privacyWithdrawCancel => 'না, থাক';

  @override
  String get privacyWithdrawn => 'ফিরিয়ে নেওয়া হয়েছে';

  @override
  String get storageTitle => 'এই ফোনের জায়গা';

  @override
  String get storagePhotos => 'ছবি আর রেকর্ডিং';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি জিনিস পাঠানো বাকি',
      one: '১টি জিনিস পাঠানো বাকি',
      zero: 'পাঠানোর কিছুই বাকি নেই',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'যা পাঠানো হয়ে গেছে তা সরান';

  @override
  String get storageClearWhy =>
      'যা এখনও পাঠানো বাকি, তাতে কখনো হাত দেওয়া হয় না।';

  @override
  String storageCleared(String size) {
    return '$size খালি হয়েছে';
  }

  @override
  String get storageNothingToClear => 'সরানোর মতো কিছু নেই';

  @override
  String get accountTitle => 'সাইন আউট';

  @override
  String get accountSignOut => 'এই ফোন থেকে সাইন আউট করুন';

  @override
  String get accountSignOutTitle => 'সাইন আউট করবেন?';

  @override
  String get accountSignOutBody =>
      'পাঠানো বাকি থাকা সব হারিয়ে যাবে। যা বিক্রিতে আছে তা বিক্রিতেই থাকবে।';

  @override
  String get accountSignOutConfirm => 'হ্যাঁ, সাইন আউট';

  @override
  String get accountSignOutCancel => 'না, সাইন ইন থাকুন';

  @override
  String get accountDelete => 'আমার অ্যাকাউন্ট মুছে ফেলুন';

  @override
  String get accountDeleteTitle => 'আপনার অ্যাকাউন্ট মুছে ফেলবেন?';

  @override
  String get accountDeleteBody =>
      'সব কিছু বিক্রি থেকে নেমে যাবে আর এই ফোনের সব মুছে যাবে। এটা আর ফেরত আসবে না।';

  @override
  String get accountDeleteConfirm => 'হ্যাঁ, সব মুছে ফেলুন';

  @override
  String get accountDeleteCancel => 'না, আমার অ্যাকাউন্ট থাক';

  @override
  String get accountDeleteHold => 'মুছতে বোতাম চেপে ধরে রাখুন';

  @override
  String get profileHelpEntry => 'সাহায্য';

  @override
  String get helpTitle => 'সাহায্য';

  @override
  String get helpBody =>
      'ছোট উত্তর, পড়ে শোনানো হয়। শুনতে যেকোনোটায় চাপ দিন।';

  @override
  String get helpSteps => 'এভাবে করুন';

  @override
  String get helpTopicPhotos => 'ভালো ছবি কীভাবে তুলবেন';

  @override
  String get helpTopicPhotosBody =>
      'ভালো ছবিতে জিনিস বিক্রি হয়। ক্রেতা জিনিস হাতে নিতে পারেন না, তাঁর কাছে শুধু ছবিটাই থাকে।';

  @override
  String get helpTopicPhotosStep1 =>
      'দরজা বা জানলার কাছে দাঁড়ান, যাতে দিনের আলো জিনিসের উপর পড়ে';

  @override
  String get helpTopicPhotosStep2 =>
      'জিনিসটা একটা সাদামাটা কাপড়ের উপর রাখুন, আশেপাশে আর কিছু না রেখে';

  @override
  String get helpTopicPhotosStep3 =>
      'ছবি না ওঠা পর্যন্ত দুই হাতে ফোন স্থির রাখুন';

  @override
  String get helpTopicPhotosStep4 =>
      'কাছ থেকে একটা ছবি তুলুন, যাতে কাজটা দেখা যায়';

  @override
  String get helpTopicPhotosStep5 =>
      'একটা ছবিতে পাশে হাত রাখুন, যাতে মাপ বোঝা যায়';

  @override
  String get helpTopicVoice => 'আপনার জিনিস নিয়ে কী বলবেন';

  @override
  String get helpTopicVoiceBody =>
      'সামনে দাঁড়ানো খদ্দেরের সঙ্গে যেভাবে কথা বলেন, সেভাবেই বলুন। বলার কোনো ভুল উপায় নেই।';

  @override
  String get helpTopicVoiceStep1 => 'বলুন এটা কী';

  @override
  String get helpTopicVoiceStep2 => 'বলুন এটা কী দিয়ে তৈরি';

  @override
  String get helpTopicVoiceStep3 => 'বলুন এটা কত বড়, ইঞ্চি বা ফুটে';

  @override
  String get helpTopicVoiceStep4 => 'বলুন বানাতে কত সময় লেগেছে';

  @override
  String get helpTopicVoiceStep5 => 'বলুন এর জন্য আপনি কত চান';

  @override
  String get helpTopicPrice => 'দাম কীভাবে ঠিক করবেন';

  @override
  String get helpTopicPriceBody =>
      'দামে আপনার জিনিসপত্রের খরচ আর আপনার সময়ের মূল্য দুটোই উঠে আসা দরকার। আমরা আপনার সঙ্গে সেটা হিসাব করি, আর না জানিয়ে কখনো তার নিচে যেতে দিই না।';

  @override
  String get helpTopicPriceStep1 => 'জিনিসপত্রে কত খরচ হয়েছে গুনুন';

  @override
  String get helpTopicPriceStep2 => 'কাজে কত দিন লেগেছে গুনুন';

  @override
  String get helpTopicPriceStep3 =>
      'আমরা যা বলি দেখুন, আর আপনি ভালো জানলে বদলে দিন';

  @override
  String get helpTopicPriceStep4 =>
      'আপনার খরচের চেয়ে কম হলে আমরা জানাব, কিন্তু সিদ্ধান্ত আপনারই';

  @override
  String get helpTopicSold => 'বিক্রির পরে কী হয়';

  @override
  String get helpTopicSoldBody =>
      'ক্রেতা বাজারে টাকা দেন। আপনি প্যাক করে দিয়ে দেন, আর টাকা আপনার কাছে আসে।';

  @override
  String get helpTopicSoldStep1 => 'বিক্রি হলেই আমরা আপনাকে জানাব';

  @override
  String get helpTopicSoldStep2 => 'খুলে দেখুন কী আর কতগুলো প্যাক করতে হবে';

  @override
  String get helpTopicSoldStep3 => 'আমাদের দেখানো তারিখের আগে প্যাক করুন';

  @override
  String get helpTopicSoldStep4 => 'যিনি নিতে আসবেন তাঁর হাতে দিন';

  @override
  String get helpTopicSoldStep5 => 'তারপর টাকা আপনার কাছে পৌঁছায়';

  @override
  String get helpVideoComing => 'এর জন্য একটা ছোট ভিডিও শীঘ্রই আসছে।';

  @override
  String get helpPractice => 'ভালো ছবি কীভাবে তুলবেন';

  @override
  String get helpPracticeBody => 'একই হাঁড়ির একটা ভালো আর একটা খারাপ ছবি।';

  @override
  String get helpFaqEntry => 'লোকে যা জিজ্ঞেস করেন';

  @override
  String get helpAboutEntry => 'কীর্তিকর সম্পর্কে';

  @override
  String get helpSupportEntry => 'মানুষের সঙ্গে কথা বলুন';

  @override
  String get helpTermsEntry => 'শর্ত ও গোপনীয়তা';

  @override
  String get faqTitle => 'লোকে যা জিজ্ঞেস করেন';

  @override
  String get faqQ1 => 'এর জন্য কি আমাকে কিছু দিতে হবে?';

  @override
  String get faqA1 =>
      'না। জিনিস তোলা বিনামূল্যে। কিছু বিক্রি হলে তবেই বাজার তার ছোট ভাগ নেয়।';

  @override
  String get faqQ2 => 'নেটওয়ার্ক না থাকলে কী হবে?';

  @override
  String get faqA2 =>
      'সব কাজ চলতে থাকে। আপনার বানানো আপনার ফোনে থাকে আর নেটওয়ার্ক এলে নিজে থেকেই চলে যায়।';

  @override
  String get faqQ3 => 'আমার টাকা কে পায়?';

  @override
  String get faqA3 =>
      'আপনি। ক্রেতা বাজারে টাকা দেন আর তা আপনার অ্যাকাউন্টে আসে। টাকা কখনো আমাদের হাত দিয়ে যায় না।';

  @override
  String get faqQ4 => 'বিক্রিতে ওঠার পরে কি কিছু বদলানো যায়?';

  @override
  String get faqA4 =>
      'হ্যাঁ। আপনার জিনিসের তালিকা থেকে খুলুন, যা চান বদলান, আর এটা আবার বিক্রিতে চলে যাবে।';

  @override
  String get faqQ5 => 'আমি কিছু ভুল বলে ফেললে?';

  @override
  String get faqA5 =>
      'আপনি শুনে ঠিক আছে না বলা পর্যন্ত কিছুই বিক্রিতে যায় না। মুখে বলে যেকোনো অংশ ঠিক করতে পারেন।';

  @override
  String get faqQ6 => 'আমাকে কি পড়তে-লিখতে জানতে হবে?';

  @override
  String get faqA6 =>
      'না। আপনি সব কিছু মুখে বলে আর চাপ দিয়ে করতে পারেন। প্রতিটি স্ক্রিন আপনাকে পড়ে শোনানো যায়।';

  @override
  String get faqQ7 => 'আমার নাম আর গ্রাম কে দেখে?';

  @override
  String get faqA7 =>
      'শুধু আপনি অনুমতি দিলে, আর প্রতিটি জিনিসের জন্য আলাদা করে। আপনি যখন খুশি তা ফিরিয়ে নিতে পারেন।';

  @override
  String get aboutTitle => 'কীর্তিকর সম্পর্কে';

  @override
  String get aboutWhatTitle => 'এটা কী';

  @override
  String get aboutWhat =>
      'কীর্তিকর হাতে বানানো জিনিস ONDC-তে পৌঁছে দেয়, ভারতের কেনাবেচার খোলা নেটওয়ার্ক, আর তার জন্য কারিগরকে লিখতে হয় না, শুধু বলতে হয়। আপনার নিজের ভাষায় কয়েকটা ছবি আর একটা ভয়েস নোট থেকে এমন তালিকা তৈরি হয় যা দেশজুড়ে ক্রেতারা খুঁজে পান।';

  @override
  String get aboutWhyTitle => 'আমরা কেন এটা বানিয়েছি';

  @override
  String get aboutWhy =>
      'ভারতে প্রায় সত্তর লাখ কারিগর এমন জিনিস বানান যা লোকে কিনতে চায়, আর তাঁদের বেশিরভাগই মধ্যস্বত্বভোগীর মাধ্যমে বিক্রি করেন যিনি লাভের ফারাকটা রেখে দেন। বাধা কাজে নয়। বাধা ফর্মে: অনলাইন তালিকা চায় ইংরেজিতে টাইপ করা, অনেক ঘর ভরা, আর ক্যাটালগের মতো তোলা ছবি। এই অ্যাপ সেই ফর্মটাই সরিয়ে দেয়।';

  @override
  String get aboutHowTitle => 'এটা কীভাবে কাজ করে';

  @override
  String get aboutHow =>
      'তিনটে ছবি তুলুন আর মুখে বলুন এটা কী। আমাদের ব্যবস্থা শোনে, তালিকা লেখে, আর আপনাকে পড়ে শোনায়। আপনি শুনে ঠিক আছে না বলা পর্যন্ত কিছুই বাইরে যায় না।';

  @override
  String get aboutSihTitle => 'স্মার্ট ইন্ডিয়া হ্যাকাথন ২০২৫';

  @override
  String get aboutSih =>
      'সমস্যা ০৯০-এর জন্য বানানো: কারিগর আর তাঁতিদের ONDC-তে ক্রেতাদের কাছে পৌঁছতে সাহায্য করা।';

  @override
  String get aboutMissionTitle => 'আমরা কী করতে চাই';

  @override
  String get aboutMission =>
      'একটা কাজের দাম যেন সেই কাজ যিনি করেছেন তাঁর হাতেই থাকে।';

  @override
  String get supportTitle => 'মানুষের সঙ্গে কথা বলুন';

  @override
  String get supportBody =>
      'কিছু কাজ না করলে, বা কী করবেন বুঝতে না পারলে, আমাদের ফোন করুন। একজন মানুষ আপনার ভাষায় উত্তর দেবেন।';

  @override
  String get supportCall => 'আমাদের ফোন করুন';

  @override
  String get supportWhatsApp => 'হোয়াটসঅ্যাপে মেসেজ করুন';

  @override
  String get supportHours => 'প্রতিদিন, সকাল নটা থেকে সন্ধে সাতটা।';

  @override
  String supportNumber(String number) {
    return 'আমাদের নম্বর $number';
  }

  @override
  String supportFailed(String number) {
    return 'আপনার ফোন এটা খুলতে পারেনি। আমাদের নম্বর $number।';
  }

  @override
  String get termsTitle => 'শর্ত ও গোপনীয়তা';

  @override
  String get termsSummaryTitle => 'সংক্ষেপে';

  @override
  String get termsSummary1 =>
      'আপনার বানানো জিনিস আপনারই। আমরা আপনার হয়ে বিক্রিতে তুলি আর বিক্রি থেকে কিছুই নিই না।';

  @override
  String get termsSummary2 =>
      'আপনার ছবি আর আওয়াজ শুধু আপনার তালিকা লেখার জন্য ব্যবহার হয়, আর কিছুর জন্য নয়।';

  @override
  String get termsSummary3 =>
      'আপনার নাম, গ্রাম আর গল্প শুধু আপনার অনুমতি দেওয়া জিনিসেই যায়, আর আপনি তা ফিরিয়ে নিতে পারেন।';

  @override
  String get termsSummary4 =>
      'টাকা ক্রেতার কাছ থেকে সরাসরি আপনার কাছে যায়। কখনো আমাদের হাত দিয়ে যায় না।';

  @override
  String get termsSummary5 => 'আপনি যখন খুশি এই ফোন থেকে সব মুছে ফেলতে পারেন।';

  @override
  String get termsFullTitle => 'পুরো লেখা';

  @override
  String get termsFullBody =>
      'ব্যবহারের পুরো শর্ত আর গোপনীয়তা নীতি আমাদের ওয়েবসাইটে আছে। এখানে কিছু বুঝতে না পারলে আমাদের ফোন করুন, একজন মানুষ বুঝিয়ে দেবেন।';

  @override
  String get termsOpenFull => 'পুরো লেখা পড়ুন';

  @override
  String get termsAgreeTitle => 'শুরু করার আগে';

  @override
  String get termsAgreeBody =>
      'আপনি এই কথাগুলোতে রাজি হচ্ছেন। শুনতে স্পিকার টিপুন।';

  @override
  String get termsAgreeCheck => 'আমি শর্তে রাজি';

  @override
  String get termsAgreeContinue => 'এগিয়ে যান';

  @override
  String get termsAgreeNeeded => 'আগে “আমি শর্তে রাজি”-তে টিক দিন।';

  @override
  String versionNumber(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get versionCheck => 'নতুন সংস্করণ দেখুন';

  @override
  String get versionLicences => 'লাইসেন্স';

  @override
  String get versionLicencesWhy => 'যে বিনামূল্যের সফটওয়্যারে এই অ্যাপ তৈরি।';

  @override
  String get noNetworkTitle => 'নেটওয়ার্ক নেই';

  @override
  String get noNetworkBody =>
      'আপনি কাজ চালিয়ে যান। সব কিছু আপনার ফোনে থাকে আর নেটওয়ার্ক এলে নিজে থেকেই চলে যায়।';

  @override
  String get noNetworkNeeded =>
      'এই একটা কাজের জন্য নেটওয়ার্ক লাগবে। সিগন্যাল এলে আবার চেষ্টা করুন।';

  @override
  String get serverErrorTitle => 'আমরা আমাদের দিকে পৌঁছতে পারিনি';

  @override
  String get serverErrorBody =>
      'আপনার করা কিছুই হারায়নি। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get actionTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get permissionRecoveryTitle => 'অ্যাপের আপনার অনুমতি দরকার';

  @override
  String get permissionRecoveryBody =>
      'ফোন অ্যাপকে এগুলো ব্যবহার করতে দিচ্ছে না। ফোনের সেটিংসে গিয়ে চালু করে এখানে ফিরে আসতে পারেন।';

  @override
  String get permissionCameraWhy =>
      'আপনার বানানো জিনিসের ছবি তোলার জন্য। এটা ছাড়া কিছুই বিক্রিতে তোলা যাবে না।';

  @override
  String get permissionMicWhy =>
      'যাতে লেখার বদলে মুখে বলতে পারেন। এটা ছাড়া সব কিছু লিখতে হবে।';

  @override
  String get permissionNotifyTitle => 'বিজ্ঞপ্তি';

  @override
  String get permissionNotifyWhy =>
      'যাতে কিছু বিক্রি হলে আমরা জানাতে পারি। এটা ছাড়া আপনাকে অ্যাপ খুলে দেখতে হবে।';

  @override
  String get permissionBlocked => 'অনুমতি নেই';

  @override
  String get permissionAsk => 'আবার জিজ্ঞেস করুন';

  @override
  String get permissionRecheck => 'আমি চালু করেছি';

  @override
  String get permissionAllGood => 'অ্যাপের যা দরকার সব অনুমতি আছে।';

  @override
  String get updateTitle => 'দয়া করে অ্যাপ আপডেট করুন';

  @override
  String get updateBody =>
      'এই সংস্করণ আর আমাদের সঙ্গে যোগাযোগ করতে পারে না। স্টোরে নতুন সংস্করণ আছে, আর আপডেটের পরেও আপনার ফোনের সব যেমন আছে থাকবে।';

  @override
  String get updateAction => 'নতুন সংস্করণ নিন';

  @override
  String get updateFailed => 'স্টোর খোলেনি। সেখানে কীর্তিকর খুঁজুন।';

  @override
  String get emptyNudge => 'হোমের বড় বোতাম চেপে আপনার প্রথম জিনিস যোগ করুন।';

  @override
  String get productsInProgress => 'তৈরি হচ্ছে';

  @override
  String get productsListed => 'বিক্রিতে';

  @override
  String get productsSold => 'বিক্রি হয়েছে';

  @override
  String get voiceTypeInstead => 'লিখে বলুন';

  @override
  String get voiceSpeakInstead => 'মুখে বলুন';

  @override
  String get voiceTypeTitle => 'এবার লিখুন এটা কী';

  @override
  String get voiceTypeHint => 'এখানে লিখুন…';

  @override
  String get voiceTypeSave => 'এই বিবরণটাই রাখুন';

  @override
  String get errorNotAllowed =>
      'এই অ্যাকাউন্ট দিয়ে এটা করা যায় না। সাহায্যের জন্য আমাদের ফোন করুন।';

  @override
  String get errorNotFound => 'এটা আর নেই।';

  @override
  String get errorConflict =>
      'এটা অন্য কোথাও বদলানো হয়েছে। আবার খুলে আর একবার চেষ্টা করুন।';

  @override
  String get errorInvalid =>
      'কিছু তথ্য গ্রহণ করা হয়নি। দেখে নিয়ে আবার চেষ্টা করুন।';

  @override
  String get voiceGuideTitle => 'আপনি এগুলো নিয়ে বলতে পারেন';

  @override
  String get voiceGuideWhat => 'জিনিসের নাম';

  @override
  String get voiceGuideSize => 'উচ্চতা';

  @override
  String get voiceGuideColour => 'রং';

  @override
  String get voiceGuideTime => 'বানাতে কত সময় লেগেছে';
}
