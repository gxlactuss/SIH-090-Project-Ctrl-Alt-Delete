abstract final class SarvamConfig {
  static const String apiKey = String.fromEnvironment('SARVAM_API_KEY');

  static bool get isConfigured => apiKey.isNotEmpty;

  static const String baseUrl = 'https://api.sarvam.ai';

  static const String sttModel = 'saaras:v3';

  static const Duration maxClipLength = Duration(seconds: 30);

  static const Duration transcribeTimeout = Duration(seconds: 20);

  static const String ttsModel = 'bulbul:v3';

  static const String ttsSpeaker = String.fromEnvironment(
    'SARVAM_TTS_SPEAKER',
    defaultValue: 'shubh',
  );

  static const int maxSpeakChars = 2500;

  static const Duration speakTimeout = Duration(seconds: 8);

  static const String translateModel = 'mayura:v1';

  static const int maxTranslateChars = 1000;

  static const Duration translateTimeout = Duration(seconds: 10);

  static const double rupeesPerSpokenThousandChars = 3.0;
  static const double rupeesPerTranscribedHour = 30.0;
  static const double rupeesPerTranslatedThousandChars = 2.0;
}
