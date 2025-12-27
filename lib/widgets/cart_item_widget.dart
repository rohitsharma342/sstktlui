import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.painting.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: AppColors.surface,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: AppColors.surface,
                child: Icon(
                  Icons.error,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.painting.title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'by ${item.painting.artist}',
                  style: AppTextStyles.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '\$${item.painting.price.toStringAsFixed(2)} each',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (item.quantity > 1) {
                                onQuantityChanged(item.quantity - 1);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              item.quantity.toString(),
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => onQuantityChanged(item.quantity + 1),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}