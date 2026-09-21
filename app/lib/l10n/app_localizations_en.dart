import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kirtikar';

  @override
  String get actionNext => 'Next';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionDone => 'Done';

  @override
  String get actionListen => 'Listen';

  @override
  String get actionStopListening => 'Stop';

  @override
  String stepOfSteps(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get splashTagline => 'Speak, and it gets sold';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageHint => 'Tap the language you speak';

  @override
  String get welcomeCard1Title => 'Take three photos';

  @override
  String get welcomeCard1Body =>
      'Take three photos of what you made. The app shows you how.';

  @override
  String get welcomeCard2Title => 'Say what it is';

  @override
  String get welcomeCard2Body =>
      'What it is, what it is made of, what it costs. Just say it out loud. No writing.';

  @override
  String get welcomeCard3Title => 'It goes on sale';

  @override
  String get welcomeCard3Body =>
      'We read it back to you first. Nothing goes online until you say yes.';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get permissionsTitle => 'The app needs three things';

  @override
  String get permissionCameraTitle => 'Camera';

  @override
  String get permissionCameraBody =>
      'To photograph what you made. The photos stay on your phone until you say yes.';

  @override
  String get permissionMicTitle => 'Microphone';

  @override
  String get permissionMicBody => 'So you can speak instead of writing.';

  @override
  String get permissionNotificationTitle => 'Notifications';

  @override
  String get permissionNotificationBody =>
      'So we can tell you the moment something sells.';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionNotNow => 'Not now';

  @override
  String get permissionGranted => 'Allowed';

  @override
  String get permissionDeniedTitle => 'Not allowed';

  @override
  String get permissionDeniedBody =>
      'This will not work without it. Open your phone settings and allow it there.';

  @override
  String get permissionOpenSettings => 'Open settings';

  @override
  String get phoneTitle => 'Your phone number';

  @override
  String get phoneWhy =>
      'We will send a code to this number. Nobody else is given this number.';

  @override
  String get phoneInvalid => 'Enter a ten digit number';

  @override
  String phoneUnknown(String number) {
    return 'That number does not work in this demo. Use $number.';
  }

  @override
  String get phoneSendCode => 'Send the code';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSentTo(String number) {
    return 'Sent to $number';
  }

  @override
  String otpResendIn(int seconds) {
    return 'Send again in $seconds seconds';
  }

  @override
  String get otpResend => 'Send the code again';

  @override
  String get otpCallMe => 'Call me and read it out';

  @override
  String get otpCalling =>
      'You will get a call shortly and the code will be read out to you.';

  @override
  String get otpWrong => 'That code is not right. Enter it again.';

  @override
  String get phoneSendFailed =>
      'The code could not be sent. Check the network and try again.';

  @override
  String get otpExpired => 'The code has expired. Send it again.';

  @override
  String get authTooManyTries => 'Too many tries. Wait a while and try again.';

  @override
  String get otpChangeNumber => 'Change the number';

  @override
  String get otpAutoRead => 'The message was read automatically';

  @override
  String get profileTitle => 'Tell us about yourself';

  @override
  String get profileNameLabel => 'Your name';

  @override
  String get profileNameHint => 'Say it or type it';

  @override
  String get profileNameMissing => 'Please give your name';

  @override
  String get profileCraftLabel => 'What do you make';

  @override
  String get profileCraftMissing => 'Choose one';

  @override
  String get profileSpeakToFill => 'Say it';

  @override
  String get profileListening => 'Listening…';

  @override
  String get dictationUnavailable =>
      'Speaking is not working on this phone. Please type instead.';

  @override
  String get dictationNothingHeard =>
      'We did not hear anything. Press the microphone and speak again.';

  @override
  String get craftWeaving => 'Weaving';

  @override
  String get craftPottery => 'Pottery';

  @override
  String get craftWoodwork => 'Woodwork';

  @override
  String get craftMetalwork => 'Metalwork';

  @override
  String get craftJewellery => 'Jewellery';

  @override
  String get craftEmbroidery => 'Embroidery';

  @override
  String get craftPainting => 'Painting';

  @override
  String get craftLeather => 'Leather';

  @override
  String get craftBamboo => 'Bamboo and cane';

  @override
  String get craftOther => 'Something else';

  @override
  String get ondcTitle => 'Link your ONDC account';

  @override
  String get ondcExplain =>
      'ONDC is where buyers see and buy what you make. The money goes straight to you, never through us.';

  @override
  String get ondcMalformed =>
      'That does not look like a seller ID. Please check it, or scan the code again.';

  @override
  String get ondcEmailLabel => 'ONDC email';

  @override
  String get ondcEmailMalformed =>
      'That does not look like an email address. Please check it.';

  @override
  String get ondcSellerIdLabel => 'Seller ID';

  @override
  String get ondcScan => 'Scan the QR code';

  @override
  String get ondcLink => 'Link the account';

  @override
  String get ondcLinking => 'Linking…';

  @override
  String get ondcFailed => 'We could not find that account. Please check it.';

  @override
  String get ondcNoAccount => 'I do not have one yet';

  @override
  String get ondcNoAccountExplain =>
      'That is fine. You can still get your products ready. The moment an account is linked, everything goes out together.';

  @override
  String get practiceTitle => 'How to take a good photo';

  @override
  String get practiceIntro =>
      'The same pot, taken well and taken badly. Swipe to see both.';

  @override
  String get practiceGoodBadge => 'Do this';

  @override
  String get practiceGoodTitle => 'A good photo';

  @override
  String get practiceGoodTip1 => 'Sharp: the phone was held still';

  @override
  String get practiceGoodTip2 => 'Bright: taken near a window or a door';

  @override
  String get practiceGoodTip3 => 'The whole product is in the photo';

  @override
  String get practiceBadBadge => 'Do not do this';

  @override
  String get practiceBadTitle => 'A bad photo';

  @override
  String get practiceBadTip1 => 'Blurry: the phone moved';

  @override
  String get practiceBadTip2 => 'Buyers cannot see the details';

  @override
  String get practiceBadTip3 => 'The app will ask you to take it again';

  @override
  String get practiceFinish => 'Open the app';

  @override
  String get navHome => 'Home';

  @override
  String get navListings => 'Products';

  @override
  String get navProfile => 'Profile';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeAddProduct => 'Add a product';

  @override
  String get homeAddProductSpoken =>
      'Press this big button to add a product. Take three photos, say what it is, and it goes on sale.';

  @override
  String homeQueueWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items waiting to send',
      one: '1 item waiting to send',
    );
    return '$_temp0';
  }

  @override
  String homeSold(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sold',
      one: '1 sold',
    );
    return '$_temp0';
  }

  @override
  String get homeRecent => 'Your recent products';

  @override
  String get homeNextTitle => 'Next thing to do';

  @override
  String get homeEmptyTitle => 'Nothing here yet';

  @override
  String get homeEmptyBody =>
      'Press the big button above to add your first product.';

  @override
  String get offlineNoNetwork => 'No network right now';

  @override
  String get offlineNothingLost =>
      'Nothing is lost. It will send itself when the network comes back.';

  @override
  String get statusQueued => 'Waiting to send';

  @override
  String get statusProcessing => 'Being prepared';

  @override
  String get statusNeedsAttention => 'Needs your answer';

  @override
  String get statusReady => 'Ready to publish';

  @override
  String get statusPublished => 'On sale';

  @override
  String get statusFailed => 'Did not send';

  @override
  String get listingUntitled => 'Product';

  @override
  String get listingNoPrice => 'Price not said';

  @override
  String get captureTitle => 'Add a product';

  @override
  String capturePhotoStep(int current, int total) {
    return 'Photo $current of $total';
  }

  @override
  String get capturePhotoWhole => 'Show the whole product';

  @override
  String get capturePhotoDetail => 'Take one from close up';

  @override
  String get capturePhotoScale => 'Put a hand beside it, so the size shows';

  @override
  String get captureTakePhoto => 'Take the photo';

  @override
  String get captureFromGallery => 'Choose from gallery';

  @override
  String get captureTorchOn => 'Light on';

  @override
  String get captureTorchOff => 'Light off';

  @override
  String get captureCameraFailed => 'The camera did not open';

  @override
  String get captureCameraRetry => 'Try again';

  @override
  String get captureCameraPermission =>
      'This app needs the camera to take photos of your product.';

  @override
  String get captureOpenSettings => 'Open settings';

  @override
  String get captureLeaveTitle => 'Leave without saving?';

  @override
  String get captureLeaveBody =>
      'The photos and what you said will be thrown away.';

  @override
  String get captureLeaveConfirm => 'Throw it away';

  @override
  String get captureLeaveCancel => 'Stay here';

  @override
  String get shotReviewChecking => 'Checking the photo…';

  @override
  String get shotReviewRetake => 'Take it again';

  @override
  String get qualityTooDark =>
      'This photo is too dark. Try standing near the door.';

  @override
  String get qualityTooBright =>
      'There is too much light on this. Try turning away from the sun.';

  @override
  String get qualityBlurry =>
      'This photo is not clear. Hold the phone still and take it again.';

  @override
  String get qualityUnreadable =>
      'This photo did not save properly. Please take it again.';

  @override
  String get qualityNoSubject =>
      'The product cannot be seen in this photo. Put it inside the outline and come closer.';

  @override
  String get qualityOutOfFrame =>
      'Only part of the product is in this photo. Put the whole product inside the outline.';

  @override
  String get qualityWarningTitle => 'Take this one again';

  @override
  String get qualityKeepAnyway => 'Keep it anyway';

  @override
  String get photoSetTitle => 'Your three photos';

  @override
  String get photoSetBody =>
      'The first photo is the one buyers see first. Press a photo to take it again.';

  @override
  String get photoSetMain => 'First photo';

  @override
  String get photoSetRetakeThis => 'Take this one again';

  @override
  String get photoSetConfirm => 'These photos are good';

  @override
  String get photoEditOpen => 'Crop or turn this photo';

  @override
  String get photoEditTitle => 'Crop the photo';

  @override
  String get photoEditBody =>
      'Drag a corner or an edge of the box to crop. Drag inside the box to move it.';

  @override
  String get photoEditTurn => 'Turn';

  @override
  String get photoEditStraighten => 'Straighten';

  @override
  String get photoEditReset => 'Start again';

  @override
  String get photoEditDone => 'Use this photo';

  @override
  String get photoEditCancel => 'Go back';

  @override
  String get photoEditFailed =>
      'This change could not be saved. Please try again.';

  @override
  String get photoIssueTooDark => 'Too dark to see clearly';

  @override
  String get photoIssueTooBright => 'Too much light on it';

  @override
  String get photoIssueBlurry => 'Blurry, not clear enough';

  @override
  String get photoIssueNoSubject => 'No product seen in this photo';

  @override
  String get photoIssueUnreadable => 'This photo did not save';

  @override
  String get photoIssueOutOfFrame => 'Product not fully in the photo';

  @override
  String get voiceTitle => 'Now say what it is';

  @override
  String get voiceBody =>
      'What it is, what it is made of, how big it is, how long it took to make, and the price.';

  @override
  String get voiceHoldToSpeak => 'Hold and speak';

  @override
  String get voiceRecording => 'Speaking… let go when you are finished';

  @override
  String voiceElapsed(int seconds, int total) {
    return '$seconds of $total seconds';
  }

  @override
  String get voiceTooShort =>
      'That was very short. Hold the button and speak again.';

  @override
  String get voiceFailed =>
      'The microphone did not start. Check that this app is allowed to use it.';

  @override
  String get voiceBackToPhotos => 'Back to the photos';

  @override
  String get playbackPlay => 'Listen';

  @override
  String get playbackStop => 'Stop';

  @override
  String get playbackAgain => 'Say it again';

  @override
  String get playbackAccept => 'This is right';

  @override
  String get playbackUnavailable =>
      'This phone cannot play it back. You can still send it, or say it again.';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedBody => 'It will send itself when there is a network.';

  @override
  String get savedBodyOnline =>
      'It is being sent now. You do not have to wait here.';

  @override
  String get savedAddAnother => 'Add another product';

  @override
  String get savedGoHome => 'Go to the home screen';

  @override
  String get saveFailed =>
      'It could not be saved on this phone. There may be no space left.';

  @override
  String get saveRetry => 'Try saving again';

  @override
  String get queueTitle => 'Waiting to be sent';

  @override
  String get queueBody =>
      'Nothing here is lost. Each one goes as soon as there is a network.';

  @override
  String get queueEmptyTitle => 'Nothing is waiting';

  @override
  String get queueEmptyBody => 'Everything you have made has been sent.';

  @override
  String get queueStateWaiting => 'Waiting for a network';

  @override
  String queueStateUploading(int percent) {
    return 'Sending… $percent out of a hundred';
  }

  @override
  String get queueStateProcessing => 'With us now. We are writing it up.';

  @override
  String get queueStateFailed => 'Did not go. Press to see why.';

  @override
  String get queueItemTitle => 'This item';

  @override
  String queueMadeAt(String date) {
    return 'Made on $date';
  }

  @override
  String queueAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tried $count times',
      one: 'Tried once',
    );
    return '$_temp0';
  }

  @override
  String get queueRetryNow => 'Try sending it now';

  @override
  String get queueRetryWaiting =>
      'There is no network yet. It will go on its own.';

  @override
  String get queueDelete => 'Delete this item';

  @override
  String get queueDeleteTitle => 'Delete this item?';

  @override
  String get queueDeleteBody =>
      'The photos and what you said will be gone. This cannot be undone.';

  @override
  String get queueDeleteConfirm => 'Yes, delete it';

  @override
  String get queueDeleteCancel => 'No, keep it';

  @override
  String get failureNetwork =>
      'The network stopped part way. It will go again on its own when there is a signal.';

  @override
  String get failureServer =>
      'Our side did not answer. It will be tried again.';

  @override
  String get failureMissingFiles =>
      'The photos are no longer on this phone, so this cannot be sent. Please make it again.';

  @override
  String get failureRejected =>
      'This could not be accepted. Please make it again.';

  @override
  String get failureUnknown => 'Something went wrong. You can try again.';

  @override
  String get processingTitle => 'We are writing it up';

  @override
  String get processingBody =>
      'Your photos and your words are with us. This takes a few minutes.';

  @override
  String get processingLeave =>
      'You do not have to wait here. We will tell you when it is ready.';

  @override
  String get processingGoHome => 'Go to the home screen';

  @override
  String get attentionTitle => 'One question';

  @override
  String get attentionBody =>
      'We understood everything else. Only this is missing.';

  @override
  String get attentionHoldToAnswer => 'Hold and answer';

  @override
  String get attentionAnswering => 'Sending your answer…';

  @override
  String get attentionFailed =>
      'Your answer did not go through. Please say it again.';

  @override
  String get attentionRetakePhotos => 'Take the photos again';

  @override
  String get attentionRetakeSending => 'Sending your new photos…';

  @override
  String get attentionRetakeFailed =>
      'The new photos did not go through. Please try again.';

  @override
  String get readBackTitle => 'This is what we understood';

  @override
  String get readBackListen => 'Listen to the whole thing';

  @override
  String get readBackFields => 'What we wrote down';

  @override
  String get readBackCorrect => 'Press anything that is wrong';

  @override
  String get readBackApprove => 'All of this is right';

  @override
  String get notSaid => 'Not said';

  @override
  String get fieldMaterial => 'Made of';

  @override
  String get fieldSize => 'Size';

  @override
  String get fieldColour => 'Colour';

  @override
  String get fieldTechnique => 'How it was made';

  @override
  String get fieldOrigin => 'Where it was made';

  @override
  String get fieldQuantity => 'How many';

  @override
  String get fieldPrice => 'Price';

  @override
  String correctTitle(String field) {
    return 'Say the correct $field';
  }

  @override
  String get correctHoldToSpeak => 'Hold and say it';

  @override
  String get correctListening => 'Listening…';

  @override
  String get correctFailedOnce => 'We did not catch that. Try once more.';

  @override
  String get correctUseKeypad => 'Type it instead';

  @override
  String get correctUseVoice => 'Say it instead';

  @override
  String get correctPick => 'Or choose one';

  @override
  String get correctSave => 'Save this';

  @override
  String get correctCancel => 'Leave it as it is';

  @override
  String get correctTypeHint => 'Type the answer here';

  @override
  String correctHeard(Object text) {
    return 'We heard “$text”';
  }

  @override
  String get listingCancelAction => 'Cancel this listing';

  @override
  String get listingCancelTitle => 'Cancel this listing?';

  @override
  String get listingCancelBody =>
      'The photos, the recording and everything you have said will be deleted. This cannot be undone.';

  @override
  String get listingCancelConfirm => 'Yes, cancel it';

  @override
  String get listingCancelKeep => 'No, keep it';

  @override
  String get photoSaveAction => 'Save photos';

  @override
  String get photoSaved => 'Saved to your photos';

  @override
  String get photoSaveFailed => 'Could not save the photo';

  @override
  String get photoSaveDenied => 'Allow photo access to save the picture';

  @override
  String get colourRed => 'Red';

  @override
  String get colourBlue => 'Blue';

  @override
  String get colourGreen => 'Green';

  @override
  String get colourYellow => 'Yellow';

  @override
  String get colourBlack => 'Black';

  @override
  String get colourWhite => 'White';

  @override
  String get colourBrown => 'Brown';

  @override
  String get colourMulti => 'Many colours';

  @override
  String get sizeSmall => 'Small';

  @override
  String get sizeMedium => 'Medium';

  @override
  String get sizeLarge => 'Large';

  @override
  String get sizeExtraLarge => 'Very large';

  @override
  String get suggestTitle => 'Shall we add this?';

  @override
  String get suggestYes => 'Yes, add it';

  @override
  String get suggestNo => 'No, leave it out';

  @override
  String get suggestSkip => 'I am not sure';

  @override
  String suggestProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get suggestDone => 'Nothing more to add';

  @override
  String get priceTitle => 'What is the price?';

  @override
  String get priceBody => 'This is for one piece.';

  @override
  String priceFloor(String amount) {
    return 'What it cost you: $amount';
  }

  @override
  String get priceFloorExplain =>
      'Your materials and your time come to this much. Selling below it means you lose money on the work.';

  @override
  String priceBand(String low, String high) {
    return 'Others sell this kind of thing for $low to $high';
  }

  @override
  String get priceBelowFloor =>
      'This is below what it cost you to make. You can still choose it.';

  @override
  String get priceSayIt => 'Say the price';

  @override
  String get priceConfirm => 'This price is right';

  @override
  String get stockTitle => 'How many do you have?';

  @override
  String get stockBody =>
      'When they are all sold, we take the listing down for you.';

  @override
  String get stockOneOfAKind =>
      'There is only one, and there will never be another';

  @override
  String get stockMore => 'One more';

  @override
  String get stockLess => 'One less';

  @override
  String get stockConfirm => 'This is right';

  @override
  String get photosTitle => 'Which photo comes first?';

  @override
  String get photosBody => 'Buyers see the first photo before anything else.';

  @override
  String get photosMakeFirst => 'Make this the first photo';

  @override
  String get photosFirst => 'First photo';

  @override
  String get photosConfirm => 'These photos are right';

  @override
  String get previewTitle => 'This is what buyers will see';

  @override
  String get previewListenAll => 'Listen to all of it';

  @override
  String get previewNoDescription => 'No description was written.';

  @override
  String get previewConfirm => 'Yes, this is right';

  @override
  String get previewChange => 'Change something';

  @override
  String get consentTitle => 'May we put this up for sale?';

  @override
  String get consentPhoto => 'Show my photos';

  @override
  String get consentPhotoExplain =>
      'The photographs of your product go on the buyer\'s screen.';

  @override
  String get consentStory => 'Show my craft story';

  @override
  String get consentStoryExplain =>
      'Your name, your village and how you make things go on the maker card. You can say no and still sell.';

  @override
  String get consentNeeded => 'We cannot put it up without the photos.';

  @override
  String get consentPublish => 'Put it up for sale';

  @override
  String get publishingTitle => 'Putting it up for sale';

  @override
  String get publishingBody => 'This takes a moment. Do not close the app.';

  @override
  String get publishedTitle => 'It is up for sale';

  @override
  String get publishedBody => 'Buyers can see it now.';

  @override
  String get publishedShare => 'Send it on WhatsApp';

  @override
  String get publishedCopyLink => 'Copy the link';

  @override
  String get publishedLinkCopied => 'The link is copied';

  @override
  String get publishedShowQr => 'Show the code to scan';

  @override
  String get publishedQrExplain =>
      'Anyone can point their phone at this to open your product.';

  @override
  String get publishedAnother => 'Make another like this';

  @override
  String get publishedDone => 'Go to the home screen';

  @override
  String get publishFailed =>
      'It could not be put up. Nothing is lost -- you can try again.';

  @override
  String get publishRetry => 'Try again';

  @override
  String get reviewLeaveTitle => 'Leave this for now?';

  @override
  String get reviewLeaveBody =>
      'What you have approved is kept. You can come back to it from your products.';

  @override
  String get reviewLeaveConfirm => 'Leave it for now';

  @override
  String get editLeaveTitle => 'Your changes are not on sale yet';

  @override
  String get editLeaveBody =>
      'What you changed is saved, but buyers still see the old one. Pressing the last button is what puts it back on sale.';

  @override
  String get editLeaveConfirm => 'Alright, I will do it later';

  @override
  String get reviewLeaveCancel => 'Keep going';

  @override
  String get statusSoldOut => 'All sold';

  @override
  String get statusUnpublished => 'Taken down';

  @override
  String get listingsTitle => 'Your products';

  @override
  String get listingsEmptyTitle => 'You have not made anything yet';

  @override
  String get listingsEmptyBody =>
      'Press the big button on the home screen to add your first product.';

  @override
  String get listingsEmptyFilter => 'Nothing here.';

  @override
  String listingsStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count left',
      one: '1 left',
      zero: 'None left',
    );
    return '$_temp0';
  }

  @override
  String listingsViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seen $count times',
      one: 'Seen once',
      zero: 'Not seen yet',
    );
    return '$_temp0';
  }

  @override
  String get listingsQuickStock => 'Change how many';

  @override
  String get listingTitle => 'This product';

  @override
  String get listingOpenPreview => 'See what buyers see';

  @override
  String get listingEdit => 'Change something';

  @override
  String get listingDuplicate => 'Make another like this';

  @override
  String get listingUnpublish => 'Take it off sale';

  @override
  String get listingRelist => 'Put it back on sale';

  @override
  String get listingFinish => 'Finish this one';

  @override
  String get listingSoldOutTitle => 'All of these are sold';

  @override
  String get listingSoldOutBody =>
      'We took it off sale for you. Put it back when you have made more.';

  @override
  String get editTitle => 'Change this product';

  @override
  String get editBody =>
      'You will go through it again, and then it goes back on sale.';

  @override
  String get editRepublishing => 'Putting the changes on sale…';

  @override
  String get editRepublished => 'Your changes are on sale now';

  @override
  String get editRepublishConfirm => 'Put the change back on sale';

  @override
  String get quickStockTitle => 'How many are left?';

  @override
  String get quickStockMarkSoldOut => 'They are all sold';

  @override
  String get quickStockSave => 'Save';

  @override
  String get quickStockSaved => 'Saved';

  @override
  String get actionUndo => 'Undo';

  @override
  String get unpublishTitle => 'Take it off sale?';

  @override
  String get unpublishBody =>
      'Buyers will not see it any more. Nothing is deleted, and you can put it back at any time.';

  @override
  String get unpublishConfirm => 'Yes, take it off';

  @override
  String get unpublishCancel => 'No, leave it on sale';

  @override
  String get unpublishDone => 'It is off sale';

  @override
  String get relistDone => 'It is back on sale';

  @override
  String get duplicateTitle => 'Make another like this?';

  @override
  String get duplicateBody =>
      'We keep what you said about it. You only need to take new photos.';

  @override
  String get duplicateConfirm => 'Take the photos';

  @override
  String get duplicateCancel => 'Not now';

  @override
  String get duplicateBanner =>
      'Making another like your last one. Only the photos are new.';

  @override
  String get listingActionFailed => 'That did not work. Please try again.';

  @override
  String get salesNew => 'New';

  @override
  String get salesEmptyTitle => 'Nothing has sold yet';

  @override
  String get salesEmptyBody =>
      'When someone buys something, it will show up here and we will tell you.';

  @override
  String get salesLoading => 'Checking what has sold…';

  @override
  String salesQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0';
  }

  @override
  String salesPackBy(String date) {
    return 'Pack by $date';
  }

  @override
  String get salesPackByToday => 'Pack it today';

  @override
  String get salesPackByTomorrow => 'Pack it tomorrow';

  @override
  String get salesPackedAlready => 'This one is past its date';

  @override
  String get saleTitle => 'This order';

  @override
  String get saleReadOnly =>
      'This is only to tell you. Everything about the order happens on the marketplace, not in this app.';

  @override
  String salePaid(String amount) {
    return 'You are paid $amount';
  }

  @override
  String salePlaced(String date) {
    return 'Sold on $date';
  }

  @override
  String saleGoingTo(String area) {
    return 'Going to $area';
  }

  @override
  String get saleWhatToPack => 'What to pack';

  @override
  String get salePackingHelp => 'How to pack it';

  @override
  String get saleSeeListing => 'See this product';

  @override
  String get packingTitle => 'How to pack it';

  @override
  String get packingBody =>
      'Go through these one at a time. Press each one when it is done.';

  @override
  String get packingStep1 =>
      'Wrap it in cloth or paper, so nothing rubs against it';

  @override
  String get packingStep2 =>
      'Put paper or straw around it, so it cannot move inside the box';

  @override
  String get packingStep3 => 'Check that the right number of pieces are inside';

  @override
  String get packingStep4 => 'Close the box and tape it all the way round';

  @override
  String get packingStep5 =>
      'Keep it ready for the person who comes to collect it';

  @override
  String get packingDone => 'All done';

  @override
  String packingProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get earningsTitle => 'What you have earned';

  @override
  String get earningsWeek => 'This week';

  @override
  String get earningsMonth => 'This month';

  @override
  String get earningsTotal => 'Since you started';

  @override
  String earningsItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces sold',
      one: '1 piece sold',
      zero: 'Nothing sold yet',
    );
    return '$_temp0';
  }

  @override
  String get earningsNote =>
      'This is what comes to you, after the marketplace has taken its share.';

  @override
  String get profileVillageLabel => 'Village or cluster';

  @override
  String get profileNotSet => 'Not given';

  @override
  String get profileEditEntry => 'Change your details';

  @override
  String get profileStoryEntry => 'Your craft story';

  @override
  String get profileLanguageEntry => 'Language';

  @override
  String get profilePhoneEntry => 'Phone number';

  @override
  String get profileOndcEntry => 'Your selling account';

  @override
  String get profileNotificationsEntry => 'What we tell you about';

  @override
  String get profileVoiceEntry => 'Voice and sound';

  @override
  String get profilePrivacyEntry => 'What is shown about you';

  @override
  String get profileStorageEntry => 'Space on this phone';

  @override
  String get profileAccountEntry => 'Sign out';

  @override
  String get editProfileTitle => 'Your details';

  @override
  String get editProfileAddPhoto => 'Add a photo of yourself';

  @override
  String get editProfileChangePhoto => 'Change the photo';

  @override
  String get editProfileRemovePhoto => 'Remove the photo';

  @override
  String get editProfilePhotoWhy =>
      'Buyers see this on your maker card, only if you allow it.';

  @override
  String get editProfileVillageHint => 'Say it or type it';

  @override
  String get editProfileSave => 'Save';

  @override
  String get editProfileSaved => 'Saved';

  @override
  String get storyTitle => 'Your craft story';

  @override
  String get storyBody =>
      'Tell buyers who you are and how you make things. Speak it, and we will write it down for you.';

  @override
  String get storyHoldToSpeak => 'Hold and tell your story';

  @override
  String get storyEmpty => 'You have not told your story yet.';

  @override
  String get storyEditHint => 'You can change any word of it.';

  @override
  String get storyExample =>
      'For example: my family has made these for three generations, and I still work on my grandfather\'s loom.';

  @override
  String get changePhoneTitle => 'Change your number';

  @override
  String get changePhoneBody =>
      'We will send a code to the new number to make sure it is yours.';

  @override
  String changePhoneCurrent(String number) {
    return 'Your number now is $number';
  }

  @override
  String get changePhoneDone => 'Your number is changed';

  @override
  String get ondcAccountTitle => 'Your selling account';

  @override
  String get ondcAccountLinked => 'Your account is linked';

  @override
  String get ondcAccountNone => 'No account is linked yet';

  @override
  String get ondcAccountNoneBody =>
      'You can keep making products. They go on sale the moment an account is linked.';

  @override
  String get ondcAccountLink => 'Link an account';

  @override
  String get ondcAccountUnlink => 'Unlink this account';

  @override
  String get ondcUnlinkTitle => 'Unlink this account?';

  @override
  String get ondcUnlinkBody =>
      'Anything on sale comes down. Nothing you have made is deleted, and you can link it again.';

  @override
  String get ondcUnlinkConfirm => 'Yes, unlink it';

  @override
  String get ondcUnlinkCancel => 'No, keep it';

  @override
  String get ondcUnlinkDone => 'The account is unlinked';

  @override
  String get notificationsTitle => 'What we tell you about';

  @override
  String get notifySold => 'When something sells';

  @override
  String get notifySoldWhy =>
      'We tell you as soon as a buyer has paid, so you can start packing.';

  @override
  String get notifyAttention => 'When we need to ask you something';

  @override
  String get notifyAttentionWhy =>
      'Sometimes one thing is missing before a product can go on sale.';

  @override
  String get notifyUpload => 'When a product has been sent';

  @override
  String get notifyUploadWhy =>
      'We tell you when what you made on your phone has reached us.';

  @override
  String get notifyPackBy => 'When it is time to pack';

  @override
  String get notifyPackByWhy =>
      'We remind you the day before a sale has to be packed, and on the day.';

  @override
  String get notificationsBlocked =>
      'This phone is not letting us send you anything. You can turn it on in the phone\'s settings.';

  @override
  String get voiceSettingsTitle => 'Voice and sound';

  @override
  String get voiceSpeed => 'How fast we speak';

  @override
  String get voiceSpeedSlow => 'Slower';

  @override
  String get voiceSpeedFast => 'Faster';

  @override
  String get voiceTry => 'Say something now';

  @override
  String get voiceSample => 'This is how fast we will speak to you.';

  @override
  String get voiceAutoRead => 'Read every screen out loud when it opens';

  @override
  String get voiceAutoReadWhy =>
      'When this is off, we only speak when you press a speaker.';

  @override
  String get voiceUnavailable =>
      'This phone cannot speak. Everything still works, but nothing will be read out.';

  @override
  String get privacyTitle => 'What is shown about you';

  @override
  String get privacyBody =>
      'You said yes to these when you put each product up for sale. You can take any of them back.';

  @override
  String get privacyPhoto => 'Photos of this product';

  @override
  String get privacyStory => 'Your name, village and story';

  @override
  String get privacyNothing => 'Nothing of yours is on sale right now.';

  @override
  String get privacyWithdrawTitle => 'Take this back?';

  @override
  String get privacyWithdrawPhotoBody =>
      'Without the photos this product cannot stay on sale, so it will come down. Nothing is deleted.';

  @override
  String get privacyWithdrawStoryBody =>
      'Your name, village and story will be taken off this product. It stays on sale.';

  @override
  String get privacyWithdrawConfirm => 'Yes, take it back';

  @override
  String get privacyWithdrawCancel => 'No, leave it';

  @override
  String get privacyWithdrawn => 'Taken back';

  @override
  String get storageTitle => 'Space on this phone';

  @override
  String get storagePhotos => 'Photos and recordings';

  @override
  String storageWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things are waiting to be sent',
      one: '1 thing is waiting to be sent',
      zero: 'Nothing is waiting to be sent',
    );
    return '$_temp0';
  }

  @override
  String get storageClear => 'Clear what has already been sent';

  @override
  String get storageClearWhy =>
      'Anything still waiting to be sent is never touched.';

  @override
  String storageCleared(String size) {
    return 'Cleared $size';
  }

  @override
  String get storageNothingToClear => 'There is nothing to clear';

  @override
  String get accountTitle => 'Sign out';

  @override
  String get accountSignOut => 'Sign out of this phone';

  @override
  String get accountSignOutTitle => 'Sign out?';

  @override
  String get accountSignOutBody =>
      'Anything waiting to be sent will be lost. What is already on sale stays on sale.';

  @override
  String get accountSignOutConfirm => 'Yes, sign out';

  @override
  String get accountSignOutCancel => 'No, stay signed in';

  @override
  String get accountDelete => 'Delete my account';

  @override
  String get accountDeleteTitle => 'Delete your account?';

  @override
  String get accountDeleteBody =>
      'Everything comes off sale and everything on this phone is erased. This cannot be undone.';

  @override
  String get accountDeleteConfirm => 'Yes, delete everything';

  @override
  String get accountDeleteCancel => 'No, keep my account';

  @override
  String get accountDeleteHold => 'Hold the button to delete';

  @override
  String get profileHelpEntry => 'Help';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpBody =>
      'Short answers, read out loud. Press any one to hear it.';

  @override
  String get helpSteps => 'Do it like this';

  @override
  String get helpTopicPhotos => 'Taking good photos';

  @override
  String get helpTopicPhotosBody =>
      'Good photos sell. Buyers cannot pick the product up, so the photo is all they have.';

  @override
  String get helpTopicPhotosStep1 =>
      'Stand near a door or a window, so daylight falls on the product';

  @override
  String get helpTopicPhotosStep2 =>
      'Put the product on a plain cloth, with nothing else around it';

  @override
  String get helpTopicPhotosStep3 =>
      'Hold the phone still with both hands until the picture is taken';

  @override
  String get helpTopicPhotosStep4 =>
      'Take one from close up, so the work can be seen';

  @override
  String get helpTopicPhotosStep5 =>
      'Put your hand beside it in one photo, so the size shows';

  @override
  String get helpTopicVoice => 'What to say about your product';

  @override
  String get helpTopicVoiceBody =>
      'Speak the way you would to a customer standing in front of you. There is no wrong way to say it.';

  @override
  String get helpTopicVoiceStep1 => 'Say what it is';

  @override
  String get helpTopicVoiceStep2 => 'Say what it is made of';

  @override
  String get helpTopicVoiceStep3 => 'Say how big it is, in inches or feet';

  @override
  String get helpTopicVoiceStep4 => 'Say how long it took you to make';

  @override
  String get helpTopicVoiceStep5 => 'Say what you want for it';

  @override
  String get helpTopicPrice => 'Setting a price';

  @override
  String get helpTopicPriceBody =>
      'Your price has to cover what the materials cost and what your time is worth. We work that out with you and never let you go under it without saying so.';

  @override
  String get helpTopicPriceStep1 => 'Count what the materials cost you';

  @override
  String get helpTopicPriceStep2 => 'Count how many days the work took';

  @override
  String get helpTopicPriceStep3 =>
      'Look at what we suggest, and change it if you know better';

  @override
  String get helpTopicPriceStep4 =>
      'If it is below your cost, we will tell you, but the choice stays yours';

  @override
  String get helpTopicSold => 'What happens after something sells';

  @override
  String get helpTopicSoldBody =>
      'The buyer pays on the marketplace. You pack it and hand it over, and the money comes to you.';

  @override
  String get helpTopicSoldStep1 => 'We tell you as soon as it sells';

  @override
  String get helpTopicSoldStep2 => 'Open it to see what to pack and how many';

  @override
  String get helpTopicSoldStep3 => 'Pack it before the date we show you';

  @override
  String get helpTopicSoldStep4 =>
      'Hand it to the person who comes to collect it';

  @override
  String get helpTopicSoldStep5 => 'The money reaches you after that';

  @override
  String get helpVideoComing => 'A short video for this is on the way.';

  @override
  String get helpPractice => 'How to take a good photo';

  @override
  String get helpPracticeBody => 'A good photo and a bad one of the same pot.';

  @override
  String get helpFaqEntry => 'Questions people ask';

  @override
  String get helpAboutEntry => 'About Kirtikar';

  @override
  String get helpSupportEntry => 'Talk to a person';

  @override
  String get helpTermsEntry => 'Terms and privacy';

  @override
  String get faqTitle => 'Questions people ask';

  @override
  String get faqQ1 => 'Does this cost me anything?';

  @override
  String get faqA1 =>
      'No. Putting your products up is free. The marketplace takes a small share only when something sells.';

  @override
  String get faqQ2 => 'What if I have no network?';

  @override
  String get faqA2 =>
      'Everything keeps working. What you make is kept on your phone and sent by itself when the network comes back.';

  @override
  String get faqQ3 => 'Who gets my money?';

  @override
  String get faqA3 =>
      'You do. The buyer pays on the marketplace and it comes to your account. The money never passes through us.';

  @override
  String get faqQ4 => 'Can I change something after it is on sale?';

  @override
  String get faqA4 =>
      'Yes. Open it from your products, change what you want, and it goes back on sale.';

  @override
  String get faqQ5 => 'What if I said something wrong?';

  @override
  String get faqA5 =>
      'Nothing goes on sale until you have heard it back and said it is right. You can correct any part of it by speaking.';

  @override
  String get faqQ6 => 'Do I have to read or write?';

  @override
  String get faqA6 =>
      'No. You can do everything by speaking and pressing. Every screen can be read out to you.';

  @override
  String get faqQ7 => 'Who sees my name and my village?';

  @override
  String get faqA7 =>
      'Only if you allow it, for each product. You can take that back at any time.';

  @override
  String get aboutTitle => 'About Kirtikar';

  @override
  String get aboutWhatTitle => 'What this is';

  @override
  String get aboutWhat =>
      'Kirtikar puts handmade work on ONDC, India\'s open network for buying and selling, by letting the maker speak instead of type. Photos and a voice note in your own language become a listing that buyers across the country can find.';

  @override
  String get aboutWhyTitle => 'Why we built it';

  @override
  String get aboutWhy =>
      'Around seven million artisans in India make things people want to buy, and most of them sell through a middleman who takes the difference. The barrier is not the work. It is the form: an online listing asks for typed English, a bank of fields, and a photograph shot like a catalogue. This app removes that form.';

  @override
  String get aboutHowTitle => 'How it works';

  @override
  String get aboutHow =>
      'Take three photos and say what it is. Our pipeline listens, writes the listing, and reads it back to you. Nothing goes out until you have heard it and said it is right.';

  @override
  String get aboutSihTitle => 'Smart India Hackathon 2025';

  @override
  String get aboutSih =>
      'Built for problem statement 090: helping artisans and weavers reach buyers on ONDC.';

  @override
  String get aboutMissionTitle => 'What we are trying to do';

  @override
  String get aboutMission =>
      'Put the price of a piece of work in the hands of the person who made it.';

  @override
  String get supportTitle => 'Talk to a person';

  @override
  String get supportBody =>
      'If something is not working, or you are not sure what to do, call us. A person answers, in your language.';

  @override
  String get supportCall => 'Call us';

  @override
  String get supportWhatsApp => 'Message us on WhatsApp';

  @override
  String get supportHours =>
      'Every day, nine in the morning to seven in the evening.';

  @override
  String supportNumber(String number) {
    return 'Our number is $number';
  }

  @override
  String supportFailed(String number) {
    return 'Your phone could not open that. Our number is $number.';
  }

  @override
  String get termsTitle => 'Terms and privacy';

  @override
  String get termsSummaryTitle => 'The short version';

  @override
  String get termsSummary1 =>
      'What you make is yours. We put it on sale for you and take nothing from the sale.';

  @override
  String get termsSummary2 =>
      'Your photos and your voice are used to write your listing, and for nothing else.';

  @override
  String get termsSummary3 =>
      'Your name, village and story go out only on the products you allowed, and you can take that back.';

  @override
  String get termsSummary4 =>
      'The money goes from the buyer to you. It never passes through us.';

  @override
  String get termsSummary5 =>
      'You can delete everything from this phone at any time.';

  @override
  String get termsFullTitle => 'The full text';

  @override
  String get termsFullBody =>
      'The complete terms of use and privacy policy are on our website. If anything here is unclear, call us and a person will explain it.';

  @override
  String get termsOpenFull => 'Read the full text';

  @override
  String get termsAgreeTitle => 'Before we start';

  @override
  String get termsAgreeBody =>
      'This is what you agree to. Press the speaker to hear it.';

  @override
  String get termsAgreeCheck => 'I agree to the terms';

  @override
  String get termsAgreeContinue => 'Continue';

  @override
  String get termsAgreeNeeded => 'Tick “I agree to the terms” first.';

  @override
  String versionNumber(String version) {
    return 'Version $version';
  }

  @override
  String get versionCheck => 'Check for a new version';

  @override
  String get versionLicences => 'Licences';

  @override
  String get versionLicencesWhy => 'The free software this app is built on.';

  @override
  String get noNetworkTitle => 'No network';

  @override
  String get noNetworkBody =>
      'You can keep working. Everything is kept on your phone and goes by itself when the network comes back.';

  @override
  String get noNetworkNeeded =>
      'This one thing needs a network. Try again when you have a signal.';

  @override
  String get serverErrorTitle => 'We could not reach our side';

  @override
  String get serverErrorBody =>
      'Nothing you did is lost. Please try again in a moment.';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get permissionRecoveryTitle => 'This app needs your permission';

  @override
  String get permissionRecoveryBody =>
      'The phone is not letting the app use these. You can turn them on in the phone\'s settings, and then come back here.';

  @override
  String get permissionCameraWhy =>
      'To take photos of what you have made. Without it, nothing can be put up for sale.';

  @override
  String get permissionMicWhy =>
      'So you can speak instead of typing. Without it, everything has to be typed.';

  @override
  String get permissionNotifyTitle => 'Notifications';

  @override
  String get permissionNotifyWhy =>
      'So we can tell you when something sells. Without it, you have to open the app to find out.';

  @override
  String get permissionBlocked => 'Not allowed';

  @override
  String get permissionAsk => 'Ask again';

  @override
  String get permissionRecheck => 'I have turned it on';

  @override
  String get permissionAllGood => 'Everything this app needs is allowed.';

  @override
  String get updateTitle => 'Please update the app';

  @override
  String get updateBody =>
      'This version cannot talk to us any more. A newer one is waiting in the store, and everything on your phone will still be here after you update.';

  @override
  String get updateAction => 'Get the new version';

  @override
  String get updateFailed =>
      'The store did not open. Search for Kirtikar there.';

  @override
  String get emptyNudge =>
      'Press the big button on the home screen to add your first product.';

  @override
  String get productsInProgress => 'In progress';

  @override
  String get productsListed => 'Listed';

  @override
  String get productsSold => 'Sold';

  @override
  String get voiceTypeInstead => 'Type it instead';

  @override
  String get voiceSpeakInstead => 'Speak instead';

  @override
  String get voiceTypeTitle => 'Now write what it is';

  @override
  String get voiceTypeHint => 'Type here…';

  @override
  String get voiceTypeSave => 'Use this description';

  @override
  String get errorNotAllowed =>
      'This account cannot do that. Please call us for help.';

  @override
  String get errorNotFound => 'This is no longer there.';

  @override
  String get errorConflict =>
      'This was changed somewhere else. Please open it again and try once more.';

  @override
  String get errorInvalid =>
      'Some details were not accepted. Please check them and try again.';

  @override
  String get voiceGuideTitle => 'Things you can talk about';

  @override
  String get voiceGuideWhat => 'Name of the item';

  @override
  String get voiceGuideSize => 'Height';

  @override
  String get voiceGuideColour => 'Colour';

  @override
  String get voiceGuideTime => 'Time taken to make it';
}
