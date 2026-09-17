import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/permission_service.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import '../profile/widgets/settings_scaffold.dart';
import '../../widgets/info_panel.dart';

class PermissionRecoveryScreen extends StatefulWidget {
  const PermissionRecoveryScreen({super.key});

  @override
  State<PermissionRecoveryScreen> createState() =>
      _PermissionRecoveryScreenState();
}

class _PermissionRecoveryScreenState extends State<PermissionRecoveryScreen>
    with WidgetsBindingObserver {
  final Map<AppPermission, PermissionOutcome> _status = {};
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final permissions = context.read<PermissionService>();
    setState(() => _checking = true);

    for (final permission in AppPermission.values) {
      _status[permission] = await permissions.check(permission);
    }
    if (mounted) setState(() => _checking = false);
  }

  Future<void> _ask(AppPermission permission) async {
    final permissions = context.read<PermissionService>();
    final outcome = await permissions.request(permission);
    if (!mounted) return;

    if (outcome == PermissionOutcome.blocked) {
      await permissions.openSettings();
      return;
    }
    setState(() => _status[permission] = outcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allGranted = AppPermission.values.every(
      (p) => _status[p] == PermissionOutcome.granted,
    );

    return SettingsScaffold(
      title: l10n.permissionRecoveryTitle,
      subtitle: l10n.permissionRecoveryBody,
      busy: _checking,
      rows: [
        if (allGranted && !_checking) ...[
          InfoPanel(
            icon: Icons.check_circle,
            text: l10n.permissionAllGood,
            tone: InfoTone.success,
            bordered: true,
            emphasized: true,
            margin: const EdgeInsets.only(bottom: 16),
          ),
        ],
        for (final permission in AppPermission.values)
          _PermissionRow(
            permission: permission,
            outcome: _status[permission],
            onAsk: () => _ask(permission),
          ),
      ],
      actions: [
        BigActionButton(
          label: l10n.captureOpenSettings,
          icon: Icons.settings,
          onPressed: () => context.read<PermissionService>().openSettings(),
          spokenLabel:
              '${l10n.captureOpenSettings}. ${l10n.permissionRecoveryBody}',
        ),
        BigActionButton(
          label: l10n.permissionRecheck,
          icon: Icons.refresh,
          tone: ButtonTone.secondary,
          busy: _checking,
          onPressed: _checking ? null : _check,
        ),
      ],
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.permission,
    required this.outcome,
    required this.onAsk,
  });

  final AppPermission permission;
  final PermissionOutcome? outcome;
  final VoidCallback onAsk;

  ({String title, String why, IconData icon}) _copy(AppLocalizations l10n) =>
      switch (permission) {
        AppPermission.camera => (
          title: l10n.permissionCameraTitle,
          why: l10n.permissionCameraWhy,
          icon: Icons.photo_camera_outlined,
        ),
        AppPermission.microphone => (
          title: l10n.permissionMicTitle,
          why: l10n.permissionMicWhy,
          icon: Icons.mic_none,
        ),
        AppPermission.notifications => (
          title: l10n.permissionNotifyTitle,
          why: l10n.permissionNotifyWhy,
          icon: Icons.notifications_none,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final copy = _copy(l10n);
    final granted = outcome == PermissionOutcome.granted;
    final tone = granted ? AppColors.success : AppColors.danger;
    final state = granted ? l10n.permissionGranted : l10n.permissionBlocked;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: granted ? AppColors.border : tone, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(copy.icon, size: 28, color: AppColors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: WholeWordText(
                  copy.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                granted ? Icons.check_circle : Icons.cancel_outlined,
                size: 24,
                color: tone,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: WholeWordText(
                  state,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tone,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: WholeWordText(
                  copy.why,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: AppColors.muted,
                  ),
                ),
              ),
              SpeakButton.lines(
                lines: [copy.title, state, copy.why],
                utteranceKey: 'permission:${permission.name}',
                size: 28,
              ),
            ],
          ),
          if (!granted)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onAsk,
                icon: const Icon(Icons.lock_open, size: 22),
                label: WholeWordText(l10n.permissionAsk),
              ),
            ),
        ],
      ),
    );
  }
}
