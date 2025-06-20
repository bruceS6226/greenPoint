import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class PersonaNatural extends StatefulWidget {
  const PersonaNatural({super.key});

  @override
  State<PersonaNatural> createState() => _PersonaNaturalState();
}

class _PersonaNaturalState extends State<PersonaNatural> {
  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 16, color: Colors.black38),
      ),
      labelStyle: const TextStyle(color: Colors.black87),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(14, 145, 14, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(14, 145, 14, 1), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController _roleController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _identificationController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _genderController = TextEditingController();

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    width: navBarState.isExpanded ? 43 : 200,
                    child: navBarState.isExpanded
                        ? IconButton(
                            onPressed: () {
                              
                              Navigator.pushNamed(context, "/selectUserType");
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
                              Navigator.pushNamed(context, "/selectUserType");
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tipo Cliente
                      TextFormField(
                        initialValue: 'Persona Natural',
                        decoration: _inputDecoration(
                          "Tipo Cliente",
                          "Ingrese su tipo de cliente",
                        ),
                        enabled:
                            false, // ← Lo hace no editable, pero conserva el estilo de input
                      ),
                      const SizedBox(height: 12),

                      // Rol
                      DropdownButtonFormField<String>(
                        
                        decoration: _inputDecoration("Rol", ""),
                        items: const [
                          DropdownMenuItem(
                            value: 'ADMIN',
                            child: Text('ADMIN'),
                          ),
                          DropdownMenuItem(value: 'USER', child: Text('USER')),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Rol requerido';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 12),

                      // Nombre Cliente
                      TextFormField(
                        decoration: _inputDecoration(
                          "Nombre Cliente",
                          "Ingrese su nombre de cliente",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nombre del cliente requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Cédula / Pasaporte
                      TextFormField(
                        decoration: _inputDecoration(
                          "Cédula / Pasaporte",
                          "Ingrese su cédula ó pasaporte",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Cédula ó pasaporte requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Correo Electrónico
                      TextFormField(
                        decoration: _inputDecoration(
                          "Correo Electrónico",
                          "Ingrese su correo electrónico",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Correo electrónico requerido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      // Teléfono
                      TextFormField(
                        decoration: _inputDecoration(
                          "Teléfono",
                          "Ingrese su teléfono",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Teléfono requerido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // Dirección
                      TextFormField(
                        decoration: _inputDecoration(
                          "Dirección",
                          "Ingrese su dirección",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Dirección requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Género
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration(
                          "Género",
                          "Seleccione su género",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Género requerido';
                          }
                          return null;
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Masculino',
                            child: Text('Masculino'),
                          ),
                          DropdownMenuItem(
                            value: 'Femenino',
                            child: Text('Femenino'),
                          ),
                          DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                        ],
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),

                      // Botón registrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // Todos los campos fueron completados correctamente
                              // Ejecuta la acción de registro aquí
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
                            "Registrar Usuario",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
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
