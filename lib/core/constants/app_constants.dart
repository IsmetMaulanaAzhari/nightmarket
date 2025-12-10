/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'BookCircle';
  static const String appTagline = 'Give Books a Second Life';
  
  // Book Conditions
  static const List<String> bookConditions = [
    'Like New',
    'Good',
    'Fair',
  ];
  
  // Categories
  static const List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Textbooks',
    'Comics',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Biography',
    'Self-Help',
    'Children',
  ];
  
  // Shipping Methods
  static const Map<String, double> shippingMethods = {
    'Standard Shipping (5-7 days)': 5.00,
    'Express Shipping (2-3 days)': 12.00,
    'Same Day Delivery': 20.00,
  };
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Bank Transfer',
    'Cash on Delivery (COD)',
  ];
  
  // Price Ranges for Filtering
  static const List<Map<String, dynamic>> priceRanges = [
    {'label': 'All Prices', 'min': 0.0, 'max': double.infinity},
    {'label': 'Under \$5', 'min': 0.0, 'max': 5.0},
    {'label': '\$5 - \$15', 'min': 5.0, 'max': 15.0},
    {'label': '\$15 - \$30', 'min': 15.0, 'max': 30.0},
    {'label': 'Over \$30', 'min': 30.0, 'max': double.infinity},
  ];
  
  // Hive Box Names
  static const String cartBoxName = 'cart_box';
  static const String wishlistBoxName = 'wishlist_box';
  static const String userBoxName = 'user_box';
}
