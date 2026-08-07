import '../datasources/local/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

abstract class CartRepository {
  List<CartItemModel> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  List<CartItemModel> getCartItems() => localDataSource.getCartItems();

  @override
  Future<void> addToCart(CartItemModel item) =>
      localDataSource.addOrUpdateItem(item);

  @override
  Future<void> removeFromCart(int productId) =>
      localDataSource.removeItem(productId);

  @override
  Future<void> updateQuantity(int productId, int quantity) =>
      localDataSource.updateQuantity(productId, quantity);

  @override
  Future<void> clearCart() => localDataSource.clearCart();
}