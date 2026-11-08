import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/cache/app_image_cache.dart';
import 'package:quiz_app/core/utils/color_utils.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';

// Shows the category image, or its colour and first letter if there is no
// image, it is still loading, or it could not be loaded.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category});

  final Category category;

  static const _size = 40.0;

  @override
  Widget build(BuildContext context) {
    final fallback = _buildFallback(context);
    final url = category.imageUrl;
    if (url == null || url.isEmpty) return fallback;

    return SizedBox(
      width: _size,
      height: _size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          cacheManager: AppImageCache.instance,
          fit: BoxFit.cover,
          memCacheWidth: 120,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (context, url) => fallback,
          errorWidget: (context, url, error) => fallback,
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final background = colorFromHex(category.color) ??
        Theme.of(context).colorScheme.primaryContainer;
    final isDark =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
    final initial =
        category.name.isEmpty ? '?' : category.name[0].toUpperCase();

    return CircleAvatar(
      radius: _size / 2,
      backgroundColor: background,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      child: Text(initial),
    );
  }
}