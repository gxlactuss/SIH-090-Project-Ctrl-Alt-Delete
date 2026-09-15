import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/onboarding_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/onboarding_scaffold.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, this.isReplay = false});

  final bool isReplay;

  static const goodPhoto = 'assets/images/practice/good_photo.jpg';
  static const badPhoto = 'assets/images/practice/blurry_photo.jpg';

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _pages = PageController();
  late SpeechService _speech;
  int _index = 0;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = context.read<SpeechService>();
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  List<_Example> _examples(AppLocalizations l10n) => [
    _Example(
      good: true,
      asset: PracticeScreen.goodPhoto,
      badge: l10n.practiceGoodBadge,
      title: l10n.practiceGoodTitle,
      tips: [
        l10n.practiceGoodTip1,
        l10n.practiceGoodTip2,
        l10n.practiceGoodTip3,
      ],
    ),
    _Example(
      good: false,
      asset: PracticeScreen.badPhoto,
      badge: l10n.practiceBadBadge,
      title: l10n.practiceBadTitle,
      tips: [l10n.practiceBadTip1, l10n.practiceBadTip2, l10n.practiceBadTip3],
    ),
  ];

  void _goTo(int index) {
    _pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    if (widget.isReplay) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _finishing = true);
    await context.read<OnboardingController>().finish();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final examples = _examples(l10n);
    final isLast = _index == examples.length - 1;

    return OnboardingScaffold(
      step: widget.isReplay ? null : 10,
      title: l10n.practiceTitle,
      spokenLines: [l10n.practiceTitle, l10n.practiceIntro],
      compact: true,
      scrollable: false,
      body: Expanded(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: examples.length,
                onPageChanged: (i) {
                  setState(() => _index = i);
                  final example = examples[i];
                  _speech.speakIfAuto([
                    example.badge,
                    example.title,
                    ...example.tips,
                  ], key: 'practice:$i');
                },
                itemBuilder: (context, i) => _ExampleView(
                  example: examples[i],
                  intro: i == 0 ? l10n.practiceIntro : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Dots(count: examples.length, index: _index),
          ],
        ),
      ),
      actions: [
        if (isLast)
          BigActionButton(
            label: widget.isReplay ? l10n.actionDone : l10n.practiceFinish,
            icon: widget.isReplay ? Icons.check : Icons.home,
            busy: _finishing,
            onPressed: _finish,
          )
        else
          BigActionButton(
            label: l10n.actionNext,
            icon: Icons.arrow_forward,
            onPressed: () => _goTo(_index + 1),
          ),
        if (_index > 0)
          BigActionButton(
            label: l10n.actionBack,
            icon: Icons.arrow_back,
            tone: ButtonTone.secondary,
            onPressed: _finishing ? null : () => _goTo(_index - 1),
          ),
      ],
    );
  }
}

class _Example {
  const _Example({
    required this.good,
    required this.asset,
    required this.badge,
    required this.title,
    required this.tips,
  });

  final bool good;
  final String asset;
  final String badge;
  final String title;
  final List<String> tips;
}

class _ExampleView extends StatelessWidget {
  const _ExampleView({required this.example, this.intro});

  final _Example example;

  final String? intro;

  @override
  Widget build(BuildContext context) {
    final color = example.good ? AppColors.success : AppColors.danger;
    final mark = example.good ? Icons.check_circle : Icons.cancel;
    final spoken = [example.badge, example.title, ...example.tips];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (intro != null) ...[
            WholeWordText(
              intro!,
              style: const TextStyle(
                fontSize: 17,
                height: 1.35,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Icon(mark, size: 34, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: WholeWordText(
                  example.badge,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              SpeakButton.lines(
                lines: spoken,
                utteranceKey: 'practice:${example.asset}',
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 5),
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radius - 4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          example.asset,
                          fit: BoxFit.cover,
                          semanticLabel: '${example.badge}. ${example.title}',
                          errorBuilder: (context, _, _) => Container(
                            color: AppColors.cream,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image,
                              size: 48,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(mark, size: 48, color: color),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          WholeWordText(
            example.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          for (final tip in example.tips)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      example.good ? Icons.check : Icons.close,
                      size: 24,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WholeWordText(
                      tip,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
