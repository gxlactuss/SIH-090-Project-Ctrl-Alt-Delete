import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class FactSheet {
  const FactSheet({
    this.material,
    this.size,
    this.colour,
    this.quantity,
    this.priceInPaise,
    this.hoursToMake,
    this.materialCostInPaise,
    this.isOneOfAKind = false,
  });

  final String? material;
  final String? size;
  final String? colour;

  final int? quantity;
  final int? priceInPaise;
  final double? hoursToMake;

  final int? materialCostInPaise;

  final bool isOneOfAKind;

  FactSheet copyWith({
    String? material,
    String? size,
    String? colour,
    int? quantity,
    int? priceInPaise,
    double? hoursToMake,
    int? materialCostInPaise,
    bool? isOneOfAKind,
  }) {
    return FactSheet(
      material: material ?? this.material,
      size: size ?? this.size,
      colour: colour ?? this.colour,
      quantity: quantity ?? this.quantity,
      priceInPaise: priceInPaise ?? this.priceInPaise,
      hoursToMake: hoursToMake ?? this.hoursToMake,
      materialCostInPaise: materialCostInPaise ?? this.materialCostInPaise,
      isOneOfAKind: isOneOfAKind ?? this.isOneOfAKind,
    );
  }

  Object? value(ListingField field) => switch (field) {
    ListingField.material => material,
    ListingField.size => size,
    ListingField.colour => colour,
    ListingField.quantity => quantity,
    ListingField.price => priceInPaise,
  };

  FactSheet withField(ListingField field, Object? value) => switch (field) {
    ListingField.material => copyWith(material: value as String?),
    ListingField.size => copyWith(size: value as String?),
    ListingField.colour => copyWith(colour: value as String?),
    ListingField.quantity => copyWith(quantity: value as int?),
    ListingField.price => copyWith(priceInPaise: value as int?),
  };
}

enum ListingField {
  material(Correction.words),
  size(Correction.chips),
  colour(Correction.chips),
  quantity(Correction.number),
  price(Correction.number);

  const ListingField(this.fallback);

  final Correction fallback;
}

enum Correction { number, chips, words }

extension ListingFieldDisplay on ListingField {
  String label(AppLocalizations l10n) => switch (this) {
    ListingField.material => l10n.fieldMaterial,
    ListingField.size => l10n.fieldSize,
    ListingField.colour => l10n.fieldColour,
    ListingField.quantity => l10n.fieldQuantity,
    ListingField.price => l10n.fieldPrice,
  };

  IconData get icon => switch (this) {
    ListingField.material => Icons.category_outlined,
    ListingField.size => Icons.straighten,
    ListingField.colour => Icons.palette_outlined,
    ListingField.quantity => Icons.inventory_2_outlined,
    ListingField.price => Icons.currency_rupee,
  };

  List<String> chips(AppLocalizations l10n) => switch (this) {
    ListingField.colour => [
      l10n.colourRed,
      l10n.colourBlue,
      l10n.colourGreen,
      l10n.colourYellow,
      l10n.colourBlack,
      l10n.colourWhite,
      l10n.colourBrown,
      l10n.colourMulti,
    ],
    ListingField.size => [
      l10n.sizeSmall,
      l10n.sizeMedium,
      l10n.sizeLarge,
      l10n.sizeExtraLarge,
    ],
    _ => const [],
  };
}

abstract final class SpokenFieldValue {
  static Object? parse(ListingField field, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    if (field.fallback != Correction.number) return trimmed;

    final digits = StringBuffer();
    for (final rune in trimmed.runes) {
      final value = _digitValue(rune);
      if (value != null) {
        digits.write(value);
      } else if (digits.isNotEmpty) {
        break;
      }
    }

    final number = int.tryParse(digits.toString());
    if (number == null) return null;
    return field == ListingField.price ? number * 100 : number;
  }

  static int? _digitValue(int rune) {
    if (rune >= 0x30 && rune <= 0x39) return rune - 0x30;

    const indicZeros = [
      0x0966,
      0x09E6,
      0x0A66,
      0x0AE6,
      0x0B66,
      0x0BE6,
      0x0C66,
      0x0CE6,
      0x0D66,
    ];
    for (final zero in indicZeros) {
      if (rune >= zero && rune <= zero + 9) return rune - zero;
    }
    return null;
  }
}
