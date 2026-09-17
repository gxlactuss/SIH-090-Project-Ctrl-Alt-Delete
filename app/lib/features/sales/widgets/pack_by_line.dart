import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sale.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/whole_word_text.dart';

class PackByLine extends StatelessWidget {
  const PackByLine({super.key, required this.sale, this.size = 17});

  final Sale sale;
  final double size;

  static String? text(BuildContext context, Sale sale) {
    final packBy = sale.packByDate;
    if (packBy == null) return null;

    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(packBy.year, packBy.month, packBy.day);
    final days = due.difference(today).inDays;

    if (days < 0) return l10n.salesPackedAlready;
    if (days == 0) return l10n.salesPackByToday;
    if (days == 1) return l10n.salesPackByTomorrow;

    final date = DateFormat.MMMd(Localizations.localeOf(context).toString())
        .format(packBy);
    return l10n.salesPackBy(date);
  }

  static bool isUrgent(Sale sale) {
    final packBy = sale.packByDate;
    if (packBy == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(packBy.year, packBy.month, packBy.day);
    return due.difference(today).inDays <= 1;
  }

  @override
  Widget build(BuildContext context) {
    final label = text(context, sale);
    if (label == null) return const SizedBox.shrink();

    final urgent = isUrgent(sale);
    final colour = urgent ? AppColors.terracotta : AppColors.muted;

    return Row(
      children: [
        Icon(
          urgent ? Icons.schedule : Icons.calendar_today,
          size: size + 3,
          color: colour,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: WholeWordText(
            label,
            style: TextStyle(
              fontSize: size,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: colour,
            ),
          ),
        ),
      ],
    );
  }
}
