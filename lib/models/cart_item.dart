import 'painting.dart';

class CartItem {
  final Painting painting;
  int quantity;
  
  CartItem({
    required this.painting,
    this.quantity = 1,
  });
  
  double get totalPrice => painting.price * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'painting': painting.toJson(),
      'quantity': quantity,
    };
  }
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      painting: Painting.fromJson(json['painting']),
      quantity: json['quantity'],
    );
  }
}