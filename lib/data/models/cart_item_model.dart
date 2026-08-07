import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}