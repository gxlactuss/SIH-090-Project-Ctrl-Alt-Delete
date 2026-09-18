import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/image_decode.dart';
import '../data/remote/media_auth.dart';
import 'fade_in.dart';

class AppImage extends StatelessWidget {
  const AppImage(
    this.path, {
    super.key,
    required this.decodeSize,
    this.fallback = const ImageFallback(),
    this.fit = BoxFit.cover,
    this.fadeIn = true,
  });

  final String? path;

  final double decodeSize;

  final Widget fallback;

  final BoxFit fit;

  final bool fadeIn;

  @override
  Widget build(BuildContext context) {
    final source = path;
    if (source == null) return fallback;

    final decodeWidth = decodeWidthFor(context, decodeSize);
    final frameBuilder = fadeIn ? imageFadeIn : null;
    Widget onError(BuildContext context, Object _, StackTrace? _) => fallback;

    final Widget image;
    if (source.startsWith('http')) {
      image = Image.network(
        source,
        headers: Provider.of<MediaAuth?>(
          context,
          listen: false,
        )?.headersFor(source),
        fit: fit,
        cacheWidth: decodeWidth,
        frameBuilder: frameBuilder,
        errorBuilder: onError,
      );
    } else if (source.startsWith('assets/')) {
      image = Image.asset(
        source,
        fit: fit,
        cacheWidth: decodeWidth,
        frameBuilder: frameBuilder,
        errorBuilder: onError,
      );
    } else {
      image = Image.file(
        File(source),
        fit: fit,
        cacheWidth: decodeWidth,
        frameBuilder: frameBuilder,
        errorBuilder: onError,
      );
    }

    if (!fadeIn) return image;
    return Stack(fit: StackFit.expand, children: [fallback, image]);
  }
}

class ImageFallback extends StatelessWidget {
  const ImageFallback({
    super.key,
    this.icon = Icons.image,
    this.iconSize = 30,
    this.color = AppColors.cream,
    this.iconColor = AppColors.muted,
  });

  final IconData icon;
  final double iconSize;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
