import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformacion extends StatefulWidget {
  const UserInformacion({super.key});

  @override
  State<UserInformacion> createState() => _UserInformacionState();
}

class _UserInformacionState extends State<UserInformacion> {
  User? _user;
  List<Machine> _machines = [];

  @override
  void initState() {
    super.initState();
    _loadSpecificUser();
  }

  Future<void> _loadMachines(int userId) async {
    try {
      print(userId);
      final machineService = MachineService();
      final data = await machineService.getByUserId(userId);
      setState(() {
        _machines = data
            .map<Machine>((json) => Machine.fromJson(json))
            .toList();
      });
    } catch (e) {
      print("Error cargando máquinas: $e");
    }
  }

  Future<void> _loadSpecificUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('SpecificUser');

    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      final user = User.fromJson(jsonData);
      setState(() {
        _user = user;
      });
      await _loadMachines(user.id);
    }
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
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MiniEncabezado(
                      titulo: "Información Usuario",
                      icono: Icons.arrow_back,
                      textoBoton: "Regresar",
                      ruta: "/createdUsers",
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(234, 234, 234, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow(
                            "Tipo de Cliente:",
                            _user!.naturalPerson ? "Natural" : "Jurídico",
                          ),
                          infoRow("Rol:", _user!.role),
                          infoRow("Nombre:", _user!.name),
                          infoRow("Identificación:", _user!.identification),
                          infoRow("Email:", _user!.email),
                          infoRow("Teléfono:", _user!.phone),
                          infoRow("Dirección:", _user!.address),
                          infoRow("Género:", _user!.gender),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Máquinas Registradas",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _machines.isEmpty
                        ? const Text(
                            "Este usuario no tiene máquinas registradas.",
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16,
                              headingRowColor: WidgetStateProperty.all<Color>(
                                const Color.fromRGBO(234, 234, 234, 1),
                              ),
                              columns: const [
                                DataColumn(label: Text('#')),
                                DataColumn(label: Text('Nombre Máquina')),
                                DataColumn(label: Text('Cantón')),
                                DataColumn(label: Text('Sector')),
                                DataColumn(label: Text('Dirección')),
                                DataColumn(label: Text('Estado')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: _machines.map((machine) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(machine.id?.toString() ?? '-'),
                                    ),
                                    DataCell(Text(machine.name)),
                                    DataCell(Text(machine.canton)),
                                    DataCell(Text(machine.sector)),
                                    DataCell(Text(machine.address)),
                                    DataCell(
                                      Text(
                                        machine.active ? 'Activo' : 'Inactivo',
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
                                            tooltip: 'Ver',
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
