import 'fact_sheet.dart';
import 'listing_status.dart';
import 'suggestion.dart';

class Listing {
  const Listing({
    required this.id,
    required this.status,
    required this.factSheet,
    this.title,
    this.description,
    this.imageUrls = const [],
    this.suggestions = const [],
    this.followUpQuestion,
    this.suggestedPriceInPaise,
    this.priceFloorInPaise,
    this.previewUrl,
    this.photoConsent = false,
    this.storyConsent = false,
    this.views = 0,
    this.templateListingId,
  });

  final String id;
  final ListingStatus status;
  final FactSheet factSheet;
  final String? title;
  final String? description;
  final List<String> imageUrls;
  final List<Suggestion> suggestions;

  final String? followUpQuestion;

  final int? suggestedPriceInPaise;
  final int? priceFloorInPaise;

  final String? previewUrl;

  final bool photoConsent;
  final bool storyConsent;

  final int views;

  final String? templateListingId;

  bool get needsAttention => followUpQuestion != null;

  bool get asksForPhotos => RegExp(
    r'photo|picture|image|frame',
    caseSensitive: false,
  ).hasMatch(followUpQuestion ?? '');

  int get stock => factSheet.quantity ?? 0;

  bool get isSoldOut => status == ListingStatus.soldOut || stock <= 0;

  List<Suggestion> get unansweredSuggestions =>
      suggestions.where((s) => s.accepted == null).toList();

  List<Suggestion> get acceptedSuggestions =>
      suggestions.where((s) => s.accepted == true).toList();

  Map<String, Object?> toJson() => {
    'id': id,
    'status': status.name,
    'title': title,
    'description': description,
    'imageUrls': imageUrls,
    'followUpQuestion': followUpQuestion,
    'suggestedPriceInPaise': suggestedPriceInPaise,
    'priceFloorInPaise': priceFloorInPaise,
    'previewUrl': previewUrl,
    'photoConsent': photoConsent,
    'storyConsent': storyConsent,
    'views': views,
    'templateListingId': templateListingId,
    'factSheet': {
      'material': factSheet.material,
      'size': factSheet.size,
      'colour': factSheet.colour,
      'quantity': factSheet.quantity,
      'priceInPaise': factSheet.priceInPaise,
      'hoursToMake': factSheet.hoursToMake,
      'materialCostInPaise': factSheet.materialCostInPaise,
      'isOneOfAKind': factSheet.isOneOfAKind,
    },
    'suggestions': [
      for (final suggestion in suggestions)
        {
          'id': suggestion.id,
          'spokenPrompt': suggestion.spokenPrompt,
          'textIfAccepted': suggestion.textIfAccepted,
          'field': suggestion.field,
          'accepted': suggestion.accepted,
        },
    ],
  };

  factory Listing.fromJson(Map<String, Object?> json) {
    final status = ListingStatus.values
        .where((s) => s.name == json['status'])
        .firstOrNull;
    if (status == null) {
      throw FormatException('Unknown listing status: ${json['status']}');
    }

    final sheet = (json['factSheet'] as Map?)?.cast<String, Object?>() ?? {};
    int? whole(Object? value) => (value as num?)?.toInt();

    return Listing(
      id: json['id'] as String,
      status: status,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrls: (json['imageUrls'] as List?)?.cast<String>() ?? const [],
      followUpQuestion: json['followUpQuestion'] as String?,
      suggestedPriceInPaise: whole(json['suggestedPriceInPaise']),
      priceFloorInPaise: whole(json['priceFloorInPaise']),
      previewUrl: json['previewUrl'] as String?,
      photoConsent: json['photoConsent'] as bool? ?? false,
      storyConsent: json['storyConsent'] as bool? ?? false,
      views: whole(json['views']) ?? 0,
      templateListingId: json['templateListingId'] as String?,
      factSheet: FactSheet(
        material: sheet['material'] as String?,
        size: sheet['size'] as String?,
        colour: sheet['colour'] as String?,
        quantity: whole(sheet['quantity']),
        priceInPaise: whole(sheet['priceInPaise']),
        hoursToMake: (sheet['hoursToMake'] as num?)?.toDouble(),
        materialCostInPaise: whole(sheet['materialCostInPaise']),
        isOneOfAKind: sheet['isOneOfAKind'] as bool? ?? false,
      ),
      suggestions: [
        for (final raw in (json['suggestions'] as List? ?? const []))
          if (raw is Map)
            Suggestion(
              id: raw['id'] as String,
              spokenPrompt: raw['spokenPrompt'] as String,
              textIfAccepted: raw['textIfAccepted'] as String,
              field: raw['field'] as String?,
              accepted: raw['accepted'] as bool?,
            ),
      ],
    );
  }

  Listing copyWith({
    ListingStatus? status,
    FactSheet? factSheet,
    String? title,
    String? description,
    List<String>? imageUrls,
    List<Suggestion>? suggestions,
    String? followUpQuestion,
    bool clearFollowUpQuestion = false,
    int? suggestedPriceInPaise,
    int? priceFloorInPaise,
    String? previewUrl,
    bool? photoConsent,
    bool? storyConsent,
    int? views,
    String? templateListingId,
  }) {
    return Listing(
      id: id,
      status: status ?? this.status,
      factSheet: factSheet ?? this.factSheet,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      suggestions: suggestions ?? this.suggestions,
      followUpQuestion: clearFollowUpQuestion
          ? null
          : followUpQuestion ?? this.followUpQuestion,
      suggestedPriceInPaise:
          suggestedPriceInPaise ?? this.suggestedPriceInPaise,
      priceFloorInPaise: priceFloorInPaise ?? this.priceFloorInPaise,
      previewUrl: previewUrl ?? this.previewUrl,
      photoConsent: photoConsent ?? this.photoConsent,
      storyConsent: storyConsent ?? this.storyConsent,
      views: views ?? this.views,
      templateListingId: templateListingId ?? this.templateListingId,
    );
  }
}
