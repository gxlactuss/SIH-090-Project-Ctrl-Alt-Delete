import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/dev/dev_accounts.dart';
import '../../core/dev/dev_skip_onboarding.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/app_language.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/whole_word_text.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key, this.isChange = false});

  final bool isChange;

  Future<void> _choose(BuildContext context, AppLanguage language) async {
    final navigator = Navigator.of(context);
    await context.read<AppState>().setLanguage(language);
    if (!context.mounted) return;

    if (isChange) {
      navigator.pop(language);
    } else {
      navigator.pushReplacementNamed(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = context.select((AppState s) => s.language);

    return Scaffold(
      appBar: isChange ? AppBar() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isChange) const SizedBox(height: 12),
              WholeWordText(
                l10n.languageTitle,
                style: isChange
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context).textTheme.headlineMedium,
              ),
              if (isChange) const SizedBox(height: 16),
              if (!isChange) ...[
                const SizedBox(height: 8),
                WholeWordText(
                  l10n.languageHint,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (DevAccounts.enabled && !isChange)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: OutlinedButton.icon(
                            key: const Key('dev-skip-onboarding'),
                            onPressed: () => skipOnboardingForDev(context),
                            icon: const Icon(Icons.fast_forward, size: 26),
                            label: const WholeWordText('Skip onboarding (dev)'),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.15,
                            ),
                        itemCount: AppLanguage.supported.length,
                        itemBuilder: (context, i) {
                          final language = AppLanguage.supported[i];
                          return _LanguageTile(
                            language: language,
                            selected: isChange && language.code == current.code,
                            onTap: () => _choose(context, language),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final speech = context.read<SpeechService>();
    final (available, speakingThis) = context.select(
      (SpeechService s) =>
          (s.isAvailable, s.speakingKey == 'lang:${language.code}'),
    );

    return Material(
      color: selected
          ? AppColors.terracotta.withValues(alpha: 0.10)
          : AppColors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.terracotta : AppColors.border,
          width: selected ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: WholeWordText(
                    language.endonym,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              if (available)
                IconButton(
                  onPressed: () => speech.speakIn(
                    language,
                    language.endonym,
                    key: 'lang:${language.code}',
                  ),
                  icon: Icon(
                    speakingThis ? Icons.stop_circle : Icons.volume_up,
                    size: 32,
                    color: speakingThis
                        ? AppColors.terracotta
                        : AppColors.muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
