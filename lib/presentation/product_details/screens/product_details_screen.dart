import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/product_model.dart';

import '../../common/widgets/app_button.dart';
import '../../common/widgets/rating_badge.dart';

// Cart provider
import '../../cart/providers/cart_providers.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends ConsumerState<ProductDetailsScreen> {
  bool _descriptionExpanded = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Details',
                    style: AppTextStyles.headingMedium,
                  ),
                  _circleIconButton(
                    icon: Icons.favorite_border,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        28,
                        20,
                        20,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.title,
                                  style:
                                      AppTextStyles.headingMedium,
                                ),
                              ),
                              _quantityStepper(),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              RatingBadge(
                                icon: Icons.star,
                                label:
                                    product.rating.rate.toString(),
                              ),
                              RatingBadge(
                                icon: Icons.reviews_outlined,
                                label:
                                    '${product.rating.count} reviews',
                              ),
                              RatingBadge(
                                icon:
                                    Icons.category_outlined,
                                label:
                                    product.category.toTitleCase(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'About this item',
                            style: AppTextStyles.productTitle
                                .copyWith(fontSize: 16),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            product.description,
                            style: AppTextStyles.bodyText,
                            maxLines:
                                _descriptionExpanded ? null : 3,
                            overflow: _descriptionExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),

                          GestureDetector(
                            onTap: () => setState(
                              () => _descriptionExpanded =
                                  !_descriptionExpanded,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 4),
                              child: Text(
                                _descriptionExpanded
                                    ? 'Show less'
                                    : 'More details...',
                                style: AppTextStyles.bodySmall
                                    .copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom bar
      bottomNavigationBar: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Text(
                '\$${(product.price * _quantity).toStringAsFixed(2)}',
                style: AppTextStyles.priceText,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: AppButton(
                  label: 'Add to cart',

                  // UPDATED
                  onPressed: () async {
                    await ref
                        .read(cartProvider.notifier)
                        .addToCart(
                          product,
                          quantity: _quantity,
                        );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.title} added to cart',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _quantityStepper() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepButton(
          icon: Icons.remove,
          onTap: () {
            if (_quantity > 1) {
              setState(() => _quantity--);
            }
          },
        ),

        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$_quantity',
            style: AppTextStyles.productTitle.copyWith(
              fontSize: 16,
            ),
          ),
        ),

        _stepButton(
          icon: Icons.add,
          isAccent: true,
          onTap: () {
            setState(() => _quantity++);
          },
        ),
      ],
    );
  }

  Widget _stepButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isAccent = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isAccent
              ? AppColors.accent
              : AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isAccent
              ? Colors.white
              : AppColors.textPrimary,
        ),
      ),
    );
  }
}