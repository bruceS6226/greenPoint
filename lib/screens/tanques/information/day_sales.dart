import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/information.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/tank_information_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentasDiarias extends StatefulWidget {
  const VentasDiarias({super.key});

  @override
  State<VentasDiarias> createState() => _VentasDiariasState();
}

class _VentasDiariasState extends State<VentasDiarias> {
  late Future<List<Bills>> _billsFuture;
  final InformationService _infoService = InformationService();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  Machine? machine;
  List<ProductSale> ventas = [];

  @override
  void initState() {
    super.initState();
    _billsFuture = _loadBillsInfo();
  }

  Future<List<Bills>> _loadBillsInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final machineJson = prefs.getString('SpecificMachine');

    if (machineJson != null) {
      final machineData = jsonDecode(machineJson);
      machine = Machine.fromJson(machineData);

      final int machineId = machine!.id!;
      final response = await _infoService.getBillsInfo(machineId);

      return response.map((e) => Bills.fromJson(e)).toList();
    }

    return [];
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );

    if (picked != null) {
      final dateStr =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      // ✅ Verificación de seguridad
      if (machine != null) {
        try {
          final salesJson = await _infoService.getSalesInfo(
            machine!.id!,
            dateStr,
          );
          setState(() {
            _selectedDate = picked;
            _dateController.text =
                "${picked.day}/${picked.month}/${picked.year}";
            ventas = salesJson.map((e) => ProductSale.fromJson(e)).toList();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al obtener ventas: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Datos de la máquina no cargados aún.")),
        );
      }
    }
  }

  InputDecoration buildInputDecoration(String label, String hint) {
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

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

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
            children: [
              MiniEncabezado(
                titulo: "Consulta de Ventas Diarias",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/tanks",
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Bills>>(
                future: _billsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: \${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No hay ventas registradas.");
                  }

                  final bills = snapshot.data!;
                  List<Widget> widgets = [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF085508),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.file_copy,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                if (!navBarState.isExpanded) ...[
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Informe en EXCEL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                if (!navBarState.isExpanded) ...[
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Informe en PDF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Seleccione una fecha para visualizar las ventas",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Fecha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(context),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Fecha requerida'
                          : null,
                    ),
                    const SizedBox(height: 13),
                  ];

                  if (_selectedDate != null) {
                    final selectedDateStr =
                        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

                    final Bills? selectedBills = bills.firstWhere(
                      (b) => b.date.trim() == selectedDateStr.trim(),
                      orElse: () => Bills(date: '', billsInfo: []),
                    );

                    if (ventas.isNotEmpty) {
                      widgets.add(const SizedBox(height: 16));
                      widgets.add(
                        const Text(
                          "Ventas por producto",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                      widgets.add(const SizedBox(height: 8));
                      final subtotal = ventas.fold(
                        0.0,
                        (sum, v) => sum + v.totalSales,
                      );
                      final iva = ventas.fold(
                        0.0,
                        (sum, v) => sum + v.totalTaxes,
                      );
                      final total = subtotal + iva;

                      widgets.add(
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: Colors.blue),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Producto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Total",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            ...ventas.map(
                              (v) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(v.product),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      "\$${v.totalSales.toStringAsFixed(2)}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                              ),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("SubTotal"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "\$${subtotal.toStringAsFixed(2)}",
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                              ),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("IVA 15%"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text("\$${iva.toStringAsFixed(2)}"),
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                              ),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Valor Total",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "\$${total.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (_selectedDate != null) {
                      widgets.add(const SizedBox(height: 30));
                      widgets.add(
                        const Text(
                          "No hay ventas registradas para esta fecha.",
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    if (selectedBills!.date.isNotEmpty &&
                        selectedBills.billsInfo.isNotEmpty) {
                      widgets.add(const SizedBox(height: 16));
                      widgets.add(
                        const Text(
                          "Facturas del día",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                      widgets.add(const SizedBox(height: 8));
                      widgets.add(
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: Colors.green),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Tipo Comprobante",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Datos",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Total",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            ...selectedBills.billsInfo.map(
  (b) => TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          b.id == '9999999999999' ? 'Consumidor Final' : 'Factura',
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          b.id.trim().isNotEmpty ? b.id : "",
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          "\$${b.total.toStringAsFixed(2)}",
        ),
      ),
    ],
  ),
),

                          ],
                        ),
                      );
                    }
                  }

                  return Column(children: widgets);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
