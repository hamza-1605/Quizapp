import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/cache/app_image_cache.dart';

class QuestionImage extends StatelessWidget {
  const QuestionImage({super.key, required this.url});

  final String url;

  static const _height = 180.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: _height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        cacheManager: AppImageCache.instance,
        fit: BoxFit.contain,
        memCacheWidth: 900,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Image unavailable',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}