import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Icon(
                Icons.palette,
                size: 100,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Create Account',
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Join our community of art lovers',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!authController.isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    authController.signUp(
                                      emailController.text.trim(),
                                      passwordController.text,
                                      nameController.text.trim(),
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
                          child: authController.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Sign Up',
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.body2,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.login),
                  child: Text(
                    'Login',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              if (authController.error.value.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authController.error.value,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}