import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';

class PersonaNatural extends StatefulWidget {
  const PersonaNatural({super.key});

  @override
  State<PersonaNatural> createState() => _PersonaNaturalState();
}

class _PersonaNaturalState extends State<PersonaNatural> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _identificationController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  String? _selectedRole;
  String? _selectedGender;
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
          gender: _selectedGender ?? '',
          address: _addressController.text,
          isNaturalPerson: true,
          role: _selectedRole ?? 'USER',
          isActive: true,
        );

        final response = await _userService.register(newUser.toJson());

        if (response['id'] != null) {
          _showSuccessDialog(response['name']); // Pasamos el nombre al dialog
        } else {
          _showErrorDialog('Error desconocido al registrar el usuario.');
        }
        // ✅ Diálogo con redirección
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Error al registrar: $e');
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

  void _showSuccessDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registro exitoso'),
        content: Text('El usuario "$name" ha sido registrado correctamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.pushReplacementNamed(
                context,
                '/createdUsers',
              ); // Redirige
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error en el registro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
                        initialValue: 'Persona Natural',
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
                        //hint: Text('Seleccione un rol'),
                      ),
                      const SizedBox(height: 12),

                      // Nombre Cliente
                      TextFormField(
                        controller: _nameController,
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
                        controller: _identificationController,
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

                      // Género
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
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
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        //hint: Text('Seleccione un género'),
                      ),
                      const SizedBox(height: 20),

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
