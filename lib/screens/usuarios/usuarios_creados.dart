import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';

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
              MiniEncabezado(
                titulo: "Usuarios Creados",
                icono: Icons.add,
                textoBoton: "Añadir Usuario",
                ruta: "/selectUserType",
              ),

              const SizedBox(height: 16),
              FutureBuilder<List<User>>(
                future: _usersFuture,
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
                    return const Text("No hay usuarios disponibles.");
                  }

                  final users = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      headingRowColor: WidgetStateProperty.all<Color>(
                        Color.fromRGBO(
                          234,
                          234,
                          234,
                          1,
                        ), // o cualquier otro color
                      ),
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
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      user.active
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: user.active
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    tooltip: user.active
                                        ? 'Activo'
                                        : 'Inactivo',
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Column(
                                            children: [
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.orange,
                                                size: 48,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '¿Estás seguro que deseas ${user.active ? 'desactivar' : 'activar'} al usuario "${user.name}"?',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(false),
                                              child: const Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueAccent,
                                              ),
                                              child: const Text(
                                                'Aceptar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm != true) return;

                                      try {
                                        final userService = UserService();
                                        await userService.changeState(user.id);

                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            "/createdUsers",
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(e.toString()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cerrar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    ),
                                    tooltip: 'Ver',
                                    onPressed: () async {
                                      try {
                                        final userService = UserService();
                                        await userService.getById(user.id);

                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            "/userInfo",
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(e.toString()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cerrar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    tooltip: 'Editar',
                                    onPressed: () async {
                                      try {
                                        final userService = UserService();
                                        await userService.getById(user.id);

                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            "/updateUser",
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(e.toString()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cerrar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
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
