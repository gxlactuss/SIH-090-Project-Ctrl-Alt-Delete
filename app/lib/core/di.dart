import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension OptionalRead on BuildContext {
  T? maybeRead<T extends Object>() {
    try {
      return read<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }
}
