import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';

class MaquinasCreadas extends StatefulWidget {
  const MaquinasCreadas({super.key});

  @override
  State<MaquinasCreadas> createState() => _MaquinasCreadasState();
}

class _MaquinasCreadasState extends State<MaquinasCreadas> {
  late Future<void> _initDataFuture;
  List<Machine> machines = [];
  List<Map<String, dynamic>> allUsers = []; // Lista completa de usuarios
  Map<int, String> userNamesById = {}; // Para mostrar nombre en la tabla

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadMachinesAndUsers();
  }

Future<void> _loadMachinesAndUsers() async {
  final machineService = MachineService();
  final userService = UserService();

  final rawMachineList = await machineService.getAll();
  final List<Map<String, dynamic>> userList =
      List<Map<String, dynamic>>.from(await userService.getAll());

  setState(() {
    machines = rawMachineList.map((json) => Machine.fromJson(json)).toList();
    allUsers = userList;
    userNamesById = {
      for (var userJson in userList)
        userJson['id'] as int: userJson['name'] as String,
    };
  });
}

  @override
  Widget build(BuildContext context) {
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
              MiniEncabezado(
                titulo: "Máquinas Creadas",
                icono: Icons.add,
                textoBoton: "Añadir Máquina",
                ruta: "/userSelection",
              ),
              const SizedBox(height: 16),
              FutureBuilder<void>(
                future: _initDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      headingRowColor: WidgetStateProperty.all<Color>(
                        const Color.fromRGBO(234, 234, 234, 1),
                      ),
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Provincia')),
                        DataColumn(label: Text('Cantón')),
                        DataColumn(label: Text('Sector')),
                        DataColumn(label: Text('Dirección')),
                        DataColumn(label: Text('Nombre del Cliente')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: machines.map((machine) {
                        return DataRow(
                          cells: [
                            DataCell(Text(machine.id?.toString() ?? '-')),
                            DataCell(Text(machine.name)),
                            DataCell(Text(machine.province)),
                            DataCell(Text(machine.canton)),
                            DataCell(Text(machine.sector)),
                            DataCell(Text(machine.address)),
                            DataCell(
                              Text(
                                userNamesById[machine.userId] ?? 'Desconocido',
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      final selectedUser = allUsers.firstWhere(
                                        (user) => user['id'] == machine.userId,
                                        orElse: () => {},
                                      );
                                      await prefs.setString(
                                        'SpecificMachine',
                                        jsonEncode(machine.toJson()),
                                      );
                                      await prefs.setString(
                                        'SpecificUser',
                                        jsonEncode(selectedUser),
                                      );
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/tanks',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
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