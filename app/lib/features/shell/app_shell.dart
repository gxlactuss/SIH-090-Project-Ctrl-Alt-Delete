import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/di.dart';
import '../../core/routing/link_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/catalog_controller.dart';
import '../../state/sales_controller.dart';
import '../../widgets/offline_banner.dart';
import '../home/home_screen.dart';
import '../products/products_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/whole_word_text.dart';

enum ShellTab { home, products, profile }

class ShellScope extends InheritedWidget {
  const ShellScope({
    super.key,
    required this.open,
    required this.openProducts,
    required super.child,
  });

  final void Function(ShellTab tab) open;

  final void Function(ProductsSection section) openProducts;

  static ShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope oldWidget) => false;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  ShellTab _tab = ShellTab.home;

  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
    value: 1,
  );

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _fade,
    curve: AppMotion.enter,
  );

  final ValueNotifier<ProductsSection> _section = ValueNotifier(
    ProductsSection.inProgress,
  );

  LinkRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = context.maybeRead<LinkRouter>();
    _router?.isReady = true;
  }

  @override
  void dispose() {
    _router?.isReady = false;
    _section.dispose();
    _fade.dispose();
    super.dispose();
  }

  void _open(ShellTab tab) {
    if (_tab == tab) return;
    HapticFeedback.selectionClick();
    context.read<SpeechService>().stop();
    setState(() => _tab = tab);
    if (AppMotion.reduced(context)) {
      _fade.value = 1;
    } else {
      _fade.forward(from: 0);
    }
    _refresh(tab);
  }

  void _openProducts(ProductsSection section) {
    _section.value = section;
    _open(ShellTab.products);
  }

  void _refresh(ShellTab tab) {
    switch (tab) {
      case ShellTab.home:
        context.maybeRead<CatalogController>()?.refresh();
        context.maybeRead<SalesController>()?.load();
      case ShellTab.products:
        context.maybeRead<CatalogController>()?.refresh();
        context.maybeRead<SalesController>()?.load();
      case ShellTab.profile:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tab == ShellTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _open(ShellTab.home);
      },
      child: ShellScope(
        open: _open,
        openProducts: _openProducts,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _opacity,
                  child: IndexedStack(
                    index: _tab.index,
                    children: [
                      HeroMode(
                        enabled: _tab == ShellTab.home,
                        child: const HomeScreen(),
                      ),
                      HeroMode(
                        enabled: _tab == ShellTab.products,
                        child: ProductsScreen(section: _section),
                      ),
                      HeroMode(
                        enabled: _tab == ShellTab.profile,
                        child: const ProfileScreen(),
                      ),
                    ],
                  ),
                ),
              ),
              const OfflineBanner(),
            ],
          ),
          bottomNavigationBar: _BottomNav(current: _tab, onSelect: _open),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect});

  final ShellTab current;
  final void Function(ShellTab tab) onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tabs = <(ShellTab, IconData, String)>[
      (ShellTab.home, Icons.home, l10n.navHome),
      (ShellTab.products, Icons.inventory_2, l10n.navListings),
      (ShellTab.profile, Icons.person, l10n.navProfile),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Row(
              children: [
                for (final (tab, icon, label) in tabs)
                  Expanded(
                    child: _TabButton(
                      icon: icon,
                      label: label,
                      selected: tab == current,
                      onTap: () => onSelect(tab),
                    ),
                  ),
              ],
            ),
            PositionedDirectional(
              top: 6,
              start: 0,
              end: 0,
              child: IgnorePointer(
                child: AnimatedAlign(
                  alignment: AlignmentDirectional(
                    -1 + 2 * current.index / (tabs.length - 1),
                    0,
                  ),
                  duration: AppMotion.of(context, AppMotion.medium),
                  curve: AppMotion.standard,
                  child: FractionallySizedBox(
                    widthFactor: 1 / tabs.length,
                    child: Center(
                      child: Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.terracotta,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colour = selected ? AppColors.terracotta : AppColors.muted;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        onLongPress: () =>
            context.read<SpeechService>().speak(label, key: 'tab:$label'),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: colour),
                duration: AppMotion.of(context, AppMotion.medium),
                builder: (context, value, _) =>
                    Icon(icon, size: 28, color: value),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: WholeWordText(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppTheme.minTextSize,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: colour,
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
