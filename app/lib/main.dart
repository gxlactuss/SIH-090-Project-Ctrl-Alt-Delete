import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/config/sarvam_config.dart';
import 'data/remote/voice/sarvam_voice_api.dart';
import 'data/repositories/seller_repository.dart';
import 'firebase_options.dart';
import 'services/background_upload.dart';
import 'services/crash_reporter.dart';
import 'services/speech_service.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CrashReporter().install();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  BackgroundUpload.schedule();

  final voice = SarvamConfig.isConfigured
      ? SarvamVoiceApi(apiKey: SarvamConfig.apiKey)
      : null;

  runApp(
    MultiProvider(
      providers: appProviders(
        sellers: SellerRepository(),
        speech: SpeechService(voice: voice),
        voice: voice,
        backgroundUploads: BackgroundUpload.nudge,
      ),
      child: const KaarigarApp(),
    ),
  );
}
