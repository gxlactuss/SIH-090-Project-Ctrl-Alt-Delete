import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/listing.dart';
import '../../../data/models/listing_status.dart';
import '../../../data/repositories/listing_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/analytics_service.dart';
import '../../../services/speech_service.dart';
import '../../../state/catalog_controller.dart';
import '../../../widgets/animated_number.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/fade_in.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/screen_header.dart';
import '../../../widgets/info_panel.dart';
import '../../../widgets/api_problem_text.dart';

class QuickStockSheet extends StatefulWidget {
  const QuickStockSheet({super.key, required this.listing});

  final Listing listing;

  static Future<void> show(BuildContext context, Listing listing) {
    final catalog = context.read<CatalogController>();
    final listings = context.read<ListingRepository>();
    final speech = context.read<SpeechService>();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) => MultiProvider(
        providers: [
          ChangeNotifierProvider<CatalogController>.value(value: catalog),
          Provider<ListingRepository>.value(value: listings),
          ChangeNotifierProvider<SpeechService>.value(value: speech),
        ],
        child: QuickStockSheet(listing: listing),
      ),
    );
  }

  @override
  State<QuickStockSheet> createState() => _QuickStockSheetState();
}

class _QuickStockSheetState extends State<QuickStockSheet> {
  late int _stock = widget.listing.stock;
  bool _saving = false;
  String? _error;

  Future<void> _save(int stock) async {
    final l10n = AppLocalizations.of(context);
    final catalog = context.read<CatalogController>();
    final listings = context.read<ListingRepository>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final analytics = context.maybeRead<AnalyticsService>();
    final listingId = widget.listing.id;
    final previous = widget.listing.stock;

    setState(() {
      _stock = stock;
      _saving = true;
      _error = null;
    });

    try {
      final updated = await listings.setStock(
        listingId: listingId,
        quantity: stock,
      );
      catalog.replace(updated);
      if (updated.status == ListingStatus.soldOut) {
        analytics?.log(
          AnalyticsEvent.listingSoldOut,
          properties: {'listingId': updated.id},
        );
      }
      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          persist: false,
          duration: const Duration(seconds: 6),
          content: WholeWordText(
            updated.status == ListingStatus.soldOut
                ? l10n.listingSoldOutBody
                : l10n.quickStockSaved,
          ),
          action: stock == previous
              ? null
              : SnackBarAction(
                  label: l10n.actionUndo,
                  onPressed: () => _undo(
                    listings: listings,
                    catalog: catalog,
                    messenger: messenger,
                    l10n: l10n,
                    listingId: listingId,
                    stock: previous,
                  ),
                ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = errorMessage(error, l10n);
      });
    }
  }

  static Future<void> _undo({
    required ListingRepository listings,
    required CatalogController catalog,
    required ScaffoldMessengerState messenger,
    required AppLocalizations l10n,
    required String listingId,
    required int stock,
  }) async {
    try {
      catalog.replace(
        await listings.setStock(listingId: listingId, quantity: stock),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: WholeWordText(errorMessage(error, l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final soldOut = _stock <= 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: l10n.quickStockTitle,
              spokenLines: [l10n.quickStockTitle],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  label: l10n.stockLess,
                  onPressed: _saving || _stock <= 0
                      ? null
                      : () => setState(() => _stock--),
                ),
                SwapNumber(
                  value: _stock,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  label: l10n.stockMore,
                  onPressed: _saving ? null : () => setState(() => _stock++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: AppMotion.of(context, AppMotion.medium),
              curve: AppMotion.standard,
              alignment: Alignment.topCenter,
              child: !soldOut
                  ? const SizedBox(width: double.infinity)
                  : FadeIn(
                      child: InfoPanel(
                        icon: Icons.info_outline,
                        text: l10n.listingSoldOutBody,
                        dense: true,
                      ),
                    ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              WholeWordText(
                _error!,
                style: const TextStyle(fontSize: 17, color: AppColors.danger),
              ),
            ],
            const SizedBox(height: 18),
            BigActionButton(
              label: l10n.quickStockSave,
              icon: Icons.check,
              busy: _saving,
              onPressed: _saving ? null : () => _save(_stock),
            ),
            const SizedBox(height: 10),
            BigActionButton(
              label: l10n.quickStockMarkSoldOut,
              icon: Icons.inventory,
              tone: ButtonTone.secondary,
              onPressed: _saving || widget.listing.stock <= 0
                  ? null
                  : () => _save(0),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 92,
        height: 92,
        child: Material(
          color: onPressed == null
              ? AppColors.border
              : AppColors.terracotta.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: onPressed == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  },
            onLongPress: () =>
                context.read<SpeechService>().speak(label, key: 'stock:$label'),
            child: Icon(
              icon,
              size: 44,
              color: onPressed == null ? AppColors.muted : AppColors.terracotta,
            ),
          ),
        ),
      ),
    );
  }
}
