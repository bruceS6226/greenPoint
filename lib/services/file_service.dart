import 'dart:typed_data';
import 'package:green_aplication/services/auth_service.dart';

class FileService {
  final String _basePath = 'file';
  final AuthService _authService = AuthService();

  Future<Uint8List> generateTankExcel(Map<String, dynamic> tankFileInfo) async {
    final response = await _authService.post(
      '$_basePath/tank-excel',
      body: tankFileInfo,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Error al generar el archivo Excel');
  }

  Future<Uint8List> generateTankPdf(Map<String, dynamic> tankFileInfo) async {
    final response = await _authService.post(
      '$_basePath/tank-pdf',
      body: tankFileInfo,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Error al generar el archivo PDF');
  }
}
