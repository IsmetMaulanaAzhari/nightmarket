import 'package:flutter/foundation.dart';
import 'package:nightmarket/data/models/book.dart';
import 'package:nightmarket/data/repositories/mock_data.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing book listings
class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  List<Book> _myListings = [];
  bool _isInitialized = false;

  List<Book> get books => _books;
  List<Book> get myListings => _myListings;
  List<Book> get featuredBooks => _books.where((book) => book.isFeatured && !book.isSold).toList();

  Future<void> initialize() async {
    if (!_isInitialized) {
      _books = List.from(MockData.books);
      _isInitialized = true;
      notifyListeners();
    }
  }

  List<Book> getBooksByCategory(String category) {
    if (category == 'All') {
      return _books.where((book) => !book.isSold).toList();
    }
    return _books.where((book) => book.category == category && !book.isSold).toList();
  }

  List<Book> searchBooks(String query, {String? category, String? condition, double? minPrice, double? maxPrice}) {
    var results = _books.where((book) => !book.isSold);

    // Text search
    if (query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      results = results.where((book) =>
          book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          book.description.toLowerCase().contains(lowercaseQuery));
    }

    // Category filter
    if (category != null && category != 'All') {
      results = results.where((book) => book.category == category);
    }

    // Condition filter
    if (condition != null && condition.isNotEmpty) {
      results = results.where((book) => book.condition == condition);
    }

    // Price range filter
    if (minPrice != null) {
      results = results.where((book) => book.price >= minPrice);
    }
    if (maxPrice != null && maxPrice != double.infinity) {
      results = results.where((book) => book.price <= maxPrice);
    }

    return results.toList();
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  void incrementBookViews(String bookId) {
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      _books[index] = _books[index].copyWith(views: _books[index].views + 1);
      notifyListeners();
    }
  }

  Future<void> addBook({
    required String title,
    required String author,
    String? isbn,
    required String category,
    required String condition,
    required double price,
    required bool acceptsBarter,
    required String description,
    required List<String> imageUrls,
    required String sellerId,
    required String sellerName,
  }) async {
    final newBook = Book(
      id: const Uuid().v4(),
      title: title,
      author: author,
      isbn: isbn,
      category: category,
      condition: condition,
      price: price,
      acceptsBarter: acceptsBarter,
      description: description,
      imageUrls: imageUrls,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerRating: 0.0,
      listedDate: DateTime.now(),
      isSold: false,
      isFeatured: false,
      views: 0,
    );

    _books.insert(0, newBook);
    _myListings.insert(0, newBook);
    notifyListeners();
  }

  Future<void> updateBook(String bookId, {
    String? title,
    String? author,
    String? isbn,
    String? category,
    String? condition,
    double? price,
    bool? acceptsBarter,
    String? description,
    List<String>? imageUrls,
  }) async {
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      _books[index] = _books[index].copyWith(
        title: title,
        author: author,
        isbn: isbn,
        category: category,
        condition: condition,
        price: price,
        acceptsBarter: acceptsBarter,
        description: description,
        imageUrls: imageUrls,
      );
      
      // Update in myListings as well
      final myIndex = _myListings.indexWhere((book) => book.id == bookId);
      if (myIndex != -1) {
        _myListings[myIndex] = _books[index];
      }
      
      notifyListeners();
    }
  }

  Future<void> deleteBook(String bookId) async {
    _books.removeWhere((book) => book.id == bookId);
    _myListings.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }

  Future<void> markAsSold(String bookId) async {
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      _books[index] = _books[index].copyWith(isSold: true);
      
      // Update in myListings as well
      final myIndex = _myListings.indexWhere((book) => book.id == bookId);
      if (myIndex != -1) {
        _myListings[myIndex] = _books[index];
      }
      
      notifyListeners();
    }
  }

  void loadMyListings(String userId) {
    _myListings = _books.where((book) => book.sellerId == userId).toList();
    notifyListeners();
  }
}
