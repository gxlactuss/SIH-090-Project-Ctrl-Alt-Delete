import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_theme.dart';
import 'whole_word_text.dart';

class HoldToSpeakButton extends StatefulWidget {
  const HoldToSpeakButton({
    super.key,
    required this.label,
    required this.recording,
    required this.onStart,
    required this.onStop,
  });

  final String label;
  final bool recording;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;

  @override
  State<HoldToSpeakButton> createState() => _HoldToSpeakButtonState();
}

class _HoldToSpeakButtonState extends State<HoldToSpeakButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppMotion.breathe,
  );

  bool _pressed = false;
  bool _reduced = false;

  int? _pointer;
  Future<void>? _starting;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = AppMotion.reduced(context);
    _syncPulse();
  }

  @override
  void didUpdateWidget(HoldToSpeakButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recording != widget.recording) {
      _syncPulse();
      if (widget.recording) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _syncPulse() {
    if (widget.recording && !_reduced) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  void _down(PointerDownEvent event) {
    if (_pointer != null) return;
    _pointer = event.pointer;
    setState(() => _pressed = true);
    _starting = widget.onStart();
  }

  Future<void> _up(PointerEvent event) async {
    if (event.pointer != _pointer) return;
    _pointer = null;
    if (mounted) setState(() => _pressed = false);

    final stop = widget.onStop;
    final starting = _starting;
    _starting = null;
    if (starting != null) {
      try {
        await starting;
      } catch (_) {}
    }
    await stop();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Widget _ring(double t) {
    final spread = 12 * t;
    return Positioned(
      left: -spread,
      top: -spread,
      right: -spread,
      bottom: -spread,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radius + spread),
          border: Border.all(
            color: AppColors.danger.withValues(alpha: 0.55 * (1 - t)),
            width: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recording = widget.recording;
    final duration = AppMotion.of(context, AppMotion.fast);

    return Semantics(
      button: true,
      label: widget.label,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _down,
        onPointerUp: _up,
        onPointerCancel: _up,
        child: AnimatedScale(
          scale: _pressed || recording ? 0.97 : 1,
          duration: duration,
          curve: AppMotion.enter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (recording)
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    final t = _pulse.value;
                    return Positioned.fill(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: _reduced
                            ? [_ring(0.3)]
                            : [_ring(t), _ring((t + 0.5) % 1)],
                      ),
                    );
                  },
                ),
              AnimatedContainer(
                duration: duration,
                constraints: const BoxConstraints(minHeight: 78),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: recording ? AppColors.danger : AppColors.terracotta,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      recording ? Icons.stop : Icons.mic,
                      size: 32,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: WholeWordText(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
