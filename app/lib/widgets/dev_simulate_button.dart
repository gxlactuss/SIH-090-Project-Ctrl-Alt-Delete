import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/dev/dev_accounts.dart';
import '../core/di.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../data/remote/api_client.dart';
import '../data/remote/hybrid_api.dart';
import '../data/remote/mock_api.dart';
import '../l10n/app_localizations.dart';
import '../state/catalog_controller.dart';
import 'whole_word_text.dart';

class DevSimulateButton extends StatelessWidget {
  const DevSimulateButton({super.key, this.listingId, this.bottomGap = false});

  final String? listingId;

  final bool bottomGap;

  void _simulate(BuildContext context, MockApi api) {
    final listing = api.simulatePolished(listingId: listingId);

    context.read<CatalogController>().replace(listing);
    Navigator.of(context).pushNamed(AppRoutes.review, arguments: listing);
  }

  @override
  Widget build(BuildContext context) {
    final client = context.maybeRead<ApiClient>();
    final api = switch (client) {
      MockApi() => client,
      HybridApi() => client.mock,
      _ => null,
    };
    if (!DevAccounts.enabled || kReleaseMode || api == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: bottomGap
          ? const EdgeInsets.only(bottom: 10)
          : const EdgeInsets.only(top: 12),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.muted,
          side: const BorderSide(color: AppColors.muted, width: 2),
          minimumSize: const Size.fromHeight(AppTheme.minTapTarget),
        ),
        onPressed: () => _simulate(context, api),
        icon: const Icon(Icons.bug_report_outlined, size: 24),
        label: WholeWordText(AppLocalizations.of(context).devSimulateResult),
      ),
    );
  }
}
