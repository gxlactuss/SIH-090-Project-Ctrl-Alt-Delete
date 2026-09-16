import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/speech_service.dart';
import '../../../state/review_controller.dart';
import '../../../widgets/big_action_button.dart';
import '../widgets/review_scaffold.dart';
import '../../../widgets/whole_word_text.dart';
import '../../../widgets/app_image.dart';

class PhotosStage extends StatefulWidget {
  const PhotosStage({super.key, required this.onClose, required this.onBack});

  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  State<PhotosStage> createState() => _PhotosStageState();
}

class _PhotosStageState extends State<PhotosStage>
    with SingleTickerProviderStateMixin {
  List<String>? _order;

  final Map<String, GlobalKey> _keys = {};

  Map<String, double> _shift = const {};

  late final AnimationController _move = AnimationController(
    vsync: this,
    duration: AppMotion.slow,
    value: 1,
  );

  late final Animation<double> _moveCurve = CurvedAnimation(
    parent: _move,
    curve: AppMotion.standard,
  );

  List<String> _current(ReviewController review) =>
      _order ?? review.listing.imageUrls;

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  void _makeFirst(List<String> images, int index) {
    final heights = {
      for (final path in images)
        path: _keys[path]?.currentContext?.size?.height ?? 0.0,
    };

    final next = [...images];
    next.insert(0, next.removeAt(index));

    final before = <String, double>{};
    var top = 0.0;
    for (final path in images) {
      before[path] = top;
      top += heights[path]!;
    }

    final shift = <String, double>{};
    top = 0;
    for (final path in next) {
      shift[path] = before[path]! - top;
      top += heights[path]!;
    }

    setState(() {
      _order = next;
      _shift = shift;
    });
    if (AppMotion.reduced(context)) {
      _move.value = 1;
    } else {
      _move.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = context.watch<ReviewController>();
    final images = _current(review);

    return ReviewScaffold(
      title: l10n.photosTitle,
      subtitle: l10n.photosBody,
      busy: review.isBusy,
      onBack: widget.onBack,
      onClose: widget.onClose,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < images.length; i++)
            AnimatedBuilder(
              key: _keys.putIfAbsent(images[i], GlobalKey.new),
              animation: _moveCurve,
              builder: (context, child) => Transform.translate(
                offset: Offset(
                  0,
                  (_shift[images[i]] ?? 0) * (1 - _moveCurve.value),
                ),
                child: child,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PhotoRow(
                  path: images[i],
                  isFirst: i == 0,
                  onMakeFirst: i == 0 ? null : () => _makeFirst(images, i),
                ),
              ),
            ),
        ],
      ),
      actions: [
        BigActionButton(
          label: l10n.photosConfirm,
          icon: Icons.check,
          busy: review.isBusy,
          onPressed: review.isBusy
              ? null
              : () async {
                  final saved = await review.setPhotoOrder(images);
                  if (saved) review.next();
                },
        ),
      ],
    );
  }
}

class _PhotoRow extends StatelessWidget {
  const _PhotoRow({
    required this.path,
    required this.isFirst,
    required this.onMakeFirst,
  });

  final String path;
  final bool isFirst;
  final VoidCallback? onMakeFirst;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = AppMotion.of(context, AppMotion.medium);

    return AnimatedContainer(
      duration: duration,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isFirst ? AppColors.terracotta : AppColors.border,
          width: isFirst ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 96,
              height: 96,
              child: AppImage(path, decodeSize: 96),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: duration,
              layoutBuilder: (current, previous) => Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [...previous, ?current],
              ),
              child: isFirst
                  ? Row(
                      key: const ValueKey('first'),
                      children: [
                        const Icon(
                          Icons.star,
                          size: 22,
                          color: AppColors.terracotta,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: WholeWordText(
                            l10n.photosFirst,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.terracotta,
                            ),
                          ),
                        ),
                      ],
                    )
                  : TextButton.icon(
                      key: const ValueKey('make-first'),
                      onPressed: onMakeFirst,
                      onLongPress: () => context.read<SpeechService>().speak(
                        l10n.photosMakeFirst,
                        key: 'photos:first',
                      ),
                      icon: const Icon(Icons.arrow_upward, size: 24),
                      label: WholeWordText(l10n.photosMakeFirst),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
