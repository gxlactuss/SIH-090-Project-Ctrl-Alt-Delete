import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

enum ListingStatus {
  queued,
  processing,
  needsAttention,
  ready,
  published,

  soldOut,

  unpublished,

  failed,
}

extension ListingStatusDisplay on ListingStatus {
  String label(AppLocalizations l10n) => switch (this) {
    ListingStatus.queued => l10n.statusQueued,
    ListingStatus.processing => l10n.statusProcessing,
    ListingStatus.needsAttention => l10n.statusNeedsAttention,
    ListingStatus.ready => l10n.statusReady,
    ListingStatus.published => l10n.statusPublished,
    ListingStatus.soldOut => l10n.statusSoldOut,
    ListingStatus.unpublished => l10n.statusUnpublished,
    ListingStatus.failed => l10n.statusFailed,
  };

  IconData get icon => switch (this) {
    ListingStatus.queued => Icons.schedule,
    ListingStatus.processing => Icons.autorenew,
    ListingStatus.needsAttention => Icons.help_outline,
    ListingStatus.ready => Icons.check_circle_outline,
    ListingStatus.published => Icons.storefront,
    ListingStatus.soldOut => Icons.inventory,
    ListingStatus.unpublished => Icons.visibility_off,
    ListingStatus.failed => Icons.error_outline,
  };

  bool get needsSeller =>
      this == ListingStatus.needsAttention ||
      this == ListingStatus.ready ||
      this == ListingStatus.failed ||
      this == ListingStatus.soldOut;

  bool get isLive => this == ListingStatus.published;

  bool get wasPublished =>
      this == ListingStatus.published ||
      this == ListingStatus.soldOut ||
      this == ListingStatus.unpublished;

  bool get isWorking =>
      this == ListingStatus.queued || this == ListingStatus.processing;

  bool get isDraft =>
      this == ListingStatus.queued ||
      this == ListingStatus.processing ||
      this == ListingStatus.ready;
}
