import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

enum CraftType {
  weaving(Icons.grid_on),
  pottery(Icons.local_drink),
  woodwork(Icons.forest),
  metalwork(Icons.hardware),
  jewellery(Icons.diamond),
  embroidery(Icons.gesture),
  painting(Icons.brush),
  leather(Icons.work),
  bamboo(Icons.grass),
  other(Icons.more_horiz);

  const CraftType(this.icon);

  final IconData icon;

  String get image => 'assets/images/crafts/$name.jpg';

  String get id => name;

  static CraftType? byId(String? id) {
    if (id == null) return null;
    for (final craft in values) {
      if (craft.id == id) return craft;
    }
    return null;
  }

  String label(AppLocalizations l10n) => switch (this) {
    CraftType.weaving => l10n.craftWeaving,
    CraftType.pottery => l10n.craftPottery,
    CraftType.woodwork => l10n.craftWoodwork,
    CraftType.metalwork => l10n.craftMetalwork,
    CraftType.jewellery => l10n.craftJewellery,
    CraftType.embroidery => l10n.craftEmbroidery,
    CraftType.painting => l10n.craftPainting,
    CraftType.leather => l10n.craftLeather,
    CraftType.bamboo => l10n.craftBamboo,
    CraftType.other => l10n.craftOther,
  };
}
