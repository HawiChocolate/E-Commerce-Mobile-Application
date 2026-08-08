import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../common/widgets/empty_state_widget.dart';
import '../providers/cart_providers.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart', style: AppTextStyles.headingMedium),
      ),
      body: cartItems.isEmpty
          ? const EmptyStateWidget(
              message: 'Your cart is empty.',
              icon: Icons.shopping_cart_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemTile(
                  item: item,
                  onQuantityChanged: (newQty) =>
                      cartNotifier.updateQuantity(item.productId, newQty),
                  onRemove: () => cartNotifier.removeFromCart(item.productId),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : CartSummary(
              totalPrice: cartNotifier.totalPrice,
              onCheckout: () {
                // Checkout flow is out of scope per assignment requirements —
                // show confirmation only.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout not implemented in this scope.')),
                );
              },
            ),
    );
  }
}