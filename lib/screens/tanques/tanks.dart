import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_aplication/models/tank.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/tank_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tanques extends StatefulWidget {
  const Tanques({super.key});

  @override
  State<Tanques> createState() => _TanquesState();
}

class _TanquesState extends State<Tanques> {
  late List<Piston> pistons = [];
  final InformationService _infoService = InformationService();
  //final WebSocketService _webSocketService = WebSocketService();
  Map<String, dynamic>? userData;
  Map<String, dynamic>? machineData;

  @override
  void initState() {
    super.initState();
    _loadTankInfo();
  }

  void _loadTankInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString('SpecificUser');
    final machineJson = prefs.getString('SpecificMachine');

    if (userJson != null && machineJson != null) {
      setState(() {
        userData = jsonDecode(userJson);
        machineData = jsonDecode(machineJson);
      });

      final int machineId = jsonDecode(machineJson)['id'];
      final response = await _infoService.getTankInfo(machineId);

      setState(() {
        pistons = response.map((e) => Piston.fromJson(e)).toList();
      });
    }
  }

  void _downloadExcel() {
    // lógica real para descargar
  }

  void _downloadPdf() {
    // lógica real para descargar
  }

  String _getColor(int level) {
    if (level >= 100) return 'green';
    if (level >= 20) return 'yellow';
    return 'red';
  }

  double _getPercentage(int liters) => liters / 2;

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 78, bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // mini encabezado
              MiniEncabezado(
                titulo: "Nivel de Tanques",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/createdMachines",
              ),

              // cuerpo
              const SizedBox(height: 16),
              Column(
                children: [
                  const SizedBox(height: 15),
                  navBarState.isExpanded
                      ? Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF085508),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centrar el contenido
                                  children: const [
                                    Icon(
                                      Icons.file_copy,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centrar el contenido
                                  children: const [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF085508),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centrar el contenido
                                  children: const [
                                    Icon(
                                      Icons.file_copy,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Informe en EXCEL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centrar el contenido
                                  children: const [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Informe en PDF',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 5),
                  ...pistons.map(
                    (tank) => GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                          'specificTank',
                          jsonEncode(tank.toJson()),
                        );
                        Navigator.pushNamed(context, '/tankInformation');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/Tanque2.png',
                                  width: 78,
                                  height: 180,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF042504),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          tank.name,
                                          style: const TextStyle(
                                            color: Color(0xFFEAFF00),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        tank.product,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${tank.level} lt / 200 lt'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Porcentaje
                            Positioned(
                              top: 140,
                              left: 288,
                              child: Text(
                                "${_getPercentage(tank.level)}%",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            // Barra tanque
                            Positioned(
                              top: 49,
                              left: 15,
                              child: Container(
                                width: 53,
                                height: 100,
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(18),
                                  ),
                                  color: Colors.grey.shade200,
                                ),
                                child: Container(
                                  height: tank.level / 2,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _getColor(tank.level) == 'green'
                                        ? Colors.green
                                        : _getColor(tank.level) == 'yellow'
                                        ? Colors.yellow
                                        : Colors.red,
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Barra horizontal
                            Positioned(
                              top: 165,
                              left: 10,
                              right: 10,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double maxWidth = constraints.maxWidth;
                                  double levelWidth =
                                      (tank.level / 200) * maxWidth;

                                  return Container(
                                    height: 15,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      width: levelWidth,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _getColor(tank.level) == 'green'
                                            ? Colors.green
                                            : _getColor(tank.level) == 'yellow'
                                            ? Colors.yellow
                                            : Colors.red,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
