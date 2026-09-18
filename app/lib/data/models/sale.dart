class Sale {
  const Sale({
    required this.id,
    required this.listingTitle,
    required this.quantity,
    required this.amountInPaise,
    required this.placedAt,
    this.packByDate,
    this.listingId,
    this.imageUrl,
    this.buyerArea,
    this.isRead = false,
  });

  final String id;
  final String listingTitle;
  final int quantity;

  final int amountInPaise;

  final DateTime placedAt;

  final DateTime? packByDate;

  final String? listingId;
  final String? imageUrl;

  final String? buyerArea;

  final bool isRead;

  Sale copyWith({bool? isRead}) => Sale(
    id: id,
    listingTitle: listingTitle,
    quantity: quantity,
    amountInPaise: amountInPaise,
    placedAt: placedAt,
    packByDate: packByDate,
    listingId: listingId,
    imageUrl: imageUrl,
    buyerArea: buyerArea,
    isRead: isRead ?? this.isRead,
  );

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    id: json['id'] as String,
    listingId: json['listing_id'] as String?,
    listingTitle: json['listing_title'] as String? ?? '',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    amountInPaise: (json['amount_in_paise'] as num?)?.toInt() ?? 0,
    placedAt: DateTime.parse(json['placed_at'] as String),
    packByDate: json['pack_by'] == null
        ? null
        : DateTime.parse(json['pack_by'] as String),
    imageUrl: json['image_url'] as String?,
    buyerArea: json['buyer_area'] as String?,
  );
}
