import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/shipping_option.dart';

class ShippingService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<ShippingOption>> getShippingOptions({
    required int destinationCityId,
    required List<CartItem> cartItems,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Autentikasi gagal.');

      final cartItemIds = cartItems.map((item) => item.id).toList();

      final response = await _dio.post(
        '$_baseUrl/shipping-cost',
        data: {
          'destination_city_id': destinationCityId,
          'cart_item_ids': cartItemIds,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        }),
      );

      List<dynamic> results = response.data['data'];

      return results
          .map((item) => ShippingOption(
                code: item['code'],
                name: item['name'],
                service: item['service'],
                description: item['description'],
                price: item['cost'],
                etd: item['etd'],
              ))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          'Gagal mengambil opsi pengiriman: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
