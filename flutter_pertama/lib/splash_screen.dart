import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color primaryOrange = Color(0xFFFFA726); // Orange
  static const Color accentYellow = Color(0xFFFFF3E0); // Light yellow background
  static const Color sectionTitleColor = Color(0xFFEF6C00); // Deep orange
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentYellow,
      body: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primaryOrange.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: primaryOrange, width: 1.3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Splash/star accent above Jonjoni
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: primaryOrange, size: 28),
                  const SizedBox(width: 4),
                  Icon(Icons.bubble_chart, color: primaryOrange.withOpacity(0.7), size: 18),
                ],
              ),
              const SizedBox(height: 2),
              Image.asset('assets/logo.png', height: 90),
              const SizedBox(height: 10),
              Text(
                'Jonjoni',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: sectionTitleColor,
                  fontFamily: 'Pacifico', // Use 'Pacifico' if available
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.orangeAccent,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CircularProgressIndicator(color: primaryOrange),
              const SizedBox(height: 18),
              Text(
                'Created by RayhanWahyu',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
