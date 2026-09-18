import 'package:flutter_test/flutter_test.dart';
import 'package:kirtikar/data/models/sale.dart';
import 'package:kirtikar/data/repositories/seller_repository.dart';
import 'package:kirtikar/services/deep_link_service.dart';
import 'package:kirtikar/services/notification_service.dart';

class _Sellers implements SellerRepository {
  bool packBy = true;
  Set<String> reminded = {};

  @override
  Future<bool> notifyPackBy() async => packBy;

  @override
  Future<Set<String>> remindedToPack() async => {...reminded};

  @override
  Future<void> saveRemindedToPack(Set<String> keys) async =>
      reminded = {...keys};

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  final monday = DateTime(2026, 9, 14, 9);

  Sale sale(String id, DateTime? packBy) => Sale(
    id: id,
    listingTitle: 'Blue water jug',
    quantity: 1,
    amountInPaise: 45000,
    placedAt: DateTime(2026, 9, 12),
    packByDate: packBy,
  );

  late _Sellers sellers;
  late DebugNotificationPresenter tray;
  late NotificationService notifications;

  setUp(() {
    sellers = _Sellers();
    tray = DebugNotificationPresenter();
    notifications = NotificationService(sellers: sellers, presenter: tray);
  });

  test(
    'reminds the day before and on the day, and never twice a day',
    () async {
      final sales = [sale('s1', DateTime(2026, 9, 15))];

      expect(await notifications.remindToPack(sales, now: monday), 1);
      expect(
        await notifications.remindToPack(
          sales,
          now: monday.add(const Duration(hours: 1)),
        ),
        0,
      );
      expect(
        await notifications.remindToPack(
          sales,
          now: monday.add(const Duration(days: 1)),
        ),
        1,
      );
      expect(tray.shown, hasLength(2));
      expect(tray.shown.first.kind, NotificationKind.packBy);
    },
  );

  test('says nothing about sales that are far off, past, or undated', () async {
    final sales = [
      sale('later', DateTime(2026, 9, 20)),
      sale('past', DateTime(2026, 9, 13)),
      sale('none', null),
    ];

    expect(await notifications.remindToPack(sales, now: monday), 0);
    expect(tray.shown, isEmpty);
  });

  test(
    'a reminder held back by the switch is still owed when it is turned on',
    () async {
      final sales = [sale('s1', DateTime(2026, 9, 15))];

      sellers.packBy = false;
      expect(await notifications.remindToPack(sales, now: monday), 0);

      sellers.packBy = true;
      expect(await notifications.remindToPack(sales, now: monday), 1);
    },
  );

  test('forgets reminders for sales no longer in the list', () async {
    sellers.reminded = {'gone:1'};
    await notifications.remindToPack([
      sale('s1', DateTime(2026, 9, 15)),
    ], now: monday);
    expect(sellers.reminded, {'s1:1'});
  });

  test('tapping one opens the sale', () {
    const message = PushMessage(kind: NotificationKind.packBy, saleId: 's1');
    expect(message.target, isA<LinkTarget>());
  });
}
