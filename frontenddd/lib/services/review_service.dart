import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';

class ReviewService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Review>> getReviews(int productId) async {
    try {
      final response = await _dio.get('$_baseUrl/products/$productId/reviews');

      List<dynamic> reviewData = response.data['data']['data'];
      return reviewData.map((json) => Review.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil ulasan: ${e.message}');
    }
  }

  Future<void> addReview({
    required int productId,
    required int orderId,
    required int rating,
    required String comment,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Autentikasi gagal.');
      }

      await _dio.post(
        '$_baseUrl/products/$productId/reviews',
        data: {
          'order_id': orderId,
          'rating': rating,
          'comment': comment,
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
          'Gagal mengirim ulasan: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
