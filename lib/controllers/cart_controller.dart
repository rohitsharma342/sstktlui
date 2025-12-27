import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/painting.dart';
import '../services/data_service.dart';
import '../services/supabase_service.dart';
import '../controllers/auth_controller.dart';

class CartController extends GetxController {
  final DataService _dataService = Get.find();
  final SupabaseService _supabaseService = Get.find();
  final AuthController _authController = Get.find();
  
  final RxList<CartItem> _items = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  
  @override
  void onInit() {
    super.onInit();
    _loadCartItems();
    
    // Listen to auth state changes
    ever(_authController.isLoggedIn, (isLoggedIn) {
      if (isLoggedIn) {
        _loadCartItems();
      } else {
        _items.clear();
      }
    });
  }
  
  Future<void> _loadCartItems() async {
    if (!_authController.isLoggedIn.value) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;
      
      final cartData = await _supabaseService.fetchUserCartItems(userId);
      
      _items.value = cartData.map((item) {
        final paintingData = item['paintings'];
        final painting = Painting.fromJson(paintingData);
        
        return CartItem(
          id: item['id'],
          painting: painting,
          quantity: item['quantity'],
        );
      }).toList();
    } catch (e) {
      error.value = 'Failed to load cart: $e';
      print('Error loading cart items: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> addToCart(Painting painting, int quantity) async {
    if (!_authController.isLoggedIn.value) {
      Get.snackbar(
        'Login Required',
        'Please login to add items to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;
      
      await _dataService.addToCart(userId, painting.id, quantity);
      await _loadCartItems(); // Refresh cart
      
      Get.snackbar(
        'Added to Cart',
        '${painting.title} has been added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      error.value = 'Failed to add to cart: $e';
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      await _dataService.updateCartItemQuantity(cartItemId, newQuantity);
      await _loadCartItems(); // Refresh cart
    } catch (e) {
      error.value = 'Failed to update quantity: $e';
      Get.snackbar(
        'Error',
        'Failed to update item quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _dataService.removeFromCart(cartItemId);
      await _loadCartItems(); // Refresh cart
      
      Get.snackbar(
        'Removed from Cart',
        'Item has been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      error.value = 'Failed to remove from cart: $e';
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> clearCart() async {
    if (!_authController.isLoggedIn.value) return;
    
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return;
      
      await _dataService.clearUserCart(userId);
      _items.clear();
    } catch (e) {
      error.value = 'Failed to clear cart: $e';
      print('Error clearing cart: $e');
    }
  }
  
  bool isInCart(String paintingId) {
    return _items.any((item) => item.painting.id == paintingId);
  }
  
  int getQuantityInCart(String paintingId) {
    final item = _items.firstWhereOrNull((item) => item.painting.id == paintingId);
    return item?.quantity ?? 0;
  }
  
  Future<String?> checkout() async {
    if (!_authController.isLoggedIn.value || _items.isEmpty) return null;
    
    try {
      isLoading.value = true;
      
      final userId = _authController.currentUser.value?.id;
      if (userId == null) return null;
      
      // Prepare order items
      final orderItems = _items.map((item) => {
        'painting_id': item.painting.id,
        'quantity': item.quantity,
        'price': item.painting.price,
      }).toList();
      
      // Create order
      final orderId = await _dataService.createOrder(
        userId,
        orderItems,
        totalAmount,
      );
      
      // Clear cart after successful order
      await clearCart();
      
      return orderId;
    } catch (e) {
      error.value = 'Failed to process order: $e';
      Get.snackbar(
        'Error',
        'Failed to process your order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}