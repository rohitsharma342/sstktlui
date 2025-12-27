import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../controllers/cart_controller.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showCartIcon;
  final bool showProfileIcon;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.showCartIcon = true,
    this.showProfileIcon = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.heading2.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            )
          : null,
      actions: [
        if (actions != null) ...actions!,
        if (showCartIcon)
          Obx(() => badges.Badge(
                badgeContent: Text(
                  cartController.itemCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                showBadge: cartController.itemCount > 0,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
              )),
        if (showProfileIcon)
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}