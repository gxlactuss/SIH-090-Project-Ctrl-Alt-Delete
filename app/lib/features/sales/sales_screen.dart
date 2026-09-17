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
import '../../state/sales_controller.dart';
import '../../widgets/animated_number.dart';
import '../../widgets/skeleton_tiles.dart';
import '../../widgets/status_view.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/pack_by_line.dart';
import '../../widgets/app_image.dart';

class SalesList extends StatefulWidget {
  const SalesList({super.key});

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SalesController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sales = context.watch<SalesController>();
    final firstLoad = sales.isLoading && !sales.isLoaded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (firstLoad && !sales.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppTheme.gutter),
            child: LinearProgressIndicator(minHeight: 6),
          ),
        Expanded(
          child: sales.isEmpty
              ? firstLoad
                    ? SkeletonTiles(label: l10n.salesLoading)
                    : _Empty(loaded: sales.isLoaded)
              : RefreshIndicator(
                  onRefresh: sales.load,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.gutter,
                      12,
                      AppTheme.gutter,
                      24,
                    ),
                    itemCount: sales.sales.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) return const _EarningsCard();
                      return _SaleRow(sale: sales.sales[index - 1]);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final week = context.select((SalesController s) => s.thisWeekInPaise);

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.earnings),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.successTint,
          border: Border.all(color: AppColors.success, width: 2),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.savings_outlined,
              size: 32,
              color: AppColors.success,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WholeWordText(
                    l10n.earningsWeek,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                    ),
                  ),
                  AnimatedNumber(
                    value: week,
                    format: (value) => Money.rupees(value, locale),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 28, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final amount = Money.rupees(sale.amountInPaise, locale);
    final when = DateFormat.MMMd(locale).format(sale.placedAt);
    final packBy = PackByLine.text(context, sale);

    final spoken = [
      sale.listingTitle,
      l10n.salesQuantity(sale.quantity),
      l10n.salePaid(amount),
      packBy,
    ];

    return Semantics(
      button: true,
      label: spoken.whereType<String>().join('. '),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.sale, arguments: sale.id),
        onLongPress: () => context.read<SpeechService>().speakAll(
          spoken,
          key: 'sale:${sale.id}',
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: sale.isRead ? AppColors.border : AppColors.terracotta,
              width: sale.isRead ? 2 : 3,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(sale: sale),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!sale.isRead) ...[
                      _NewBadge(label: l10n.salesNew),
                      const SizedBox(height: 6),
                    ],
                    WholeWordText(
                      sale.listingTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    WholeWordText(
                      '$amount · ${l10n.salesQuantity(sale.quantity)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.terracotta,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PackByLine(sale: sale, size: 16),
                    const SizedBox(height: 2),
                    WholeWordText(
                      l10n.salePlaced(when),
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

class _NewBadge extends StatelessWidget {
  const _NewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.terracotta,
        borderRadius: BorderRadius.circular(999),
      ),
      child: WholeWordText(
        label,
        style: const TextStyle(
          fontSize: AppTheme.minTextSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 76,
        height: 76,
        child: AppImage(
          sale.imageUrl,
          decodeSize: 76,
          fallback: const ImageFallback(icon: Icons.shopping_bag, iconSize: 28),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.loaded});

  final bool loaded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusView(
      kind: StatusKind.empty,
      icon: loaded ? Icons.shopping_bag_outlined : Icons.wifi_off,
      title: loaded ? l10n.salesEmptyTitle : l10n.salesLoading,
      body: loaded ? l10n.salesEmptyBody : l10n.noNetworkBody,
    );
  }
}
