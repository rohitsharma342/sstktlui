import 'painting.dart';

class CartItem {
  final String? id;
  final Painting painting;
  int quantity;
  
  CartItem({
    this.id,
    required this.painting,
    this.quantity = 1,
  });
  
  double get totalPrice => painting.price * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'painting_id': painting.id,
      'quantity': quantity,
      'painting': painting.toJson(),
    };
  }
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      painting: Painting.fromJson(json['painting'] ?? json),
      quantity: json['quantity'] ?? 1,
    );
  }
}