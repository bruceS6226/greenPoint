import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBarMaquina extends StatefulWidget {
  final Widget child;

  const NavBarMaquina({super.key, required this.child});

  @override
  State<NavBarMaquina> createState() => _NavBarMaquinaState();
}

class _NavBarMaquinaState extends State<NavBarMaquina> {
  User? user;
  Machine? machine;

  @override
  void initState() {
    super.initState();
    _loadSpecificUserAndMachine();
  }

  Map<String, dynamic>? userData;
  Map<String, dynamic>? machineData;

  Future<void> _loadSpecificUserAndMachine() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUserString = prefs.getString('SpecificUser');
    final jsonMachineString = prefs.getString('SpecificMachine');

    if (jsonUserString != null && jsonMachineString != null) {
      setState(() {
        userData = jsonDecode(jsonUserString);
        machineData = jsonDecode(jsonMachineString);
        user = User.fromJson(userData!);
        machine = Machine.fromJson(machineData!);
      });
    }
  }

  Widget buildMenuOption({
    required IconData icon,
    required String label,
    required String? ruta,
    required String? currentRoute,
  }) {
    bool isActive = ruta == currentRoute;
    if (currentRoute == ruta) {
      isActive = ruta == currentRoute;
    } else {
      if (currentRoute!.contains('tank') && ruta == '/tanks') {
        isActive = true;
      } else {
        isActive = false;
      }
    }
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamed(context, ruta!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Colors.green.shade900
                  : const Color.fromRGBO(8, 85, 8, 1),
              size: 35,
            ),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.green.shade900
                    : const Color.fromRGBO(8, 85, 8, 1),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || machine == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final navBarState = Provider.of<NavBarState>(context);
    final AuthService authService = AuthService();
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/punto-green-fondo.webp"),
                fit: BoxFit.cover,
                alignment: Alignment(-0.8, 0),
              ),
            ),
          ),
          // Barra de arriba
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 85,
            child: Container(
              color: Color.fromRGBO(8, 85, 8, 1),
              padding: const EdgeInsets.only(left: 5, right: 5, top: 25),
              child: Row(
                children: [
                  if (!navBarState.isExpanded) ...[
                    GestureDetector(
                      onTap: () {
                        navBarState.expand();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          machine!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          user!.name,
                          style: const TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const Spacer(), // Empuja los iconos a la derecha
                  // Iconos a la derecha
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.white,
                    width: 5,
                    indent: 15,
                    endIndent: 15,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: const [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 48,
                              ),
                              SizedBox(height: 10),
                              Text('¿Estás seguro que deseas cerrar sesión?'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Cierra el diálogo
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Cierra el diálogo
                                authService.logout(
                                  context,
                                ); // Ejecuta el logout
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              // Menú lateral expandido
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: navBarState.isExpanded ? 77 : 0,
                color: navBarState.isExpanded
                    ? Colors.white
                    : Colors.transparent,
                child: navBarState.isExpanded
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            // Menú scrollable
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/welcome',
                                          );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/images/logo-punto-verde.png',
                                              height: 90,
                                              fit: BoxFit.contain,
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              color: Color.fromRGBO(
                                                8,
                                                85,
                                                8,
                                                1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Gestor de Máquinas",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    buildMenuOption(
                                      icon: Icons.battery_full,
                                      label: 'Nivel de Tanques',
                                      ruta: '/tanks',
                                      currentRoute: currentRoute,
                                    ),
                                    buildMenuOption(
                                      icon: Icons.sell,
                                      label: 'Consulta de Ventas',
                                      ruta: '/daySales',
                                      currentRoute: currentRoute,
                                    ),
                                    const SizedBox(height: 5),
                                    buildMenuOption(
                                      icon: Icons.attach_money,
                                      label: 'Ventas Totales',
                                      ruta: '',
                                      currentRoute: currentRoute,
                                    ),
                                    buildMenuOption(
                                      icon: Icons.insert_chart,
                                      label: 'Estadísticas Generales',
                                      ruta: '',
                                      currentRoute: currentRoute,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            buildMenuOption(
                              icon: Icons.settings,
                              label: 'Configuración Máquina',
                              ruta: '/updateMachine',
                              currentRoute: currentRoute,
                            ),
                            const SizedBox(height: 5),
                            // Botón colapsar y configurar al fondo
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      navBarState.collapse();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(8, 85, 8, 1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              // Contenido principal
              Expanded(child: widget.child),
            ],
          ),
        ],
      ),
    );
  }
}
