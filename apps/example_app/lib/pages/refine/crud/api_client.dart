// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';

/// Minimal HTTP client for the fake-rest refine API.
/// No external dependencies — uses dart:io [HttpClient].
class ApiClient {
  /// Creates an [ApiClient].
  ApiClient({this.baseUrl = 'https://api.fake-rest.refine.dev'});

  /// Base URL for all requests.
  final String baseUrl;

  final _client = HttpClient();

  /// GET request. Returns decoded JSON.
  Future<dynamic> get(String path, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    final request = await _client.getUrl(uri);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body);
  }

  /// POST request. Returns decoded JSON.
  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(data));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body);
  }

  /// PUT request. Returns decoded JSON.
  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _client.putUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(data));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body);
  }

  /// DELETE request.
  Future<void> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _client.deleteUrl(uri);
    final response = await request.close();
    await response.drain<void>();
  }
}
