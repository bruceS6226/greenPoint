import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_aplication/config/api_config.dart';

class AuthService {
  final Uri apiBase = Uri.parse(apiUrl);
  String? _sessionCookie;

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? get sessionCookie => _sessionCookie;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionCookie = prefs.getString('sessionCookie');
  }

  bool get isLoggedIn => _sessionCookie != null;

  Future<void> login(String usuario, String password) async {
    final Uri url = apiBase.replace(path: '${apiBase.path}user/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': usuario, 'password': password}),
    );

    if (response.statusCode == 200) {
      final rawCookie = response.headers['set-cookie'];
      if (rawCookie != null) {
        _sessionCookie = rawCookie.split(';').first;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sessionCookie', _sessionCookie!);
      }
    } else {
      final msg =
          jsonDecode(response.body)['message'] ?? 'Error de autenticación';
      throw ('Login fallido: $msg');
    }
  }

Future<http.Response> get(String endpoint, {BuildContext? context}) async {
  if (_sessionCookie == null) throw Exception('Sesión no iniciada');

  final url = apiBase.replace(path: '${apiBase.path}$endpoint');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Cookie': _sessionCookie!,
  });

  if (response.statusCode == 401 || response.statusCode == 403) {
    await logout();

    // Muestra alerta si se proporcionó contexto
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sesión expirada'),
          content: const Text('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }

    throw Exception('Sesión expirada');
  }

  return response;
}

// auth_service.dart
Future<http.Response> post(
  String endpoint, {
  Map<String, dynamic>? body,
  BuildContext? context,
}) async {
  if (_sessionCookie == null) throw Exception('Sesión no iniciada');

  final url = apiBase.replace(path: '${apiBase.path}$endpoint');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': _sessionCookie!,
    },
    body: jsonEncode(body ?? {}),
  );

  if (response.statusCode == 401 || response.statusCode == 403) {
    await logout(context);
    throw Exception('Sesión expirada');
  }

  return response;
}

Future<http.Response> put(
  String endpoint, {
  Map<String, dynamic>? body,
  BuildContext? context,
}) async {
  if (_sessionCookie == null) throw Exception('Sesión no iniciada');

  final url = apiBase.replace(path: '${apiBase.path}$endpoint');
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': _sessionCookie!,
    },
    body: jsonEncode(body ?? {}),
  );

  if (response.statusCode == 401 || response.statusCode == 403) {
    await logout(context);
    throw Exception('Sesión expirada');
  }

  return response;
}


  Future<void> logout([BuildContext? context]) async {
  _sessionCookie = null;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('sessionCookie');

  if (context != null && context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

}
