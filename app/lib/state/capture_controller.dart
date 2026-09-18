import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/image_quality.dart';
import '../core/utils/photo_edit.dart';
import '../data/local/capture_dao.dart';
import '../data/models/capture_item.dart';
import '../services/analytics_service.dart';
import '../services/recorder_service.dart';
import 'queue_controller.dart';

enum CaptureStage {
  camera,

  checking,

  qualityWarning,

  photoSet,

  photoEdit,

  voiceRecord,

  saved,
}

class CaptureController extends ChangeNotifier {
  CaptureController({
    required this._dao,
    required this._queue,
    required this._recorder,
    Uuid uuid = const Uuid(),
    Future<ImageQuality> Function(Uint8List bytes)? qualityChecker,
    Future<ImageIssue?> Function(File photo, int width, int height)?
    framingChecker,
    Future<Directory> Function()? storageDirectory,
    Future<Uint8List?> Function(Uint8List bytes, PhotoEdit edit)? photoRenderer,
    this._analytics,
    this.templateListingId,
  }) : _checkQuality = qualityChecker ?? _defaultQualityCheck,
       _checkFraming = framingChecker,
       _renderEdit = photoRenderer ?? _defaultRender,
       _storageDirectory = storageDirectory ?? getApplicationDocumentsDirectory,
       id = uuid.v4();

  final CaptureDao _dao;
  final QueueController _queue;
  final RecorderService _recorder;
  final Future<ImageQuality> Function(Uint8List bytes) _checkQuality;

  final Future<ImageIssue?> Function(File photo, int width, int height)?
  _checkFraming;
  final Future<Directory> Function() _storageDirectory;

  final Future<Uint8List?> Function(Uint8List bytes, PhotoEdit edit)
  _renderEdit;

  final AnalyticsService? _analytics;

  final String id;

  final String? templateListingId;

  bool get isDuplicate => templateListingId != null;

  int get stepCount => AppConstants.photosPerListing + (isDuplicate ? 0 : 1);

  int? get step => switch (_stage) {
    CaptureStage.photoSet => AppConstants.photosPerListing,
    CaptureStage.voiceRecord => AppConstants.photosPerListing + 1,
    CaptureStage.saved => null,
    _ =>
      hasAllPhotos
          ? AppConstants.photosPerListing
          : _slot.clamp(0, AppConstants.photosPerListing - 1) + 1,
  };

  CaptureStage _stage = CaptureStage.camera;
  CaptureStage get stage => _stage;

  final List<File> _photos = [];
  List<File>? _photoSnapshot;

  final List<ImageQuality?> _photoQuality = [];

  final List<File> _originals = [];
  final List<PhotoEdit?> _edits = [];

  List<File> get photos => _photoSnapshot ??= List.unmodifiable(_photos);

  int _slot = 0;
  int get slot => _slot;

  bool get isRetakingSlot => _slot < _photos.length;

  int get photoCount => _photos.length;

  ImageIssue? issueAt(int index) => index >= 0 && index < _photoQuality.length
      ? _photoQuality[index]?.issue
      : null;

  bool get hasAllPhotos => _photos.length >= AppConstants.photosPerListing;

  File? _shot;

  File? get shot => _shot;

  int? _editIndex;

  bool _discarded = false;
  bool _disposed = false;

  bool _applyingEdit = false;

  bool get isApplyingEdit => _applyingEdit;

  Object? _editError;
  Object? get editError => _editError;

  ImageQuality? _quality;
  ImageQuality? get quality => _quality;

  bool _checking = false;

  bool get isChecking => _checking;

  String? _voiceNotePath;
  String? get voiceNotePath => _voiceNotePath;

  String? _typedDescription;
  String? get typedDescription => _typedDescription;

  bool _saving = false;
  bool get isSaving => _saving;

  Object? _saveError;
  Object? get saveError => _saveError;

  Directory? _directory;

  Future<Directory> _captureDirectory() async {
    final existing = _directory;
    if (existing != null) return existing;
    final root = await _storageDirectory();
    final dir = Directory(p.join(root.path, 'captures', id));
    await dir.create(recursive: true);
    _directory = dir;
    return dir;
  }

  Future<String> voiceNoteTarget() async {
    final dir = await _captureDirectory();
    return p.join(dir.path, 'voice.m4a');
  }

  Future<void> reviewShot(File file) async {
    _shot = file;
    _quality = null;
    _checking = true;
    _stage = CaptureStage.checking;
    notifyListeners();

    ImageQuality quality;
    try {
      quality = await _checkQuality(await file.readAsBytes());
    } catch (_) {
      quality = const ImageQuality(
        sharpness: 0,
        brightness: 0,
        isAcceptable: true,
      );
    }

    if (quality.isAcceptable) quality = await _withFraming(file, quality);

    if (_discarded || _disposed) return;
    _quality = quality;
    _checking = false;
    if (quality.isAcceptable) {
      await keepShot();
      return;
    }

    _stage = CaptureStage.qualityWarning;
    _analytics?.log(
      AnalyticsEvent.retakePrompted,
      properties: {'captureId': id, 'reason': quality.issue?.name},
    );
    notifyListeners();
  }

  Future<ImageQuality> _withFraming(File file, ImageQuality quality) async {
    final check = _checkFraming;
    if (check == null || quality.width == 0 || quality.height == 0) {
      return quality;
    }

    final ImageIssue? issue;
    try {
      issue = await check(file, quality.width, quality.height);
    } catch (_) {
      return quality;
    }
    if (issue == null) return quality;

    return ImageQuality(
      sharpness: quality.sharpness,
      brightness: quality.brightness,
      width: quality.width,
      height: quality.height,
      isAcceptable: false,
      issue: issue,
    );
  }

  Future<void> keepShot() async {
    final shot = _shot;
    if (shot == null) return;

    final dir = await _captureDirectory();
    final target = File(p.join(dir.path, 'photo_${_slot + 1}.jpg'));
    try {
      if (await target.exists()) await target.delete();
      await shot.copy(target.path);
      await _deleteQuietly(shot);
    } catch (_) {
      await _place(shot);
      _afterKeep();
      return;
    }

    await _place(target);
    _afterKeep();
  }

  Future<void> _place(File file) async {
    if (_slot < _photos.length) {
      final old = _photos[_slot];
      if (old.path != _originals[_slot].path && old.path != file.path) {
        await _deleteQuietly(old);
      }
      _photos[_slot] = file;
      _originals[_slot] = file;
      _edits[_slot] = null;
      _photoQuality[_slot] = _quality;
    } else {
      _photos.add(file);
      _originals.add(file);
      _edits.add(null);
      _photoQuality.add(_quality);
    }
  }

  void _afterKeep() {
    if (_photos.isNotEmpty) {
      _analytics?.captureStarted(id);
      if (isDuplicate) {
        _analytics?.log(
          AnalyticsEvent.duplicateStarted,
          properties: {'captureId': id, 'from': templateListingId},
        );
      }
    }
    _shot = null;
    _quality = null;
    _slot = _photos.length;
    _stage = hasAllPhotos ? CaptureStage.photoSet : CaptureStage.camera;
    notifyListeners();
  }

  Future<void> retakeShot() async {
    final shot = _shot;
    _shot = null;
    _quality = null;
    _stage = CaptureStage.camera;
    notifyListeners();
    await _deleteQuietly(shot);
  }

  void editPhotoAt(int index) {
    if (index < 0 || index >= _photos.length) return;
    _editIndex = index;
    _editError = null;
    _stage = CaptureStage.photoEdit;
    notifyListeners();
  }

  File? get editSource => switch (_editIndex) {
    final i? when i < _originals.length => _originals[i],
    _ => null,
  };

  PhotoEdit get currentEdit => switch (_editIndex) {
    final i? when i < _edits.length => _edits[i] ?? PhotoEdit.identity,
    _ => PhotoEdit.identity,
  };

  void cancelEdit() {
    if (_stage != CaptureStage.photoEdit || _applyingEdit) return;
    _editIndex = null;
    _editError = null;
    _stage = CaptureStage.photoSet;
    notifyListeners();
  }

  Future<bool> applyEdit(PhotoEdit edit) async {
    final index = _editIndex;
    final source = editSource;
    if (index == null || source == null || _applyingEdit) return false;

    File? rendered;
    if (!edit.isIdentity) {
      _applyingEdit = true;
      _editError = null;
      notifyListeners();
      try {
        final bytes = await _renderEdit(await source.readAsBytes(), edit);
        if (bytes == null) throw const FormatException('undecodable photo');
        final dir = await _captureDirectory();
        rendered = File(
          p.join(
            dir.path,
            'photo_${index + 1}_edit_${DateTime.now().microsecondsSinceEpoch}.jpg',
          ),
        );
        await rendered.writeAsBytes(bytes, flush: true);
      } catch (error) {
        await _deleteQuietly(rendered);
        _editError = error;
        _applyingEdit = false;
        notifyListeners();
        return false;
      }
      _applyingEdit = false;
    }

    if (_stage != CaptureStage.photoEdit || _editIndex != index) {
      await _deleteQuietly(rendered);
      return false;
    }

    File? stale;
    final original = _originals[index];
    final old = _photos[index];
    if (old.path != original.path) stale = old;
    _photos[index] = rendered ?? original;
    _edits[index] = edit.isIdentity ? null : edit;

    _editIndex = null;
    _stage = CaptureStage.photoSet;
    notifyListeners();
    await _deleteQuietly(stale);
    return true;
  }

  void retakePhotoAt(int index) {
    if (index < 0 || index >= _photos.length) return;
    _slot = index;
    _stage = CaptureStage.camera;
    notifyListeners();
  }

  void movePhoto(int from, int to) {
    if (from == to) return;
    if (from < 0 || from >= _photos.length) return;
    if (to < 0 || to >= _photos.length) return;
    final photo = _photos.removeAt(from);
    _photos.insert(to, photo);
    _originals.insert(to, _originals.removeAt(from));
    _edits.insert(to, _edits.removeAt(from));
    _photoQuality.insert(to, _photoQuality.removeAt(from));
    notifyListeners();
  }

  void confirmPhotos() {
    if (!hasAllPhotos) return;
    if (isDuplicate) {
      save();
      return;
    }
    _stage = CaptureStage.voiceRecord;
    notifyListeners();
  }

  void backToPhotos() {
    _stage = CaptureStage.photoSet;
    notifyListeners();
  }

  Future<bool> startRecording() async {
    final path = await voiceNoteTarget();
    if (_voiceNotePath != null) {
      _voiceNotePath = null;
      notifyListeners();
    }
    return _recorder.start(
      path,
      maxDuration: const Duration(seconds: AppConstants.maxVoiceNoteSeconds),
    );
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stop();
    _voiceNotePath = path;
    notifyListeners();
  }

  Future<void> recordAgain() async {
    final old = _voiceNotePath;
    _voiceNotePath = null;
    _stage = CaptureStage.voiceRecord;
    notifyListeners();
    await _recorder.deleteFile(old);
  }

  Future<bool> saveTyped(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    final old = _voiceNotePath;
    _voiceNotePath = null;
    _typedDescription = trimmed;
    await _recorder.deleteFile(old);
    return save();
  }

  Future<bool> save() async {
    final voiceNote = _voiceNotePath;
    final typed = voiceNote == null ? _typedDescription : null;
    if (!hasAllPhotos || (voiceNote == null && typed == null && !isDuplicate)) {
      return false;
    }

    _saving = true;
    _saveError = null;
    notifyListeners();

    final item = CaptureItem(
      id: id,
      photoPaths: _photos.map((f) => f.path).toList(),
      voiceNotePath: voiceNote ?? '',
      createdAt: DateTime.now(),
      templateListingId: templateListingId,
      description: typed,
    );

    try {
      await _dao.insert(item);
    } catch (error) {
      _saveError = error;
      _saving = false;
      notifyListeners();
      return false;
    }

    _queue.add(item);
    for (var i = 0; i < _photos.length; i++) {
      if (_originals[i].path != _photos[i].path) {
        await _deleteQuietly(_originals[i]);
      }
    }
    _analytics?.log(AnalyticsEvent.captureSaved, properties: {'captureId': id});
    _saving = false;
    _stage = CaptureStage.saved;
    notifyListeners();
    return true;
  }

  Future<void> discard() async {
    if (_stage == CaptureStage.saved) return;
    _discarded = true;
    await _analytics?.captureDiscarded(id);
    await _deleteQuietly(_shot);
    if (_recorder.isRecording) await _recorder.cancel();
    final dir = _directory;
    if (dir == null) return;
    try {
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  }

  @override
  void notifyListeners() {
    _photoSnapshot = null;
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _deleteQuietly(File? file) async {
    if (file == null) return;
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}

Future<ImageQuality> _defaultQualityCheck(Uint8List bytes) =>
    compute(checkImageQualityBytes, bytes);

Future<Uint8List?> _defaultRender(Uint8List bytes, PhotoEdit edit) =>
    compute(renderPhotoEdit, PhotoEditJob(bytes, edit));
