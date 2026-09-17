import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/speak_button.dart';
import '../../../widgets/whole_word_text.dart';

abstract final class ShareListing {
  static Future<void> whatsapp(
    BuildContext context, {
    required String url,
    String? title,
  }) async {
    final message = Uri.encodeComponent('${title ?? ''} $url'.trim());
    final whatsapp = Uri.parse('https://wa.me/?text=$message');

    if (!await launchUrl(whatsapp, mode: LaunchMode.externalApplication)) {
      if (context.mounted) await copy(context, url);
    }
  }

  static Future<void> copy(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: url));
    messenger.showSnackBar(
      SnackBar(content: WholeWordText(l10n.publishedLinkCopied)),
    );
  }

  static Future<void> showQr(BuildContext context, {required String url}) {
    final speech = context.read<SpeechService>();
    final l10n = AppLocalizations.of(context);

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) => ChangeNotifierProvider<SpeechService>.value(
        value: speech,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.gutter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListingQr(url: url),
                const SizedBox(height: 12),
                SelectableText(
                  url,
                  style: const TextStyle(fontSize: 16, color: AppColors.muted),
                ),
                const SizedBox(height: 16),
                BigActionButton(
                  label: l10n.publishedCopyLink,
                  icon: Icons.copy,
                  tone: ButtonTone.secondary,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    copy(context, url);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListingQr extends StatelessWidget {
  const ListingQr({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        children: [
          QrImageView(
            data: url,
            size: 200,
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: WholeWordText(
                  l10n.publishedQrExplain,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: AppColors.muted,
                  ),
                ),
              ),
              SpeakButton(text: l10n.publishedQrExplain, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
