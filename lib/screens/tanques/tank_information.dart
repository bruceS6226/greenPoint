import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/tank.dart';
import 'package:green_aplication/services/machine_service.dart';
import 'package:green_aplication/widgets/mensajes.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformacionTanque extends StatefulWidget {
  const InformacionTanque({super.key});

  @override
  State<InformacionTanque> createState() => _InformacionTanqueState();
}


class _InformacionTanqueState extends State<InformacionTanque> {
  Piston? tank;
  bool _isLoading = false;
  bool _editingLevel = false;
  final TextEditingController _levelController = TextEditingController();
  final _machineService = MachineService();

  @override
  void initState() {
    super.initState();
    _loadSelectedTank();
  }

  Future<void> _loadSelectedTank() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('specificTank');

    if (jsonString != null) {
      setState(() {
        final tankJson = jsonDecode(jsonString);
        tank = Piston.fromJson(tankJson);
      });
    }
  }

  String _getColor(int level) {
    if (level >= 100) return 'green';
    if (level >= 20) return 'yellow';
    return 'red';
  }

  @override
  Widget build(BuildContext context) {
    if (tank == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniEncabezado(
                titulo: "Nivel de Tanques",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/tanks",
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF042504),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tank!.name,
                        style: const TextStyle(
                          color: Color(0xFFEAFF00),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Imagen y barra superpuesta
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/Tanque2.png',
                          width: 250,
                          height: 300,
                        ),
                        Positioned(
                          top: 52,
                          left: 69,
                          child: Container(
                            width: 122,
                            height: 225,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                              height: tank!.level * 1.116,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _getColor(tank!.level) == 'green'
                                    ? Colors.green
                                    : _getColor(tank!.level) == 'yellow'
                                    ? Colors.yellow
                                    : Colors.red,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      tank!.product,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _editingLevel
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            width: double.infinity,
                            child: TextFormField(
                              controller: _levelController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Ingrese el nivel (lt)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                suffixText: "lt  ",
                              ),
                              validator: (value) {
                                final numValue = int.tryParse(value ?? '');
                                if (numValue == null) {
                                  return 'Ingrese un número válido';
                                } else if (numValue < 0) {
                                  return 'El nivel no puede ser negativo';
                                } else if (numValue > 200) {
                                  return 'El tanque solo admite hasta 200 lt';
                                }
                                return null;
                              },
                            ),
                          )
                        : Text(
                            '${tank!.level} lt / 200 lt',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_editingLevel) {
                            setState(() {
                              _levelController.text = tank!.level.toString();
                              _editingLevel = true;
                            });
                          } else {
                            final text = _levelController.text;
                            final numValue = int.tryParse(text);

                            // Validaciones manuales antes de guardar
                            if (numValue == null) {
                              Mensajes.mostrarMensaje(
                                context,
                                'Ingrese un número válido',
                                TipoMensaje.error,
                              );
                              return;
                            }
                            if (numValue < 0) {
                              Mensajes.mostrarMensaje(
                                context,
                                'El nivel no puede ser negativo',
                                TipoMensaje.error,
                              );
                              return;
                            }
                            if (numValue > 200) {
                              Mensajes.mostrarMensaje(
                                context,
                                'El nivel no puede superar los 200 lt',
                                TipoMensaje.error,
                              );
                              return;
                            }
                            setState(() => _isLoading = true);
                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final machineJson = jsonDecode(
                                prefs.getString('SpecificMachine') ?? '{}',
                              );

                              final updatedLevel =
                                  int.tryParse(_levelController.text) ??
                                  tank!.level;

                              await _machineService.updateTankLevel(
                                machineId: machineJson['id'],
                                product: tank!.product,
                                level: updatedLevel,
                              );

                              setState(() {
                                tank!.level = updatedLevel;
                                _editingLevel = false;
                              });
                              Mensajes.mostrarMensaje(
                                context,
                                'Nivel actualizado con éxito',
                                TipoMensaje.success,
                              );
                            } catch (e) {
                              Mensajes.mostrarMensaje(
                                context,
                                'Ocurrio un error al actualizar el nivel',
                                TipoMensaje.error,
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? Colors.grey
                        : const Color.fromRGBO(14, 145, 14, 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
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
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _editingLevel ? Icons.save : Icons.update,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _editingLevel ? "Guardar" : "Actualizar Cantidad",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
