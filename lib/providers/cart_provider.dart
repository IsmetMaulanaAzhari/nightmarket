import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nightmarket/data/models/cart_item.dart';
import 'package:nightmarket/data/models/book.dart';
import 'package:nightmarket/core/constants/app_constants.dart';

/// Provider for managing shopping cart state
class CartProvider extends ChangeNotifier {
  late Box<CartItem> _cartBox;
  bool _isInitialized = false;

  List<CartItem> get items => _isInitialized ? _cartBox.values.toList() : [];
  
  int get itemCount => items.length;
  
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  double calculateTotal(double shippingCost) {
    return subtotal + shippingCost;
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      _cartBox = await Hive.openBox<CartItem>(AppConstants.cartBoxName);
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> addToCart(Book book) async {
    if (!_isInitialized) await initialize();
    
    // Check if item already exists
    final existingItem = items.firstWhere(
      (item) => item.bookId == book.id,
      orElse: () => CartItem(
        bookId: '',
        title: '',
        author: '',
        price: 0,
        imageUrl: '',
        condition: '',
        sellerId: '',
      ),
    );

    if (existingItem.bookId.isNotEmpty) {
      // Item exists, increment quantity
      existingItem.quantity++;
      await existingItem.save();
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
      await _cartBox.add(cartItem);
    }
    
    notifyListeners();
  }

  Future<void> removeFromCart(String bookId) async {
    if (!_isInitialized) await initialize();
    
    final item = items.firstWhere((item) => item.bookId == bookId);
    await item.delete();
    notifyListeners();
  }

  Future<void> updateQuantity(String bookId, int quantity) async {
    if (!_isInitialized) await initialize();
    
    if (quantity <= 0) {
      await removeFromCart(bookId);
      return;
    }

    final item = items.firstWhere((item) => item.bookId == bookId);
    item.quantity = quantity;
    await item.save();
    notifyListeners();
  }

  Future<void> clearCart() async {
    if (!_isInitialized) await initialize();
    
    await _cartBox.clear();
    notifyListeners();
  }

  bool isInCart(String bookId) {
    return items.any((item) => item.bookId == bookId);
  }

  int getQuantity(String bookId) {
    try {
      final item = items.firstWhere((item) => item.bookId == bookId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }
}
