import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_address.dart';

class AddressService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<UserAddress>> getAddresses() async {
    final token = await _getToken();
    final response = await _dio.get('$_baseUrl/addresses',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    List<dynamic> data = response.data['data'];
    return data.map((json) => UserAddress.fromJson(json)).toList();
  }

  Future<UserAddress> addAddress(Map<String, dynamic> addressData) async {
    final token = await _getToken();
    final response = await _dio.post('$_baseUrl/addresses',
        data: addressData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return UserAddress.fromJson(response.data['data']);
  }

  Future<UserAddress> updateAddress(
      int id, Map<String, dynamic> addressData) async {
    final token = await _getToken();
    final response = await _dio.put('$_baseUrl/addresses/$id',
        data: addressData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return UserAddress.fromJson(response.data['data']);
  }

  Future<void> deleteAddress(int id) async {
    final token = await _getToken();
    await _dio.delete('$_baseUrl/addresses/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<UserAddress> getAddressById(int id) async {
    final token = await _getToken();
    final response = await _dio.get('$_baseUrl/addresses/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return UserAddress.fromJson(response.data['data']);
  }
}
