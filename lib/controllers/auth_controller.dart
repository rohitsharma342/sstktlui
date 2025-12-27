import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../utils/routes.dart';

class AuthController extends GetxController {
  final SupabaseService _supabaseService = Get.find();
  
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
    _listenToAuthChanges();
  }
  
  void _initializeAuth() {
    currentUser.value = _supabaseService.getCurrentUser();
    isLoggedIn.value = currentUser.value != null;
  }
  
  void _listenToAuthChanges() {
    _supabaseService.authStateChanges().listen((data) {
      currentUser.value = data.session?.user;
      isLoggedIn.value = currentUser.value != null;
    });
  }
  
  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _supabaseService.signUp(email, password, name);
      
      if (response?.user != null) {
        Get.snackbar(
          'Success',
          'Account created successfully! Please check your email for verification.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      error.value = _getErrorMessage(e.toString());
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _supabaseService.signIn(email, password);
      
      if (response?.user != null) {
        Get.snackbar(
          'Welcome Back!',
          'You have successfully logged in',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      error.value = _getErrorMessage(e.toString());
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _supabaseService.signOut();
      
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      error.value = _getErrorMessage(e.toString());
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists';
    } else if (error.contains('Password should be at least 6 characters')) {
      return 'Password must be at least 6 characters long';
    } else if (error.contains('Unable to validate email address')) {
      return 'Please enter a valid email address';
    } else if (error.contains('Network')) {
      return 'Network error. Please check your connection';
    } else {
      return 'An unexpected error occurred. Please try again';
    }
  }
  
  bool isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }
}