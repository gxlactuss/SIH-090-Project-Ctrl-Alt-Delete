import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/connectivity_service.dart';
import '../services/speech_service.dart';
import 'speak_button.dart';
import '../state/queue_controller.dart';
import 'whole_word_text.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = context.select((ConnectivityService c) => c.isOffline);
    final pending = context.select((QueueController q) => q.pendingCount);

    if (!offline && pending == 0) return const SizedBox.shrink();

    final lines = <String>[
      if (offline) l10n.offlineNoNetwork,
      if (pending > 0) l10n.homeQueueWaiting(pending),
    ];
    final headline = lines.join(' · ');
    final spoken = [...lines, l10n.offlineNothingLost];

    final background = offline ? AppColors.warningTint : AppColors.cream;

    return Material(
      color: background,
      child: InkWell(
        onTap: pending == 0
            ? null
            : () => Navigator.of(context).pushNamed(AppRoutes.queue),
        onLongPress: () =>
            context.read<SpeechService>().speakAll(spoken, key: 'offline'),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border, width: 2)),
          ),
          child: Row(
            children: [
              Icon(
                offline ? Icons.wifi_off : Icons.cloud_upload,
                size: 26,
                color: AppColors.ink,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WholeWordText(
                      headline,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    WholeWordText(
                      l10n.offlineNothingLost,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.25,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),

              SpeakButton.lines(
                lines: spoken,
                utteranceKey: 'offline',
                size: 30,
              ),
              if (pending > 0)
                const Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: AppColors.muted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
