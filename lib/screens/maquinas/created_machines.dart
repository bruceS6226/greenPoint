import 'package:flutter/material.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:provider/provider.dart';

class MaquinasCreadas extends StatefulWidget {
  const MaquinasCreadas({super.key});

  @override
  State<MaquinasCreadas> createState() => _MaquinasCreadasState();
}

class _MaquinasCreadasState extends State<MaquinasCreadas> {
  late Future<void> _initDataFuture;
  List<Machine> machines = [];
  Map<int, String> userNamesById = {};

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadMachinesAndUsers();
  }

  Future<void> _loadMachinesAndUsers() async {
    final machineService = MachineService();
    final userService = UserService();

    final rawMachineList = await machineService.getAll();
    final userList = await userService.getAll();

    setState(() {
      machines = rawMachineList.map((json) => Machine.fromJson(json)).toList();
      userNamesById = {
        for (var userJson in userList)
          userJson['id'] as int: userJson['name'] as String,
      };
    });
  }

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
              Row(
                children: [
                  const Text(
                    "Máquinas Creadas",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: navBarState.isExpanded ? 43 : 200,
                    child: navBarState.isExpanded
                        ? IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/userSelection");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                14,
                                145,
                                14,
                                1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(6),
                            ),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, "/userSelection");
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color.fromRGBO(14, 145, 14, 1),
                                size: 22,
                              ),
                            ),
                            label: const Text(
                              "Añadir Máquina",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                14,
                                145,
                                14,
                                1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                  ),
                ],
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
                        DataColumn(
                          label: Text('Nombre del Cliente'),
                        ), // Nueva columna
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
                            ), // Aquí
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    ),
                                    tooltip: 'Ver detalles',
                                    onPressed: () {
                                      // Acción al ver detalles
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
