import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isExpanded = false;

  Widget buildMenuOption({required IconData icon, required String label}) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes manejar navegación o acciones
        print('$label presionado');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: isExpanded
            ? Row(
                children: [
                  Icon(icon, color: Color.fromRGBO(8, 85, 8, 1), size: 30),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(color: Color.fromRGBO(8, 85, 8, 1), fontSize: 20),
                  ),
                ],
              )
            : Icon(icon, color: Color.fromRGBO(8, 85, 8, 1), size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '10',
                    style: TextStyle(
                      fontSize: 160,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'rfr',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Menú lateral flotante
          AnimatedPositioned(
            // Dentro del AnimatedPositioned
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            left: 0,
            width: isExpanded ? 350 : 70,
            // Dentro del AnimatedPositioned
            child: Container(
              color: Colors.white,
              child: Column(
                // Distribuye arriba/abajo
                children: [
                  // Parte superior (logo o lo que quieras)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      isExpanded
                          ? 'assets/images/logo-horizontal-03.webp'
                          : 'assets/images/logo-punto-verde.png',
                      width: double.infinity, // Ajusta tamaño según tu diseño
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        buildMenuOption(icon: Icons.home, label: 'Inicio'),
                        buildMenuOption(
                          icon: Icons.settings,
                          label: 'Configuración',
                        ),
                        buildMenuOption(icon: Icons.info, label: 'Acerca de'),
                      ],
                    ),
                  ),
                  // Parte inferior (botón de flecha)
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(8, 85, 8, 1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpanded
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}
