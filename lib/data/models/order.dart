import 'package:flutter/material.dart';

/// Order status enum
enum OrderStatus {
  pending,      // Menunggu pembayaran
  paid,         // Sudah dibayar
  processing,   // Sedang diproses penjual
  shipped,      // Dalam pengiriman
  delivered,    // Sudah diterima
  completed,    // Selesai (sudah di-review)
  cancelled,    // Dibatalkan
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Menunggu Pembayaran';
      case OrderStatus.paid:
        return 'Sudah Dibayar';
      case OrderStatus.processing:
        return 'Sedang Diproses';
      case OrderStatus.shipped:
        return 'Dalam Pengiriman';
      case OrderStatus.delivered:
        return 'Sudah Diterima';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.paid:
        return Icons.payment;
      case OrderStatus.processing:
        return Icons.inventory_2;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.completed:
        return Icons.verified;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  bool get canReview => this == OrderStatus.delivered;
  bool get canCancel => this == OrderStatus.pending || this == OrderStatus.paid;
  bool get canConfirmReceived => this == OrderStatus.shipped;
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String shippingAddress;
  final String city;
  final String postalCode;
  final String phone;
  final String shippingMethod;
  final String paymentMethod;
  final DateTime orderDate;
  final OrderStatus status;
  final String? trackingNumber;
  final DateTime? shippedDate;
  final DateTime? deliveredDate;
  final Review? review;

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
    this.status = OrderStatus.pending,
    this.trackingNumber,
    this.shippedDate,
    this.deliveredDate,
    this.review,
  });

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? total,
    String? shippingAddress,
    String? city,
    String? postalCode,
    String? phone,
    String? shippingMethod,
    String? paymentMethod,
    DateTime? orderDate,
    OrderStatus? status,
    String? trackingNumber,
    DateTime? shippedDate,
    DateTime? deliveredDate,
    Review? review,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippedDate: shippedDate ?? this.shippedDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      review: review ?? this.review,
    );
  }

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
      'status': status.name,
      'trackingNumber': trackingNumber,
      'shippedDate': shippedDate?.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'review': review?.toJson(),
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
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      trackingNumber: json['trackingNumber'],
      shippedDate: json['shippedDate'] != null ? DateTime.parse(json['shippedDate']) : null,
      deliveredDate: json['deliveredDate'] != null ? DateTime.parse(json['deliveredDate']) : null,
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}

class OrderItem {
  final String bookId;
  final String title;
  final String author;
  final double price;
  final int quantity;
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

class Review {
  final int rating; // 1-5
  final String comment;
  final DateTime reviewDate;
  final List<String>? photoUrls;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewDate,
    this.photoUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate.toIso8601String(),
      'photoUrls': photoUrls,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      reviewDate: DateTime.parse(json['reviewDate']),
      photoUrls: json['photoUrls'] != null 
          ? List<String>.from(json['photoUrls']) 
          : null,
    );
  }
}
