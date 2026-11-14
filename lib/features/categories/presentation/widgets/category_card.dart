import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/cache/app_image_cache.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/utils/color_utils.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';

// A wide image card with the category name on a dark gradient.
// [alignRight] puts the name (and the gradient) on the right side.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.alignRight,
    this.onTap,
  });

  final Category category;
  final bool alignRight;
  final VoidCallback? onTap;

  static const _height = 175.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = category.imageUrl;
    final fallback = ColoredBox(
      color: colorFromHex(category.color) ?? AppColors.panel,
    );
    
    final shape = BeveledRectangleBorder(
      side: BorderSide(
        color: AppColors.outline.withValues(alpha: 0.45),
        width: 1.5,
      ),
      borderRadius: BorderRadiusGeometry.circular(16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        height: _height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppColors.navyDeep,
          shape: shape
        ),
        foregroundDecoration: ShapeDecoration(shape: shape),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null && url.isNotEmpty)
              CachedNetworkImage(
                imageUrl: url,
                cacheManager: AppImageCache.instance,
                fit: BoxFit.cover,
                memCacheWidth: 900,
                fadeInDuration: const Duration(milliseconds: 150),
                placeholder: (context, url) => fallback,
                errorWidget: (context, url, error) => fallback,
              )
            else
              fallback,
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: alignRight
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  end: alignRight
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Align(
              alignment:
                  alignRight ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: alignRight ? TextAlign.right : TextAlign.left,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            // On top of everything, so the whole card reacts to taps.
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}