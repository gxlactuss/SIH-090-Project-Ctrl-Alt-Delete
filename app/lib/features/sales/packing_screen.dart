import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/sales_controller.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/info_panel.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({super.key, required this.saleId});

  final String saleId;

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  final Set<int> _done = {};

  List<String> _steps(AppLocalizations l10n) => [
    l10n.packingStep1,
    l10n.packingStep2,
    l10n.packingStep3,
    l10n.packingStep4,
    l10n.packingStep5,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = _steps(l10n);
    final sale = context.select((SalesController s) => s.byId(widget.saleId));
    final complete = _done.length == steps.length;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.gutter,
            0,
            AppTheme.gutter,
            24,
          ),
          children: [
            ScreenHeader(
              title: l10n.packingTitle,
              subtitle: l10n.packingBody,
              spokenLines: [l10n.packingTitle, l10n.packingBody, ...steps],
              utteranceKey: 'screen:packing',
              subtitleGap: 12,
              subtitleStyle: const TextStyle(
                fontSize: 18,
                height: 1.35,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            WholeWordText(
              l10n.packingProgress(_done.length, steps.length),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.terracotta,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < steps.length; i++) ...[
              _Step(
                number: i + 1,
                text: i == 2 && sale != null
                    ? '${steps[i]} — ${l10n.salesQuantity(sale.quantity)}'
                    : steps[i],
                done: _done.contains(i),
                onTap: () => setState(() {
                  if (!_done.remove(i)) _done.add(i);
                }),
              ),
              const SizedBox(height: 12),
            ],
            if (complete)
              InfoPanel(
                icon: Icons.check_circle,
                text: l10n.packingDone,
                tone: InfoTone.success,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.text,
    required this.done,
    required this.onTap,
  });

  final int number;
  final String text;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: done,
      label: text,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () =>
            context.read<SpeechService>().speak(text, key: 'packing:$number'),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: done ? AppColors.success : AppColors.border,
              width: done ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                done ? Icons.check_box : Icons.check_box_outline_blank,
                size: 34,
                color: done ? AppColors.success : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WholeWordText(
                  text,
                  style: TextStyle(
                    fontSize: 19,
                    height: 1.35,
                    color: done ? AppColors.muted : AppColors.ink,
                    decoration: done ? TextDecoration.lineThrough : null,
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
