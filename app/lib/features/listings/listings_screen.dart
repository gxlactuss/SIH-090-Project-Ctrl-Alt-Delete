import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/listing.dart';
import '../../data/models/listing_status.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/catalog_controller.dart';
import '../../widgets/listing_tile.dart';
import '../../widgets/status_view.dart';
import 'widgets/quick_stock_sheet.dart';
import '../../widgets/whole_word_text.dart';

class ListingsList extends StatelessWidget {
  const ListingsList({super.key, required this.filter});

  final ListingFilter filter;

  @override
  Widget build(BuildContext context) {
    final listings = context.select(
      (CatalogController c) => c.withFilter(filter),
    );
    final (failed, isEmpty) = context.select(
      (CatalogController c) => (c.failedToRefresh, c.isEmpty),
    );
    final catalog = context.read<CatalogController>();

    if (listings.isEmpty) {
      return RefreshIndicator(
        onRefresh: catalog.refresh,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: failed
                      ? StatusView(
                          kind: StatusKind.serverError,
                          onAction: catalog.refresh,
                        )
                      : _Empty(hasAnything: !isEmpty),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: catalog.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppTheme.gutter,
          10,
          AppTheme.gutter,
          24,
        ),
        itemCount: listings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _ListingRow(listing: listings[index]),
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  const _ListingRow({required this.listing});

  final Listing listing;

  bool get _opensReview =>
      listing.status == ListingStatus.needsAttention ||
      listing.status == ListingStatus.ready;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListingTile(
          listing: listing,
          onTap: () => Navigator.of(context).pushNamed(
            _opensReview ? AppRoutes.review : AppRoutes.listing,
            arguments: listing,
          ),
        ),
        if (listing.status.wasPublished)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 4),
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 20,
                      color: listing.isSoldOut
                          ? AppColors.danger
                          : AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    WholeWordText(
                      l10n.listingsStock(listing.stock),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: listing.isSoldOut
                            ? AppColors.danger
                            : AppColors.muted,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => QuickStockSheet.show(context, listing),
                  onLongPress: () => context.read<SpeechService>().speak(
                    l10n.listingsQuickStock,
                    key: 'listings:stock',
                  ),
                  icon: const Icon(Icons.edit, size: 22),
                  label: WholeWordText(l10n.listingsQuickStock),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.hasAnything});

  final bool hasAnything;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusView(
      kind: StatusKind.empty,
      title: hasAnything ? l10n.listingsEmptyFilter : l10n.listingsEmptyTitle,
      icon: hasAnything
          ? Icons.filter_alt_off_outlined
          : Icons.inventory_2_outlined,
      body: hasAnything ? '' : l10n.listingsEmptyBody,
    );
  }
}
