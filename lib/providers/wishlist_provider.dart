import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing wishlist state
class WishlistProvider extends ChangeNotifier {
  Set<String> _wishlistIds = {};
  bool _isInitialized = false;
  
  static const String _wishlistKey = 'wishlist_ids';

  Set<String> get wishlistIds => _wishlistIds;
  
  int get itemCount => _wishlistIds.length;

  Future<void> initialize() async {
    if (!_isInitialized) {
      final prefs = await SharedPreferences.getInstance();
      final storedIds = prefs.getStringList(_wishlistKey) ?? [];
      _wishlistIds = storedIds.toSet();
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(String bookId) async {
    if (!_isInitialized) await initialize();
    
    if (_wishlistIds.contains(bookId)) {
      _wishlistIds.remove(bookId);
    } else {
      _wishlistIds.add(bookId);
    }
    
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> addToWishlist(String bookId) async {
    if (!_isInitialized) await initialize();
    
    if (!_wishlistIds.contains(bookId)) {
      _wishlistIds.add(bookId);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String bookId) async {
    if (!_isInitialized) await initialize();
    
    if (_wishlistIds.contains(bookId)) {
      _wishlistIds.remove(bookId);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  bool isInWishlist(String bookId) {
    return _wishlistIds.contains(bookId);
  }

  Future<void> clearWishlist() async {
    if (!_isInitialized) await initialize();
    
    _wishlistIds.clear();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_wishlistKey, _wishlistIds.toList());
  }
}
