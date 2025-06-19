import 'dart:convert';
import 'package:green_aplication/config/api_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final apiBase = Uri.parse(apiUrl);

  Future<void> login(String usuario, String password) async {
    final Uri url = apiBase.replace(
      path: '${apiBase.path}user/auth/login',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': usuario, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Login exitoso
      return;
    } else if (response.statusCode == 403 || response.statusCode == 500) {
      final message =
          jsonDecode(response.body)['message'] ??
          'Credenciales inválidas o usuario inactivo';
      throw ('Acceso denegado: $message');
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}
