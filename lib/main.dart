import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/book_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BookCircleApp());
}

class BookCircleApp extends StatefulWidget {
  const BookCircleApp({super.key});

  @override
  State<BookCircleApp> createState() => _BookCircleAppState();
}

class _BookCircleAppState extends State<BookCircleApp> {
  late final UserProvider _userProvider;
  late final ThemeProvider _themeProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider()..initialize();
    _themeProvider = ThemeProvider()..initialize();
    _router = createRouter(_userProvider);
  }

  @override
  void dispose() {
    _userProvider.dispose();
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => CartProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider.value(value: _userProvider),
        ChangeNotifierProvider.value(value: _themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'BookCircle',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
