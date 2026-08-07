import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/providers.dart';
import '../../../data/models/product_model.dart';

/// Fetches a single product by id — used for deep-link / refresh scenarios.
/// family lets us parameterize the provider by productId.
final productDetailsProvider =
    FutureProvider.family<ProductModel, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProductById(productId);

  if (result.isSuccess) {
    return result.data!;
  } else {
    throw result.failure!;
  }
});