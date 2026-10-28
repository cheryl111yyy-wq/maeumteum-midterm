import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_data.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  Future<AppData> fetchBootstrap({String path = '/bootstrap'}) async {
    final response = await http
        .get(Uri.parse('$baseUrl$path'))
        .timeout(const Duration(seconds: 6));

    if (response.statusCode != 200) {
      throw Exception('GET $path 실패 (${response.statusCode})');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw Exception('서버 응답 형식이 올바르지 않습니다.');
    }

    return AppData.fromJson(decoded);
  }
}
