import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:provider/provider.dart';

class UsuariosCreados extends StatefulWidget {
  const UsuariosCreados({super.key});

  @override
  State<UsuariosCreados> createState() => _UsuariosCreadosState();
}

class _UsuariosCreadosState extends State<UsuariosCreados> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final service = UserService();
    final List<dynamic> data = await service.getAll();
    return data.map((json) => User.fromJson(json)).toList();
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
                  Text(
                    "Usuarios Creados",
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
                              Navigator.pushNamed(context, "/selectUserType");
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
                              color: Color.fromRGBO(255, 255, 255, 1),
                              size: 30,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, "/selectUserType");
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
                              "Añadir Usuario",
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
              FutureBuilder<List<User>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No hay usuarios disponibles.");
                  }

                  final users = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Tipo')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Identificación')),
                        DataColumn(label: Text('Teléfono')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: users.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(Text(user.id.toString())),
                            DataCell(
                              Text(
                                user.naturalPerson
                                    ? 'Persona natural'
                                    : 'Persona jurídica',
                              ),
                            ),
                            DataCell(Text(user.email.toString())),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.identification)),
                            DataCell(Text(user.phone)),
                            DataCell(Text(user.phone)),
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
