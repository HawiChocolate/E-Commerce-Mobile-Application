import '../../models/cart_item_model.dart';
import 'storage_service.dart';

abstract class CartLocalDataSource {
  List<CartItemModel> getCartItems();
  Future<void> addOrUpdateItem(CartItemModel item);
  Future<void> removeItem(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  @override
  List<CartItemModel> getCartItems() {
    return StorageService.cartBox.values.toList();
  }

  @override
  Future<void> addOrUpdateItem(CartItemModel item) async {
    final box = StorageService.cartBox;
    final existingKey = box.keys.firstWhere(
      (key) => box.get(key)?.productId == item.productId,
      orElse: () => null,
    );

    if (existingKey != null) {
      final existing = box.get(existingKey)!;
      existing.quantity += item.quantity;
      await existing.save();
    } else {
      await box.add(item);
    }
  }

  @override
  Future<void> removeItem(int productId) async {
    final box = StorageService.cartBox;
    final key = box.keys.firstWhere(
      (key) => box.get(key)?.productId == productId,
      orElse: () => null,
    );
    if (key != null) await box.delete(key);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final box = StorageService.cartBox;
    final key = box.keys.firstWhere(
      (key) => box.get(key)?.productId == productId,
      orElse: () => null,
    );
    if (key != null) {
      final item = box.get(key)!;
      if (quantity <= 0) {
        await box.delete(key);
      } else {
        item.quantity = quantity;
        await item.save();
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await StorageService.cartBox.clear();
  }
}