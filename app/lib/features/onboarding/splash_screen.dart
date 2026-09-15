import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/update_service.dart';
import '../../state/app_state.dart';
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
    await appState.bootstrap();

    await updates.check();

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final String next;
    if (updates.mustUpdate) {
      next = AppRoutes.forceUpdate;
    } else if (appState.hasCompletedSetup) {
      next = AppRoutes.home;
    } else if (appState.hasChosenLanguage) {
      next = AppRoutes.welcome;
    } else {
      next = AppRoutes.language;
    }
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 132,
              height: 132,
              decoration: const BoxDecoration(
                color: AppColors.terracotta,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.pan_tool_alt,
                size: 68,
                color: AppColors.cream,
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
