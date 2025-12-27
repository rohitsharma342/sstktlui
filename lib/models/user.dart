class User {
  final String id;
  final String name;
  final String email;
  final String? shippingAddress;
  final String? paymentInfo;
  final List<Order> orderHistory;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.shippingAddress,
    this.paymentInfo,
    this.orderHistory = const [],
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'shippingAddress': shippingAddress,
      'paymentInfo': paymentInfo,
      'orderHistory': orderHistory.map((order) => order.toJson()).toList(),
    };
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      shippingAddress: json['shippingAddress'],
      paymentInfo: json['paymentInfo'],
      orderHistory: (json['orderHistory'] as List<dynamic>? ?? [])
          .map((order) => Order.fromJson(order))
          .toList(),
    );
  }
}

class Order {
  final String id;
  final DateTime date;
  final double totalAmount;
  final String status;
  final List<String> items;
  
  Order({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'items': items,
    };
  }
  
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      items: List<String>.from(json['items']),
    );
  }
}