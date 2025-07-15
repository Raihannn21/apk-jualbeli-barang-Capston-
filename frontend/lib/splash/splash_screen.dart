import 'package:flutter/material.dart';
import 'package:frontend/screen/auth/login_screen.dart';
import 'package:frontend/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // State untuk mengontrol animasi
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Mulai animasi fade-in setelah sedikit jeda
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    // Navigasi setelah animasi selesai
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuth();
    });
  }

  void _checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (mounted) {
        if (token != null && token.isNotEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna dari tema yang sedang aktif
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Background menyesuaikan dengan tema
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: Center(
        // AnimatedOpacity untuk efek fade-in
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeIn,
          // AnimatedScale untuk efek sedikit membesar
          child: AnimatedScale(
            scale: _isVisible ? 1.0 : 0.8,
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ganti dengan logo Anda jika ada, atau gunakan ikon default
                Icon(
                  Icons.shopping_cart_checkout_rounded,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "ToSerBa",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
