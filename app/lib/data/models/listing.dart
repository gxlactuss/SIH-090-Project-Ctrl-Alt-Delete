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

  int get stock => factSheet.quantity ?? 0;

  bool get isSoldOut => status == ListingStatus.soldOut || stock <= 0;

  List<Suggestion> get unansweredSuggestions =>
      suggestions.where((s) => s.accepted == null).toList();

  List<Suggestion> get acceptedSuggestions =>
      suggestions.where((s) => s.accepted == true).toList();

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
      followUpQuestion:
          clearFollowUpQuestion ? null : followUpQuestion ?? this.followUpQuestion,
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
