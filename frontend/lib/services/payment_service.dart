import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  // --- FUNGSI INI SEKARANG DIISI LENGKAP ---
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fungsi untuk membuat transaksi & mendapatkan payment token
  Future<String> createTransaction(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal. Silakan login kembali.');
      }

      final response = await _dio.post(
        '$_baseUrl/orders/$orderId/payment',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.data != null &&
          response.data['success'] == true &&
          response.data['payment_token'] != null) {
        return response.data['payment_token'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Gagal membuat token pembayaran.');
      }
    } on DioException catch (e) {
      throw Exception(
          'Gagal membuat transaksi: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
