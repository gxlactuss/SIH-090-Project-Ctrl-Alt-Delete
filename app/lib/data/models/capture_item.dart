class CaptureItem {
  const CaptureItem({
    required this.id,
    required this.photoPaths,
    required this.voiceNotePath,
    required this.createdAt,
    this.uploadedAt,
    this.attempts = 0,
    this.lastError,
    this.templateListingId,
    this.description,
  });

  final String id;
  final List<String> photoPaths;
  final String voiceNotePath;
  final DateTime createdAt;
  final DateTime? uploadedAt;
  final int attempts;

  final String? lastError;

  final String? templateListingId;

  final String? description;

  bool get isPending => uploadedAt == null;

  CaptureItem copyWith({
    DateTime? uploadedAt,
    int? attempts,
    String? lastError,

    bool clearError = false,
  }) {
    return CaptureItem(
      id: id,
      photoPaths: photoPaths,
      voiceNotePath: voiceNotePath,
      createdAt: createdAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      attempts: attempts ?? this.attempts,
      lastError: clearError ? null : lastError ?? this.lastError,
      templateListingId: templateListingId,
      description: description,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'photo_paths': photoPaths.join('\n'),
    'voice_note_path': voiceNotePath,
    'created_at': createdAt.millisecondsSinceEpoch,
    'uploaded_at': uploadedAt?.millisecondsSinceEpoch,
    'attempts': attempts,
    'last_error': lastError,
    'template_listing_id': templateListingId,
    'description': description,
  };

  factory CaptureItem.fromMap(Map<String, Object?> map) {
    final paths = (map['photo_paths'] as String? ?? '')
        .split('\n')
        .where((p) => p.isNotEmpty)
        .toList();
    final uploaded = map['uploaded_at'] as int?;

    return CaptureItem(
      id: map['id'] as String,
      photoPaths: paths,
      voiceNotePath: map['voice_note_path'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int? ?? 0,
      ),
      uploadedAt: uploaded == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(uploaded),
      attempts: map['attempts'] as int? ?? 0,
      lastError: map['last_error'] as String?,
      templateListingId: map['template_listing_id'] as String?,
      description: map['description'] as String?,
    );
  }
}
