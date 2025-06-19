import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/widgets/navbar.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);
    return Center(
      child: Opacity(
        opacity: 0.8,
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 78,
            bottom: 8,
          ),
          padding: navBarState.isExpanded
              ? const EdgeInsets.only(top: 50, left: 10, right: 10)
              : const EdgeInsets.only(top: 50, left: 40, right: 40),
          decoration: BoxDecoration(
            color: Color.fromRGBO(8, 85, 8, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Bienvenido al gestor de máquinas de distribución de Punto Green",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white, ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "Para continuar seleccione que desea ver",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(234, 255, 0, 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 70),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.group,
                      color: Color.fromRGBO(8, 85, 8, 1),
                      size: 80,
                    ),
                    Text("Usuarios", style: const TextStyle(fontSize: 22)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 70),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.memory,
                      color: Color.fromRGBO(8, 85, 8, 1),
                      size: 80,
                    ),
                    Text("Maquinas", style: const TextStyle(fontSize: 22)),
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
