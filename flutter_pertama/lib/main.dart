import 'package:flutter/material.dart';
import 'package:flutter_pertama/splash_screen.dart';
import 'login_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kios JonJoni',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final username = settings.arguments as String? ?? '';
          return MaterialPageRoute(
            builder: (context) => DashboardPage(username: username),
          );
        }
        return null;
      },
    );
  }
}
