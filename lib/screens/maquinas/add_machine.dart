import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/user.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrarMaquina extends StatefulWidget {
  const RegistrarMaquina({super.key});

  @override
  State<RegistrarMaquina> createState() => _RegistrarMaquinaState();
}

class _RegistrarMaquinaState extends State<RegistrarMaquina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MachineService _machineService = MachineService();

  late TextEditingController _nameController;
  late TextEditingController _sectorController;
  late TextEditingController _addressController;
  String? _selectedProvince;
  String? _selectedCanton;

  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sectorController = TextEditingController();
    _addressController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('SpecificUser');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      final user = User.fromJson(jsonData);
      setState(() {
        _user = user;
      });
    } else {
      _showErrorDialog("No se encontró el usuario actual.");
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

  Future<void> _registerMachine() async {
    if (!_formKey.currentState!.validate()) return;

    if (_user?.id == null) {
      _showErrorDialog(
        "No se pudo registrar la máquina porque no se encontró el usuario.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newMachine = {
        'name': _nameController.text,
        'province': _selectedProvince,
        'canton': _selectedCanton,
        'sector': _sectorController.text,
        'address': _addressController.text,
        'userId': _user?.id,
        'active': true,
      };

      final response = await _machineService.create(newMachine);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Máquina registrada"),
            content: Text(
              "La máquina '${response['data']['name']}' fue registrada exitosamente.",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/createdMachines"),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showErrorDialog("Error al registrar la máquina: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      "Información cliente",
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
                                Navigator.pushNamed(context, "/userSelection");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  14,
                                  145,
                                  14,
                                  1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.all(6),
                              ),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                size: 30,
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, "/userSelection");
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(234, 234, 234, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow(
                        "Tipo de Cliente:",
                        _user!.naturalPerson ? "Natural" : "Jurídico",
                      ),
                      infoRow("Rol:", _user!.role),
                      infoRow("Nombre:", _user!.name),
                      infoRow("Identificación:", _user!.identification),
                      infoRow("Email:", _user!.email),
                      infoRow("Teléfono:", _user!.phone),
                      infoRow("Dirección:", _user!.address),
                      infoRow("Género:", _user!.gender),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Agregar Máquina",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration(
                    "Nombre de la máquina",
                    "Ingrese el nombre de la máquina",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nombre de la máquina requerido'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: _inputDecoration("Provincia", ""),
                  value: _selectedProvince, // null por defecto
                  items: provincesCities.keys.map((province) {
                    return DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      _selectedCanton = null;
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
                    onPressed: _isLoading ? null : _registerMachine,
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
                            "Registrar Máquina",
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
