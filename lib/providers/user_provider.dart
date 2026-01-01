import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:nightmarket/data/models/user.dart';
import 'package:nightmarket/data/repositories/mock_data.dart';

/// Provider for managing user authentication and profile state
class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isGuest = false;
  bool _isInitialized = false;
  
  // Mock database of registered users
  final List<Map<String, dynamic>> _registeredUsers = [
    {
      'email': 'user@example.com',
      'password': '123456',
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'id': 'user-001',
    },
    {
      'email': 'seller@example.com',
      'password': '123456',
      'name': 'Siti Rahayu',
      'phone': '082345678901',
      'id': 'user-002',
    },
  ];

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isGuest => _isGuest;
  bool get isAuthenticated => _currentUser != null && !_isGuest;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId');
    final isGuestMode = prefs.getBool('isGuest') ?? false;
    
    if (isGuestMode) {
      _isGuest = true;
      _currentUser = _createGuestUser();
    } else if (savedUserId != null) {
      // Find user in mock database
      final userData = _registeredUsers.firstWhere(
        (u) => u['id'] == savedUserId,
        orElse: () => {},
      );
      
      if (userData.isNotEmpty) {
        _currentUser = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          joinedDate: DateTime.now().subtract(const Duration(days: 30)),
        );
      }
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  User _createGuestUser() {
    return User(
      id: 'guest-${const Uuid().v4()}',
      name: 'Tamu',
      email: 'guest@bookcircle.com',
      joinedDate: DateTime.now(),
    );
  }

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check mock database
    final userData = _registeredUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    
    if (userData.isNotEmpty) {
      _currentUser = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        joinedDate: DateTime.now().subtract(const Duration(days: 30)),
        avatarUrl: MockData.currentUser.avatarUrl,
        address: MockData.currentUser.address,
        city: MockData.currentUser.city,
        postalCode: MockData.currentUser.postalCode,
        rating: MockData.currentUser.rating,
        totalSales: MockData.currentUser.totalSales,
      );
      _isGuest = false;
      
      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userData['id']);
      await prefs.setBool('isGuest', false);
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if email already exists
    final existingUser = _registeredUsers.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );
    
    if (existingUser.isNotEmpty) {
      return false; // Email already registered
    }
    
    // Add new user to mock database
    final newUserId = 'user-${const Uuid().v4()}';
    _registeredUsers.add({
      'id': newUserId,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });
    
    return true;
  }

  Future<void> loginAsGuest() async {
    _currentUser = _createGuestUser();
    _isGuest = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', true);
    await prefs.remove('userId');
    
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if email exists
    final existingUser = _registeredUsers.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );
    
    return existingUser.isNotEmpty;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
    String? avatarUrl,
    String? avatarPath, // Local file path for avatar
  }) async {
    if (_currentUser != null) {
      // In a real app, avatarPath would be uploaded to a server
      // and the returned URL would be saved
      final newAvatarUrl = avatarPath != null 
          ? 'file://$avatarPath' // For local file
          : avatarUrl;
          
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        postalCode: postalCode,
        avatarUrl: newAvatarUrl,
      );
      notifyListeners();
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_currentUser == null || _isGuest) return false;
    
    // Find user and update password
    final userIndex = _registeredUsers.indexWhere(
      (u) => u['id'] == _currentUser!.id && u['password'] == currentPassword,
    );
    
    if (userIndex != -1) {
      _registeredUsers[userIndex]['password'] = newPassword;
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isGuest = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('isGuest');
    
    notifyListeners();
  }
}
