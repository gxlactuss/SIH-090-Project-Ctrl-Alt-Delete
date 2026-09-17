import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/catalog_controller.dart';
import '../../state/sales_controller.dart';
import '../../widgets/animated_number.dart';
import '../../widgets/whole_word_text.dart';
import '../listings/listings_screen.dart';
import '../sales/sales_screen.dart';
import '../../widgets/screen_header.dart';

enum ProductsSection { inProgress, listed, sold }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.section});

  final ValueNotifier<ProductsSection>? section;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ValueNotifier<ProductsSection> _section =
      widget.section ?? ValueNotifier(ProductsSection.inProgress);

  (Object, bool)? _fitsCache;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CatalogController>().refresh();
      context.read<SalesController>().load();
    });
  }

  @override
  void dispose() {
    if (widget.section == null) _section.dispose();
    super.dispose();
  }

  String _label(AppLocalizations l10n, ProductsSection section) =>
      switch (section) {
        ProductsSection.inProgress => l10n.productsInProgress,
        ProductsSection.listed => l10n.productsListed,
        ProductsSection.sold => l10n.productsSold,
      };

  IconData _icon(ProductsSection section) => switch (section) {
    ProductsSection.inProgress => Icons.autorenew,
    ProductsSection.listed => Icons.storefront,
    ProductsSection.sold => Icons.shopping_bag,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inProgress = context.select(
      (CatalogController c) => c.countOf(ListingFilter.inProgress),
    );
    final listed = context.select(
      (CatalogController c) => c.countOf(ListingFilter.listed),
    );
    final sold = context.select((SalesController s) => s.sales.length);

    int count(ProductsSection section) => switch (section) {
      ProductsSection.inProgress => inProgress,
      ProductsSection.listed => listed,
      ProductsSection.sold => sold,
    };

    return SafeArea(
      child: ValueListenableBuilder<ProductsSection>(
        valueListenable: _section,
        builder: (context, current, _) => NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.gutter,
                      8,
                      AppTheme.gutter,
                      0,
                    ),
                    child: ScreenHeader(
                      title: l10n.listingsTitle,
                      spokenLines: [l10n.listingsTitle, _label(l10n, current)],
                      utteranceKey: 'screen:products',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.gutter,
                    ),
                    child: _sections(l10n, current, count),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
          body: AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.medium),
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.exit,
            layoutBuilder: (incoming, outgoing) =>
                Stack(fit: StackFit.expand, children: [...outgoing, ?incoming]),
            child: KeyedSubtree(
              key: ValueKey(current),
              child: switch (current) {
                ProductsSection.inProgress => const ListingsList(
                  filter: ListingFilter.inProgress,
                ),
                ProductsSection.listed => const ListingsList(
                  filter: ListingFilter.listed,
                ),
                ProductsSection.sold => const SalesList(),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _sections(
    AppLocalizations l10n,
    ProductsSection current,
    int Function(ProductsSection section) count,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool fitsAcross() {
          final inner = (constraints.maxWidth - 16) / 3 - 12 - 6;
          final style = DefaultTextStyle.of(context).style.merge(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          );
          final scaler = MediaQuery.textScalerOf(context);
          final direction = Directionality.of(context);
          final labels = [
            for (final section in ProductsSection.values) _label(l10n, section),
          ];

          final key = (inner, scaler, direction, style, labels.join('|'));
          final cached = _fitsCache;
          if (cached != null && cached.$1 == key) return cached.$2;

          var fits = true;
          final painter = TextPainter(
            textDirection: direction,
            textScaler: scaler,
          );
          outer:
          for (final label in labels) {
            for (final word in label.split(RegExp(r'\s+'))) {
              painter
                ..text = TextSpan(text: word, style: style)
                ..layout();
              if (painter.width > inner) {
                fits = false;
                break outer;
              }
            }
          }
          painter.dispose();

          _fitsCache = (key, fits);
          return fits;
        }

        final across = fitsAcross();
        final buttons = [
          for (final section in ProductsSection.values)
            _SectionButton(
              key: ValueKey('section-${section.name}'),
              icon: _icon(section),
              label: _label(l10n, section),
              count: count(section),
              selected: section == current,
              stacked: !across,
              onTap: () {
                if (section == ProductsSection.sold) {
                  context.read<SalesController>().load();
                }
                _section.value = section;
              },
            ),
        ];

        if (!across) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                buttons[i],
              ],
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: buttons[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.stacked,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool selected;

  final bool stacked;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconAndCount = [
      Icon(
        icon,
        size: 22,
        color: selected ? AppColors.terracotta : AppColors.muted,
      ),
      const SizedBox(width: 6),
      AnimatedNumber(
        value: count,
        format: (value) => '$value',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    ];
    final labelStyle = TextStyle(
      fontSize: 16,
      height: 1.2,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      color: AppColors.ink,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () => context.read<SpeechService>().speak(
          '$label, $count',
          key: 'section:$label',
        ),
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.fast),
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: EdgeInsets.symmetric(
            horizontal: stacked ? 14 : 6,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.terracotta.withValues(alpha: 0.16)
                : AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.terracotta : AppColors.border,
              width: selected ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: stacked
              ? Row(
                  children: [
                    ...iconAndCount,
                    const SizedBox(width: 12),
                    Expanded(child: WholeWordText(label, style: labelStyle)),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: iconAndCount),
                    const SizedBox(height: 4),
                    WholeWordText(
                      label,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
