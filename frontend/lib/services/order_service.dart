import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/waybill.dart';

class OrderService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> createOrder({
    required int addressId,
    required double shippingCost,
    required String shippingCourier,
    required List<int> cartItemIds,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      await _dio.post(
        '$_baseUrl/orders',
        data: {
          'user_address_id': addressId,
          'shipping_cost': shippingCost,
          'shipping_courier': shippingCourier,
          'cart_item_ids': cartItemIds,
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal membuat pesanan: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      final response = await _dio.get(
        '$_baseUrl/orders',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      List<dynamic> orderData = response.data['data']['data'];
      return orderData.map((json) => Order.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengambil riwayat pesanan: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      final response = await _dio.get(
        '$_baseUrl/orders/$orderId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return Order.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengambil detail pesanan: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> confirmDelivery(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal.');
      }

      // Panggil endpoint POST untuk konfirmasi
      await _dio.post(
        '$_baseUrl/orders/$orderId/confirm-delivery',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengkonfirmasi pesanan: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> cancelOrder(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Autentikasi gagal.');

      await _dio.post(
        '$_baseUrl/orders/$orderId/cancel',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal membatalkan pesanan: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> uploadPaymentProof(int orderId, File imageFile) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Autentikasi gagal.');

      // Ubah file gambar menjadi format yang bisa dikirim oleh Dio
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        // 'proof' harus sama dengan nama validasi di Laravel
        'proof':
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // Panggil endpoint upload-proof
      await _dio.post(
        '$_baseUrl/orders/$orderId/upload-proof',
        data: formData,
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal meng-upload bukti: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<Waybill> trackOrder(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Autentikasi gagal.');

      final response = await _dio.get(
        '$_baseUrl/orders/$orderId/track',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      // Sekarang karena API selalu konsisten, pengecekannya simpel
      if (response.data['success'] == true) {
        return Waybill.fromJson(response.data['data']);
      } else {
        // Tampilkan pesan error dari server kita
        throw Exception(response.data['message'] ?? 'Data tidak ditemukan');
      }
    } on DioException catch (e) {
      // Tangani jika server kita sendiri yang error (misal: 500)
      final serverMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan pada server.';
      throw Exception('Gagal melacak pengiriman: $serverMessage');
    }
  }
}
