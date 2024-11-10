import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/providers/convivencia_provider.dart';
import 'package:iseneca/models/expulsados_response.dart';
import 'package:intl/intl.dart';

class ExpulsadosScreen extends StatefulWidget {
  const ExpulsadosScreen({Key? key}) : super(key: key);

  @override
  _ExpulsadosScreenState createState() => _ExpulsadosScreenState();
}

class _ExpulsadosScreenState extends State<ExpulsadosScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expulsados'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ConvivenciaProvider>(
        builder: (context, convivenciaProvider, child) {
          final listadoExpulsados = convivenciaProvider.listaExpulsados;

          if (listadoExpulsados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Expulsado> listadoExpulsadosHoy = listadoExpulsados;

          if (selectedDate != null) {
            listadoExpulsadosHoy = listadoExpulsadosHoy.where((expulsado) {
              DateTime fecInic = _parseDate(expulsado.fecInic);
              DateTime fecFin = _parseDate(expulsado.fecFin);
              return selectedDate!.isAtSameMomentAs(fecInic) ||
                  selectedDate!.isAtSameMomentAs(fecFin) ||
                  (selectedDate!.isAfter(fecInic) && selectedDate!.isBefore(fecFin));
            }).toList();
          }

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  selectedDate == null
                      ? "Seleccionar Fecha"
                      : DateFormat('dd/MM/yyyy').format(selectedDate!),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listadoExpulsadosHoy.length,
                  itemBuilder: (BuildContext context, int index) {
                    final expulsado = listadoExpulsadosHoy[index];

                    // Crear una lista de widgets para los campos que tienen valor
                    List<Widget> subtitleWidgets = [];

                    if (expulsado.curso.isNotEmpty) {
                      subtitleWidgets.add(Text('Curso: ${expulsado.curso}'));
                    }
                    if (expulsado.tipoExpulsion.isNotEmpty) {
                      subtitleWidgets.add(Text('Tipo Expulsión: ${expulsado.tipoExpulsion}'));
                    }
                    if (expulsado.observaciones != null && expulsado.observaciones != "N/A" && expulsado.observaciones!.isNotEmpty) {
                      subtitleWidgets.add(Text('Observaciones: ${expulsado.observaciones}'));
                    }

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(
                          expulsado.idAlumno,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (expulsado.expulsionEntregada)
                                  const Text('Expulsión Entregada: Sí'),
                                if (!expulsado.expulsionEntregada)
                                  const Text('Expulsión Entregada: No'),
                                if (expulsado.expulsionFirmada)
                                  const Text('Expulsión Firmada: Sí'),
                                if (!expulsado.expulsionFirmada)
                                  const Text('Expulsión Firmada: No'),
                              ],
                            ),
                            ...subtitleWidgets,
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (expulsado.fecInic.isNotEmpty && expulsado.fecFin.isNotEmpty)
                              Text('Inicio: ${expulsado.fecInic} - Final: ${expulsado.fecFin}'),
                            if (expulsado.fecVuelta.isNotEmpty)
                              Text('Vuelta: ${expulsado.fecVuelta}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Función para convertir las fechas con guion o barra en un formato DateTime estándar
  DateTime _parseDate(String date) {
    String formattedDate = date.replaceAll('/', '-');  
    return DateTime.parse(formattedDate); 
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
