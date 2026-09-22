import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/capture_dao.dart';
import '../../l10n/app_localizations.dart';
import '../../services/camera_service.dart';
import '../../services/framing_service.dart';
import '../../services/player_service.dart';
import '../../services/recorder_service.dart';
import '../../services/speech_service.dart';
import '../../core/di.dart';
import '../../services/analytics_service.dart';
import '../../state/capture_controller.dart';
import '../../state/queue_controller.dart';
import 'stages/camera_stage.dart';
import 'stages/checking_stage.dart';
import 'stages/photo_edit_stage.dart';
import 'stages/photo_set_stage.dart';
import 'stages/quality_warning_stage.dart';
import 'stages/saved_stage.dart';
import 'stages/voice_record_stage.dart';
import '../../widgets/stage_switcher.dart';
import '../../widgets/confirm_dialog.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({
    super.key,
    this.templateListingId,
    this.dao,
    this.camera,
    this.recorder,
    this.player,
    this.framing,
  });

  final String? templateListingId;

  final CaptureDao? dao;
  final CameraService? camera;
  final RecorderService? recorder;
  final PlayerService? player;
  final FramingService? framing;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late final CameraService _camera = widget.camera ?? CameraService();
  late final RecorderService _recorder = widget.recorder ?? RecorderService();
  late final PlayerService _player = widget.player ?? PlayerService();
  late final FramingService _framing = widget.framing ?? FramingService();
  late CaptureController _capture;
  late final SpeechService _speech;

  @override
  void initState() {
    super.initState();
    _capture = _newCapture();
    _capture.addListener(_onStageChanged);
    _camera.start();
    _speech = context.read<SpeechService>();
    _player.onBeforePlay = _speech.stop;
    _speech.onBeforeSpeak = _player.stop;
  }

  CaptureController _newCapture() => CaptureController(
    dao: widget.dao ?? CaptureDao(),
    queue: context.read<QueueController>(),
    recorder: _recorder,
    framingChecker: _framing.check,
    analytics: context.maybeRead<AnalyticsService>(),
    templateListingId: widget.templateListingId,
  );

  void _onStageChanged() {
    final onCamera = _capture.stage == CaptureStage.camera;
    if (onCamera && !_camera.isReady) {
      _camera.start();
    } else if (!onCamera && _camera.isReady) {
      _camera.stop();
    }
  }

  void _startAnother() {
    final old = _capture;
    setState(() {
      _capture = _newCapture();
      _capture.addListener(_onStageChanged);
    });
    old.removeListener(_onStageChanged);
    old.dispose();
    _camera.start();
  }

  Future<void> _confirmLeave() async {
    if (_capture.stage == CaptureStage.saved) {
      _leave();
      return;
    }

    final l10n = AppLocalizations.of(context);
    final leave = await showSpokenConfirm(
      context,
      title: l10n.captureLeaveTitle,
      body: l10n.captureLeaveBody,
      confirm: l10n.captureLeaveConfirm,
      cancel: l10n.captureLeaveCancel,
      speechKey: 'capture:leave',
    );

    if (!leave || !mounted) return;
    await _capture.discard();
    if (!mounted) return;
    _leave();
  }

  void _leave() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _speech.onBeforeSpeak = null;
    _capture.removeListener(_onStageChanged);
    _capture.dispose();
    if (widget.camera == null) _camera.dispose();
    if (widget.recorder == null) _recorder.dispose();
    if (widget.player == null) _player.dispose();
    if (widget.framing == null) _framing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraService>.value(value: _camera),
        ChangeNotifierProvider<RecorderService>.value(value: _recorder),
        ChangeNotifierProvider<PlayerService>.value(value: _player),
        ChangeNotifierProvider<CaptureController>.value(value: _capture),
      ],
      child: Consumer<CaptureController>(
        builder: (context, capture, _) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (capture.stage == CaptureStage.photoEdit) {
                capture.cancelEdit();
              } else {
                _confirmLeave();
              }
            },
            child: StageSwitcher(
              stage: capture.stage,
              step: capture.step,
              steps: capture.stepCount,
              child: switch (capture.stage) {
                CaptureStage.camera => CameraStage(onClose: _confirmLeave),
                CaptureStage.checking => CheckingStage(onClose: _confirmLeave),
                CaptureStage.qualityWarning => QualityWarningStage(
                  onClose: _confirmLeave,
                ),
                CaptureStage.photoSet => PhotoSetStage(onClose: _confirmLeave),
                CaptureStage.photoEdit => PhotoEditStage(
                  onClose: capture.cancelEdit,
                ),
                CaptureStage.voiceRecord => VoiceRecordStage(
                  onClose: _confirmLeave,
                ),
                CaptureStage.saved => SavedStage(
                  onDone: _leave,
                  onAnother: _startAnother,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
