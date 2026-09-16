import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/info_panel.dart';

class DuplicateBanner extends StatelessWidget {
  const DuplicateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InfoPanel(
      icon: Icons.copy_all,
      text: l10n.duplicateBanner,
      dense: true,
    );
  }
}
