import 'dart:convert';
import 'package:green_aplication/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MachineService {
  final String _basePath = 'machine';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> create(Map<String, dynamic> machine) async {
    final response = await _authService.post(
      '$_basePath/create',
      body: machine,
    );
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final machineData = decoded['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('SpecificMachine', jsonEncode(machineData));
      return machineData;
    }

    throw Exception(
      jsonDecode(response.body)['message'] ?? 'Error al crear la máquina',
    );
  }
  
Future<bool> update(Map<String, dynamic> machine) async {
  final response = await _authService.put('$_basePath/update', body: machine);

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return true;
  }

  final decoded = jsonDecode(response.body);
  throw Exception(
    decoded['message'] ?? 'Error al actualizar la máquina',
  );
}


  Future<Map<String, dynamic>> getById(int id) async {
    final response = await _authService.get(
      '$_basePath/get-by-id',
      queryParams: {'id': id.toString()},
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded.containsKey('data')) {
      return decoded['data'];
    }

    throw Exception(decoded['message'] ?? 'Error al obtener la máquina por ID');
  }

  Future<List<dynamic>> getByUserId(int userId) async {
    final response = await _authService.get(
      '$_basePath/get-by-user',
      queryParams: {'userId': userId.toString()},
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded.containsKey('data')) {
      return decoded['data'];
    }

    throw Exception(
      decoded['message'] ?? 'Error al obtener máquinas por usuario',
    );
  }

  Future<List<dynamic>> getAll() async {
    final response = await _authService.get('$_basePath/get-all');

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded.containsKey('data')) {
      return decoded['data'];
    }

    throw Exception(decoded['message'] ?? 'Error al obtener las máquinas');
  }



  Future<bool> updateStatus(int id) async {
    final response = await _authService.put(
      '$_basePath/update-status',
      body: {
        'id': id,
      }, // asumimos que tu backend espera un body, no query param
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is bool) return decoded;
      return true;
    }

    throw Exception(
      jsonDecode(response.body)['message'] ??
          'Error al cambiar el estado de la máquina',
    );
  }

  Future<Map<String, dynamic>> updateTankLevel({
    required int machineId,
    required String product,
    required int level,
  }) async {
    final body = {'machineId': machineId, 'product': product, 'level': level};

    final response = await _authService.put(
      '$_basePath/update-tank',
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception(
      jsonDecode(response.body)['message'] ??
          'Error al actualizar el nivel del tanque',
    );
  }
}
