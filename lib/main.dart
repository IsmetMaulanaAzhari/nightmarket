import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/book_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters (Note: You'll need to run build_runner to generate these)
  // Hive.registerAdapter(BookAdapter());
  // Hive.registerAdapter(CartItemAdapter());
  // Hive.registerAdapter(UserAdapter());
  // Hive.registerAdapter(OrderAdapter());
  // Hive.registerAdapter(OrderItemAdapter());
  
  runApp(const BookCircleApp());
}

class BookCircleApp extends StatelessWidget {
  const BookCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => CartProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
      ],
      child: MaterialApp.router(
        title: 'BookCircle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
