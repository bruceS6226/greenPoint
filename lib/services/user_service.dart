import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:green_aplication/config/api_config.dart';
import 'package:green_aplication/services/auth_service.dart';

class UserService {
  final String _basePath = 'user';
  final AuthService _authService = AuthService();

  // Obtener todos los usuarios
  Future<List<dynamic>> getAll() async {
    try {
      final response = await _authService.get('$_basePath/get-all');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }

        throw Exception('Formato inesperado: se esperaba una lista dentro de "data".');
      } else {
        throw ('Error al obtener usuarios');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Registrar un usuario
  Future<Map<String, dynamic>> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$apiUrl/$_basePath/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_authService.sessionCookie != null)
          'Cookie': _authService.sessionCookie!,
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ('Error al registrar el usuario');
    }
  }

  // Actualizar un usuario
  Future<Map<String, dynamic>> update(Map<String, dynamic> user) async {
    final url = Uri.parse('$apiUrl/$_basePath/update');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_authService.sessionCookie != null)
          'Cookie': _authService.sessionCookie!,
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ('Error al actualizar el usuario');
    }
  }

  // Obtener usuario por ID
  Future<Map<String, dynamic>> getById(int id) async {
    try {
      final response = await _authService.get('$_basePath/get-by-id?id=$id');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ('Error al obtener el usuario');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cambiar estado del usuario
  Future<bool> changeState(int id) async {
    final url = Uri.parse('$apiUrl/$_basePath/change-state?id=$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_authService.sessionCookie != null)
          'Cookie': _authService.sessionCookie!,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) == true;
    } else {
      throw ('Error al cambiar el estado del usuario');
    }
  }
}
