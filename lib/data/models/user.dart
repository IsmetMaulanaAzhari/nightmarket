import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? avatarUrl;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? city;

  @HiveField(7)
  final String? postalCode;

  @HiveField(8)
  final double rating;

  @HiveField(9)
  final int totalSales;

  @HiveField(10)
  final DateTime joinedDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
    this.city,
    this.postalCode,
    this.rating = 0.0,
    this.totalSales = 0,
    required this.joinedDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    String? city,
    String? postalCode,
    double? rating,
    int? totalSales,
    DateTime? joinedDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      rating: rating ?? this.rating,
      totalSales: totalSales ?? this.totalSales,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'rating': rating,
      'totalSales': totalSales,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      rating: json['rating']?.toDouble() ?? 0.0,
      totalSales: json['totalSales'] ?? 0,
      joinedDate: DateTime.parse(json['joinedDate']),
    );
  }
}
