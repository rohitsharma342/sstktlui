import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    _navigateToNextScreen();
    
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette,
              size: 120,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'SSTKTLUI',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Art Gallery & Collection',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      if (authController.isLoggedIn.value) {
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}