import '../models/book.dart';
import '../models/user.dart';

/// Mock data for books and users
class MockData {
  static final User currentUser = User(
    id: 'user_1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1234567890',
    address: '123 Main Street',
    city: 'New York',
    postalCode: '10001',
    rating: 4.5,
    totalSales: 23,
    joinedDate: DateTime(2024, 1, 15),
  );

  static final List<Book> books = [
    // Featured Books
    Book(
      id: 'book_1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      isbn: '9780743273565',
      category: 'Fiction',
      condition: 'Like New',
      price: 12.99,
      acceptsBarter: true,
      description: 'A classic American novel set in the Jazz Age. Barely read, excellent condition with no markings or damage.',
      imageUrls: ['https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400'],
      sellerId: 'user_2',
      sellerName: 'Sarah Johnson',
      sellerRating: 4.8,
      listedDate: DateTime.now().subtract(const Duration(days: 2)),
      isFeatured: true,
      views: 145,
    ),
    Book(
      id: 'book_2',
      title: 'Sapiens: A Brief History of Humankind',
      author: 'Yuval Noah Harari',
      isbn: '9780062316110',
      category: 'Non-Fiction',
      condition: 'Good',
      price: 15.50,
      acceptsBarter: false,
      description: 'Fascinating read about human history. Some highlighting on a few pages, but overall in good condition.',
      imageUrls: ['https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400'],
      sellerId: 'user_3',
      sellerName: 'Michael Chen',
      sellerRating: 4.6,
      listedDate: DateTime.now().subtract(const Duration(days: 5)),
      isFeatured: true,
      views: 203,
    ),
    Book(
      id: 'book_3',
      title: 'Introduction to Algorithms',
      author: 'Thomas H. Cormen',
      isbn: '9780262033848',
      category: 'Textbooks',
      condition: 'Good',
      price: 45.00,
      acceptsBarter: true,
      description: 'Essential computer science textbook. Used for one semester, some notes in margins.',
      imageUrls: ['https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400'],
      sellerId: 'user_4',
      sellerName: 'Emily Rodriguez',
      sellerRating: 4.9,
      listedDate: DateTime.now().subtract(const Duration(days: 1)),
      isFeatured: true,
      views: 98,
    ),
    
    // Fiction
    Book(
      id: 'book_4',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      isbn: '9780060935467',
      category: 'Fiction',
      condition: 'Fair',
      price: 8.99,
      acceptsBarter: true,
      description: 'Classic novel with important themes. Well-loved copy with some wear on the cover.',
      imageUrls: ['https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400'],
      sellerId: 'user_5',
      sellerName: 'David Wilson',
      sellerRating: 4.3,
      listedDate: DateTime.now().subtract(const Duration(days: 7)),
      views: 76,
    ),
    Book(
      id: 'book_5',
      title: '1984',
      author: 'George Orwell',
      isbn: '9780451524935',
      category: 'Fiction',
      condition: 'Like New',
      price: 10.99,
      acceptsBarter: false,
      description: 'Dystopian masterpiece. Read once, perfect condition.',
      imageUrls: ['https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400'],
      sellerId: 'user_2',
      sellerName: 'Sarah Johnson',
      sellerRating: 4.8,
      listedDate: DateTime.now().subtract(const Duration(days: 3)),
      views: 132,
    ),
    
    // Mystery
    Book(
      id: 'book_6',
      title: 'The Girl with the Dragon Tattoo',
      author: 'Stieg Larsson',
      isbn: '9780307949486',
      category: 'Mystery',
      condition: 'Good',
      price: 11.50,
      acceptsBarter: true,
      description: 'Gripping mystery thriller. Some creasing on spine from reading.',
      imageUrls: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
      sellerId: 'user_6',
      sellerName: 'Lisa Anderson',
      sellerRating: 4.7,
      listedDate: DateTime.now().subtract(const Duration(days: 4)),
      views: 89,
    ),
    
    // Science Fiction
    Book(
      id: 'book_7',
      title: 'Dune',
      author: 'Frank Herbert',
      isbn: '9780441172719',
      category: 'Science Fiction',
      condition: 'Like New',
      price: 14.99,
      acceptsBarter: true,
      description: 'Epic sci-fi classic. Excellent condition, must-read for any sci-fi fan.',
      imageUrls: ['https://images.unsplash.com/photo-1589998059171-988d887df646?w=400'],
      sellerId: 'user_3',
      sellerName: 'Michael Chen',
      sellerRating: 4.6,
      listedDate: DateTime.now().subtract(const Duration(days: 6)),
      views: 156,
    ),
    Book(
      id: 'book_8',
      title: 'The Martian',
      author: 'Andy Weir',
      isbn: '9780553418026',
      category: 'Science Fiction',
      condition: 'Good',
      price: 9.99,
      acceptsBarter: false,
      description: 'Thrilling survival story on Mars. Read twice, still in great shape.',
      imageUrls: ['https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'],
      sellerId: 'user_7',
      sellerName: 'James Taylor',
      sellerRating: 4.4,
      listedDate: DateTime.now().subtract(const Duration(days: 8)),
      views: 112,
    ),
    
    // Romance
    Book(
      id: 'book_9',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      isbn: '9780141439518',
      category: 'Romance',
      condition: 'Fair',
      price: 7.50,
      acceptsBarter: true,
      description: 'Timeless romance classic. Well-loved with some yellowing pages.',
      imageUrls: ['https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400'],
      sellerId: 'user_8',
      sellerName: 'Amanda White',
      sellerRating: 4.5,
      listedDate: DateTime.now().subtract(const Duration(days: 10)),
      views: 95,
    ),
    
    // Self-Help
    Book(
      id: 'book_10',
      title: 'Atomic Habits',
      author: 'James Clear',
      isbn: '9780735211292',
      category: 'Self-Help',
      condition: 'Like New',
      price: 16.99,
      acceptsBarter: false,
      description: 'Life-changing book on building good habits. Highlighted key sections.',
      imageUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'],
      sellerId: 'user_9',
      sellerName: 'Robert Brown',
      sellerRating: 4.9,
      listedDate: DateTime.now().subtract(const Duration(days: 1)),
      views: 178,
    ),
    Book(
      id: 'book_11',
      title: 'The 7 Habits of Highly Effective People',
      author: 'Stephen R. Covey',
      isbn: '9781982137274',
      category: 'Self-Help',
      condition: 'Good',
      price: 13.50,
      acceptsBarter: true,
      description: 'Classic self-improvement book. Some notes in margins, great condition.',
      imageUrls: ['https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400'],
      sellerId: 'user_2',
      sellerName: 'Sarah Johnson',
      sellerRating: 4.8,
      listedDate: DateTime.now().subtract(const Duration(days: 5)),
      views: 134,
    ),
    
    // Biography
    Book(
      id: 'book_12',
      title: 'Steve Jobs',
      author: 'Walter Isaacson',
      isbn: '9781451648539',
      category: 'Biography',
      condition: 'Good',
      price: 14.00,
      acceptsBarter: false,
      description: 'Comprehensive biography of Apple founder. Minor wear on cover.',
      imageUrls: ['https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400'],
      sellerId: 'user_10',
      sellerName: 'Jennifer Lee',
      sellerRating: 4.7,
      listedDate: DateTime.now().subtract(const Duration(days: 3)),
      views: 121,
    ),
    
    // Children
    Book(
      id: 'book_13',
      title: 'Harry Potter and the Philosopher\'s Stone',
      author: 'J.K. Rowling',
      isbn: '9780439708180',
      category: 'Children',
      condition: 'Fair',
      price: 8.00,
      acceptsBarter: true,
      description: 'First book in the beloved series. Well-read with some page creasing.',
      imageUrls: ['https://images.unsplash.com/photo-1535905557558-afc4877a26fc?w=400'],
      sellerId: 'user_11',
      sellerName: 'Karen Martinez',
      sellerRating: 4.6,
      listedDate: DateTime.now().subtract(const Duration(days: 9)),
      views: 167,
    ),
    
    // Comics
    Book(
      id: 'book_14',
      title: 'Watchmen',
      author: 'Alan Moore',
      isbn: '9781401245252',
      category: 'Comics',
      condition: 'Like New',
      price: 18.99,
      acceptsBarter: false,
      description: 'Iconic graphic novel. Pristine condition, never bent or folded.',
      imageUrls: ['https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=400'],
      sellerId: 'user_12',
      sellerName: 'Kevin Garcia',
      sellerRating: 4.8,
      listedDate: DateTime.now().subtract(const Duration(days: 2)),
      views: 143,
    ),
    
    // More Textbooks
    Book(
      id: 'book_15',
      title: 'Campbell Biology',
      author: 'Jane B. Reece',
      isbn: '9780321775658',
      category: 'Textbooks',
      condition: 'Good',
      price: 55.00,
      acceptsBarter: true,
      description: 'Comprehensive biology textbook. Some highlighting, all pages intact.',
      imageUrls: ['https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400'],
      sellerId: 'user_4',
      sellerName: 'Emily Rodriguez',
      sellerRating: 4.9,
      listedDate: DateTime.now().subtract(const Duration(days: 4)),
      views: 87,
    ),
  ];

  static List<Book> getFeaturedBooks() {
    return books.where((book) => book.isFeatured).toList();
  }

  static List<Book> getBooksByCategory(String category) {
    if (category == 'All') return books;
    return books.where((book) => book.category == category).toList();
  }

  static List<Book> searchBooks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          book.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static Book? getBookById(String id) {
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}
