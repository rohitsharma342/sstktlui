import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String profile = '/profile';
  
  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: dashboard,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: productDetails,
      page: () => ProductDetailsScreen(),
    ),
    GetPage(
      name: cart,
      page: () => CartScreen(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
    ),
  ];
}