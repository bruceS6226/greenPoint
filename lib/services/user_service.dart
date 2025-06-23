import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:green_aplication/config/api_config.dart';
import 'package:green_aplication/services/auth_service.dart';

class UserService {
  final String _basePath = 'user';
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getAll() async {
    final response = await _authService.get('$_basePath/get-all');
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        decoded is Map<String, dynamic> &&
        decoded.containsKey('data')) {
      return decoded['data'];
    }
    throw Exception(
      decoded['message'] ?? 'Error al obtener usuarios',
    );
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> user) async {
    final response = await _authService.post(
      '$_basePath/register',
      body: user,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ??
        'Error al registrar el usuario');
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> user) async {
    final response = await _authService.put(
      '$_basePath/update',
      body: user,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ??
        'Error al actualizar el usuario');
  }

  // ... (getById y changeState siguen igual pero usando _authService)
}
