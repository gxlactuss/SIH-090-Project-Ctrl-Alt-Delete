import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/permission_service.dart';
import '../../services/speech_service.dart';
import '../../widgets/big_action_button.dart';
import 'widgets/onboarding_scaffold.dart';
import '../../widgets/whole_word_text.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  static const _order = [
    AppPermission.camera,
    AppPermission.microphone,
    AppPermission.notifications,
  ];

  int _index = 0;
  bool _asking = false;
  final Map<AppPermission, PermissionOutcome> _outcomes = {};

  AppPermission get _current => _order[_index];

  Future<void> _ask() async {
    final permissions = context.read<PermissionService>();
    setState(() => _asking = true);
    final outcome = await permissions.request(_current);
    if (!mounted) return;
    setState(() {
      _asking = false;
      _outcomes[_current] = outcome;
    });

    if (outcome != PermissionOutcome.blocked) _advance();
  }

  void _advance() {
    if (_index < _order.length - 1) {
      setState(() => _index++);
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.phone);
  }

  Future<void> _openSettings() async {
    await context.read<PermissionService>().openSettings();
  }

  _Copy _copy(AppLocalizations l10n) => switch (_current) {
    AppPermission.camera => _Copy(
      icon: Icons.photo_camera,
      title: l10n.permissionCameraTitle,
      body: l10n.permissionCameraBody,
    ),
    AppPermission.microphone => _Copy(
      icon: Icons.mic,
      title: l10n.permissionMicTitle,
      body: l10n.permissionMicBody,
    ),
    AppPermission.notifications => _Copy(
      icon: Icons.notifications_active,
      title: l10n.permissionNotificationTitle,
      body: l10n.permissionNotificationBody,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final copy = _copy(l10n);
    final blocked = _outcomes[_current] == PermissionOutcome.blocked;

    return OnboardingScaffold(
      key: ValueKey(_current),
      step: 5,
      title: copy.title,
      subtitle: copy.body,
      compact: true,
      spokenLines: [
        l10n.permissionsTitle,
        copy.title,
        copy.body,
        if (blocked) l10n.permissionDeniedBody,
      ],
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Icon(copy.icon, size: 76, color: AppColors.terracotta),
          ),
          const SizedBox(height: 16),
          if (blocked) ...[
            _DeniedNotice(
              title: l10n.permissionDeniedTitle,
              body: l10n.permissionDeniedBody,
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _order.length; i++)
                Container(
                  width: i == _index ? 28 : 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _index
                        ? AppColors.terracotta
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        if (blocked)
          BigActionButton(
            label: l10n.permissionOpenSettings,
            icon: Icons.settings,
            onPressed: _openSettings,
          )
        else
          BigActionButton(
            label: l10n.permissionAllow,
            icon: Icons.check_circle,
            busy: _asking,
            onPressed: _ask,
            spokenLabel: '${l10n.permissionAllow}. ${copy.body}',
          ),
        BigActionButton(
          label: blocked ? l10n.actionNext : l10n.permissionNotNow,
          icon: Icons.arrow_forward,
          tone: ButtonTone.secondary,
          onPressed: _asking ? null : _advance,
        ),
      ],
    );
  }
}

class _Copy {
  const _Copy({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

class _DeniedNotice extends StatelessWidget {
  const _DeniedNotice({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final speech = context.read<SpeechService>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerTint,
        border: Border.all(color: AppColors.danger, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WholeWordText(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: 6),
                WholeWordText(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => speech.speakAll([title, body], key: 'denied'),
            icon: const Icon(Icons.volume_up, size: 28),
          ),
        ],
      ),
    );
  }
}
