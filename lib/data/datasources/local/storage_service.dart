import 'package:hive_flutter/hive_flutter.dart';
import '../../models/cart_item_model.dart';

/// Central place for Hive/local storage setup.
/// All other local datasources should go through this rather than
/// opening their own boxes directly.
class StorageService {
  static const String cartBoxName = 'cart_box';
  static const String authBoxName = 'auth_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CartItemModelAdapter());
    await Hive.openBox<CartItemModel>(cartBoxName);
    await Hive.openBox(authBoxName); // plain box for token/session strings
  }

  static Box<CartItemModel> get cartBox =>
      Hive.box<CartItemModel>(cartBoxName);

  static Box get authBox => Hive.box(authBoxName);
}