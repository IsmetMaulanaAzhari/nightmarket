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
import 'package:nightmarket/presentation/widgets/main_navigation.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
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
      builder: (context, state) => const AddBookScreen(),
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
  ],
);
