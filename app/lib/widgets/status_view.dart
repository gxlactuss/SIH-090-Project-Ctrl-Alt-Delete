import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'big_action_button.dart';
import 'speak_button.dart';
import 'whole_word_text.dart';

enum StatusKind { noNetwork, uploadFailed, serverError, empty }

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.kind,
    this.title,
    this.body,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final StatusKind kind;

  final String? title;
  final String? body;
  final IconData? icon;

  final String? actionLabel;
  final VoidCallback? onAction;

  final bool compact;

  String _title(AppLocalizations l10n) =>
      title ??
      switch (kind) {
        StatusKind.noNetwork => l10n.noNetworkTitle,
        StatusKind.uploadFailed => l10n.statusFailed,
        StatusKind.serverError => l10n.serverErrorTitle,
        StatusKind.empty => l10n.listingsEmptyTitle,
      };

  String _body(AppLocalizations l10n) =>
      body ??
      switch (kind) {
        StatusKind.noNetwork => l10n.noNetworkBody,
        StatusKind.uploadFailed => l10n.failureUnknown,
        StatusKind.serverError => l10n.serverErrorBody,
        StatusKind.empty => l10n.emptyNudge,
      };

  IconData get _icon =>
      icon ??
      switch (kind) {
        StatusKind.noNetwork => Icons.wifi_off,
        StatusKind.uploadFailed => Icons.cloud_off,
        StatusKind.serverError => Icons.cloud_off,
        StatusKind.empty => Icons.inventory_2_outlined,
      };

  Color get _tone => switch (kind) {
    StatusKind.noNetwork => AppColors.marigold,
    StatusKind.uploadFailed => AppColors.danger,
    StatusKind.serverError => AppColors.danger,
    StatusKind.empty => AppColors.muted,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _title(l10n);
    final body = _body(l10n);

    final panel = Container(
      padding: EdgeInsets.all(compact ? 16 : 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: _tone, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: compact ? 40 : 52, color: _tone),
          const SizedBox(height: 14),
          WholeWordText(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          if (body.isNotEmpty) ...[
            const SizedBox(height: 8),
            WholeWordText(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.4,
                color: AppColors.muted,
              ),
            ),
          ],

          SpeakButton.lines(
            lines: [title, body],
            utteranceKey: 'status:${kind.name}',
            size: 32,
          ),
          if (onAction != null) ...[
            const SizedBox(height: 10),
            BigActionButton(
              label: actionLabel ?? l10n.actionTryAgain,
              icon: Icons.refresh,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );

    if (compact) return panel;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.gutter),
        child: panel,
      ),
    );
  }
}
