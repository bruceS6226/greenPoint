import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeleccionarUsuario extends StatefulWidget {
  const SeleccionarUsuario({super.key});

  @override
  State<SeleccionarUsuario> createState() => _SeleccionarUsuarioState();
}

class _SeleccionarUsuarioState extends State<SeleccionarUsuario> {
  final UserService _userService = UserService();
  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await _userService.getAll();
    setState(() {
      _users = data.map((json) => User.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  Future<void> _saveSelectedUser() async {
    if (_selectedUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SpecificUser', jsonEncode(_selectedUser!.toJson()));

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/addMachine');
    }
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
                titulo: "Agregar máquina",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/createdMachines",
              ),

              const SizedBox(height: 25),
              _isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height - 260,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Primero seleccione a qué usuario desea asignar la máquina",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<User>(
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _users.map((user) {
                              return DropdownMenuItem<User>(
                                value: user,
                                child: Text(user.name),
                              );
                            }).toList(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            value: _selectedUser,
                            onChanged: (user) {
                              setState(() {
                                _selectedUser = user;
                              });
                            },
                            hint: Text('Seleccione un usuario'),
                            validator: (value) => value == null
                                ? 'Debe seleccionar un usuario'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveSelectedUser(); // Solo se llama si todo está validado
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                14,
                                145,
                                14,
                                1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
