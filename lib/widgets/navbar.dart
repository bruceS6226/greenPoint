import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final Widget child;

  const NavBar({super.key, required this.child});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  Widget buildMenuOption({required IconData icon, required String label}) {
    return GestureDetector(
      onTap: () {
        print('$label presionado');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Color.fromRGBO(8, 85, 8, 1), size: 35),
            //const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromRGBO(8, 85, 8, 1),
                fontSize: 10,
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
            height: 70,
            child: Container(
              color: Color.fromRGBO(8, 85, 8, 1),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Row(
                children: [
                  // Botón hamburguesa flotante solo cuando está cerrado
                  if (!navBarState.isExpanded)
                    Positioned(
                      top: 20,
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            navBarState.expand();
                          });
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
                    width: 5, // espacio total que ocupa el divider
                    indent: 15, // margen arriba
                    endIndent: 15,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              // Menú lateral expandido
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: navBarState.isExpanded ? 70 : 0,
                color: navBarState.isExpanded ? Colors.white : Colors.transparent,
                child: navBarState.isExpanded
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 6,
                              right: 6,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo-punto-verde.png',
                                  height: 90,
                                  fit: BoxFit.contain,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Color.fromRGBO(8, 85, 8, 1),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Gestor de Usuarios",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          buildMenuOption(
                            icon: Icons.group,
                            label: 'Ver Usuarios',
                          ),
                          buildMenuOption(
                            icon: Icons.person_add,
                            label: 'Agregar Usuarios',
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Gestor de Máquinas",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          buildMenuOption(
                            icon: Icons.group,
                            label: 'Ver Máquinas',
                          ),
                          buildMenuOption(
                            icon: Icons.person_add,
                            label: 'Gestionar Máquinas',
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {navBarState.collapse();},
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
                      )
                    : null,
              ),
              // Contenido principal
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
