import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/photo_edit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/whole_word_text.dart';
import '../widgets/capture_scaffold.dart';
import '../widgets/crop_geometry.dart';

class PhotoEditStage extends StatefulWidget {
  const PhotoEditStage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<PhotoEditStage> createState() => _PhotoEditStageState();
}

enum _Drag { none, move, handle, pinch }

class _PhotoEditStageState extends State<PhotoEditStage> {
  static const _cornerReach = 30.0;
  static const _edgeReach = 22.0;

  ui.Image? _image;
  PhotoPreview? _preview;
  bool _failed = false;

  PhotoEdit _edit = PhotoEdit.identity;

  _Drag _drag = _Drag.none;
  Offset _dragStartFinger = Offset.zero;
  Rect _dragStartBox = Rect.zero;
  CropHandle _handle = (left: false, top: false, right: false, bottom: false);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final capture = context.read<CaptureController>();
    final source = capture.editSource;
    if (source == null) return;
    try {
      final bytes = await source.readAsBytes();
      final preview = await compute(decodePreview, bytes);
      if (preview == null) throw const FormatException('undecodable photo');
      final image = await _toUiImage(preview);
      if (!mounted) {
        image.dispose();
        return;
      }
      setState(() {
        _preview = preview;
        _image = image;
        _edit = capture.currentEdit.clampedFor(preview.width, preview.height);
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  static Future<ui.Image> _toUiImage(PhotoPreview preview) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(preview.rgba);
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: preview.width,
      height: preview.height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    codec.dispose();
    descriptor.dispose();
    buffer.dispose();
    return frame.image;
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  void _update(PhotoEdit edit) {
    final preview = _preview;
    if (preview == null) return;
    setState(() => _edit = edit.clampedFor(preview.width, preview.height));
  }

  CropGeometry _geometry(Size view) => CropGeometry(
    view: view,
    imageWidth: _preview!.width,
    imageHeight: _preview!.height,
    edit: _edit,
  );

  void _onScaleStart(ScaleStartDetails details, Size view) {
    final geometry = _geometry(view);
    final box = geometry.box;
    final finger = details.localFocalPoint;

    _dragStartFinger = finger;
    _dragStartBox = box;

    if (details.pointerCount > 1) {
      _drag = _Drag.pinch;
      return;
    }

    final corners = <(Offset, CropHandle)>[
      (box.topLeft, (left: true, top: true, right: false, bottom: false)),
      (box.topRight, (left: false, top: true, right: true, bottom: false)),
      (box.bottomLeft, (left: true, top: false, right: false, bottom: true)),
      (box.bottomRight, (left: false, top: false, right: true, bottom: true)),
    ];
    for (final (corner, handle) in corners) {
      if ((finger - corner).distance <= _cornerReach) {
        _drag = _Drag.handle;
        _handle = handle;
        return;
      }
    }

    final alongX = finger.dx >= box.left && finger.dx <= box.right;
    final alongY = finger.dy >= box.top && finger.dy <= box.bottom;
    final edges = <(bool, CropHandle)>[
      (
        alongY && (finger.dx - box.left).abs() <= _edgeReach,
        (left: true, top: false, right: false, bottom: false),
      ),
      (
        alongY && (finger.dx - box.right).abs() <= _edgeReach,
        (left: false, top: false, right: true, bottom: false),
      ),
      (
        alongX && (finger.dy - box.top).abs() <= _edgeReach,
        (left: false, top: true, right: false, bottom: false),
      ),
      (
        alongX && (finger.dy - box.bottom).abs() <= _edgeReach,
        (left: false, top: false, right: false, bottom: true),
      ),
    ];
    for (final (hit, handle) in edges) {
      if (hit) {
        _drag = _Drag.handle;
        _handle = handle;
        return;
      }
    }

    _drag = _Drag.move;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size view) {
    final geometry = _geometry(view);
    switch (_drag) {
      case _Drag.none:
        return;
      case _Drag.move:
        _update(
          geometry.editFor(
            _dragStartBox.shift(details.localFocalPoint - _dragStartFinger),
          ),
        );
      case _Drag.handle:
        _update(
          geometry.resize(_dragStartBox, _handle, details.localFocalPoint),
        );
      case _Drag.pinch:
        final start = _dragStartBox;
        final factor = math.max(
          details.scale,
          CropGeometry.minBoxSide / math.min(start.width, start.height),
        );
        _update(
          geometry.editFor(
            Rect.fromCenter(
              center: start.center,
              width: start.width * factor,
              height: start.height * factor,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final capture = context.watch<CaptureController>();
    final speech = context.read<SpeechService>();
    final image = _image;
    final preview = _preview;
    final ready = image != null && preview != null;
    final busy = capture.isApplyingEdit;

    return CaptureScaffold(
      title: l10n.photoEditTitle,
      subtitle: l10n.photoEditBody,
      onClose: widget.onClose,
      padBody: false,
      scrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: AppColors.ink,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final view = constraints.biggest;
                  if (_failed) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 56,
                        color: AppColors.marigold,
                      ),
                    );
                  }
                  if (!ready) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    key: const Key('photo-edit-canvas'),
                    behavior: HitTestBehavior.opaque,
                    onScaleStart: busy ? null : (d) => _onScaleStart(d, view),
                    onScaleUpdate: busy ? null : (d) => _onScaleUpdate(d, view),
                    onScaleEnd: (_) => _drag = _Drag.none,
                    child: CustomPaint(
                      size: view,
                      painter: _CropPainter(
                        image: image,
                        geometry: _geometry(view),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.25,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.gutter,
                8,
                AppTheme.gutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (capture.editError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: WholeWordText(
                        l10n.photoEditFailed,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      const Icon(
                        Icons.straighten,
                        size: 26,
                        color: AppColors.ink,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: WholeWordText(
                          l10n.photoEditStraighten,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _edit.angle,
                          min: -AppConstants.maxStraightenDegrees,
                          max: AppConstants.maxStraightenDegrees,
                          divisions: (AppConstants.maxStraightenDegrees * 4)
                              .round(),
                          onChanged: ready && !busy
                              ? (value) => _update(_edit.copyWith(angle: value))
                              : null,
                        ),
                      ),
                      WholeWordText(
                        '${_edit.angle > 0 ? '+' : ''}'
                        '${_edit.angle.toStringAsFixed(1)}°',
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: ready && !busy
                            ? () => _update(_edit.turned())
                            : null,
                        onLongPress: () => speech.speak(
                          l10n.photoEditTurn,
                          key: 'photoedit:turn',
                        ),
                        icon: const Icon(Icons.rotate_90_degrees_cw, size: 26),
                        label: WholeWordText(l10n.photoEditTurn),
                      ),
                      TextButton.icon(
                        onPressed: ready && !busy && !_edit.isIdentity
                            ? () => _update(PhotoEdit.identity)
                            : null,
                        onLongPress: () => speech.speak(
                          l10n.photoEditReset,
                          key: 'photoedit:reset',
                        ),
                        icon: const Icon(Icons.restart_alt, size: 26),
                        label: WholeWordText(l10n.photoEditReset),
                      ),
                      TextButton.icon(
                        onPressed: busy ? null : capture.cancelEdit,
                        onLongPress: () => speech.speak(
                          l10n.photoEditCancel,
                          key: 'photoedit:cancel',
                        ),
                        icon: const Icon(Icons.arrow_back, size: 26),
                        label: WholeWordText(l10n.photoEditCancel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.photoEditDone,
          icon: Icons.crop,
          busy: busy,
          onPressed: ready ? () => capture.applyEdit(_edit) : null,
        ),
      ],
    );
  }
}

class _CropPainter extends CustomPainter {
  _CropPainter({required this.image, required this.geometry});

  final ui.Image image;
  final CropGeometry geometry;

  @override
  void paint(Canvas canvas, Size size) {
    final edit = geometry.edit;
    final center = geometry.viewCenter;

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(edit.angle * math.pi / 180)
      ..scale(geometry.scale)
      ..rotate(edit.quarterTurns * math.pi / 2)
      ..drawImage(
        image,
        Offset(-image.width / 2, -image.height / 2),
        Paint()..filterQuality = FilterQuality.medium,
      )
      ..restore();

    final box = geometry.box;

    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRect(box),
      Paint()..color = Colors.black.withValues(alpha: 0.6),
    );

    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..strokeWidth = 3;
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.2;
    for (final paint in [shadow, line]) {
      for (var i = 1; i < 3; i++) {
        final x = box.left + box.width * i / 3;
        final y = box.top + box.height * i / 3;
        canvas
          ..drawLine(Offset(x, box.top), Offset(x, box.bottom), paint)
          ..drawLine(Offset(box.left, y), Offset(box.right, y), paint);
      }
    }

    canvas.drawRect(
      box,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 2,
    );

    final handle = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.marigold
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final arm = math.min(16.0, math.min(box.width, box.height) / 4);
    for (final (corner, dx, dy) in [
      (box.topLeft, 1.0, 1.0),
      (box.topRight, -1.0, 1.0),
      (box.bottomLeft, 1.0, -1.0),
      (box.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..drawLine(corner, corner + Offset(dx * arm, 0), handle)
        ..drawLine(corner, corner + Offset(0, dy * arm), handle);
    }
    final barX = math.min(12.0, box.width / 6);
    final barY = math.min(12.0, box.height / 6);
    final middle = box.center;
    canvas
      ..drawLine(
        Offset(middle.dx - barX, box.top),
        Offset(middle.dx + barX, box.top),
        handle,
      )
      ..drawLine(
        Offset(middle.dx - barX, box.bottom),
        Offset(middle.dx + barX, box.bottom),
        handle,
      )
      ..drawLine(
        Offset(box.left, middle.dy - barY),
        Offset(box.left, middle.dy + barY),
        handle,
      )
      ..drawLine(
        Offset(box.right, middle.dy - barY),
        Offset(box.right, middle.dy + barY),
        handle,
      );
  }

  @override
  bool shouldRepaint(_CropPainter old) =>
      old.image != image ||
      old.geometry.edit != geometry.edit ||
      old.geometry.view != geometry.view;
}
