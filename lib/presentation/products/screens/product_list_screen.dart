import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';

import '../../common/widgets/loading_widget.dart';
import '../../common/widgets/empty_state_widget.dart';
import '../../common/widgets/error_state_widget.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';

import '../../product_details/screens/product_details_screen.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          'Shop',
          style: AppTextStyles.headingMedium,
        ),
      ),

      body: Column(
        children: [
          // =========================
          // SEARCH BAR
          // =========================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: const SearchBarWidget(),
          ),

          const SizedBox(height: 14),

          // =========================
          // CATEGORIES
          // =========================
          SizedBox(
            height: 44,
            child: categoriesAsync.when(
              loading: () => const SizedBox.shrink(),

              error: (_, __) =>
                  const SizedBox.shrink(),

              data: (categories) {
                final allCategories = [
                  'all',
                  ...categories,
                ];

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: allCategories.length,

                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 10),

                  itemBuilder: (context, index) {
                    final category =
                        allCategories[index];

                    final label = category == 'all'
                        ? 'All'
                        : category.toTitleCase();

                    return CategoryChip(
                      label: label,
                      isSelected:
                          selectedCategory == category,

                      onTap: () {
                        ref
                            .read(
                              selectedCategoryProvider
                                  .notifier,
                            )
                            .state = category;
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // PRODUCT LIST
          // =========================
          Expanded(
            child: filteredProducts.when(
              // Loading
              loading: () => const LoadingWidget(),

              // Error
              error: (error, stack) {
                return ErrorStateWidget(
                  message: error.toString(),
                  onRetry: () {
                    ref.invalidate(
                      allProductsProvider,
                    );
                  },
                );
              },

              // Products loaded
              data: (products) {
                // =========================
                // EMPTY STATE
                // =========================
                if (products.isEmpty) {
                  final query =
                      ref.watch(searchQueryProvider);

                  final message = query.isNotEmpty
                      ? 'No results for "$query"'
                      : 'No products in this category';

                  return EmptyStateWidget(
                    message: message,
                    icon: Icons.search_off,
                  );
                }

                // =========================
                // PRODUCT GRID
                // =========================
                return GridView.builder(
                  padding: const EdgeInsets.all(16),

                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        Responsive.productGridColumns(
                      context,
                    ),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),

                  itemCount: products.length,

                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                      product: product,

                      // Open product details
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(
                              product: product,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}