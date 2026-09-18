import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_motion.dart';

class SuccessMark extends StatefulWidget {
  const SuccessMark({
    super.key,
    required this.icon,
    required this.colour,
    required this.tint,
    this.size = 116,
    this.iconSize = 64,
    this.celebrate = false,
  });

  final IconData icon;
  final Color colour;
  final Color tint;
  final double size;
  final double iconSize;
  final bool celebrate;

  @override
  State<SuccessMark> createState() => _SuccessMarkState();
}

class _SuccessMarkState extends State<SuccessMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.celebrate,
  );

  late final Animation<double> _circle = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.55, curve: AppMotion.overshoot),
  );

  late final Animation<double> _icon = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 0.85, curve: AppMotion.overshoot),
  );

  late final Animation<double> _ring = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 1, curve: AppMotion.enter),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
    if (widget.celebrate) HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (widget.celebrate)
            AnimatedBuilder(
              animation: _ring,
              builder: (context, _) {
                final t = _ring.value;
                if (t == 0 || t == 1) return const SizedBox.shrink();
                final grown = size * (1 + 0.35 * t);
                return OverflowBox(
                  maxWidth: grown,
                  maxHeight: grown,
                  child: Container(
                    width: grown,
                    height: grown,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.colour.withValues(alpha: 0.5 * (1 - t)),
                        width: 3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ScaleTransition(
            scale: _circle,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: widget.tint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _icon,
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.colour,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
