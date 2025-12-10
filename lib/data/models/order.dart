import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final List<OrderItem> items;

  @HiveField(3)
  final double subtotal;

  @HiveField(4)
  final double shippingCost;

  @HiveField(5)
  final double total;

  @HiveField(6)
  final String shippingAddress;

  @HiveField(7)
  final String city;

  @HiveField(8)
  final String postalCode;

  @HiveField(9)
  final String phone;

  @HiveField(10)
  final String shippingMethod;

  @HiveField(11)
  final String paymentMethod;

  @HiveField(12)
  final DateTime orderDate;

  @HiveField(13)
  final String status; // Pending, Processing, Shipped, Delivered, Cancelled

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.shippingAddress,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.shippingMethod,
    required this.paymentMethod,
    required this.orderDate,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'total': total,
      'shippingAddress': shippingAddress,
      'city': city,
      'postalCode': postalCode,
      'phone': phone,
      'shippingMethod': shippingMethod,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
      subtotal: json['subtotal'].toDouble(),
      shippingCost: json['shippingCost'].toDouble(),
      total: json['total'].toDouble(),
      shippingAddress: json['shippingAddress'],
      city: json['city'],
      postalCode: json['postalCode'],
      phone: json['phone'],
      shippingMethod: json['shippingMethod'],
      paymentMethod: json['paymentMethod'],
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'] ?? 'Pending',
    );
  }
}

@HiveType(typeId: 4)
class OrderItem extends HiveObject {
  @HiveField(0)
  final String bookId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final String imageUrl;

  OrderItem({
    required this.bookId,
    required this.title,
    required this.author,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }
}
