import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/core/domain/token_storage.dart';
import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/models/request_type.dart';

class BaseAPIService {
  final String baseUrl;
  final TokenStorage _tokenStorage;
  final bool requiresAuth;

  BaseAPIService({
    this.baseUrl = Constants.baseUrl,
    TokenStorage? tokenStorage,
    this.requiresAuth = true,
  }) : _tokenStorage = tokenStorage ?? TokenStorage();

  /// Build default headers with optional authorization
  Future<Map<String, String>> getDefaultHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (requiresAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// ---------------- GET ----------------
  Future<APIResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      requestType: RequestType.get,
      endpoint: endpoint,
      headers: headers,
    );
  }

  /// ---------------- POST ----------------
  Future<APIResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      requestType: RequestType.post,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
  }

  /// ---------------- PUT ----------------
  Future<APIResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      requestType: RequestType.put,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
  }

  /// ---------------- DELETE ----------------
  Future<APIResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      requestType: RequestType.delete,
      endpoint: endpoint,
      headers: headers,
    );
  }

  /// ---------------- MAIN HANDLER ----------------
  Future<APIResponse> _sendRequest({
    required RequestType requestType,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool isRetry = false,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final mergedHeaders = {
      ...(await getDefaultHeaders()),
      ...?headers,
    };

    http.Response response;
    try {
      switch (requestType) {
        case RequestType.post:
          response = await http.post(
            uri,
            headers: mergedHeaders,
            body: jsonEncode(body),
          );
          break;
        case RequestType.put:
          response = await http.put(
            uri,
            headers: mergedHeaders,
            body: jsonEncode(body),
          );
          break;
        case RequestType.delete:
          response = await http.delete(uri, headers: mergedHeaders);
          break;
        case RequestType.get:
          response = await http.get(uri, headers: mergedHeaders);
      }

      // Handle expired token (401)
      if (response.statusCode == 401 && !isRetry && requiresAuth) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry once after refresh
          return _sendRequest(
            requestType: requestType,
            endpoint: endpoint,
            body: body,
            headers: headers,
            isRetry: true,
          );
        }
      }

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// ---------------- HANDLE RESPONSE ----------------
  APIResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final apiResponse = APIResponse(statusCode: statusCode);

    if (response.body.isNotEmpty) {
      try {
        apiResponse.data = jsonDecode(response.body);
      } catch (_) {
        apiResponse.data = response.body;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return apiResponse;
    } else {
      throw Exception('HTTP Error ${response.statusCode}');
    }
  }

  /// ---------------- REFRESH TOKEN LOGIC ----------------
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final url = Uri.parse('$baseUrl/auth/refresh');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final accessToken = body['accessToken'];
        final newRefreshToken = body['refreshToken'];

        if (accessToken != null && newRefreshToken != null) {
          await _tokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
