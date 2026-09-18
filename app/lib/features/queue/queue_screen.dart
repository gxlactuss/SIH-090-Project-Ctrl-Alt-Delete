import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/capture_item.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/queue_controller.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/status_view.dart';
import 'widgets/queue_state_line.dart';
import '../../widgets/screen_header.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = context.select((QueueController q) => q.items);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.gutter,
            0,
            AppTheme.gutter,
            24,
          ),
          itemCount: items.isEmpty ? 2 : items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ScreenHeader(
                  title: l10n.queueTitle,
                  subtitle: items.isEmpty
                      ? l10n.queueEmptyBody
                      : l10n.queueBody,
                  utteranceKey: 'screen:queue',
                  subtitleGap: 8,
                  subtitleStyle: const TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    color: AppColors.muted,
                  ),
                ),
              );
            }
            if (items.isEmpty) return const _EmptyQueue();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QueueRow(item: items[index - 1]),
            );
          },
        ),
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.item});

  final CaptureItem item;

  @override
  Widget build(BuildContext context) {
    final state = context.select((QueueController q) => q.stateOf(item));
    return QueueProgressBuilder(
      state: state,
      builder: (progress) => _row(context, state, progress),
    );
  }

  Widget _row(BuildContext context, QueueItemState state, double progress) {
    final l10n = AppLocalizations.of(context);

    final when = DateFormat.MMMd(Localizations.localeOf(context).toString())
        .add_jm()
        .format(item.createdAt);
    final spoken = [
      QueueStateLine.label(l10n, state, progress),
      l10n.queueMadeAt(when),
    ];

    return Semantics(
      button: true,
      label: spoken.join('. '),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () =>
            Navigator.of(context)
                .pushNamed(AppRoutes.queueItem, arguments: item.id),
        onLongPress: () => context.read<SpeechService>().speakAll(
          spoken,
          key: 'queue:${item.id}',
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: state == QueueItemState.failed
                  ? AppColors.danger
                  : AppColors.border,
              width: state == QueueItemState.failed ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              CaptureThumbnail(item: item),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QueueStateLine(state: state, progress: progress),
                    const SizedBox(height: 6),
                    WholeWordText(
                      l10n.queueMadeAt(when),
                      style: const TextStyle(
                        fontSize: AppTheme.minTextSize,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 28, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusView(
      kind: StatusKind.empty,
      compact: true,
      icon: Icons.check_circle_outline,
      title: l10n.queueEmptyTitle,
      body: l10n.queueEmptyBody,
    );
  }
}
