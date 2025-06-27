import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_aplication/models/information.dart';
import 'package:green_aplication/models/machine.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/services/tank_information_service.dart';
import 'package:green_aplication/widgets/mini_encabezado.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentasTotales extends StatefulWidget {
  const VentasTotales({super.key});

  @override
  State<VentasTotales> createState() => _VentasTotalesState();
}

class _VentasTotalesState extends State<VentasTotales> {
  late Future<List<YearsInfo>> _yearsFuture;
  final InformationService _infoService = InformationService();
  Machine? machine;
  YearsInfo? selectedYear;
String? selectedMonthName;

Widget _buildResumenTable() {
  return Table(
    border: TableBorder.all(color: Colors.grey),
    columnWidths: const {
      0: FlexColumnWidth(2),
      1: FlexColumnWidth(2),
    },
    children: [
      const TableRow(
        decoration: BoxDecoration(color: Colors.green),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Mes", style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Total", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      ..._getFixedMonths().map((monthName) {
        final monthData = selectedYear!.months.firstWhere(
          (m) => m.month.toLowerCase() == monthName.toLowerCase(),
          orElse: () => Month(
              month: monthName,
              total: 0,
              subtotal: 0,
              iva: 0,
              billsWith: [],
              billsWithout: []),
        );
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(monthData.month),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child:
                  Text("\$${monthData.total.toStringAsFixed(2)}"),
            ),
          ],
        );
      }),
      TableRow(
        decoration: const BoxDecoration(color: Colors.black12),
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text("SubTotal"),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("\$${_sumAll((m) => m.subtotal).toStringAsFixed(2)}"),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(color: Colors.black12),
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text("IVA 15%"),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("\$${_sumAll((m) => m.iva).toStringAsFixed(2)}"),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(color: Colors.black26),
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Valor Total",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "\$${_sumAll((m) => m.total).toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildBillsTable(String monthName) {
  final monthData = selectedYear!.months.firstWhere(
    (m) => m.month.toLowerCase() == monthName.toLowerCase(),
    orElse: () => Month(
        month: monthName,
        total: 0,
        subtotal: 0,
        iva: 0,
        billsWith: [],
        billsWithout: []),
  );

  final bills = [...monthData.billsWith, ...monthData.billsWithout];

  if (bills.isEmpty) {
    return const Text("No hay facturas registradas para este mes.");
  }

  return Table(
    border: TableBorder.all(color: Colors.grey),
    columnWidths: const {
      0: FlexColumnWidth(4),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(3),
    },
    children: [
      const TableRow(
        decoration: BoxDecoration(color: Colors.green),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Tipo Comprobante",
                style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Datos", style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Total", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      ...bills.map((b) => TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("Factura"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(b.id),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("\$${b.total.toStringAsFixed(2)}"),
              ),
            ],
          )),
    ],
  );
}

List<String> _getFixedMonths() => [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre",
    ];

double _sumAll(double Function(Month) selector) {
  if (selectedYear == null) return 0;
  return selectedYear!.months.fold(0, (sum, m) => sum + selector(m));
}

  @override
  void initState() {
    super.initState();
    _yearsFuture = _loadYearsInfo();
  }

  Future<List<YearsInfo>> _loadYearsInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final machineJson = prefs.getString('SpecificMachine');

    if (machineJson != null) {
      final machineData = jsonDecode(machineJson);
      machine = Machine.fromJson(machineData);
      final int machineId = machine!.id!;
      final response = await _infoService.getTotalInfo(machineId);
      final years = response.map((e) => YearsInfo.fromJson(e)).toList();

      // Si solo hay un año, lo seleccionamos directamente
      if (years.length == 1) {
        selectedYear = years.first;
      }

      return years;
    }

    return [];
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
                titulo: "Consulta de Ventas Totales",
                icono: Icons.arrow_back,
                textoBoton: "Regresar",
                ruta: "/tanks",
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<YearsInfo>>(
                future: _yearsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No hay ventas registradas.");
                  }
                  final yearsInfo = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (yearsInfo.length > 1)
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Seleccione un año',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          items: yearsInfo
                              .map(
                                (y) => DropdownMenuItem<int>(
                                  value: y.year,
                                  child: Text(y.year.toString()),
                                ),
                              )
                              .toList(),
                          value: selectedYear?.year,
                          onChanged: (int? value) {
                            setState(() {
                              selectedYear = yearsInfo.firstWhere(
                                (element) => element.year == value,
                              );
                            });
                          },
                        ),
                      const SizedBox(height: 20),
                      if (selectedYear != null)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔽 Botones antes de la tabla
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Acción para Excel
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF085508),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_copy, color: Colors.white, size: 15),
                  if (!navBarState.isExpanded) ...[
                    const SizedBox(width: 5),
                    const Text(
                      'Informe en EXCEL',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Acción para PDF
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf,
                      color: Colors.white, size: 15),
                  if (!navBarState.isExpanded) ...[
                    const SizedBox(width: 5),
                    const Text(
                      'Informe en PDF',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // 🔽 Tabla resumen anual
      Text(
        "Ventas del año ${selectedYear!.year}",
        style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      _buildResumenTable(),

      const SizedBox(height: 30),

      // 🔽 Combo de mes y tabla de facturas
      const Text(
        "Seleccione un mes para ver las facturas",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: "Seleccione un mes",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: _getFixedMonths()
            .map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m),
                ))
            .toList(),
        onChanged: (String? selected) {
          setState(() {
            selectedMonthName = selected!;
          });
        },
        value: selectedMonthName,
      ),
      const SizedBox(height: 20),
      if (selectedMonthName != null)
        _buildBillsTable(selectedMonthName!),
    ],
  )
],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
