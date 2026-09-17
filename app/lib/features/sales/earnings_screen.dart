import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../l10n/app_localizations.dart';
import '../../services/speech_service.dart';
import '../../state/sales_controller.dart';
import '../../widgets/animated_number.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/screen_header.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final (week, month, total, itemsSold) = context.select(
      (SalesController s) =>
          (s.thisWeekInPaise, s.thisMonthInPaise, s.totalInPaise, s.itemsSold),
    );

    final rows = <(String, int)>[
      (l10n.earningsWeek, week),
      (l10n.earningsMonth, month),
      (l10n.earningsTotal, total),
    ];

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
              title: l10n.earningsTitle,
              spokenLines: [
                for (final (label, paise) in rows)
                  '$label: ${Money.rupees(paise, locale)}',
                l10n.earningsItems(itemsSold),
                l10n.earningsNote,
              ],
              utteranceKey: 'screen:earnings',
            ),
            const SizedBox(height: 16),
            for (final (label, paise) in rows) ...[
              _Amount(label: label, paise: paise, locale: locale),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 26,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: WholeWordText(
                    l10n.earningsItems(itemsSold),
                    style: const TextStyle(fontSize: 19, color: AppColors.ink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 26,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WholeWordText(
                      l10n.earningsNote,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  SpeakButton(text: l10n.earningsNote, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.label,
    required this.paise,
    required this.locale,
  });

  final String label;
  final int paise;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final amount = Money.rupees(paise, locale);

    return GestureDetector(
      onLongPress: () => context.read<SpeechService>().speak(
        '$label: $amount',
        key: 'earnings:$label',
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WholeWordText(
              label,
              style: const TextStyle(fontSize: 17, color: AppColors.muted),
            ),
            const SizedBox(height: 4),
            AnimatedNumber(
              value: paise,
              format: (value) => Money.rupees(value, locale),
              style: const TextStyle(
                fontSize: 34,
                height: 1.15,
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
