import 'dart:convert';

import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/core/models/api_response.dart';
import 'package:http/http.dart' as http;

class BaseAPIService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  BaseAPIService({
    this.baseUrl = Constants.baseUrl,
    this.defaultHeaders = const {'Content-Type': 'application/json'},
  });

  Future<APIResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: {
        ...defaultHeaders,
        ...?headers,
      },
    );

    return _handleResponse(response);
  }

  APIResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final apiResponse = APIResponse(statusCode: statusCode);
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    switch (statusCode) {
      case 200:
        apiResponse.data = body;
      default:
        throw Exception();
    }
    return apiResponse;
  }
}
