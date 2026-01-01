/// Represents an item in the shopping cart
class CartItem {
  final String bookId;
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final String condition;
  int quantity;
  final String sellerId;

  CartItem({
    required this.bookId,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.condition,
    this.quantity = 1,
    required this.sellerId,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? bookId,
    String? title,
    String? author,
    double? price,
    String? imageUrl,
    String? condition,
    int? quantity,
    String? sellerId,
  }) {
    return CartItem(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      condition: condition ?? this.condition,
      quantity: quantity ?? this.quantity,
      sellerId: sellerId ?? this.sellerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'price': price,
      'imageUrl': imageUrl,
      'condition': condition,
      'quantity': quantity,
      'sellerId': sellerId,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      condition: json['condition'],
      quantity: json['quantity'] ?? 1,
      sellerId: json['sellerId'],
    );
  }
}
