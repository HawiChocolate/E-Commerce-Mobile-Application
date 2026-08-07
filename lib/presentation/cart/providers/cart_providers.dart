import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/cart_local_datasource.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/cart_repository.dart';

final cartLocalDataSourceProvider =
    Provider<CartLocalDataSource>((ref) => CartLocalDataSourceImpl());

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final localDataSource = ref.watch(cartLocalDataSourceProvider);
  return CartRepositoryImpl(localDataSource);
});

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  final CartRepository repository;

  CartNotifier(this.repository) : super(repository.getCartItems());

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final item = CartItemModel(
      productId: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      quantity: quantity,
    );
    await repository.addToCart(item);
    state = repository.getCartItems();
  }

  Future<void> removeFromCart(int productId) async {
    await repository.removeFromCart(productId);
    state = repository.getCartItems();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await repository.updateQuantity(productId, quantity);
    state = repository.getCartItems();
  }

  Future<void> clearCart() async {
    await repository.clearCart();
    state = [];
  }

  int get totalItemCount =>
      state.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});