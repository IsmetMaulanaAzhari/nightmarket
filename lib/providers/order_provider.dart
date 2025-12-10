import 'package:flutter/foundation.dart';
import 'package:nightmarket/data/models/order.dart';
import 'package:nightmarket/data/models/cart_item.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing orders
class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  
  List<Order> get orders => List.unmodifiable(_orders);
  
  int get orderCount => _orders.length;

  Future<Order> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double subtotal,
    required double shippingCost,
    required String shippingAddress,
    required String city,
    required String postalCode,
    required String phone,
    required String shippingMethod,
    required String paymentMethod,
  }) async {
    final order = Order(
      id: const Uuid().v4(),
      userId: userId,
      items: cartItems
          .map((item) => OrderItem(
                bookId: item.bookId,
                title: item.title,
                author: item.author,
                price: item.price,
                quantity: item.quantity,
                imageUrl: item.imageUrl,
              ))
          .toList(),
      subtotal: subtotal,
      shippingCost: shippingCost,
      total: subtotal + shippingCost,
      shippingAddress: shippingAddress,
      city: city,
      postalCode: postalCode,
      phone: phone,
      shippingMethod: shippingMethod,
      paymentMethod: paymentMethod,
      orderDate: DateTime.now(),
      status: 'Pending',
    );

    _orders.insert(0, order);
    notifyListeners();
    
    return order;
  }

  List<Order> getUserOrders(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      // Note: Since Order is immutable, we'd need to recreate it
      // For now, this is a placeholder for status updates
      notifyListeners();
    }
  }
}
