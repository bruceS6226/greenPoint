import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_aplication/main.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/models/tank.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/file_service.dart';
import 'package:green_aplication/services/tank_information_service.dart';
import 'package:green_aplication/widgets/mensajes.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tanques extends StatefulWidget {
  const Tanques({super.key});

  @override
  State<Tanques> createState() => _TanquesState();
}

class _TanquesState extends State<Tanques> with RouteAware {
  late Future<List<Piston>> _pistonsFuture;
  final InformationService _infoService = InformationService();
  Map<String, dynamic>? userData;
  Map<String, dynamic>? machineData;
  Machine? machine;
  List<Piston> pistons = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Este método se llama cuando regresamos a esta pantalla
    setState(() {
      _pistonsFuture = _loadTanksInfo(); // recarga los datos
    });
  }

  @override
  void initState() {
    super.initState();
    _pistonsFuture = _loadTanksInfo();
  }

  Future<List<Piston>> _loadTanksInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('SpecificUser');
    final machineJson = prefs.getString('SpecificMachine');

    if (userJson != null && machineJson != null) {
      userData = jsonDecode(userJson);
      machineData = jsonDecode(machineJson);

      machine = Machine.fromJson(machineData!);

      final int machineId = jsonDecode(machineJson)['id'];
      final response = await _infoService.getTanksInfo(machineId);

      return response.map((e) => Piston.fromJson(e)).toList();
    }

    return []; // si no hay data
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
        margin: const EdgeInsets.only(left: 10, right: 10, top: 90, bottom: 8),
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
              FutureBuilder<List<Piston>>(
                future: _pistonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 260,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No hay tanques disponibles.");
                  }

                  final pistons = snapshot.data!;

                  // Botones de Excel y PDF
                  final buttons = Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final fileService = FileService();
                            final prefs = await SharedPreferences.getInstance();
                            final machine = jsonDecode(
                              prefs.getString('SpecificMachine')!,
                            );

                            final payload = {
                              "machine": {
                                "name": machine['name'],
                                "province": machine['province'],
                                "canton": machine['canton'],
                                "sector": machine['sector'],
                                "address": machine['address'],
                              },
                              "pistons": pistons
                                  .map((e) => e.toJson())
                                  .toList(),
                            };

                            try {
                              final bytes = await fileService.generateTankExcel(
                                payload,
                              );
                              final directory = Directory(
                                '/storage/emulated/0/Download',
                              );
                              final path =
                                  '${directory.path}/${machine['name']}.xlsx';
                              final file = File(path);
                              await file.writeAsBytes(bytes);

                              await OpenFile.open(path);
                              Mensajes.mostrarMensaje(context, 'Excel guardado en: $path', TipoMensaje.success);
                            } catch (e) {
                              Mensajes.mostrarMensaje(context, 'Error al generar PDF: $e', TipoMensaje.error);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF085508),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.file_copy,
                                color: Colors.white,
                                size: 15,
                              ),
                              if (!navBarState.isExpanded) ...[
                                const SizedBox(width: 5),
                                const Text(
                                  'Informe en EXCEL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final fileService = FileService();
                            final prefs = await SharedPreferences.getInstance();
                            final machine = jsonDecode(
                              prefs.getString('SpecificMachine')!,
                            );

                            final payload = {
                              "machine": {
                                "name": machine['name'],
                                "province": machine['province'],
                                "canton": machine['canton'],
                                "sector": machine['sector'],
                                "address": machine['address'],
                              },
                              "pistons": pistons
                                  .map((e) => e.toJson())
                                  .toList(),
                            };

                            try {
                              final bytes = await fileService.generateTankPdf(
                                payload,
                              );
                              final directory = Directory(
                                '/storage/emulated/0/Download',
                              );
                              final path =
                                  '${directory.path}/${machine['name']}.pdf';
                              final file = File(path);
                              await file.writeAsBytes(bytes);
                              await OpenFile.open(path);
                              Mensajes.mostrarMensaje(context, 'PDF guardado en: $path', TipoMensaje.success);
                            } catch (e) {
                              Mensajes.mostrarMensaje(context, 'Error al generar PDF: $e', TipoMensaje.error);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                                size: 15,
                              ),
                              if (!navBarState.isExpanded) ...[
                                const SizedBox(width: 5),
                                const Text(
                                  'Informe en PDF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );

                  // Retorno final del FutureBuilder (botones + lista de tanques)
                  return Column(
                    children: [
                      buttons,
                      const SizedBox(height: 5),
                      ...pistons.map((tank) {
                        return GestureDetector(
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                Positioned(
                                  top: 140,
                                  left: 285,
                                  child: Text(
                                    "${_getPercentage(tank.level)}%",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
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
                                      decoration: BoxDecoration(
                                        color: _getColor(tank.level) == 'green'
                                            ? Colors.green
                                            : _getColor(tank.level) == 'yellow'
                                            ? Colors.yellow
                                            : Colors.red,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              bottom: Radius.circular(20),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          color: Colors.grey.shade200,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Container(
                                          width: levelWidth,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                _getColor(tank.level) == 'green'
                                                ? Colors.green
                                                : _getColor(tank.level) ==
                                                      'yellow'
                                                ? Colors.yellow
                                                : Colors.red,
                                            borderRadius:
                                                const BorderRadius.all(
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
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
