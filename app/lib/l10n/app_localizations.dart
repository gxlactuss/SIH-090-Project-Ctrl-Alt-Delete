import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  String get appTitle;

  String get actionNext;

  String get actionBack;

  String get actionSkip;

  String get actionDone;

  String get actionRetry;

  String get actionYes;

  String get actionNo;

  String get actionListen;

  String get actionStopListening;

  String stepOfSteps(int current, int total);

  String get splashTagline;

  String get languageTitle;

  String get languageHint;

  String get welcomeTitle;

  String get welcomeCard1Title;

  String get welcomeCard1Body;

  String get welcomeCard2Title;

  String get welcomeCard2Body;

  String get welcomeCard3Title;

  String get welcomeCard3Body;

  String get welcomeStart;

  String get permissionsTitle;

  String get permissionCameraTitle;

  String get permissionCameraBody;

  String get permissionMicTitle;

  String get permissionMicBody;

  String get permissionNotificationTitle;

  String get permissionNotificationBody;

  String get permissionAllow;

  String get permissionNotNow;

  String get permissionGranted;

  String get permissionDeniedTitle;

  String get permissionDeniedBody;

  String get permissionOpenSettings;

  String get phoneTitle;

  String get phoneWhy;

  String get phoneInvalid;

  String phoneUnknown(String number);

  String get phoneSendCode;

  String get otpTitle;

  String otpSentTo(String number);

  String otpResendIn(int seconds);

  String get otpResend;

  String get otpCallMe;

  String get otpCalling;

  String get otpWrong;

  String get otpChangeNumber;

  String get otpAutoRead;

  String get profileTitle;

  String get profileNameLabel;

  String get profileNameHint;

  String get profileNameMissing;

  String get profileCraftLabel;

  String get profileCraftMissing;

  String get profileSpeakToFill;

  String get profileListening;

  String get dictationUnavailable;

  String get dictationNothingHeard;

  String get craftWeaving;

  String get craftPottery;

  String get craftWoodwork;

  String get craftMetalwork;

  String get craftJewellery;

  String get craftEmbroidery;

  String get craftPainting;

  String get craftLeather;

  String get craftBamboo;

  String get craftOther;

  String get ondcTitle;

  String get ondcExplain;

  String get ondcEmailLabel;

  String get ondcSellerIdLabel;

  String get ondcScan;

  String get ondcLink;

  String get ondcLinking;

  String get ondcLinked;

  String get ondcFailed;

  String get ondcNoAccount;

  String get ondcNoAccountExplain;

  String get practiceTitle;

  String get practiceIntro;

  String get practiceStart;

  String practicePhotoStep(int current, int total);

  String get practicePhotoWhole;

  String get practicePhotoDetail;

  String get practicePhotoScale;

  String get practiceTakePhoto;

  String get practiceVoiceTitle;

  String get practiceVoiceBody;

  String get practiceHoldToSpeak;

  String get practiceReviewTitle;

  String get practiceReviewBody;

  String get practiceDoneTitle;

  String get practiceNothingPublished;

  String get practiceAgain;

  String get practiceFinish;

  String onboardingDoneTitle(String name);

  String get onboardingDoneBody;

  String get navHome;

  String get navListings;

  String get navSales;

  String get navProfile;

  String homeGreeting(String name);

  String get homeAddProduct;

  String get homeAddProductSpoken;

  String homeQueueWaiting(int count);

  String homeSold(int count);

  String get homeRecent;

  String get homeEmptyTitle;

  String get homeEmptyBody;

  String get homeSeeAll;

  String get offlineNoNetwork;

  String get offlineNothingLost;

  String get offlineSeeQueue;

  String get statusQueued;

  String get statusProcessing;

  String get statusNeedsAttention;

  String get statusReady;

  String get statusPublished;

  String get statusFailed;

  String get listingUntitled;

  String get listingNoPrice;

  String get comingSoonTitle;

  String get comingSoonBody;

  String get captureTitle;

  String capturePhotoStep(int current, int total);

  String get capturePhotoWhole;

  String get capturePhotoDetail;

  String get capturePhotoScale;

  String get captureTakePhoto;

  String get captureFromGallery;

  String get captureTorchOn;

  String get captureTorchOff;

  String get captureCameraFailed;

  String get captureCameraRetry;

  String get captureCameraPermission;

  String get captureOpenSettings;

  String get captureLeaveTitle;

  String get captureLeaveBody;

  String get captureLeaveConfirm;

  String get captureLeaveCancel;

  String get shotReviewTitle;

  String get shotReviewChecking;

  String get shotReviewKeep;

  String get shotReviewRetake;

  String get qualityTooDark;

  String get qualityTooBright;

  String get qualityBlurry;

  String get qualityUnreadable;

  String get qualityNoSubject;

  String get qualityWarningTitle;

  String get qualityKeepAnyway;

  String get photoSetTitle;

  String get photoSetBody;

  String get photoSetMain;

  String get photoSetMakeMain;

  String get photoSetRetakeThis;

  String get photoSetConfirm;

  String get photoIssueTooDark;

  String get photoIssueTooBright;

  String get photoIssueBlurry;

  String get photoIssueNoSubject;

  String get photoIssueUnreadable;

  String get voiceTitle;

  String get voiceBody;

  String get voiceHoldToSpeak;

  String get voiceRecording;

  String voiceElapsed(int seconds, int total);

  String get voiceTooShort;

  String get voiceFailed;

  String get voiceBackToPhotos;

  String get playbackTitle;

  String get playbackPlay;

  String get playbackStop;

  String get playbackAgain;

  String get playbackAccept;

  String get playbackUnavailable;

  String get savedTitle;

  String get savedBody;

  String get savedBodyOnline;

  String get savedAddAnother;

  String get savedGoHome;

  String get saveFailed;

  String get saveRetry;

  String get queueTitle;

  String get queueBody;

  String get queueEmptyTitle;

  String get queueEmptyBody;

  String get queueStateWaiting;

  String queueStateUploading(int percent);

  String get queueStateProcessing;

  String get queueStateFailed;

  String get queueItemTitle;

  String queueMadeAt(String date);

  String queueAttempts(int count);

  String get queueRetryNow;

  String get queueRetryWaiting;

  String get queueDelete;

  String get queueDeleteTitle;

  String get queueDeleteBody;

  String get queueDeleteConfirm;

  String get queueDeleteCancel;

  String get failureNetwork;

  String get failureServer;

  String get failureMissingFiles;

  String get failureRejected;

  String get failureUnknown;

  String get processingTitle;

  String get processingBody;

  String get processingLeave;

  String get processingGoHome;

  String get processingStepSent;

  String get processingStepListening;

  String get processingStepWriting;

  String get processingStepReady;

  String get attentionTitle;

  String get attentionBody;

  String get attentionHoldToAnswer;

  String get attentionAnswering;

  String get attentionFailed;

  String get readBackTitle;

  String get readBackListen;

  String get readBackFields;

  String get readBackCorrect;

  String get readBackApprove;

  String get notSaid;

  String get fieldMaterial;

  String get fieldSize;

  String get fieldColour;

  String get fieldTechnique;

  String get fieldQuantity;

  String get fieldPrice;

  String correctTitle(String field);

  String get correctHoldToSpeak;

  String get correctListening;

  String get correctFailedOnce;

  String get correctUseKeypad;

  String get correctUseVoice;

  String get correctPick;

  String get correctSave;

  String get correctCancel;

  String get colourRed;

  String get colourBlue;

  String get colourGreen;

  String get colourYellow;

  String get colourBlack;

  String get colourWhite;

  String get colourBrown;

  String get colourMulti;

  String get sizeSmall;

  String get sizeMedium;

  String get sizeLarge;

  String get sizeExtraLarge;

  String get suggestTitle;

  String get suggestYes;

  String get suggestNo;

  String get suggestSkip;

  String suggestProgress(int current, int total);

  String get suggestDone;

  String get priceTitle;

  String get priceBody;

  String priceFloor(String amount);

  String get priceFloorExplain;

  String priceBand(String low, String high);

  String get priceBelowFloor;

  String get priceSayIt;

  String get priceTypeIt;

  String get priceConfirm;

  String get stockTitle;

  String get stockBody;

  String get stockOneOfAKind;

  String get stockMore;

  String get stockLess;

  String get stockConfirm;

  String get photosTitle;

  String get photosBody;

  String get photosMakeFirst;

  String get photosFirst;

  String get photosConfirm;

  String get previewTitle;

  String get previewListenAll;

  String get previewNoDescription;

  String get previewConfirm;

  String get previewChange;

  String get consentTitle;

  String get consentPhoto;

  String get consentPhotoExplain;

  String get consentStory;

  String get consentStoryExplain;

  String get consentNeeded;

  String get consentPublish;

  String get publishingTitle;

  String get publishingBody;

  String get publishedTitle;

  String get publishedBody;

  String get publishedShare;

  String get publishedCopyLink;

  String get publishedLinkCopied;

  String get publishedShowQr;

  String get publishedQrExplain;

  String get publishedAnother;

  String get publishedDone;

  String get publishFailed;

  String get publishRetry;

  String get reviewLeaveTitle;

  String get reviewLeaveBody;

  String get reviewLeaveConfirm;

  String get editLeaveTitle;

  String get editLeaveBody;

  String get editLeaveConfirm;

  String get reviewLeaveCancel;

  String get reviewSaveFailed;

  String get statusSoldOut;

  String get statusUnpublished;

  String get listingsTitle;

  String get listingsFilterAll;

  String get listingsFilterDrafts;

  String get listingsFilterAttention;

  String get listingsFilterLive;

  String get listingsFilterSoldOut;

  String get listingsEmptyTitle;

  String get listingsEmptyBody;

  String get listingsEmptyFilter;

  String listingsStock(int count);

  String listingsViews(int count);

  String get listingsQuickStock;

  String get listingTitle;

  String get listingOpenPreview;

  String get listingEdit;

  String get listingDuplicate;

  String get listingUnpublish;

  String get listingRelist;

  String get listingFinish;

  String get listingSoldOutTitle;

  String get listingSoldOutBody;

  String get editTitle;

  String get editBody;

  String get editRepublishing;

  String get editRepublished;

  String get editRepublishConfirm;

  String get quickStockTitle;

  String get quickStockMarkSoldOut;

  String get quickStockSave;

  String get quickStockSaved;

  String get unpublishTitle;

  String get unpublishBody;

  String get unpublishConfirm;

  String get unpublishCancel;

  String get unpublishDone;

  String get relistDone;

  String get duplicateTitle;

  String get duplicateBody;

  String get duplicateConfirm;

  String get duplicateCancel;

  String get duplicateBanner;

  String get listingActionFailed;

  String get salesTitle;

  String get salesNew;

  String get salesEmptyTitle;

  String get salesEmptyBody;

  String get salesLoading;

  String salesQuantity(int count);

  String salesPackBy(String date);

  String get salesPackByToday;

  String get salesPackByTomorrow;

  String get salesPackedAlready;

  String get salesSeeEarnings;

  String get saleTitle;

  String get saleReadOnly;

  String salePaid(String amount);

  String salePlaced(String date);

  String saleGoingTo(String area);

  String get saleWhatToPack;

  String get salePackingHelp;

  String get saleSeeListing;

  String get packingTitle;

  String get packingBody;

  String get packingStep1;

  String get packingStep2;

  String get packingStep3;

  String get packingStep4;

  String get packingStep5;

  String get packingDone;

  String packingProgress(int done, int total);

  String get earningsTitle;

  String get earningsWeek;

  String get earningsMonth;

  String get earningsTotal;

  String earningsItems(int count);

  String get earningsNote;

  String get profileOverviewTitle;

  String get profileVillageLabel;

  String get profileNotSet;

  String get profileEditEntry;

  String get profileStoryEntry;

  String get profileLanguageEntry;

  String get profilePhoneEntry;

  String get profileOndcEntry;

  String get profileNotificationsEntry;

  String get profileVoiceEntry;

  String get profilePrivacyEntry;

  String get profileStorageEntry;

  String get profileAccountEntry;

  String get editProfileTitle;

  String get editProfilePhoto;

  String get editProfileAddPhoto;

  String get editProfileChangePhoto;

  String get editProfileRemovePhoto;

  String get editProfilePhotoWhy;

  String get editProfileVillageHint;

  String get editProfileSave;

  String get editProfileSaved;

  String get storyTitle;

  String get storyBody;

  String get storyHoldToSpeak;

  String get storyEmpty;

  String get storyEditHint;

  String get storyExample;

  String get changePhoneTitle;

  String get changePhoneBody;

  String changePhoneCurrent(String number);

  String get changePhoneDone;

  String get ondcAccountTitle;

  String get ondcAccountLinked;

  String get ondcAccountNone;

  String get ondcAccountNoneBody;

  String get ondcAccountLink;

  String get ondcAccountUnlink;

  String get ondcUnlinkTitle;

  String get ondcUnlinkBody;

  String get ondcUnlinkConfirm;

  String get ondcUnlinkCancel;

  String get ondcUnlinkDone;

  String get notificationsTitle;

  String get notifySold;

  String get notifySoldWhy;

  String get notifyAttention;

  String get notifyAttentionWhy;

  String get notifyUpload;

  String get notifyUploadWhy;

  String get notificationsBlocked;

  String get voiceSettingsTitle;

  String get voiceSpeed;

  String get voiceSpeedSlow;

  String get voiceSpeedFast;

  String get voiceTry;

  String get voiceSample;

  String get voiceAutoRead;

  String get voiceAutoReadWhy;

  String get voiceVolume;

  String get voiceUnavailable;

  String get privacyTitle;

  String get privacyBody;

  String get privacyPhoto;

  String get privacyStory;

  String get privacyNothing;

  String get privacyWithdrawTitle;

  String get privacyWithdrawPhotoBody;

  String get privacyWithdrawStoryBody;

  String get privacyWithdrawConfirm;

  String get privacyWithdrawCancel;

  String get privacyWithdrawn;

  String get storageTitle;

  String get storagePhotos;

  String storageWaiting(int count);

  String get storageClear;

  String get storageClearWhy;

  String storageCleared(String size);

  String get storageNothingToClear;

  String get accountTitle;

  String get accountSignOut;

  String get accountSignOutTitle;

  String get accountSignOutBody;

  String get accountSignOutConfirm;

  String get accountSignOutCancel;

  String get accountDelete;

  String get accountDeleteTitle;

  String get accountDeleteBody;

  String get accountDeleteConfirm;

  String get accountDeleteCancel;

  String get accountDeleteHold;

  String get profileHelpEntry;

  String get helpTitle;

  String get helpBody;

  String get helpSteps;

  String get helpTopicPhotos;

  String get helpTopicPhotosBody;

  String get helpTopicPhotosStep1;

  String get helpTopicPhotosStep2;

  String get helpTopicPhotosStep3;

  String get helpTopicPhotosStep4;

  String get helpTopicPhotosStep5;

  String get helpTopicVoice;

  String get helpTopicVoiceBody;

  String get helpTopicVoiceStep1;

  String get helpTopicVoiceStep2;

  String get helpTopicVoiceStep3;

  String get helpTopicVoiceStep4;

  String get helpTopicVoiceStep5;

  String get helpTopicPrice;

  String get helpTopicPriceBody;

  String get helpTopicPriceStep1;

  String get helpTopicPriceStep2;

  String get helpTopicPriceStep3;

  String get helpTopicPriceStep4;

  String get helpTopicSold;

  String get helpTopicSoldBody;

  String get helpTopicSoldStep1;

  String get helpTopicSoldStep2;

  String get helpTopicSoldStep3;

  String get helpTopicSoldStep4;

  String get helpTopicSoldStep5;

  String get helpVideoComing;

  String get helpPractice;

  String get helpPracticeBody;

  String get helpFaqEntry;

  String get helpAboutEntry;

  String get helpSupportEntry;

  String get helpTermsEntry;

  String get helpVersionEntry;

  String get faqTitle;

  String get faqQ1;

  String get faqA1;

  String get faqQ2;

  String get faqA2;

  String get faqQ3;

  String get faqA3;

  String get faqQ4;

  String get faqA4;

  String get faqQ5;

  String get faqA5;

  String get faqQ6;

  String get faqA6;

  String get faqQ7;

  String get faqA7;

  String get aboutTitle;

  String get aboutWhatTitle;

  String get aboutWhat;

  String get aboutWhyTitle;

  String get aboutWhy;

  String get aboutHowTitle;

  String get aboutHow;

  String get aboutSihTitle;

  String get aboutSih;

  String get aboutMissionTitle;

  String get aboutMission;

  String get aboutTeamTitle;

  String get supportTitle;

  String get supportBody;

  String get supportCall;

  String get supportWhatsApp;

  String get supportHours;

  String supportNumber(String number);

  String supportFailed(String number);

  String get termsTitle;

  String get termsSummaryTitle;

  String get termsSummary1;

  String get termsSummary2;

  String get termsSummary3;

  String get termsSummary4;

  String get termsSummary5;

  String get termsFullTitle;

  String get termsFullBody;

  String get termsOpenFull;

  String get versionTitle;

  String versionNumber(String version);

  String get versionUpToDate;

  String get versionCheck;

  String get versionChecking;

  String get versionLicences;

  String get versionLicencesWhy;

  String get noNetworkTitle;

  String get noNetworkBody;

  String get noNetworkNeeded;

  String get serverErrorTitle;

  String get serverErrorBody;

  String get actionTryAgain;

  String get permissionRecoveryTitle;

  String get permissionRecoveryBody;

  String get permissionCameraWhy;

  String get permissionMicWhy;

  String get permissionNotifyTitle;

  String get permissionNotifyWhy;

  String get permissionBlocked;

  String get permissionAsk;

  String get permissionRecheck;

  String get permissionAllGood;

  String get updateTitle;

  String get updateBody;

  String get updateAction;

  String get updateFailed;

  String get emptyNudge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
