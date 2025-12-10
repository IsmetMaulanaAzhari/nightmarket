import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final String bookId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String condition;

  @HiveField(6)
  int quantity;

  @HiveField(7)
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
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      condition: json['condition'],
      quantity: json['quantity'],
      sellerId: json['sellerId'],
    );
  }
}
