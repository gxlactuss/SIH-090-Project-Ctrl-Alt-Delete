import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../data/models/listing.dart';
import '../../data/models/listing_status.dart';
import '../../data/repositories/listing_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/catalog_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/listing_tile.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/quick_stock_sheet.dart';
import 'widgets/share_listing.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/app_image.dart';
import '../../widgets/info_panel.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key, required this.listing});

  final Listing listing;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late Listing _listing = widget.listing;
  bool _busy = false;
  String? _error;

  Future<void> _run(
    Future<Listing> Function(ListingRepository repository) action, {
    String? announce,
  }) async {
    final l10n = AppLocalizations.of(context);
    final repository = context.read<ListingRepository>();
    final catalog = context.read<CatalogController>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final updated = await action(repository);
      catalog.replace(updated);
      if (!mounted) return;
      setState(() {
        _listing = updated;
        _busy = false;
      });
      if (announce != null) {
        messenger.showSnackBar(SnackBar(content: WholeWordText(announce)));
        await context.read<SpeechService>().speakIfAuto([
          announce,
        ], key: 'listing:announce');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l10n.listingActionFailed;
      });
    }
  }

  Future<void> _unpublish() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.unpublishTitle,
      body: l10n.unpublishBody,
      confirm: l10n.unpublishConfirm,
      cancel: l10n.unpublishCancel,
      speechKey: 'listing:unpublish',
    );

    if (!confirmed || !mounted) return;
    await _run(
      (repository) => repository.unpublish(_listing.id),
      announce: l10n.unpublishDone,
    );
  }

  Future<void> _duplicate() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.duplicateTitle,
      body: l10n.duplicateBody,
      confirm: l10n.duplicateConfirm,
      cancel: l10n.duplicateCancel,
      tone: ConfirmTone.neutral,
      speechKey: 'listing:duplicate',
    );

    if (!confirmed || !mounted) return;
    await Navigator.of(context).pushNamed(
      AppRoutes.capture,
      arguments: _listing.templateListingId ?? _listing.id,
    );
  }

  Future<void> _edit() async {
    final l10n = AppLocalizations.of(context);
    final speech = context.read<SpeechService>();
    await speech.stop();
    if (_listing.status.wasPublished) {
      await speech.speakIfAuto([
        l10n.editTitle,
        l10n.editBody,
      ], key: 'listing:edit');
    }

    if (!mounted) return;
    await Navigator.of(context)
        .pushNamed(AppRoutes.review, arguments: _listing);
    if (!mounted) return;
    final refreshed = context.read<ListingRepository>().cached(_listing.id);
    if (refreshed != null) setState(() => _listing = refreshed);
  }

  static Widget _thumbnailFlight(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final tile = direction == HeroFlightDirection.push
        ? fromHeroContext
        : toHeroContext;
    return (tile.widget as Hero).child;
  }

  Future<void> _openPreview() async {
    final url = _listing.previewUrl;
    if (url == null || url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final listing =
        context.select((CatalogController c) => c.byId(_listing.id)) ??
        _listing;
    final price = listing.factSheet.priceInPaise;
    final title = listing.title?.trim().isNotEmpty == true
        ? listing.title!
        : l10n.listingUntitled;

    return Scaffold(
      appBar: AppBar(
        title: WholeWordText(l10n.listingTitle),
        actions: [
          SpeakButton.lines(
            lines: [
              title,
              if (price != null) Money.rupees(price, locale),
              listing.status.label(l10n),
              l10n.listingsStock(listing.stock),
              l10n.listingsViews(listing.views),
            ],
            utteranceKey: 'screen:listing',
            size: 32,
          ),
        ],
        bottom: _busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(minHeight: 4),
              )
            : null,
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
                  if (listing.imageUrls.isNotEmpty)
                    Hero(
                      tag: listingImageHeroTag(listing.id),
                      flightShuttleBuilder: _thumbnailFlight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: AppImage(
                            listing.imageUrls.first,
                            decodeSize: MediaQuery.sizeOf(context).width,
                            fallback: const ImageFallback(iconSize: 40),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  WholeWordText(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (price != null) ...[
                    const SizedBox(height: 6),
                    WholeWordText(
                      Money.rupees(price, locale),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.terracotta,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _StatusPanel(listing: listing),
                  const SizedBox(height: 12),
                  _Facts(listing: listing),
                  if (listing.status.isLive &&
                      (listing.previewUrl?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 16),
                    BigActionButton(
                      label: l10n.publishedShare,
                      icon: Icons.share,
                      tone: ButtonTone.secondary,
                      onPressed: () => ShareListing.whatsapp(
                        context,
                        url: listing.previewUrl!,
                        title: listing.title,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigActionButton(
                      label: l10n.publishedShowQr,
                      icon: Icons.qr_code_2,
                      tone: ButtonTone.secondary,
                      onPressed: () => ShareListing.showQr(
                        context,
                        url: listing.previewUrl!,
                      ),
                    ),
                  ],
                  if (listing.isSoldOut && listing.status.wasPublished) ...[
                    const SizedBox(height: 14),
                    _SoldOutPanel(),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    WholeWordText(
                      _error!,
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.66,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.gutter,
                    8,
                    AppTheme.gutter,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final action in _actions(l10n, listing)) ...[
                        action,
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(AppLocalizations l10n, Listing listing) {
    final status = listing.status;

    if (status == ListingStatus.needsAttention ||
        status == ListingStatus.ready) {
      return [
        BigActionButton(
          label: l10n.listingFinish,
          icon: Icons.arrow_forward,
          busy: _busy,
          onPressed: _busy ? null : _edit,
        ),
      ];
    }

    if (status.isDraft) {
      return [
        BigActionButton(
          label: l10n.processingTitle,
          icon: Icons.hourglass_bottom,
          onPressed: () =>
              Navigator.of(context)
                  .pushNamed(AppRoutes.queueItem, arguments: listing.id),
        ),
      ];
    }

    return [
      if (status.isLive && (listing.previewUrl?.isNotEmpty ?? false))
        BigActionButton(
          label: l10n.listingOpenPreview,
          icon: Icons.open_in_new,
          tone: ButtonTone.secondary,
          onPressed: _busy ? null : _openPreview,
        ),
      BigActionButton(
        label: l10n.listingsQuickStock,
        icon: Icons.inventory_2_outlined,
        tone: ButtonTone.secondary,
        onPressed: _busy
            ? null
            : () async {
                await QuickStockSheet.show(context, listing);
                if (!mounted) return;
                final updated = context.read<CatalogController>().byId(
                  listing.id,
                );
                if (updated != null) setState(() => _listing = updated);
              },
      ),
      BigActionButton(
        label: l10n.listingEdit,
        icon: Icons.edit,
        busy: _busy,
        onPressed: _busy ? null : _edit,
      ),
      BigActionButton(
        label: l10n.listingDuplicate,
        icon: Icons.add_a_photo,
        tone: ButtonTone.secondary,
        onPressed: _busy ? null : _duplicate,
      ),
      if (status.isLive)
        BigActionButton(
          label: l10n.listingUnpublish,
          icon: Icons.visibility_off,
          tone: ButtonTone.danger,
          onPressed: _busy ? null : _unpublish,
          spokenLabel: '${l10n.listingUnpublish}. ${l10n.unpublishBody}',
        )
      else
        BigActionButton(
          label: l10n.listingRelist,
          icon: Icons.storefront,
          busy: _busy,
          onPressed: _busy || listing.stock <= 0
              ? null
              : () => _run(
                  (repository) => repository.relist(listing.id),
                  announce: l10n.relistDone,
                ),
        ),
    ];
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = listing.status;
    final colour = status.isLive
        ? AppColors.success
        : (status.needsSeller ? AppColors.terracotta : AppColors.muted);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: colour, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          Icon(status.icon, size: 28, color: colour),
          const SizedBox(width: 12),
          Expanded(
            child: WholeWordText(
              status.label(l10n),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colour,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final rows = <(IconData, String)>[
      (Icons.inventory_2_outlined, l10n.listingsStock(listing.stock)),
      if (listing.status.wasPublished)
        (Icons.visibility_outlined, l10n.listingsViews(listing.views)),
    ];

    return Column(
      children: [
        for (final (icon, text) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: WholeWordText(
                    text,
                    style: const TextStyle(fontSize: 19, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SoldOutPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InfoPanel(
      icon: Icons.inventory,
      title: l10n.listingSoldOutTitle,
      text: l10n.listingSoldOutBody,
    );
  }
}
