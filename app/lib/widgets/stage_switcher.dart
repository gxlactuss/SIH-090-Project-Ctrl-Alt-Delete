import 'package:flutter/material.dart';

import '../core/di.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/speech_service.dart';
import 'whole_word_text.dart';

class StageSwitcher extends StatefulWidget {
  const StageSwitcher({
    super.key,
    required this.stage,
    required this.child,
    this.step,
    this.steps,
  });

  final Object stage;
  final Widget child;
  final int? step;
  final int? steps;

  static bool owns(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_StageScope>() != null;

  static Widget? progressOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_StageScope>();
    final step = scope?.step;
    final steps = scope?.steps;
    if (scope == null || step == null || steps == null || steps <= 0) {
      return null;
    }
    return StepProgress(step: step, steps: steps, from: scope.from);
  }

  @override
  State<StageSwitcher> createState() => _StageSwitcherState();
}

class _StageSwitcherState extends State<StageSwitcher> {
  SpeechService? _speech;
  int? _from;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = context.maybeRead<SpeechService>();
  }

  @override
  void didUpdateWidget(StageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stage != widget.stage || oldWidget.step != widget.step) {
      _from = oldWidget.step;
    }
    if (oldWidget.stage != widget.stage) _speech?.stop();
  }

  @override
  void dispose() {
    _speech?.stop();
    super.dispose();
  }

  static Widget _transition(Widget child, Animation<double> animation) {
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slide,
        child: AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final leaving = animation.status == AnimationStatus.reverse;
            return IgnorePointer(
              ignoring: leaving,
              child: ExcludeSemantics(excluding: leaving, child: child),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _StageScope(
      step: widget.step,
      steps: widget.steps,
      from: _from,
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.medium),
        switchInCurve: AppMotion.standard,
        switchOutCurve: AppMotion.standardExit,
        layoutBuilder: (current, previous) =>
            Stack(fit: StackFit.expand, children: [...previous, ?current]),
        transitionBuilder: _transition,
        child: KeyedSubtree(
          key: ValueKey<Object>(widget.stage),
          child: widget.child,
        ),
      ),
    );
  }
}

class _StageScope extends InheritedWidget {
  const _StageScope({
    required this.step,
    required this.steps,
    required this.from,
    required super.child,
  });

  final int? step;
  final int? steps;
  final int? from;

  @override
  bool updateShouldNotify(_StageScope oldWidget) =>
      step != oldWidget.step ||
      steps != oldWidget.steps ||
      from != oldWidget.from;
}

class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.step,
    required this.steps,
    this.from,
  });

  final int step;
  final int steps;
  final int? from;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = l10n.stepOfSteps(step, steps);

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: (from ?? step) / steps, end: step / steps),
                duration: AppMotion.of(context, AppMotion.slow),
                curve: AppMotion.standard,
                builder: (context, value, _) =>
                    LinearProgressIndicator(value: value, minHeight: 6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: WholeWordText(
              label,
              style: const TextStyle(
                fontSize: AppTheme.minTextSize,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
