import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/listing.dart';
import '../../data/models/listing_status.dart';
import '../../data/repositories/listing_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/catalog_controller.dart';
import '../../widgets/speak_button.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/api_problem_text.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CatalogController>().refresh();
    });
  }

  Future<void> _withdraw(Listing listing, {required bool photo}) async {
    final l10n = AppLocalizations.of(context);
    final catalog = context.read<CatalogController>();
    final listings = context.read<ListingRepository>();
    final messenger = ScaffoldMessenger.of(context);

    final body = photo
        ? l10n.privacyWithdrawPhotoBody
        : l10n.privacyWithdrawStoryBody;

    final confirmed = await showSpokenConfirm(
      context,
      title: l10n.privacyWithdrawTitle,
      body: body,
      confirm: l10n.privacyWithdrawConfirm,
      cancel: l10n.privacyWithdrawCancel,
      speechKey: 'privacy:withdraw',
    );

    if (!confirmed || !mounted) return;
    setState(() => _busy = true);

    try {
      final updated = await listings.setConsent(
        listingId: listing.id,
        photoConsent: photo ? false : listing.photoConsent,
        storyConsent: photo ? listing.storyConsent : false,
      );
      catalog.replace(updated);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: WholeWordText(l10n.privacyWithdrawn)),
      );
    } catch (error) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: WholeWordText(errorMessage(error, l10n))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final published = context.select(
      (CatalogController c) =>
          c.listings.where((l) => l.status.wasPublished).toList(),
    );

    return SettingsScaffold(
      title: l10n.privacyTitle,
      subtitle: l10n.privacyBody,
      busy: _busy,
      rows: [
        if (published.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 30,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: WholeWordText(
                    l10n.privacyNothing,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                SpeakButton(text: l10n.privacyNothing, size: 30),
              ],
            ),
          )
        else
          for (final listing in published)
            _ListingConsents(
              listing: listing,
              busy: _busy,
              onWithdraw: (photo) => _withdraw(listing, photo: photo),
            ),
      ],
    );
  }
}

class _ListingConsents extends StatelessWidget {
  const _ListingConsents({
    required this.listing,
    required this.busy,
    required this.onWithdraw,
  });

  final Listing listing;
  final bool busy;

  final void Function(bool photo) onWithdraw;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = listing.title?.trim().isNotEmpty == true
        ? listing.title!
        : l10n.listingUntitled;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: WholeWordText(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SpeakButton(text: title, size: 28),
            ],
          ),
          const SizedBox(height: 10),
          _ConsentLine(
            label: l10n.privacyPhoto,
            given: listing.photoConsent,
            onWithdraw: busy ? null : () => onWithdraw(true),
          ),
          _ConsentLine(
            label: l10n.privacyStory,
            given: listing.storyConsent,
            onWithdraw: busy ? null : () => onWithdraw(false),
          ),
        ],
      ),
    );
  }
}

class _ConsentLine extends StatelessWidget {
  const _ConsentLine({
    required this.label,
    required this.given,
    required this.onWithdraw,
  });

  final String label;
  final bool given;
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                given ? Icons.check_circle : Icons.remove_circle_outline,
                size: 26,
                color: given ? AppColors.success : AppColors.muted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: WholeWordText(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.3,
                    color: given ? AppColors.ink : AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          if (given)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                onPressed: onWithdraw,
                icon: const Icon(Icons.undo, size: 22),
                label: WholeWordText(l10n.privacyWithdrawConfirm),
              ),
            ),
        ],
      ),
    );
  }
}
