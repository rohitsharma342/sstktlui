import 'package:get/get.dart';
import '../models/user.dart';
import '../services/data_service.dart';

class UserController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isLoggedIn = false.obs;
  
  User? get user => _user.value;
  bool get isLoggedIn => _isLoggedIn.value;
  
  void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      _user.value = DataService.getSampleUser();
      _isLoggedIn.value = true;
      Get.snackbar(
        'Welcome Back!',
        'You have successfully logged in',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter valid credentials',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
  
  void logout() {
    _user.value = null;
    _isLoggedIn.value = false;
    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
  
  void updateProfile({
    String? name,
    String? email,
    String? shippingAddress,
    String? paymentInfo,
  }) {
    if (_user.value != null) {
      _user.value = User(
        id: _user.value!.id,
        name: name ?? _user.value!.name,
        email: email ?? _user.value!.email,
        shippingAddress: shippingAddress ?? _user.value!.shippingAddress,
        paymentInfo: paymentInfo ?? _user.value!.paymentInfo,
        orderHistory: _user.value!.orderHistory,
      );
      Get.snackbar(
        'Profile Updated',
        'Your profile has been successfully updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
  
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}