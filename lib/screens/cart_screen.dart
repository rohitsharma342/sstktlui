import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../utils/constants.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Shopping Cart'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (cartController.isEmpty) {
          return _buildEmptyCart();
        }
        return _buildCartContent();
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.isEmpty) {
          return SizedBox.shrink();
        }
        return _buildBottomBar();
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Browse our collection and add some paintings!',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(AppDimensions.padding),
            itemCount: cartController.items.length,
            itemBuilder: (context, index) {
              final item = cartController.items[index];
              return CartItemWidget(
                item: item,
                onQuantityChanged: (newQuantity) {
                  cartController.updateQuantity(item.painting.id, newQuantity);
                },
                onRemove: () {
                  _showRemoveConfirmation(item.painting.id, item.painting.title);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: AppTextStyles.body1,
              ),
              Obx(() => Text(
                    cartController.itemCount.toString(),
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: AppTextStyles.heading2,
              ),
              Obx(() => Text(
                    '\$${cartController.totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.primary,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _proceedToCheckout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmation(String paintingId, String title) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove Item'),
        content: Text('Are you sure you want to remove "$title" from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartController.removeFromCart(paintingId);
              Get.back();
            },
            child: Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    Get.dialog(
      AlertDialog(
        title: Text('Checkout'),
        content: Text(
          'Total: \$${cartController.totalAmount.toStringAsFixed(2)}\n\n'
          'This is a demo app. In a real app, this would redirect to payment processing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cartController.clearCart();
              Get.snackbar(
                'Order Placed!',
                'Your order has been successfully placed.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.success,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }
}