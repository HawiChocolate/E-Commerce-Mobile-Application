import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/providers.dart';
import '../../../data/models/product_model.dart';

/// Holds the currently selected category filter ('all' = no filter).
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

/// Holds the current search query typed by the user.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Fetches all products from the repository.
/// AsyncValue gives us loading/data/error for free.
final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getAllProducts();

  if (result.isSuccess) {
    return result.data!;
  } else {
    // Throwing here lets FutureProvider's AsyncValue.error state pick it up
    throw result.failure!;
  }
});

/// Fetches the list of available categories.
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getCategories();

  if (result.isSuccess) {
    return result.data!;
  } else {
    throw result.failure!;
  }
});

/// Derived provider: applies category filter + search query on top of
/// allProductsProvider, without needing a separate network call.
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsync = ref.watch(allProductsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return productsAsync.whenData((products) {
    return products.where((product) {
      final matchesCategory =
          selectedCategory == 'all' || product.category == selectedCategory;
      final matchesQuery =
          query.isEmpty || product.title.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  });
});