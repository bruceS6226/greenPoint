import 'dart:convert';
import 'package:green_aplication/services/auth_service.dart';

class InformationService {
  final String _basePath = 'information';
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getTanksInfo(int machineId) async {
    final response = await _authService.get('$_basePath/tank-info', queryParams: {
      'machineId': machineId.toString(),
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Error al obtener información del tanque');
  }

  Future<List<dynamic>> getTotalInfo(int machineId) async {
    final response = await _authService.get('$_basePath/bills', queryParams: {
      'machineId': machineId.toString(),
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Error al obtener información total');
  }

  Future<List<dynamic>> getStatisticsInfo(int machineId) async {
    final response = await _authService.get('$_basePath/statistics', queryParams: {
      'machineId': machineId.toString(),
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Error al obtener estadísticas');
  }

  Future<List<dynamic>> getSalesInfo(int machineId, String date) async {
    final response = await _authService.get('$_basePath/sales', queryParams: {
      'machineId': machineId.toString(), 'date': date,
    });

    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Error al obtener ventas');
  }

  Future<List<dynamic>> getBillsInfo(int machineId) async {
    final response = await _authService.get('$_basePath/bills-by-date', queryParams: {
      'machineId': machineId.toString(),
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Error al obtener facturas');
  }
/*
  Future<void> updateEntities(int id) async {
    final response = await _authService.post('$_basePath/update-entities', body: id);

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Error al actualizar entidades');
    }
  }
  */
}
