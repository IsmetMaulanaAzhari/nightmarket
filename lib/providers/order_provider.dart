import 'package:flutter/foundation.dart';
import 'package:nightmarket/data/models/order.dart';
import 'package:nightmarket/data/models/cart_item.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing orders
class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  
  OrderProvider() {
    _initMockOrders();
  }

  void _initMockOrders() {
    // Add some mock orders for testing
    _orders.addAll([
      Order(
        id: 'ord-001',
        userId: 'user-001',
        items: [
          OrderItem(
            bookId: '1',
            title: 'Laskar Pelangi',
            author: 'Andrea Hirata',
            price: 75000,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=100',
          ),
        ],
        subtotal: 75000,
        shippingCost: 15000,
        total: 90000,
        shippingAddress: 'Jl. Sudirman No. 123',
        city: 'Jakarta Pusat',
        postalCode: '10110',
        phone: '081234567890',
        shippingMethod: 'JNE Regular',
        paymentMethod: 'Transfer Bank',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        status: OrderStatus.delivered,
        trackingNumber: 'JNE123456789',
        shippedDate: DateTime.now().subtract(const Duration(days: 3)),
        deliveredDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        id: 'ord-002',
        userId: 'user-001',
        items: [
          OrderItem(
            bookId: '2',
            title: 'Filosofi Teras',
            author: 'Henry Manampiring',
            price: 85000,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=100',
          ),
        ],
        subtotal: 170000,
        shippingCost: 15000,
        total: 185000,
        shippingAddress: 'Jl. Sudirman No. 123',
        city: 'Jakarta Pusat',
        postalCode: '10110',
        phone: '081234567890',
        shippingMethod: 'SiCepat Express',
        paymentMethod: 'GoPay',
        orderDate: DateTime.now().subtract(const Duration(hours: 12)),
        status: OrderStatus.shipped,
        trackingNumber: 'SCP987654321',
        shippedDate: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Order(
        id: 'ord-003',
        userId: 'user-001',
        items: [
          OrderItem(
            bookId: '3',
            title: 'Atomic Habits',
            author: 'James Clear',
            price: 95000,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=100',
          ),
        ],
        subtotal: 95000,
        shippingCost: 10000,
        total: 105000,
        shippingAddress: 'Jl. Sudirman No. 123',
        city: 'Jakarta Pusat',
        postalCode: '10110',
        phone: '081234567890',
        shippingMethod: 'JNE YES',
        paymentMethod: 'QRIS',
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
      ),
    ]);
  }
  
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
      id: 'ord-${const Uuid().v4().substring(0, 8)}',
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
      status: OrderStatus.pending,
    );

    _orders.insert(0, order);
    notifyListeners();
    
    return order;
  }

  List<Order> getUserOrders(String userId) {
    return _orders
        .where((order) => order.userId == userId)
        .toList()
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = order.copyWith(
        status: newStatus,
        shippedDate: newStatus == OrderStatus.shipped ? DateTime.now() : order.shippedDate,
        deliveredDate: newStatus == OrderStatus.delivered ? DateTime.now() : order.deliveredDate,
      );
      notifyListeners();
    }
  }

  void setTrackingNumber(String orderId, String trackingNumber) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        trackingNumber: trackingNumber,
        status: OrderStatus.shipped,
        shippedDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void confirmReceived(String orderId) {
    updateOrderStatus(orderId, OrderStatus.delivered);
  }

  void addReview(String orderId, Review review) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        review: review,
        status: OrderStatus.completed,
      );
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      if (order.status.canCancel) {
        _orders[orderIndex] = order.copyWith(status: OrderStatus.cancelled);
        notifyListeners();
      }
    }
  }

  // Simulate payment (for demo)
  void simulatePayment(String orderId) {
    updateOrderStatus(orderId, OrderStatus.paid);
    // After payment, simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      updateOrderStatus(orderId, OrderStatus.processing);
    });
  }

  // Statistics
  int getPendingOrdersCount(String userId) {
    return getUserOrders(userId)
        .where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.paid)
        .length;
  }

  int getToReceiveCount(String userId) {
    return getUserOrders(userId)
        .where((o) => o.status == OrderStatus.shipped)
        .length;
  }

  int getToReviewCount(String userId) {
    return getUserOrders(userId)
        .where((o) => o.status == OrderStatus.delivered)
        .length;
  }
}
