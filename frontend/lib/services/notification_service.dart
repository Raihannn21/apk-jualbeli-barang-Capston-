import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NotificationService {
  // Fungsi untuk menampilkan notifikasi sukses
  static void showSuccessNotification(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.check_circle_outline,
            color: Color(0x15000000), size: 120),
        // Tambahkan style teks jika perlu
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      // --- PARAMETER BARU UNTUK CUSTOMISASI TAMPILAN & ANIMASI ---
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      snackBarPosition: SnackBarPosition.top, // Pastikan di atas
      animationDuration: const Duration(milliseconds: 800),
      displayDuration: const Duration(seconds: 2),
      curve: Curves.elasticOut, // Animasi yang lebih 'membal'
    );
  }

  // Fungsi untuk menampilkan notifikasi error
  static void showErrorNotification(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message.replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.shade700,
        icon: const Icon(Icons.error_outline,
            color: Color(0x15000000), size: 120),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      snackBarPosition: SnackBarPosition.top,
      animationDuration: const Duration(milliseconds: 800),
      displayDuration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
    );
  }

  // Fungsi untuk menampilkan notifikasi info/peringatan
  static void showInfoNotification(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: message,
        backgroundColor: Colors.orange.shade700,
        icon:
            const Icon(Icons.info_outline, color: Color(0x15000000), size: 120),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      snackBarPosition: SnackBarPosition.top,
      animationDuration: const Duration(milliseconds: 800),
      displayDuration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
    );
  }
}
