import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../data/models/fact_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/whole_word_text.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.field,
    required this.factSheet,
    required this.onTap,
  });

  final ListingField field;
  final FactSheet factSheet;
  final VoidCallback onTap;

  static String? valueText(
    BuildContext context,
    ListingField field,
    FactSheet sheet,
  ) {
    final value = sheet.value(field);
    if (value == null) return null;
    if (field == ListingField.price) {
      return Money.rupees(
        value as int,
        Localizations.localeOf(context).toString(),
      );
    }
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = field.label(l10n);
    final value = valueText(context, field, factSheet);
    final said = value != null;
    final spoken = '$label. ${value ?? l10n.notSaid}';

    return Semantics(
      button: true,
      label: spoken,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        onLongPress: () => context.read<SpeechService>().speak(
          spoken,
          key: 'field:${field.name}',
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: said ? AppColors.border : AppColors.marigold,
              width: said ? 2 : 3,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              Icon(field.icon, size: 28, color: AppColors.muted),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WholeWordText(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (!said) ...[
                          const Icon(
                            Icons.help_outline,
                            size: 20,
                            color: AppColors.marigold,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: WholeWordText(
                            value ?? l10n.notSaid,
                            style: TextStyle(
                              fontSize: 21,
                              height: 1.25,
                              fontWeight: FontWeight.w600,
                              color: said ? AppColors.ink : AppColors.marigold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.mic, size: 26, color: AppColors.terracotta),
            ],
          ),
        ),
      ),
    );
  }
}
