import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Login'),
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
                'Welcome Back',
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Sign in to your account to continue',
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
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
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
                                    authController.signIn(
                                      emailController.text.trim(),
                                      passwordController.text,
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
                                  'Login',
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
                  "Don't have an account? ",
                  style: AppTextStyles.body2,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.signup),
                  child: Text(
                    'Sign Up',
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