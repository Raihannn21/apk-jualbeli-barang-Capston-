import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductService {
  final Dio _dio = Dio();

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Product>> getProducts({String? categorySlug}) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (categorySlug != null) {
        queryParams['category'] = categorySlug;
      }

      Response response = await _dio.get(
        '$_baseUrl/products',
        queryParameters: queryParams,
      );

      List<dynamic> productData = response.data['data'];
      return productData.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil data produk: ${e.message}');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/categories',
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );

      List<dynamic> categoryData = response.data['data'];
      return categoryData.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil data kategori: ${e.message}');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/products/search',
        queryParameters: {'q': query},
      );

      List<dynamic> productData = response.data['data'];
      return productData.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Gagal melakukan pencarian: ${e.message}');
    }
  }

  Future<List<Product>> getLatestProducts() async {
    try {
      final response = await _dio.get('$_baseUrl/products/latest');
      List<dynamic> productData = response.data['data'];
      return productData.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil produk terbaru: ${e.message}');
    }
  }
}
