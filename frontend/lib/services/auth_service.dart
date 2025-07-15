import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = Dio();

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<Response> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      Response response = await _dio.post(
        '$_baseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Gagal melakukan registrasi: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<Response> login(
      {required String email, required String password}) async {
    try {
      Response response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Gagal melakukan login: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<User> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      final response = await _dio.get(
        '$_baseUrl/user',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal mengambil data user: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan.');
      }

      await _dio.post(
        '$_baseUrl/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      await prefs.remove('auth_token');
    } on DioException catch (e) {
      throw Exception('Gagal logout: ${e.message}');
    }
  }
}
