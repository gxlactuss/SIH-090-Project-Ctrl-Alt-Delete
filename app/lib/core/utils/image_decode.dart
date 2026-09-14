import 'package:flutter/widgets.dart';

int decodeWidthFor(BuildContext context, double logicalSize) =>
    (logicalSize * MediaQuery.devicePixelRatioOf(context) * 2).ceil();
