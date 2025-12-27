import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (!authController.isLoggedIn.value) {
          return _buildNotLoggedIn();
        }
        
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return _buildProfileContent();
      }),
    );
  }
  
  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 100,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 20),
          Text(
            'Please Login',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You need to login to access your profile',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(
              'Login',
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

  Widget _buildProfileContent() {
    final user = userController.user;
    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load profile'),
            ElevatedButton(
              onPressed: () => userController.refreshProfile(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    nameController.text = user.name;
    emailController.text = user.email;
    addressController.text = user.shippingAddress ?? '';
    paymentController.text = user.paymentInfo ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(user),
          SizedBox(height: 30),
          _buildEditableForm(),
          SizedBox(height: 30),
          _buildOrderHistory(user),
          SizedBox(height: 30),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildUserHeader(User user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.heading2,
                ),
                SizedBox(height: 4),
                Text(
                  user.email,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTextStyles.heading2,
        ),
        SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!userController.isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: addressController,
                label: 'Shipping Address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: paymentController,
                label: 'Payment Info',
                icon: Icons.credit_card_outlined,
              ),
              SizedBox(height: 20),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: userController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                userController.updateProfile(
                                  name: nameController.text,
                                  email: emailController.text,
                                  shippingAddress: addressController.text,
                                  paymentInfo: paymentController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                      ),
                      child: userController.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildOrderHistory(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order History',
          style: AppTextStyles.heading2,
        ),
        SizedBox(height: 16),
        if (user.orderHistory.isEmpty)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Center(
              child: Text(
                'No orders yet',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          ...user.orderHistory.map((order) => _buildOrderCard(order)),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id}',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == 'Delivered'
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: AppTextStyles.caption.copyWith(
                    color: order.status == 'Delivered'
                        ? AppColors.success
                        : AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Date: ${order.date.day}/${order.date.month}/${order.date.year}',
            style: AppTextStyles.body2,
          ),
          Text(
            'Total: \$${order.totalAmount.toStringAsFixed(2)}',
            style: AppTextStyles.body2,
          ),
          SizedBox(height: 8),
          Text(
            'Items: ${order.items.join(", ")}',
            style: AppTextStyles.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    authController.signOut();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
        child: Text(
          'Logout',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}