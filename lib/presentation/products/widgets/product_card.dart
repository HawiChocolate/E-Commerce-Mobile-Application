import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.productTitle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: AppColors.rating),
                const SizedBox(width: 4),
                Text(product.rating.rate.toString(), style: AppTextStyles.metaText),
              ],
            ),
            const SizedBox(height: 6),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: AppTextStyles.priceText.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}