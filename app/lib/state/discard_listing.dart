import 'dart:io';

import 'queue_controller.dart';

Future<void> dropQueuedCapture(QueueController? queue, String listingId) async {
  final queued = queue?.byId(listingId);
  if (queued == null) return;

  for (final path in [...queued.photoPaths, queued.voiceNotePath]) {
    if (path.isEmpty) continue;
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }
  await queue!.remove(listingId);
}
