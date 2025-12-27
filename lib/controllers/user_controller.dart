import 'package:get/get.dart';
import '../models/user.dart';
import '../services/data_service.dart';
import '../controllers/auth_controller.dart';

class UserController extends GetxController {
  final DataService _dataService = Get.find();
  final AuthController _authController = Get.find();
  
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  User? get user => _user.value;
  bool get isLoggedIn => _authController.isLoggedIn.value;
  
  @override
  void onInit() {
    super.onInit();
    
    // Listen to auth state changes
    ever(_authController.isLoggedIn, (isLoggedIn) {
      if (isLoggedIn) {
        _loadUserProfile();
      } else {
        _user.value = null;
      }
    });
    
    // Load profile if already logged in
    if (_authController.isLoggedIn.value) {
      _loadUserProfile();
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;
      
      final userProfile = await _dataService.getUserProfile(userId);
      _user.value = userProfile;
    } catch (e) {
      error.value = 'Failed to load profile: $e';
      print('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updateProfile({
    String? name,
    String? email,
    String? shippingAddress,
    String? paymentInfo,
  }) async {
    if (!_authController.isLoggedIn.value) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;
      
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (shippingAddress != null) updateData['shipping_address'] = shippingAddress;
      if (paymentInfo != null) updateData['payment_info'] = paymentInfo;
      
      await _dataService.updateUserProfile(userId, updateData);
      
      // Update local user object
      if (_user.value != null) {
        _user.value = User(
          id: _user.value!.id,
          name: name ?? _user.value!.name,
          email: email ?? _user.value!.email,
          shippingAddress: shippingAddress ?? _user.value!.shippingAddress,
          paymentInfo: paymentInfo ?? _user.value!.paymentInfo,
          orderHistory: _user.value!.orderHistory,
        );
      }
      
      Get.snackbar(
        'Profile Updated',
        'Your profile has been successfully updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      error.value = 'Failed to update profile: $e';
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }
  
  bool isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }
}