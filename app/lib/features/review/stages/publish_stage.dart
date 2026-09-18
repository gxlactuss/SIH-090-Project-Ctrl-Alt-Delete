import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../../../widgets/stage_switcher.dart';
import '../../../widgets/success_mark.dart';
import '../../listings/widgets/share_listing.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/api_problem_text.dart';

class PublishStage extends StatelessWidget {
  const PublishStage({
    super.key,
    required this.onDone,
    required this.onAnother,
  });

  final VoidCallback onDone;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();

    final (String state, Widget screen) = review.isBusy
        ? ('publishing', _Publishing(l10n: l10n, isEdit: review.isEdit))
        : !review.wentLive
        ? ('failed', _Failed(review: review, l10n: l10n))
        : (
            'published',
            _Published(
              l10n: l10n,
              isEdit: review.isEdit,
              url: review.listing.previewUrl,
              title: review.listing.title,
              onDone: onDone,
              onAnother: onAnother,
            ),
          );

    return StageSwitcher(stage: state, child: screen);
  }
}

class _Publishing extends StatelessWidget {
  const _Publishing({required this.l10n, required this.isEdit});

  final AppLocalizations l10n;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return ReviewScaffold(
      title: isEdit ? l10n.editRepublishing : l10n.publishingTitle,
      subtitle: l10n.publishingBody,
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
        ),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.review, required this.l10n});

  final ReviewController review;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ReviewScaffold(
      title: l10n.publishFailed,
      subtitle: errorMessage(review.error, l10n),
      spokenLines: [l10n.publishFailed, errorMessage(review.error, l10n)],
      onBack: () => review.goTo(
        review.isEdit ? ReviewStage.preview : ReviewStage.consent,
      ),
      body: const Center(
        child: SuccessMark(
          icon: Icons.cloud_off,
          colour: AppColors.danger,
          tint: AppColors.dangerTint,
          iconSize: 60,
        ),
      ),
      actions: [
        BigActionButton(
          label: l10n.publishRetry,
          icon: Icons.refresh,
          onPressed: review.isEdit
              ? review.republish
              : () => review.publish(
                  photoConsent: true,
                  storyConsent: review.listing.storyConsent,
                ),
        ),
      ],
    );
  }
}

class _Published extends StatelessWidget {
  const _Published({
    required this.l10n,
    required this.isEdit,
    required this.url,
    required this.title,
    required this.onDone,
    required this.onAnother,
  });

  final AppLocalizations l10n;
  final bool isEdit;
  final String? url;
  final String? title;
  final VoidCallback onDone;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final heading = isEdit ? l10n.editRepublished : l10n.publishedTitle;
    final link = url;

    return ReviewScaffold(
      title: heading,
      subtitle: l10n.publishedBody,
      spokenLines: [heading, l10n.publishedBody, l10n.publishedQrExplain],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: SuccessMark(
              icon: Icons.check,
              colour: AppColors.success,
              tint: AppColors.successTint,
              size: 104,
              iconSize: 60,
              celebrate: true,
            ),
          ),
          const SizedBox(height: 22),
          if (link != null) ...[
            ListingQr(url: link),
            const SizedBox(height: 14),
            SelectableText(
              link,
              style: const TextStyle(fontSize: 16, color: AppColors.muted),
            ),
          ],
        ],
      ),
      actions: [
        if (link != null) ...[
          BigActionButton(
            label: l10n.publishedShare,
            icon: Icons.share,
            onPressed: () =>
                ShareListing.whatsapp(context, url: link, title: title),
          ),
          BigActionButton(
            label: l10n.publishedCopyLink,
            icon: Icons.copy,
            tone: ButtonTone.secondary,
            onPressed: () => ShareListing.copy(context, link),
          ),
        ],
        BigActionButton(
          label: l10n.publishedAnother,
          icon: Icons.add_a_photo,
          tone: ButtonTone.secondary,
          onPressed: onAnother,
        ),
        TextButton(onPressed: onDone, child: WholeWordText(l10n.publishedDone)),
      ],
    );
  }
}
