import 'craft_type.dart';

class SellerProfile {
  const SellerProfile({
    required this.id,
    required this.name,
    required this.languageCode,
    this.phone,
    this.craft,
    this.ondcSellerId,
    this.ondcEmail,
    this.village,
    this.photoPath,
    this.craftStory,
  });

  final String id;
  final String name;
  final String languageCode;
  final String? phone;
  final CraftType? craft;

  final String? ondcSellerId;
  final String? ondcEmail;

  final String? village;

  final String? photoPath;

  final String? craftStory;

  bool get hasOndcAccount => ondcSellerId != null && ondcSellerId!.isNotEmpty;

  SellerProfile copyWith({
    String? id,
    String? name,
    String? languageCode,
    String? phone,
    CraftType? craft,
    String? ondcSellerId,
    String? ondcEmail,
    String? village,
    String? photoPath,
    String? craftStory,
    bool clearOndc = false,
    bool clearPhoto = false,
  }) {
    return SellerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
      phone: phone ?? this.phone,
      craft: craft ?? this.craft,
      ondcSellerId: clearOndc ? null : ondcSellerId ?? this.ondcSellerId,
      ondcEmail: clearOndc ? null : ondcEmail ?? this.ondcEmail,
      village: village ?? this.village,
      photoPath: clearPhoto ? null : photoPath ?? this.photoPath,
      craftStory: craftStory ?? this.craftStory,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'language_code': languageCode,
        'phone': phone,
        'craft': craft?.id,
        'ondc_seller_id': ondcSellerId,
        'ondc_email': ondcEmail,
        'village': village,
        'photo_path': photoPath,
        'craft_story': craftStory,
      };

  factory SellerProfile.fromJson(Map<String, dynamic> json) => SellerProfile(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        languageCode: json['language_code'] as String? ?? 'hi',
        phone: json['phone'] as String?,
        craft: CraftType.byId(json['craft'] as String?),
        ondcSellerId: json['ondc_seller_id'] as String?,
        ondcEmail: json['ondc_email'] as String?,
        village: json['village'] as String?,
        photoPath: json['photo_path'] as String?,
        craftStory: json['craft_story'] as String?,
      );
}
