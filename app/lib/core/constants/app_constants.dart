abstract final class AppConstants {
  static const int photosPerListing = 3;

  static const int qualityCheckWidth = 480;

  static const double minSharpness = 45.0;
  static const double minBrightness = 42.0;
  static const double maxBrightness = 232.0;

  static const int qualityGrid = 8;

  static const int minDetailCells = 3;

  static const double minContrast = 10.0;

  static const double minCellShade = 6.0;
  static const double maxSoftShare = 0.5;

  static const double minSubjectArea = 0.02;
  static const double frameEdgeMargin = 0.02;
  static const double maxSubjectOffset = 0.3;

  static const int maxVoiceNoteSeconds = 30;

  static const int minVoiceNoteSeconds = 3;

  static const double maxStraightenDegrees = 15.0;

  static const double maxPhotoZoom = 4.0;

  static const double maxCropAspect = 3.0;

  static const int photoEditPreviewSide = 1080;

  static const int editedPhotoMaxSide = 1600;
  static const int editedPhotoJpegQuality = 88;

  static const int onboardingSteps = 8;

  static const int termsVersion = 1;

  static const int phoneDigits = 10;

  static const int otpDigits = 6;

  static const int otpResendSeconds = 30;

  static const Duration otpAutoReadDelay = Duration(milliseconds: 2200);

  static const Duration fakeNetworkDelay = Duration(milliseconds: 900);
}
