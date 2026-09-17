import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import 'widgets/step_line.dart';
import '../../widgets/whole_word_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = PageController();
  late SpeechService _speech;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = context.read<SpeechService>();
  }

  @override
  void dispose() {
    _pages.dispose();
    _speech.stop();
    super.dispose();
  }

  List<_WelcomeCard> _cards(AppLocalizations l10n) => [
    _WelcomeCard(
      icon: Icons.photo_camera,
      title: l10n.welcomeCard1Title,
      body: l10n.welcomeCard1Body,
    ),
    _WelcomeCard(
      icon: Icons.mic,
      title: l10n.welcomeCard2Title,
      body: l10n.welcomeCard2Body,
    ),
    _WelcomeCard(
      icon: Icons.storefront,
      title: l10n.welcomeCard3Title,
      body: l10n.welcomeCard3Body,
    ),
  ];

  void _narrate(_WelcomeCard card) {
    _speech.speakIfAuto([card.title, card.body], key: 'welcome:${card.title}');
  }

  Future<void> _leave() async {
    await context.read<AppState>().markWelcomeSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.termsAgree);
  }

  void _next(int lastIndex) {
    if (_index >= lastIndex) {
      _leave();
      return;
    }
    _pages.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cards = _cards(l10n);
    final isLast = _index == cards.length - 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: const OnboardingStepLine(step: 3),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: cards.length,
                onPageChanged: (i) {
                  setState(() => _index = i);
                  _narrate(cards[i]);
                },
                itemBuilder: (context, i) => _CardView(
                  card: cards[i],
                  autoNarrateOnFirstBuild: i == 0,
                  onFirstBuild: () => _narrate(cards[i]),
                ),
              ),
            ),
            _Dots(count: cards.length, index: _index),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.gutter,
                16,
                AppTheme.gutter,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BigActionButton(
                    label: isLast ? l10n.welcomeStart : l10n.actionNext,
                    icon: isLast ? Icons.play_arrow : Icons.arrow_forward,
                    onPressed: () => _next(cards.length - 1),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _leave,
                    child: WholeWordText(l10n.actionSkip),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard {
  const _WelcomeCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _CardView extends StatefulWidget {
  const _CardView({
    required this.card,
    required this.autoNarrateOnFirstBuild,
    required this.onFirstBuild,
  });

  final _WelcomeCard card;

  final bool autoNarrateOnFirstBuild;
  final VoidCallback onFirstBuild;

  @override
  State<_CardView> createState() => _CardViewState();
}

class _CardViewState extends State<_CardView> {
  @override
  void initState() {
    super.initState();
    if (widget.autoNarrateOnFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFirstBuild();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = widget.card;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.gutter,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.warningTint,
              borderRadius: BorderRadius.circular(AppTheme.radius * 1.4),
            ),
            alignment: Alignment.center,
            child: Icon(card.icon, size: 96, color: AppColors.terracotta),
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WholeWordText(
                  card.title,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              SpeakButton.lines(
                lines: [card.title, card.body],
                utteranceKey: 'welcome:${card.title}',
                size: 34,
              ),
            ],
          ),
          const SizedBox(height: 10),
          WholeWordText(card.body, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            width: i == index ? 30 : 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: i == index ? AppColors.terracotta : AppColors.border,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
      ],
    );
  }
}
