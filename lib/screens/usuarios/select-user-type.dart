import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:provider/provider.dart';

class SeleccionarTipoUsuario extends StatelessWidget {
  const SeleccionarTipoUsuario({super.key});

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
              
              MiniEncabezado(
                titulo: "Agregar Usuario",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/createdUsers",
              ),

              const SizedBox(height: 20),
              Text(
                "Primero seleccione que tipo de usuario desea registrar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 210,
                margin:
                navBarState.isExpanded
                ? EdgeInsets.symmetric(horizontal: 40)
                :EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, '/naturalUser'
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.person,
                        color: Color.fromRGBO(8, 85, 8, 1),
                        size: 110,
                      ),
                      Text(
                        "Persona Natural",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 210,
                margin:
                navBarState.isExpanded
                ? EdgeInsets.symmetric(horizontal: 40)
                :EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, '/legalUser'
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.corporate_fare,
                        color: Color.fromRGBO(8, 85, 8, 1),
                        size: 110,
                      ),
                      Text(
                        "Empresa",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
