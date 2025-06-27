import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final Widget child;

  const NavBar({super.key, required this.child});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Widget buildMenuOption({
    required IconData icon,
    required String label,
    required String ruta,
    required String? currentRoute,
  }) {
    bool isActive;
    if ((currentRoute!.contains('Users') ||
            currentRoute.contains('Machines')) &&
        !currentRoute.contains('userSelection')) {
      isActive = ruta == currentRoute;
    } else {
      if (((currentRoute.contains('user') ||
          currentRoute.contains('User')) &&
        !currentRoute.contains('userSelection')) && ruta == '/selectUserType') {
        isActive = true;
      } else {
        if ((currentRoute.contains('machine') ||
            currentRoute.contains('Machine') ||
            currentRoute.contains('userSelection')) &&
                ruta == '/userSelection') {
          isActive = true;
        } else {
          isActive = false;
        }
      }
    }
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamed(context, ruta);
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
            height: 80,
            child: Container(
              color: Color.fromRGBO(8, 85, 8, 1),
              padding: const EdgeInsets.only(left: 5, right: 5, top: 25),
              child: Row(
                children: [
                  // Botón hamburguesa flotante solo cuando está cerrado
                  if (!navBarState.isExpanded)
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
                  Spacer(), // Empuja los iconos a la derecha
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
                                      "Gestor de Usuarios",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    buildMenuOption(
                                      icon: Icons.group,
                                      label: 'Ver Usuarios',
                                      ruta: '/createdUsers',
                                      currentRoute: currentRoute,
                                    ),
                                    buildMenuOption(
                                      icon: Icons.person_add,
                                      label: 'Agregar Usuarios',
                                      ruta: '/selectUserType',
                                      currentRoute: currentRoute,
                                    ),
                                    const SizedBox(height: 15),
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
                                      icon: Icons.group,
                                      label: 'Ver Máquinas',
                                      ruta: '/createdMachines',
                                      currentRoute: currentRoute,
                                    ),
                                    buildMenuOption(
                                      icon: Icons.person_add,
                                      label: 'Gestionar Máquinas',
                                      ruta: '/userSelection',
                                      currentRoute: currentRoute,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Botón colapsar al fondo
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
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
