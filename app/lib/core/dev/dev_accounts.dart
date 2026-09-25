abstract final class DevAccounts {
  static const bool enabled = !bool.fromEnvironment('dart.vm.product');

  static const String ondcSellerId = 'demo-seller-01';

  static const String ondcEmail = 'demo.seller@example.com';
}
