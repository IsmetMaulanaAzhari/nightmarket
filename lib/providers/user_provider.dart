import 'package:flutter/foundation.dart';
import 'package:nightmarket/data/models/user.dart';
import 'package:nightmarket/data/repositories/mock_data.dart';

/// Provider for managing user state
class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    // In a real app, this would check for saved session
    // For now, we'll use the mock current user
    _currentUser = MockData.currentUser;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        postalCode: postalCode,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
