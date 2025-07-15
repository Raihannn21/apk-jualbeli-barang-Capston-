// lib/services/location_service.dart
import 'package:dio/dio.dart';
import '../models/location.dart';

class LocationService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Location>> searchLocations(String query) async {
    if (query.length < 3) return [];
    try {
      final response = await _dio.get(
        '$_baseUrl/locations/search',
        queryParameters: {'q': query},
      );
      List<dynamic> data = response.data['data'];
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
