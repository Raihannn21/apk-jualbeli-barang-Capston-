import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  final Dio _dio = Dio();
  // Pastikan IP ini benar untuk Android Emulator
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  /// Mengambil token autentikasi dari penyimpanan lokal.
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Menambah produk ke keranjang.
  Future<void> addToCart(int productId, int quantity) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      await _dio.post(
        '$_baseUrl/cart',
        data: {
          'product_id': productId,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal menambah ke keranjang: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Mengambil semua item di keranjang.
  Future<List<CartItem>> getCart() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }
      final response = await _dio.get(
        '$_baseUrl/cart',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      List<dynamic> cartData = response.data['data'];

      print('--- DATA KERANJANG MENTAH DITERIMA DARI API ---');
      print(cartData);

      List<CartItem> items = [];
      for (var itemJson in cartData) {
        print('--> Memproses item: $itemJson');
        if (itemJson['product'] != null && itemJson['product'] is Map) {
          print('✅ Produk Ditemukan. Menambahkan item...');
          items.add(CartItem.fromJson(itemJson));
        } else {
          print(
              '❌ PRODUK HANTU DITEMUKAN! Melewatkan item ID: ${itemJson['id']}');
        }
      }
      print('--- PROSES SELESAI. Total item valid: ${items.length} ---');
      return items;
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengambil data keranjang: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Mengubah jumlah item di keranjang.
  Future<void> updateItemQuantity(int cartItemId, int quantity) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      await _dio.put(
        '$_baseUrl/cart/$cartItemId',
        data: {'quantity': quantity},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengubah jumlah item: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Menghapus item dari keranjang.
  Future<void> deleteItem(int cartItemId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Autentikasi gagal: Token tidak ditemukan.');
      }

      await _dio.delete(
        '$_baseUrl/cart/$cartItemId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(
          'Gagal menghapus item: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
