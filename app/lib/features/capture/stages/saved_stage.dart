import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/seller_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/permission_service.dart';
import '../../../state/capture_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/fade_in.dart';
import '../../../widgets/speak_button.dart';
import '../../../widgets/success_mark.dart';
import '../widgets/capture_scaffold.dart';
import '../../../widgets/whole_word_text.dart';

class SavedStage extends StatelessWidget {
  const SavedStage({super.key, required this.onDone, required this.onAnother});

  final VoidCallback onDone;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final online = context.select((ConnectivityService c) => c.isOnline);
    final capture = context.watch<CaptureController>();

    final body = online ? l10n.savedBodyOnline : l10n.savedBody;
    final failed = capture.saveError != null;

    return CaptureScaffold(
      title: failed ? l10n.saveFailed : l10n.savedTitle,
      subtitle: failed ? null : body,
      spokenLines: failed ? [l10n.saveFailed] : [l10n.savedTitle, body],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Center(
            child: SuccessMark(
              key: ValueKey(failed),
              icon: failed ? Icons.error_outline : Icons.check,
              colour: failed ? AppColors.danger : AppColors.success,
              tint: (failed ? AppColors.danger : AppColors.success).withValues(
                alpha: 0.15,
              ),
              celebrate: !failed,
            ),
          ),
          const SizedBox(height: 24),
          if (!failed)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Row(
                children: [
                  Icon(
                    online ? Icons.cloud_upload : Icons.wifi_off,
                    size: 28,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WholeWordText(
                      body,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!failed) const _NotifyCard(),
        ],
      ),
      actions: [
        if (failed)
          BigActionButton(
            label: l10n.saveRetry,
            icon: Icons.replay,
            busy: capture.isSaving,
            onPressed: capture.save,
          )
        else ...[
          BigActionButton(
            label: l10n.savedGoHome,
            icon: Icons.home,
            onPressed: onDone,
          ),
          BigActionButton(
            label: l10n.savedAddAnother,
            icon: Icons.add_a_photo,
            tone: ButtonTone.secondary,
            onPressed: onAnother,
          ),
        ],
      ],
    );
  }
}

class _NotifyCard extends StatefulWidget {
  const _NotifyCard();

  @override
  State<_NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<_NotifyCard> {
  SellerRepository? _sellers;
  PermissionService? _permissions;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    _sellers = context.maybeRead<SellerRepository>();
    _permissions = context.maybeRead<PermissionService>();
    _decide();
  }

  Future<void> _decide() async {
    final sellers = _sellers;
    final permissions = _permissions;
    if (sellers == null || permissions == null) return;
    try {
      if (await sellers.notificationsAsked()) return;
      final status = await permissions.check(AppPermission.notifications);
      if (status == PermissionOutcome.granted) return;
    } catch (_) {
      return;
    }
    if (mounted) setState(() => _show = true);
  }

  Future<void> _answer({required bool allow}) async {
    setState(() => _show = false);
    await _sellers?.markNotificationsAsked();
    if (allow) await _permissions?.request(AppPermission.notifications);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedSize(
      duration: AppMotion.of(context, AppMotion.medium),
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: !_show
          ? const SizedBox(width: double.infinity)
          : FadeIn(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warningTint,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          size: 28,
                          color: AppColors.ink,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WholeWordText(
                                l10n.permissionNotificationTitle,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              WholeWordText(
                                l10n.permissionNotificationBody,
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1.35,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SpeakButton.lines(
                          lines: [
                            l10n.permissionNotificationTitle,
                            l10n.permissionNotificationBody,
                          ],
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BigActionButton(
                      label: l10n.permissionAllow,
                      icon: Icons.notifications_active,
                      tone: ButtonTone.secondary,
                      onPressed: () => _answer(allow: true),
                    ),
                    TextButton(
                      onPressed: () => _answer(allow: false),
                      child: WholeWordText(l10n.permissionNotNow),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
