import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../common/widgets/app_button.dart';

class CartSummary extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.bodyText),
                Text('\$${totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.priceText),
              ],
            ),
            const SizedBox(height: 14),
            AppButton(label: 'Checkout', onPressed: onCheckout),
          ],
        ),
      ),
    );
  }
}