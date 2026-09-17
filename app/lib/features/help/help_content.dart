import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';

enum HelpTopic {
  photos(Icons.photo_camera_outlined),
  voiceNote(Icons.mic_none),
  price(Icons.currency_rupee),
  afterSale(Icons.local_shipping_outlined);

  const HelpTopic(this.icon);

  final IconData icon;

  String title(AppLocalizations l10n) => switch (this) {
    HelpTopic.photos => l10n.helpTopicPhotos,
    HelpTopic.voiceNote => l10n.helpTopicVoice,
    HelpTopic.price => l10n.helpTopicPrice,
    HelpTopic.afterSale => l10n.helpTopicSold,
  };

  String body(AppLocalizations l10n) => switch (this) {
    HelpTopic.photos => l10n.helpTopicPhotosBody,
    HelpTopic.voiceNote => l10n.helpTopicVoiceBody,
    HelpTopic.price => l10n.helpTopicPriceBody,
    HelpTopic.afterSale => l10n.helpTopicSoldBody,
  };

  List<String> steps(AppLocalizations l10n) => switch (this) {
    HelpTopic.photos => [
      l10n.helpTopicPhotosStep1,
      l10n.helpTopicPhotosStep2,
      l10n.helpTopicPhotosStep3,
      l10n.helpTopicPhotosStep4,
      l10n.helpTopicPhotosStep5,
    ],
    HelpTopic.voiceNote => [
      l10n.helpTopicVoiceStep1,
      l10n.helpTopicVoiceStep2,
      l10n.helpTopicVoiceStep3,
      l10n.helpTopicVoiceStep4,
      l10n.helpTopicVoiceStep5,
    ],
    HelpTopic.price => [
      l10n.helpTopicPriceStep1,
      l10n.helpTopicPriceStep2,
      l10n.helpTopicPriceStep3,
      l10n.helpTopicPriceStep4,
    ],
    HelpTopic.afterSale => [
      l10n.helpTopicSoldStep1,
      l10n.helpTopicSoldStep2,
      l10n.helpTopicSoldStep3,
      l10n.helpTopicSoldStep4,
      l10n.helpTopicSoldStep5,
    ],
  };

  List<String> spoken(AppLocalizations l10n) => [
    title(l10n),
    body(l10n),
    ...steps(l10n),
  ];
}

List<({String question, String answer})> faqs(AppLocalizations l10n) => [
  (question: l10n.faqQ1, answer: l10n.faqA1),
  (question: l10n.faqQ2, answer: l10n.faqA2),
  (question: l10n.faqQ3, answer: l10n.faqA3),
  (question: l10n.faqQ4, answer: l10n.faqA4),
  (question: l10n.faqQ5, answer: l10n.faqA5),
  (question: l10n.faqQ6, answer: l10n.faqA6),
  (question: l10n.faqQ7, answer: l10n.faqA7),
];

abstract final class Support {
  static const String phone = AppConfig.supportPhone;

  static bool get isConfigured => phone.isNotEmpty;

  static String get dialable => phone.replaceAll(RegExp(r'[^0-9+]'), '');
}
