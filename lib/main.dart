import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'utils/routes.dart';
import 'utils/constants.dart';
import 'controllers/painting_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/user_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(PaintingController());
    Get.put(CartController());
    Get.put(UserController());
    
    return GetMaterialApp(
      title: 'SSTKTLUI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
        ),
      ),
      home: SplashScreen(),
      getPages: AppRoutes.routes,
    );
  }
}