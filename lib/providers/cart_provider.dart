import 'package:flutter/foundation.dart';
import 'package:nightmarket/data/models/cart_item.dart';
import 'package:nightmarket/data/models/book.dart';

/// Provider for managing shopping cart state (in-memory)
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isInitialized = false;

  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.length;
  
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  double calculateTotal(double shippingCost) {
    return subtotal + shippingCost;
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = true;
      notifyListeners();
    }
  }

  void addToCart(Book book) {
    // Check if item already exists
    final existingIndex = _items.indexWhere((item) => item.bookId == book.id);

    if (existingIndex != -1) {
      // Item exists, increment quantity
      _items[existingIndex].quantity++;
    } else {
      // Add new item
      final cartItem = CartItem(
        bookId: book.id,
        title: book.title,
        author: book.author,
        price: book.price,
        imageUrl: book.imageUrls.isNotEmpty ? book.imageUrls[0] : '',
        condition: book.condition,
        sellerId: book.sellerId,
      );
      _items.add(cartItem);
    }
    
    notifyListeners();
  }

  void removeFromCart(String bookId) {
    _items.removeWhere((item) => item.bookId == bookId);
    notifyListeners();
  }

  void updateQuantity(String bookId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(bookId);
      return;
    }

    final index = _items.indexWhere((item) => item.bookId == bookId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(String bookId) {
    final index = _items.indexWhere((item) => item.bookId == bookId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String bookId) {
    final index = _items.indexWhere((item) => item.bookId == bookId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String bookId) {
    return _items.any((item) => item.bookId == bookId);
  }

  int getQuantity(String bookId) {
    final item = _items.where((item) => item.bookId == bookId).firstOrNull;
    return item?.quantity ?? 0;
  }

  CartItem? getCartItem(String bookId) {
    return _items.where((item) => item.bookId == bookId).firstOrNull;
  }
}
