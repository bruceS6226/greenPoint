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
      final responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();

      if (rawCookie != null) {
        _sessionCookie = rawCookie.split(';').first;

        prefs.setString('sessionCookie', _sessionCookie!);
      }

      final userData = responseData['data'];
      prefs.setString('user', jsonEncode(userData));
    } else {
      final msg =
          jsonDecode(response.body)['message'] ?? 'Error de autenticación';
      throw ('Login fallido: $msg');
    }
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
    BuildContext? context,
  }) async {
    final url = Uri.parse(
      '$apiUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return _handleAuthRequest(
      () => http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': _sessionCookie!,
        },
      ),
      context: context,
    );
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    BuildContext? context,
  }) async {
    final url = Uri.parse('$apiUrl$endpoint');
    return _handleAuthRequest(
      () => http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': _sessionCookie!,
        },
        body: jsonEncode(body ?? {}),
      ),
      context: context,
    );
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    BuildContext? context,
  }) async {
    final url = Uri.parse(
      '$apiUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return _handleAuthRequest(
      () => http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': _sessionCookie!,
        },
        body: jsonEncode(body ?? {}),
      ),
      context: context,
    );
  }

  Future<void> logout([BuildContext? context]) async {
    _sessionCookie = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionCookie');

    if (context != null && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  bool _isRefreshing = false;

  Future<bool> refreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final url = Uri.parse('$apiUrl/user/auth/refresh');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      _isRefreshing = false;

      if (response.statusCode == 200) {
        final rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          _sessionCookie = rawCookie.split(';').first;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionCookie', _sessionCookie!);
          return true;
        }
        return true;
      }

      return false;
    } catch (_) {
      _isRefreshing = false;
      return false;
    }
  }

  Future<http.Response> _handleAuthRequest(
    Future<http.Response> Function() request, {
    BuildContext? context,
  }) async {
    final response = await request();

    if (response.statusCode == 401 || response.statusCode == 403) {
      final refreshed = await refreshToken();
      if (refreshed) {
        return await request(); // Reintenta
      } else {
        await logout(context);
        if (context != null && context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        }
        throw Exception('Sesión expirada');
      }
    }

    return response;
  }

  Future<void> requestPasswordChange(String email) async {
  final url = Uri.parse('${apiUrl}user/forgot-password')
      .replace(queryParameters: {'email': email});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) {
    final msg = jsonDecode(response.body)['message'] ?? 'Error al solicitar recuperación';
    throw Exception(msg);
  }
}

Future<void> resetPassword(String token, String newPassword) async {
  final url = Uri.parse('$apiUrl/reset-password')
      .replace(queryParameters: {'token': token});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newPassword': newPassword}),
  );

  if (response.statusCode != 200) {
    final msg = jsonDecode(response.body)['message'] ?? 'Error al restablecer contraseña';
    throw Exception(msg);
  }
}

}
