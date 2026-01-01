import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nightmarket/presentation/screens/home_screen.dart';
import 'package:nightmarket/presentation/screens/book_details_screen.dart';
import 'package:nightmarket/presentation/screens/cart_screen.dart';
import 'package:nightmarket/presentation/screens/profile_screen.dart';
import 'package:nightmarket/presentation/screens/wishlist_screen.dart';
import 'package:nightmarket/presentation/screens/checkout_screen.dart';
import 'package:nightmarket/presentation/screens/add_book_screen.dart';
import 'package:nightmarket/presentation/screens/my_listings_screen.dart';
import 'package:nightmarket/presentation/screens/order_history_screen.dart';
import 'package:nightmarket/presentation/screens/order_detail_screen.dart';
import 'package:nightmarket/presentation/screens/edit_profile_screen.dart';
import 'package:nightmarket/presentation/screens/barcode_scanner_screen.dart';
import 'package:nightmarket/presentation/screens/auth/welcome_screen.dart';
import 'package:nightmarket/presentation/screens/auth/login_screen.dart';
import 'package:nightmarket/presentation/screens/auth/register_screen.dart';
import 'package:nightmarket/presentation/screens/auth/forgot_password_screen.dart';
import 'package:nightmarket/presentation/widgets/main_navigation.dart';
import 'package:nightmarket/providers/user_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(UserProvider userProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    refreshListenable: userProvider,
    redirect: (context, state) {
      final isLoggedIn = userProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation == '/welcome' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // If user is not logged in and trying to access app routes, redirect to welcome
      if (!isLoggedIn && !isAuthRoute) {
        return '/welcome';
      }

      // If user is logged in and trying to access auth routes, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainNavigation(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final bookId = state.pathParameters['id']!;
        return BookDetailsScreen(bookId: bookId);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/add-book',
      builder: (context, state) {
        // Check if there's prefilled data from barcode scanner
        final extra = state.extra as Map<String, dynamic>?;
        return AddBookScreen(
          bookId: null,
          prefilledData: extra,
        );
      },
    ),
    GoRoute(
      path: '/edit-book/:id',
      builder: (context, state) {
        final bookId = state.pathParameters['id'];
        return AddBookScreen(bookId: bookId);
      },
    ),
    GoRoute(
      path: '/my-listings',
      builder: (context, state) => const MyListingsScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/order/:id',
      builder: (context, state) {
        final orderId = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/scan-barcode',
      builder: (context, state) => const BarcodeScannerScreen(),
    ),
  ],
);
}

// Fallback router for when UserProvider is not available
final GoRouter router = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);