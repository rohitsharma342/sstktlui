import 'package:get/get.dart';
import '../models/painting.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

class DataService extends GetxController {
  final SupabaseService _supabaseService = Get.find();
  
  final RxList<Painting> paintings = <Painting>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchPaintings();
    fetchCategories();
  }
  
  Future<void> fetchPaintings() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _supabaseService.fetchData(
        'paintings',
        orderBy: 'created_at',
        ascending: false,
      );
      
      paintings.value = response
          .map((item) => Painting.fromJson(item))
          .toList();
    } catch (e) {
      error.value = 'Failed to fetch paintings: $e';
      print('Error fetching paintings: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchCategories() async {
    try {
      final response = await _supabaseService.fetchData('categories');
      
      List<String> categoryList = ['All'];
      categoryList.addAll(
        response.map((item) => item['name'] as String).toList(),
      );
      
      categories.value = categoryList;
    } catch (e) {
      // Fallback categories if database fetch fails
      categories.value = ['All', 'Landscape', 'Abstract', 'Portrait', 'Seascape', 'Still Life'];
      print('Error fetching categories: $e');
    }
  }
  
  Future<void> addPainting(Painting painting) async {
    try {
      await _supabaseService.insertData('paintings', painting.toJson());
      await fetchPaintings(); // Refresh list
    } catch (e) {
      error.value = 'Failed to add painting: $e';
      print('Error adding painting: $e');
    }
  }
  
  Future<void> updatePainting(String id, Painting painting) async {
    try {
      await _supabaseService.updateData('paintings', id, painting.toJson());
      await fetchPaintings(); // Refresh list
    } catch (e) {
      error.value = 'Failed to update painting: $e';
      print('Error updating painting: $e');
    }
  }
  
  Future<void> deletePainting(String id) async {
    try {
      await _supabaseService.deleteData('paintings', id);
      await fetchPaintings(); // Refresh list
    } catch (e) {
      error.value = 'Failed to delete painting: $e';
      print('Error deleting painting: $e');
    }
  }
  
  Future<Painting?> getPaintingById(String id) async {
    try {
      final response = await _supabaseService.fetchById('paintings', id);
      if (response != null) {
        return Painting.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error fetching painting by id: $e');
      return null;
    }
  }
  
  Future<User?> getUserProfile(String userId) async {
    try {
      final response = await _supabaseService.fetchUserProfile(userId);
      if (response != null) {
        // Fetch user orders
        final orders = await _supabaseService.fetchUserOrders(userId);
        final orderHistory = orders.map((order) => Order.fromJson(order)).toList();
        
        return User(
          id: response['id'],
          name: response['name'],
          email: response['email'],
          shippingAddress: response['shipping_address'],
          paymentInfo: response['payment_info'],
          orderHistory: orderHistory,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
  
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabaseService.updateData('user_profiles', userId, data);
    } catch (e) {
      error.value = 'Failed to update profile: $e';
      print('Error updating user profile: $e');
    }
  }
  
  Future<void> addToCart(String userId, String paintingId, int quantity) async {
    try {
      // Check if item already exists in cart
      final existingItems = await _supabaseService.fetchData('cart_items');
      final existingItem = existingItems.firstWhereOrNull(
        (item) => item['user_id'] == userId && item['painting_id'] == paintingId,
      );
      
      if (existingItem != null) {
        // Update quantity
        await _supabaseService.updateData('cart_items', existingItem['id'], {
          'quantity': existingItem['quantity'] + quantity,
        });
      } else {
        // Add new item
        await _supabaseService.insertData('cart_items', {
          'user_id': userId,
          'painting_id': paintingId,
          'quantity': quantity,
        });
      }
    } catch (e) {
      error.value = 'Failed to add to cart: $e';
      print('Error adding to cart: $e');
    }
  }
  
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      if (quantity <= 0) {
        await _supabaseService.deleteData('cart_items', cartItemId);
      } else {
        await _supabaseService.updateData('cart_items', cartItemId, {
          'quantity': quantity,
        });
      }
    } catch (e) {
      error.value = 'Failed to update cart: $e';
      print('Error updating cart item: $e');
    }
  }
  
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _supabaseService.deleteData('cart_items', cartItemId);
    } catch (e) {
      error.value = 'Failed to remove from cart: $e';
      print('Error removing from cart: $e');
    }
  }
  
  Future<void> clearUserCart(String userId) async {
    try {
      final cartItems = await _supabaseService.fetchData('cart_items');
      final userCartItems = cartItems.where((item) => item['user_id'] == userId);
      
      for (final item in userCartItems) {
        await _supabaseService.deleteData('cart_items', item['id']);
      }
    } catch (e) {
      error.value = 'Failed to clear cart: $e';
      print('Error clearing cart: $e');
    }
  }
  
  Future<String> createOrder(String userId, List<Map<String, dynamic>> items, double totalAmount) async {
    try {
      // Create order
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      await _supabaseService.insertData('orders', {
        'id': orderId,
        'user_id': userId,
        'total_amount': totalAmount,
        'status': 'Processing',
      });
      
      // Create order items
      for (final item in items) {
        await _supabaseService.insertData('order_items', {
          'order_id': orderId,
          'painting_id': item['painting_id'],
          'quantity': item['quantity'],
          'price': item['price'],
        });
      }
      
      return orderId;
    } catch (e) {
      error.value = 'Failed to create order: $e';
      print('Error creating order: $e');
      rethrow;
    }
  }
}