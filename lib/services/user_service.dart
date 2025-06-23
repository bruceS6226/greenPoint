import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:green_aplication/config/api_config.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    throw Exception(decoded['message'] ?? 'Error al obtener usuarios');
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> user) async {
    final response = await _authService.post('$_basePath/register', body: user);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception(
      jsonDecode(response.body)['message'] ?? 'Error al registrar el usuario',
    );
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> user) async {
    final response = await _authService.put('$_basePath/update', body: user);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(
      jsonDecode(response.body)['message'] ?? 'Error al actualizar el usuario',
    );
  }

  // obtener usuario por ID
Future<Map<String, dynamic>> getById(int id) async {
  final response = await _authService.get('user/get-by-id', queryParams: {
    'id': id.toString(),
  });

  final decoded = jsonDecode(response.body);

  if (response.statusCode == 200 && decoded['data'] != null) {
    final userData = decoded['data'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SpecificUser', jsonEncode(userData));

    return userData;
  }

  throw Exception(decoded['message'] ?? 'Error al obtener el usuario por ID');
}


  // cambiar estado (activo/inactivo)
Future<bool> changeState(int id) async {
  final response = await _authService.put(
    '$_basePath/change-state',
    queryParams: {'id': id.toString()},
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    if (decoded is bool) return decoded;
    return true;
  }

  throw Exception(
    jsonDecode(response.body)['message'] ?? 'Error al cambiar el estado del usuario',
  );
}

}
