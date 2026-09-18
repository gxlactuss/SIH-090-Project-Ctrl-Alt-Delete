import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/money.dart';
import '../data/models/listing.dart';
import '../data/models/listing_status.dart';
import '../l10n/app_localizations.dart';
import '../services/speech_service.dart';
import 'whole_word_text.dart';
import 'app_image.dart';

String listingImageHeroTag(String listingId) => 'listing-image:$listingId';

class ListingTile extends StatelessWidget {
  const ListingTile({super.key, required this.listing, this.onTap});

  final Listing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final speech = context.read<SpeechService>();

    final title = (listing.title?.trim().isNotEmpty ?? false)
        ? listing.title!.trim()
        : l10n.listingUntitled;
    final price = listing.factSheet.priceInPaise;

    final priceLabel = price == null
        ? l10n.listingNoPrice
        : Money.rupees(price, locale);
    final status = listing.status.label(l10n);

    return Semantics(
      button: onTap != null,
      label: [title, priceLabel, status].join('. '),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => speech.speakAll([
          title,
          priceLabel,
          status,
        ], key: 'listing:${listing.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Thumbnail(listing: listing),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WholeWordText(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    WholeWordText(
                      priceLabel,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: price == null
                            ? AppColors.muted
                            : AppColors.terracotta,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _StatusLine(status: listing.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final url = listing.imageUrls.isEmpty ? null : listing.imageUrls.first;
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 76,
        height: 76,
        child: AppImage(url, decodeSize: 76),
      ),
    );

    if (url == null) return image;
    return Hero(tag: listingImageHeroTag(listing.id), child: image);
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.status});

  final ListingStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colour = status.needsSeller
        ? (status == ListingStatus.failed
              ? AppColors.danger
              : AppColors.terracotta)
        : AppColors.muted;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 20, color: colour),
        const SizedBox(width: 6),

        Flexible(
          child: WholeWordText(
            status.label(l10n),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: colour,
            ),
          ),
        ),
      ],
    );
  }
}
