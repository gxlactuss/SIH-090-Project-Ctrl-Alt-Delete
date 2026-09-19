import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/di.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/connectivity_service.dart';
import '../../services/upload_service.dart';
import '../../data/models/listing_status.dart';
import '../../data/repositories/listing_repository.dart';
import '../../services/analytics_service.dart';
import '../../state/catalog_controller.dart';
import '../../state/discard_listing.dart';
import '../../state/queue_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import 'widgets/queue_state_line.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/info_panel.dart';

class QueueItemScreen extends StatelessWidget {
  const QueueItemScreen({super.key, required this.captureId});

  final String captureId;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final queue = context.read<QueueController>();

    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.queueDeleteTitle,
      body: l10n.queueDeleteBody,
      confirm: l10n.queueDeleteConfirm,
      cancel: l10n.queueDeleteCancel,
      speechKey: 'queue:delete',
    );

    if (!confirmed || !context.mounted) return;
    final navigator = Navigator.of(context);
    final catalog = context.maybeRead<CatalogController>();
    final listings = context.maybeRead<ListingRepository>();
    final analytics = context.maybeRead<AnalyticsService>();

    await dropQueuedCapture(queue, captureId);
    await listings?.discard(captureId);
    catalog?.forget(captureId);
    analytics?.log(
      AnalyticsEvent.listingCancelled,
      properties: {'listingId': captureId},
    );

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final queue = context.read<QueueController>();
    final online = context.select((ConnectivityService c) => c.isOnline);
    final selected = context.select((QueueController q) {
      final found = q.byId(captureId);
      return found == null ? null : (found, q.stateOf(found));
    });

    if (selected == null) {
      return Scaffold(
        appBar: AppBar(title: WholeWordText(l10n.queueItemTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.gutter),
            child: WholeWordText(
              l10n.queueEmptyBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    final (item, state) = selected;
    final failure = queue.failureOf(item);
    final reason = failure == null
        ? null
        : QueueStateLine.failureMessage(l10n, failure);

    final when = DateFormat.MMMd(Localizations.localeOf(context).toString())
        .add_jm()
        .format(item.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: WholeWordText(l10n.queueItemTitle),
        actions: [
          QueueProgressBuilder(
            state: state,
            builder: (progress) => SpeakButton.lines(
              lines: [
                QueueStateLine.label(l10n, state, progress),
                reason,
                l10n.queueMadeAt(when),
              ],
              utteranceKey: 'screen:queueItem',
              size: 32,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.gutter,
                  4,
                  AppTheme.gutter,
                  20,
                ),
                children: [
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: item.photoPaths.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) => CaptureThumbnail(
                        item: item,
                        size: 104,
                        photoIndex: index,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QueueProgressBuilder(
                          state: state,
                          builder: (progress) =>
                              QueueStateLine(state: state, progress: progress),
                        ),
                        const SizedBox(height: 10),
                        WholeWordText(
                          l10n.queueMadeAt(when),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.muted,
                          ),
                        ),
                        if (item.attempts > 0) ...[
                          const SizedBox(height: 4),
                          WholeWordText(
                            l10n.queueAttempts(item.attempts),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (reason != null) ...[
                    const SizedBox(height: 14),
                    _Reason(message: reason),
                  ],
                  if (state == QueueItemState.processing) ...[
                    const SizedBox(height: 14),
                    _WithUs(listingId: item.id),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.gutter,
                8,
                AppTheme.gutter,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state == QueueItemState.processing) ...[
                    BigActionButton(
                      label: l10n.processingGoHome,
                      icon: Icons.home,
                      onPressed: () =>
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                      spokenLabel:
                          '${l10n.processingGoHome}. ${l10n.processingLeave}',
                    ),
                  ] else if (failure?.isRetryable ?? true) ...[
                    BigActionButton(
                      label: l10n.queueRetryNow,
                      icon: Icons.refresh,
                      onPressed: online
                          ? () => context.read<UploadService>().retry(item.id)
                          : null,
                      spokenLabel: online
                          ? l10n.queueRetryNow
                          : l10n.queueRetryWaiting,
                    ),
                    if (!online) ...[
                      const SizedBox(height: 8),
                      WholeWordText(
                        l10n.queueRetryWaiting,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 10),
                  BigActionButton(
                    label: l10n.queueDelete,
                    icon: Icons.delete_outline,
                    tone: ButtonTone.danger,
                    onPressed: () => _confirmDelete(context),
                    spokenLabel: '${l10n.queueDelete}. ${l10n.queueDeleteBody}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithUs extends StatelessWidget {
  const _WithUs({required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = context.maybeRead<CatalogController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningTint,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (catalog != null)
            ListenableBuilder(
              listenable: catalog,
              builder: (context, _) {
                final listing = catalog.byId(listingId);
                if (listing == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        listing.status.icon,
                        size: 26,
                        color: AppColors.terracotta,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: WholeWordText(
                          listing.status.label(l10n),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          WholeWordText(
            l10n.processingBody,
            style: const TextStyle(
              fontSize: 17,
              height: 1.35,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.notifications_active_outlined,
                size: 24,
                color: AppColors.ink,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: WholeWordText(
                  l10n.processingLeave,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Reason extends StatelessWidget {
  const _Reason({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.info_outline,
      text: message,
      tone: InfoTone.danger,
      bordered: true,
      textStyle: const TextStyle(
        fontSize: 19,
        height: 1.35,
        color: AppColors.ink,
      ),
    );
  }
}
