import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final String baseUrl = 'http://localhost:3000';
  final String _api;

  Api(this._api);

  Future<String> getAll() async {
    var response = await http.get(Uri.parse("$baseUrl/$_api"));
    return response.body;
  }

  Future<http.Response> add(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse("$baseUrl/$_api"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> update(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse("$baseUrl/$_api/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> delete(int id) async {
    return await http.delete(Uri.parse("$baseUrl/$_api/$id"));
  }
}
