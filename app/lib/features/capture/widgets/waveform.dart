import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';

class Waveform extends StatefulWidget {
  const Waveform({
    super.key,
    required this.level,
    required this.active,
    this.bars = 21,
  });

  final double level;

  final bool active;
  final int bars;

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform>
    with SingleTickerProviderStateMixin {
  static const double _minHeight = 8;
  static const double _maxHeight = 76;

  static const Duration _sampleEvery = Duration(milliseconds: 70);

  final math.Random _random = math.Random();

  late final Ticker _ticker = createTicker(_onTick);

  late List<double> _samples = List.filled(_sampleCount, 0);
  late List<double> _shown = List.filled(widget.bars, 0);

  Duration _last = Duration.zero;
  Duration _lastSample = Duration.zero;
  double _seconds = 0;

  int get _sampleCount => widget.bars ~/ 2 + 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  @override
  void didUpdateWidget(Waveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bars != widget.bars) {
      _samples = List.filled(_sampleCount, 0);
      _shown = List.filled(widget.bars, 0);
    }
    _syncTicker();
  }

  void _syncTicker() {
    final animate = widget.active && !AppMotion.reduced(context);
    if (animate && !_ticker.isActive) {
      _last = Duration.zero;
      _lastSample = Duration.zero;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _seconds += dt;

    if (widget.active && elapsed - _lastSample >= _sampleEvery) {
      _lastSample = elapsed;
      _samples = [_nextSample(), ..._samples.take(_sampleCount - 1)];
    } else if (!widget.active) {
      _samples = List.filled(_sampleCount, 0);
    }

    final ease = math.min(1.0, dt * 16);
    var settled = true;
    for (var i = 0; i < widget.bars; i++) {
      final target = _target(i);
      _shown[i] += (target - _shown[i]) * ease;
      if ((target - _shown[i]).abs() > 0.002) settled = false;
    }

    if (!widget.active && settled) {
      _ticker.stop();
      _shown = List.filled(widget.bars, 0);
    }
    setState(() {});
  }

  double _nextSample() {
    final level = widget.level.clamp(0.0, 1.0);
    if (level < 0.03) return 0;
    return (level * (0.35 + 0.65 * _random.nextDouble())).clamp(0.0, 1.0);
  }

  double _target(int index) {
    final centre = (widget.bars - 1) / 2;
    final distance = (index - centre).abs().round();
    final sample = _samples[math.min(distance, _sampleCount - 1)];
    final wobble =
        math.sin(_seconds * 9 + index * 1.7) * 0.12 * widget.level.clamp(0, 1);
    return (sample + wobble).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.reduced(context);
    final heights = [
      for (var i = 0; i < widget.bars; i++)
        _minHeight +
            (_maxHeight - _minHeight) *
                (reduced
                    ? (widget.active ? widget.level.clamp(0.0, 1.0) : 0.0)
                    : _shown[i]),
    ];

    return SizedBox(
      height: 84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final height in heights)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 6,
                height: height,
                decoration: BoxDecoration(
                  color: widget.active
                      ? AppColors.terracotta
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
