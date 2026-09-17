import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../data/models/sale.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/catalog_controller.dart';
import '../../state/sales_controller.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/pack_by_line.dart';
import '../../widgets/app_image.dart';
import '../../widgets/info_panel.dart';

class SaleDetailScreen extends StatefulWidget {
  const SaleDetailScreen({super.key, required this.saleId});

  final String saleId;

  @override
  State<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SalesController>().markRead(widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final sale = context.select((SalesController s) => s.byId(widget.saleId));

    if (sale == null) {
      return Scaffold(
        appBar: AppBar(title: WholeWordText(l10n.saleTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.gutter),
            child: WholeWordText(
              l10n.salesEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    final amount = Money.rupees(sale.amountInPaise, locale);
    final when = DateFormat.yMMMd(locale).format(sale.placedAt);
    final packBy = PackByLine.text(context, sale);

    final spoken = <String?>[
      sale.listingTitle,
      l10n.salesQuantity(sale.quantity),
      l10n.salePaid(amount),
      packBy,
      l10n.salePlaced(when),
      if (sale.buyerArea != null) l10n.saleGoingTo(sale.buyerArea!),
      l10n.saleReadOnly,
    ];

    return Scaffold(
      appBar: AppBar(
        title: WholeWordText(l10n.saleTitle),
        actions: [
          SpeakButton.lines(
            lines: spoken,
            utteranceKey: 'screen:sale',
            size: 32,
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
                  _WhatToPack(sale: sale),
                  const SizedBox(height: 16),
                  _PaidPanel(amount: amount),
                  const SizedBox(height: 14),
                  if (packBy != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: PackByLine.isUrgent(sale)
                            ? AppColors.warningTint
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      child: PackByLine(sale: sale, size: 20),
                    ),
                    const SizedBox(height: 14),
                  ],
                  _Line(
                    icon: Icons.event_available,
                    text: l10n.salePlaced(when),
                  ),
                  if (sale.buyerArea != null)
                    _Line(
                      icon: Icons.place_outlined,
                      text: l10n.saleGoingTo(sale.buyerArea!),
                    ),
                  const SizedBox(height: 16),
                  _ReadOnlyStrip(text: l10n.saleReadOnly),
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
                  BigActionButton(
                    label: l10n.salePackingHelp,
                    icon: Icons.inventory_2_outlined,
                    onPressed: () =>
                        Navigator.of(context)
                            .pushNamed(AppRoutes.packing, arguments: sale.id),
                  ),
                  if (_listingOf(context, sale) != null) ...[
                    const SizedBox(height: 10),
                    BigActionButton(
                      label: l10n.saleSeeListing,
                      icon: Icons.open_in_new,
                      tone: ButtonTone.secondary,
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.listing,
                        arguments: _listingOf(context, sale),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Object? _listingOf(BuildContext context, Sale sale) {
    final id = sale.listingId;
    if (id == null) return null;
    return context.read<CatalogController>().byId(id);
  }
}

class _WhatToPack extends StatelessWidget {
  const _WhatToPack({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.terracotta, width: 3),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholeWordText(
            l10n.saleWhatToPack,
            style: const TextStyle(fontSize: 16, color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(url: sale.imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholeWordText(
                      sale.listingTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    WholeWordText(
                      l10n.salesQuantity(sale.quantity),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              SpeakButton.lines(
                lines: [
                  l10n.saleWhatToPack,
                  sale.listingTitle,
                  l10n.salesQuantity(sale.quantity),
                ],
                size: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaidPanel extends StatelessWidget {
  const _PaidPanel({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = l10n.salePaid(amount);

    return GestureDetector(
      onLongPress: () =>
          context.read<SpeechService>().speak(text, key: 'sale:paid'),
      child: InfoPanel(
        icon: Icons.payments_outlined,
        text: text,
        tone: InfoTone.success,
        speak: false,
        textStyle: const TextStyle(
          fontSize: 22,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _ReadOnlyStrip extends StatelessWidget {
  const _ReadOnlyStrip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () =>
          context.read<SpeechService>().speak(text, key: 'sale:readonly'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 26, color: AppColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: WholeWordText(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: WholeWordText(
              text,
              style: const TextStyle(fontSize: 18, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 84,
        height: 84,
        child: AppImage(
          url,
          decodeSize: 84,
          fadeIn: false,
          fallback: const ImageFallback(icon: Icons.shopping_bag),
        ),
      ),
    );
  }
}
