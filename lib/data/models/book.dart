import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String? isbn;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String condition; // Like New, Good, Fair

  @HiveField(6)
  final double price;

  @HiveField(7)
  final bool acceptsBarter;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final List<String> imageUrls;

  @HiveField(10)
  final String sellerId;

  @HiveField(11)
  final String sellerName;

  @HiveField(12)
  final double sellerRating;

  @HiveField(13)
  final DateTime listedDate;

  @HiveField(14)
  final bool isSold;

  @HiveField(15)
  final bool isFeatured;

  @HiveField(16)
  final int views;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.isbn,
    required this.category,
    required this.condition,
    required this.price,
    this.acceptsBarter = false,
    required this.description,
    required this.imageUrls,
    required this.sellerId,
    required this.sellerName,
    this.sellerRating = 0.0,
    required this.listedDate,
    this.isSold = false,
    this.isFeatured = false,
    this.views = 0,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? category,
    String? condition,
    double? price,
    bool? acceptsBarter,
    String? description,
    List<String>? imageUrls,
    String? sellerId,
    String? sellerName,
    double? sellerRating,
    DateTime? listedDate,
    bool? isSold,
    bool? isFeatured,
    int? views,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      acceptsBarter: acceptsBarter ?? this.acceptsBarter,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerRating: sellerRating ?? this.sellerRating,
      listedDate: listedDate ?? this.listedDate,
      isSold: isSold ?? this.isSold,
      isFeatured: isFeatured ?? this.isFeatured,
      views: views ?? this.views,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'condition': condition,
      'price': price,
      'acceptsBarter': acceptsBarter,
      'description': description,
      'imageUrls': imageUrls,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerRating': sellerRating,
      'listedDate': listedDate.toIso8601String(),
      'isSold': isSold,
      'isFeatured': isFeatured,
      'views': views,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      category: json['category'],
      condition: json['condition'],
      price: json['price'].toDouble(),
      acceptsBarter: json['acceptsBarter'] ?? false,
      description: json['description'],
      imageUrls: List<String>.from(json['imageUrls']),
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerRating: json['sellerRating'].toDouble(),
      listedDate: DateTime.parse(json['listedDate']),
      isSold: json['isSold'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
    );
  }
}
