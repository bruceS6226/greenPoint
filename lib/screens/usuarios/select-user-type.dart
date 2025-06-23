import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
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
              Row(
                children: [
                  Text(
                    "Agregar Usuario",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: navBarState.isExpanded ? 43 : 180,
                    child: navBarState.isExpanded
                        ? IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/createdUsers");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(14,145,14,1,),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(6),
                            ),icon: const Icon(
                                Icons.arrow_back,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                size: 30,
                              ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, "/createdUsers");
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Color.fromRGBO(14, 145, 14, 1),
                                size: 22,
                              ),
                            ),
                            label: const Text(
                              "Regresar",
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
                      context, '/naturalPerson'
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
                      context, '/legalPerson'
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
