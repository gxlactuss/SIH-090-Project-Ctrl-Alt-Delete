import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/app_state.dart';
import '../../state/catalog_controller.dart';
import '../../data/models/listing.dart';
import '../../data/models/listing_status.dart';
import '../../state/sales_controller.dart';
import '../../widgets/listing_tile.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/status_view.dart';
import '../../widgets/big_action_button.dart';
import '../../widgets/dev_simulate_button.dart';
import '../../widgets/fade_in.dart';
import '../products/products_screen.dart';
import '../shell/app_shell.dart';
import '../../widgets/screen_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      context.read<SpeechService>().speakIfAuto([
        l10n.navHome,
        l10n.homeAddProductSpoken,
      ], key: 'screen:home');
      context.read<CatalogController>().refresh();
      context.read<SalesController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = context.select<AppState, String?>((s) => s.profile?.name);
    final recent = context.select((CatalogController c) => c.recent);
    final next = context.select((CatalogController c) => c.nextToFinish);
    final others = [
      for (final listing in recent)
        if (listing.id != next?.id) listing,
    ];
    final unreadSales = context.select((SalesController s) => s.unreadCount);

    final greeting = (name == null || name.trim().isEmpty)
        ? l10n.appTitle
        : l10n.homeGreeting(name.trim());

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonHeight = (constraints.maxHeight * 0.42).clamp(
            180.0,
            340.0,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.gutter,
              8,
              AppTheme.gutter,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScreenHeader(
                  title: greeting,
                  spokenLines: [greeting, l10n.homeAddProductSpoken],
                  utteranceKey: 'screen:home',
                ),
                const SizedBox(height: 14),
                _AddProductButton(height: buttonHeight),
                const SizedBox(height: 16),
                _StatusChips(unreadSales: unreadSales),
                const DevSimulateButton(),
                const SizedBox(height: 22),
                AnimatedSize(
                  duration: AppMotion.of(context, AppMotion.medium),
                  curve: AppMotion.standard,
                  alignment: Alignment.topCenter,
                  child: next == null
                      ? const SizedBox(width: double.infinity)
                      : FadeIn(
                          key: ValueKey(next.id),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: _NextThing(listing: next),
                          ),
                        ),
                ),
                if (recent.isEmpty)
                  const _EmptyHome()
                else if (others.isNotEmpty)
                  _RecentListings(recent: others),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speech = context.read<SpeechService>();

    return Semantics(
      button: true,
      label: l10n.homeAddProductSpoken,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Material(
          color: AppColors.terracotta,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: () => Navigator.of(context).pushNamed(
              context.read<AppState>().hasSeenPractice
                  ? AppRoutes.capture
                  : AppRoutes.practice,
            ),
            onLongPress: () =>
                speech.speak(l10n.homeAddProductSpoken, key: 'home:add'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo, size: 76, color: Colors.white),
                  const SizedBox(height: 14),
                  WholeWordText(
                    l10n.homeAddProduct,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.unreadSales});

  final int unreadSales;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final chips = <Widget>[
      if (unreadSales > 0)
        FadeIn(
          key: const ValueKey('chip-sold'),
          child: _Chip(
            icon: Icons.shopping_bag,
            label: l10n.homeSold(unreadSales),
            colour: AppColors.success,
            onTap: () =>
                ShellScope.maybeOf(context)?.openProducts(ProductsSection.sold),
          ),
        ),
    ];

    return AnimatedSize(
      duration: AppMotion.of(context, AppMotion.medium),
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: chips.isEmpty
          ? const SizedBox(width: double.infinity)
          : Wrap(spacing: 10, runSpacing: 10, children: chips),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.colour,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color colour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        onLongPress: () =>
            context.read<SpeechService>().speak(label, key: 'chip:$label'),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colour.withValues(alpha: 0.16),
            border: Border.all(color: colour, width: 2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: AppColors.ink),
              const SizedBox(width: 10),
              Flexible(
                child: WholeWordText(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextThing extends StatelessWidget {
  const _NextThing({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = (listing.title?.trim().isNotEmpty ?? false)
        ? listing.title!.trim()
        : l10n.listingUntitled;
    final status = listing.status.label(l10n);
    final spoken = [l10n.homeNextTitle, title, status];

    return GestureDetector(
      onLongPress: () =>
          context.read<SpeechService>().speakAll(spoken, key: 'home:next'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warningTint,
          border: Border.all(color: AppColors.marigold, width: 3),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WholeWordText(
                    l10n.homeNextTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SpeakButton.lines(
                  lines: spoken,
                  utteranceKey: 'home:next',
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: 6),
            WholeWordText(
              title,
              style: const TextStyle(
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  listing.status.icon,
                  size: 22,
                  color: AppColors.terracotta,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: WholeWordText(
                    status,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.terracotta,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            BigActionButton(
              label: l10n.listingFinish,
              icon: Icons.arrow_forward,
              spokenLabel: '${l10n.listingFinish}. $title',
              onPressed: () =>
                  Navigator.of(context)
                      .pushNamed(AppRoutes.review, arguments: listing),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentListings extends StatelessWidget {
  const _RecentListings({required this.recent});

  final List<Listing> recent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WholeWordText(
          l10n.homeRecent,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        for (final listing in recent) ...[
          ListingTile(
            listing: listing,
            onTap: _opensReview(listing)
                ? () =>
                      Navigator.of(context)
                          .pushNamed(AppRoutes.review, arguments: listing)
                : null,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

bool _opensReview(Listing listing) =>
    listing.status == ListingStatus.needsAttention ||
    listing.status == ListingStatus.ready;

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusView(
      kind: StatusKind.empty,
      compact: true,
      title: l10n.homeEmptyTitle,
      body: l10n.homeEmptyBody,
    );
  }
}
