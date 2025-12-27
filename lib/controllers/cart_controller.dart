import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/painting.dart';

class CartController extends GetxController {
  final RxList<CartItem> _items = <CartItem>[].obs;
  
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  
  void addToCart(Painting painting, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.painting.id == painting.id);
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(painting: painting, quantity: quantity));
    }
    
    Get.snackbar(
      'Added to Cart',
      '${painting.title} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
  
  void updateQuantity(String paintingId, int newQuantity) {
    final index = _items.indexWhere((item) => item.painting.id == paintingId);
    if (index != -1) {
      if (newQuantity <= 0) {
        removeFromCart(paintingId);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }
  
  void removeFromCart(String paintingId) {
    _items.removeWhere((item) => item.painting.id == paintingId);
    Get.snackbar(
      'Removed from Cart',
      'Item has been removed from your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
  
  void clearCart() {
    _items.clear();
  }
  
  bool isInCart(String paintingId) {
    return _items.any((item) => item.painting.id == paintingId);
  }
  
  int getQuantityInCart(String paintingId) {
    final item = _items.firstWhereOrNull((item) => item.painting.id == paintingId);
    return item?.quantity ?? 0;
  }
}