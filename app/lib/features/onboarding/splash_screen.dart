import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/routing/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../l10n/app_localizations.dart';
import '../../services/update_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/whole_word_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final appState = context.read<AppState>();
    final updates = context.read<UpdateService>();
    await Future.wait([
      appState.bootstrap().then((_) => updates.check()),
      Future<void>.delayed(const Duration(milliseconds: 700)),
    ]);
    if (!mounted) return;

    final String next;
    if (updates.mustUpdate) {
      next = AppRoutes.forceUpdate;
    } else if (appState.hasCompletedSetup) {
      next = _needsSignIn ? AppRoutes.signInAgain : AppRoutes.home;
    } else if (appState.hasChosenLanguage) {
      next = AppRoutes.welcome;
    } else {
      next = AppRoutes.language;
    }
    Navigator.of(context).pushReplacementNamed(next);
  }

  bool get _needsSignIn =>
      AppConfig.hasBackend && !AuthRepository().isSignedIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: AppMotion.of(context, AppMotion.intro),
              curve: AppMotion.standard,
              builder: (context, t, _) => Opacity(
                opacity: (t * 2).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.85 + 0.15 * t,
                  child: const AppLogo(size: 132),
                ),
              ),
            ),
            const SizedBox(height: 28),
            WholeWordText(
              l10n.appTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: WholeWordText(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.muted),
              ),
            ),
            const SizedBox(height: 44),
            const SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
