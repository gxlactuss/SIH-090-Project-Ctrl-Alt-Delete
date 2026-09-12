import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class FactSheet {
  const FactSheet({
    this.material,
    this.size,
    this.colour,
    this.technique,
    this.quantity,
    this.priceInPaise,
    this.hoursToMake,
    this.materialCostInPaise,
    this.isOneOfAKind = false,
  });

  final String? material;
  final String? size;
  final String? colour;
  final String? technique;
  final int? quantity;
  final int? priceInPaise;
  final double? hoursToMake;

  final int? materialCostInPaise;

  final bool isOneOfAKind;

  FactSheet copyWith({
    String? material,
    String? size,
    String? colour,
    String? technique,
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
      technique: technique ?? this.technique,
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
        ListingField.technique => technique,
        ListingField.quantity => quantity,
        ListingField.price => priceInPaise,
      };

  FactSheet withField(ListingField field, Object? value) => switch (field) {
        ListingField.material => copyWith(material: value as String?),
        ListingField.size => copyWith(size: value as String?),
        ListingField.colour => copyWith(colour: value as String?),
        ListingField.technique => copyWith(technique: value as String?),
        ListingField.quantity => copyWith(quantity: value as int?),
        ListingField.price => copyWith(priceInPaise: value as int?),
      };
}

enum ListingField {
  material(Correction.words),
  size(Correction.chips),
  colour(Correction.chips),
  technique(Correction.words),
  quantity(Correction.number),
  price(Correction.number);

  const ListingField(this.fallback);

  final Correction fallback;
}

enum Correction {
  number,

  chips,

  words,
}

extension ListingFieldDisplay on ListingField {
  String label(AppLocalizations l10n) => switch (this) {
        ListingField.material => l10n.fieldMaterial,
        ListingField.size => l10n.fieldSize,
        ListingField.colour => l10n.fieldColour,
        ListingField.technique => l10n.fieldTechnique,
        ListingField.quantity => l10n.fieldQuantity,
        ListingField.price => l10n.fieldPrice,
      };

  IconData get icon => switch (this) {
        ListingField.material => Icons.category_outlined,
        ListingField.size => Icons.straighten,
        ListingField.colour => Icons.palette_outlined,
        ListingField.technique => Icons.handyman_outlined,
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
