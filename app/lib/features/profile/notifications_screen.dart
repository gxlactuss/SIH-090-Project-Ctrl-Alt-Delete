import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/seller_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/permission_service.dart';
import '../../widgets/big_action_button.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/info_panel.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _loaded = false;
  bool _sold = true;
  bool _attention = true;
  bool _upload = true;
  bool _packBy = true;
  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sellers = context.read<SellerRepository>();
    final permissions = context.read<PermissionService>();

    final sold = await sellers.notifySold();
    final attention = await sellers.notifyNeedsAttention();
    final upload = await sellers.notifyUploadFinished();
    final packBy = await sellers.notifyPackBy();
    final status = await permissions.check(AppPermission.notifications);

    if (!mounted) return;
    setState(() {
      _sold = sold;
      _attention = attention;
      _upload = upload;
      _packBy = packBy;
      _blocked = status != PermissionOutcome.granted;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sellers = context.read<SellerRepository>();

    return SettingsScaffold(
      title: l10n.notificationsTitle,
      busy: !_loaded,
      rows: [
        if (_blocked) ...[_BlockedPanel(), const SizedBox(height: 16)],
        SettingsToggle(
          label: l10n.notifySold,
          explain: l10n.notifySoldWhy,
          value: _sold,
          enabled: !_blocked,
          onChanged: (value) {
            setState(() => _sold = value);
            sellers.saveNotifySold(value);
          },
        ),
        SettingsToggle(
          label: l10n.notifyAttention,
          explain: l10n.notifyAttentionWhy,
          value: _attention,
          enabled: !_blocked,
          onChanged: (value) {
            setState(() => _attention = value);
            sellers.saveNotifyNeedsAttention(value);
          },
        ),
        SettingsToggle(
          label: l10n.notifyUpload,
          explain: l10n.notifyUploadWhy,
          value: _upload,
          enabled: !_blocked,
          onChanged: (value) {
            setState(() => _upload = value);
            sellers.saveNotifyUploadFinished(value);
          },
        ),
        SettingsToggle(
          label: l10n.notifyPackBy,
          explain: l10n.notifyPackByWhy,
          value: _packBy,
          enabled: !_blocked,
          onChanged: (value) {
            setState(() => _packBy = value);
            sellers.saveNotifyPackBy(value);
          },
        ),
      ],
      actions: [
        if (_blocked)
          BigActionButton(
            label: l10n.captureOpenSettings,
            icon: Icons.settings,
            onPressed: () => context.read<PermissionService>().openSettings(),
          ),
      ],
    );
  }
}

class _BlockedPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InfoPanel(
      icon: Icons.notifications_off_outlined,
      text: l10n.notificationsBlocked,
    );
  }
}
