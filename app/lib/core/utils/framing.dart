import 'dart:ui';

import '../constants/app_constants.dart';
import 'image_quality.dart';

ImageIssue? framingIssue(List<Rect> boxes, Size size) {
  if (size.isEmpty) return null;

  final frame = Offset.zero & size;
  final visible = [
    for (final box in boxes)
      if (box.intersect(frame) case final clipped when !clipped.isEmpty)
        clipped,
  ];
  if (visible.isEmpty) return ImageIssue.noSubject;

  final product = visible.reduce(
    (a, b) => a.width * a.height >= b.width * b.height ? a : b,
  );
  final marginX = size.width * AppConstants.frameEdgeMargin;
  final marginY = size.height * AppConstants.frameEdgeMargin;
  final touchesSide =
      product.left <= marginX || product.right >= size.width - marginX;
  final touchesEnd =
      product.top <= marginY || product.bottom >= size.height - marginY;

  final offsetX = (product.center.dx / size.width - 0.5).abs();
  final offsetY = (product.center.dy / size.height - 0.5).abs();

  final cutAtSide = touchesSide && offsetX > AppConstants.maxSubjectOffset;
  final cutAtEnd = touchesEnd && offsetY > AppConstants.maxSubjectOffset;
  if (cutAtSide || cutAtEnd) return ImageIssue.outOfFrame;

  final share = product.width * product.height / (size.width * size.height);
  return share < AppConstants.minSubjectArea ? ImageIssue.noSubject : null;
}
