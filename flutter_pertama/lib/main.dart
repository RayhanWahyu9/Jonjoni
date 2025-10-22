import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_provider.dart';
import 'models/orders_provider.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'dashboard_page.dart' hide CartPage;
import 'cart_page.dart';
import 'profile_page.dart';
import 'history_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jonjoni Coffee',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/cart': (context) => const CartPage(),
        '/history': (context) => const HistoryPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final username = settings.arguments as String? ?? '';
          return MaterialPageRoute(builder: (_) => DashboardPage(username: username));
        }
        return null;
      },
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}
