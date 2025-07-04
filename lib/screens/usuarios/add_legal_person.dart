import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mensajes.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
class PersonaLegal extends StatefulWidget {
  const PersonaLegal({super.key});

  @override
  State<PersonaLegal> createState() => _PersonaLegalState();
}

class _PersonaLegalState extends State<PersonaLegal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _identificationController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  String? _selectedRole;
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _identificationController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identificationController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newUser = UserRequest(
          id: 0,
          email: _emailController.text,
          name: _nameController.text,
          password: '',
          identification: _identificationController.text,
          phone: _phoneController.text,
          gender: '',
          address: _addressController.text,
          isNaturalPerson: false,
          role: _selectedRole ?? 'USER',
          isActive: true,
        );

        final response = await _userService.register(newUser.toJson());

        if (response['id'] != null) {
          Mensajes.mostrarMensaje(
            context,
            'El  "${response['name']}" ha sido registrado correctamente.',
            TipoMensaje.success,
          );
        } else {
          Mensajes.mostrarMensaje(
            context,
            'Error desconocido al registrar el usuario.',
            TipoMensaje.error,
          );
        }
        // ✅ Diálogo con redirección
      } catch (e) {
        if (mounted) {
          Mensajes.mostrarMensaje(
            context,
            'Error al registrar: $e',
            TipoMensaje.error,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniEncabezado(
                titulo: "Agregar Usuario",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/selectUserType",
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tipo Cliente
                      TextFormField(
                        initialValue: 'Persona Jurídica',
                        decoration: _inputDecoration(
                          "Tipo Cliente",
                          "Ingrese su tipo de cliente",
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 12),

                      // Rol
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
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
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        hint: Text('Seleccione un rol'),
                      ),
                      const SizedBox(height: 12),

                      // Nombre Cliente
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          "Nombre de la Persona Jurídica",
                          "Ingrese su nombre",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nombre de la persona jurídica requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Cédula / Pasaporte
                      TextFormField(
                        controller: _identificationController,
                        decoration: _inputDecoration("RUC", "Ingrese su RUC"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'RUC requerido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // Correo Electrónico
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration(
                          "Correo Electrónico",
                          "Ingrese su correo electrónico",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Correo electrónico requerido';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Ingrese un correo válido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      // Teléfono
                      TextFormField(
                        controller: _phoneController,
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
                        controller: _addressController,
                        decoration: _inputDecoration(
                          "Dirección",
                          "Ingrese su dirección",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Dirección requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Botón registrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading
                                ? Colors.grey
                                : const Color.fromRGBO(14, 145, 14, 1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Registrar Usuario",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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
        ),
      ),
    );
  }
}
