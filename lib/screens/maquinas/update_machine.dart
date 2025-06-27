import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:green_aplication/services/user_service.dart';
import 'package:green_aplication/widgets/mensajes.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActualizarMaquina extends StatefulWidget {
  const ActualizarMaquina({super.key});

  @override
  State<ActualizarMaquina> createState() => _ActualizarMaquinaState();
}

class _ActualizarMaquinaState extends State<ActualizarMaquina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MachineService _machineService = MachineService();

  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _sectorController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  String? _selectedProvince;
  String? _selectedCanton;

  List<Map<String, dynamic>> allUsers = [];
  User? selectedUser;
  Machine? machine;
  bool _isLoading = false;
  final UserService _userService = UserService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadInformation();
  }

  Future<void> _loadInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringUser = prefs.getString('SpecificUser');
    final jsonStringMachine = prefs.getString('SpecificMachine');
    if (jsonStringUser != null && jsonStringMachine != null) {
      final jsonDataUser = jsonDecode(jsonStringUser);
      final jsonDataMachine = jsonDecode(jsonStringMachine);
      final data = await _userService.getAll();
      setState(() {
        users = data.map((json) => User.fromJson(json)).toList();
        machine = Machine.fromJson(jsonDataMachine);
        selectedUser = users.firstWhere(
          (u) => u.id == jsonDataUser['id'],
          orElse: () => users.first,
        );
        _nameController.text = machine!.name;
        _sectorController.text = machine!.sector;
        _addressController.text = machine!.address;
        _selectedProvince = machine!.province;
        _selectedCanton = machine!.canton;
      });
    } else {
      Mensajes.mostrarMensaje(
        context,
        "No se encontró el usuario actual.",
        TipoMensaje.error,
      );
    }
  }

  final Map<String, List<String>> provincesCities = {
    'Azuay': ['Cuenca', 'Gualaceo', 'Girón'],
    'Bolívar': ['Guaranda'],
    'Cañar': ['Azogues', 'La Troncal'],
    'Carchi': ['Tulcán'],
    'Chimborazo': ['Riobamba', 'Alausí'],
    'Cotopaxi': ['Latacunga', 'La Maná'],
    'El Oro': ['Machala', 'Pasaje', 'Santa Rosa', 'Huaquillas'],
    'Esmeraldas': ['Esmeraldas', 'Atacames'],
    'Galápagos': ['Puerto Baquerizo Moreno', 'Puerto Ayora'],
    'Guayas': ['Guayaquil', 'Durán', 'Daule', 'Milagro', 'Samborondón'],
    'Imbabura': ['Ibarra', 'Otavalo', 'Cotacachi'],
    'Loja': ['Loja', 'Catamayo'],
    'Los Ríos': ['Babahoyo', 'Quevedo', 'Ventanas'],
    'Manabí': ['Portoviejo', 'Manta', 'Chone', 'Bahía de Caráquez'],
    'Morona Santiago': ['Macas', 'Gualaquiza'],
    'Napo': ['Tena'],
    'Orellana': ['Puerto Francisco de Orellana (El Coca)'],
    'Pastaza': ['Puyo'],
    'Pichincha': ['Quito', 'Sangolquí', 'Cayambe'],
    'Santa Elena': ['Santa Elena', 'La Libertad', 'Salinas'],
    'Santo Domingo de los Tsáchilas': ['Santo Domingo'],
    'Sucumbíos': ['Nueva Loja (Lago Agrio)'],
    'Tungurahua': ['Ambato', 'Baños de Agua Santa'],
    'Zamora Chinchipe': ['Zamora'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _sectorController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.black87),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromRGBO(14, 145, 14, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(14, 145, 14, 1),
          width: 2,
        ),
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

  Future<void> _updateMachine() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedUser?.id == null) {
      Mensajes.mostrarMensaje(
        context,
        "No se pudo actualizar la máquina porque no se encontró el usuario.",
        TipoMensaje.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    machine!
      //..name = _nameController.text
      ..sector = _sectorController.text
      ..address = _addressController.text
      ..province = _selectedProvince ?? machine!.province
      ..canton = _selectedCanton ?? machine!.canton
      ..userId = selectedUser!.id;

    try {
      final response = await _machineService.update(machine!.toJson());

      if (response) {
        Mensajes.mostrarMensaje(
          context,
          "La máquina '${machine!.name}' fue actualizada exitosamente.",
          TipoMensaje.success,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('SpecificMachine', jsonEncode(machine));
        Navigator.pushReplacementNamed(context, "/tanks");
      }
    } catch (e) {
      Mensajes.mostrarMensaje(
        context,
        "Error al actualizar la máquina: $e",
        TipoMensaje.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (machine == null && selectedUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MiniEncabezado(
                  titulo: "Actualizar Máquina",
                  icono: Icons.arrow_back,
                  textoBoton: "Regresar",
                  ruta: "/userSelection",
                ),
                const SizedBox(height: 30),

                DropdownButtonFormField<User>(
                  decoration: InputDecoration(
                    labelText: 'Usuario Asignado a la Máquina',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: users.map((user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.name),
                    );
                  }).toList(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedUser,
                  onChanged: (user) {
                    setState(() {
                      selectedUser = user;
                      if (machine != null && user != null) {
                        machine!.userId = user.id;
                      }
                    });
                  },
                  hint: Text('Seleccione un usuario'),
                  validator: (value) =>
                      value == null ? 'Debe seleccionar un usuario' : null,
                ),
                const SizedBox(height: 12),
                /*TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration(
                    "Nombre de la máquina",
                    "Ingrese el nombre de la máquina",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nombre de la máquina requerido'
                      : null,
                ),*/
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: _inputDecoration("Provincia", ""),
                  value: _selectedProvince,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: provincesCities.keys.map((province) {
                    return DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      // Resetear cantón al cambiar de provincia
                      if (_selectedProvince != machine!.province) {
                        _selectedCanton = null;
                      } else {
                        _selectedCanton = machine!.canton;
                      }
                    });
                  },

                  hint: Text('Seleccione una provincia'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Provincia requerida'
                      : null,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: _inputDecoration("Cantón", ""),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: _selectedCanton,
                  items: _selectedProvince == null
                      ? []
                      : provincesCities[_selectedProvince]!.map((canton) {
                          return DropdownMenuItem(
                            value: canton,
                            child: Text(canton),
                          );
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCanton = value;
                    });
                  },
                  hint: Text('Seleccione un cantón'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cantón requerido'
                      : null,
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _sectorController,
                  decoration: _inputDecoration("Sector", "Ingrese el sector"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Sector requerido'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration(
                    "Dirección",
                    "Ingrese su dirección",
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Campo requerido'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateMachine,
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
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            "Actualizar Máquina",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
