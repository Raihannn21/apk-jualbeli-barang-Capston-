import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // Privat constructor agar class ini tidak bisa dibuat objeknya

  // =================================================================
  // TEMA LAMA (BIRU MINIMALIS) - INI TIDAK KITA HAPUS
  // =================================================================
  static final Color _primaryColorLight = Color(0xFF4A90E2);
  static final Color _accentColorLight = Color(0xFFF5A623);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorLight,
        primary: _primaryColorLight,
        secondary: _accentColorLight,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColorLight,
        foregroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColorLight,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            )),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColorLight),
        ),
      ),
    );
  }

  // =================================================================
  // TEMA BARU (VIBRANT & CLEAN) - KITA TAMBAHKAN INI
  // =================================================================
  static final Color _primaryColorVibrant = Colors.teal.shade700; // Teal gelap
  static final Color _accentColorVibrant =
      Colors.amber.shade700; // Amber/Kuning Emas

  static ThemeData get vibrantTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark, // Kita jadikan ini sebagai "dark theme"
      scaffoldBackgroundColor: const Color(0xFF121212), // Background gelap

      // Skema warna baru
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorVibrant,
        primary: _primaryColorVibrant,
        secondary: _accentColorVibrant,
        brightness:
            Brightness.dark, // Penting untuk warna teks & ikon yang kontras
      ),

      // Tema AppBar baru
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(
            0xFF1F1F1F), // AppBar sedikit lebih terang dari background
        foregroundColor: Colors.white, // Judul & ikon putih
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Tema Tombol baru
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColorVibrant,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)), // Tombol lebih bulat
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      ),

      // Tema Input baru
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColorVibrant),
        ),
      ),
    );
  }
}
