import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'utils/routes.dart';
import 'utils/constants.dart';
import 'controllers/painting_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/auth_controller.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://cpkpsoybaplhxzuzuviz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNwa3Bzb3liYXBsaHh6dXp1dml6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY4MjE1OTgsImV4cCI6MjA4MjM5NzU5OH0.0rjtI65dNT7yia53tAETt0uQ91widcneiHCiYDxyDko',
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SupabaseService());
    Get.put(AuthController());
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