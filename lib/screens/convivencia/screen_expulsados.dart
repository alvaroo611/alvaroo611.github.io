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
        title: const Text(
          "EXPULSADOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ConvivenciaProvider>(
        builder: (context, convivenciaProvider, child) {
          final listadoExpulsados = convivenciaProvider.listaExpulsados;

          if (listadoExpulsados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filtrar la lista para omitir los objetos cuyo `idAlumno` esté vacío
          List<Expulsado> listadoExpulsadosFiltrados = listadoExpulsados.where((expulsado) {
            return expulsado.idAlumno.trim().isNotEmpty;
          }).toList();

          // Filtrar por la fecha seleccionada, si existe
          if (selectedDate != null) {
            listadoExpulsadosFiltrados = listadoExpulsadosFiltrados.where((expulsado) {
              DateTime fecInic = _parseDate(expulsado.fecInic);
              DateTime fecFin = _parseDate(expulsado.fecFin);
              // Comparar las fechas, incluyendo las fechas límite
              return (selectedDate!.isAtSameMomentAs(fecInic) || selectedDate!.isAfter(fecInic)) &&
                    (selectedDate!.isAtSameMomentAs(fecFin) || selectedDate!.isBefore(fecFin));
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
                  itemCount: listadoExpulsadosFiltrados.length,
                  itemBuilder: (BuildContext context, int index) {
                    final expulsado = listadoExpulsadosFiltrados[index];

                    List<Widget> subtitleWidgets = [];

                    if (expulsado.curso.isNotEmpty) {
                      subtitleWidgets.add(Text('Curso: ${expulsado.curso}'));
                    }
                    if (expulsado.tipoExpulsion.isNotEmpty) {
                      subtitleWidgets.add(Text('Tipo Expulsión: ${expulsado.tipoExpulsion}'));
                    }
                    if (expulsado.observaciones != null && expulsado.observaciones!.isNotEmpty) {
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
                                  const Text(' Expulsión Firmada: Sí'),
                                if (!expulsado.expulsionFirmada)
                                  const Text(' Expulsión Firmada: No'),
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

  // Método para seleccionar la fecha
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

  // Método para parsear las fechas con diferentes formatos
  DateTime _parseDate(String date) {
  String formattedDate = date.replaceAll('/', '-');

  List<String> dateParts = formattedDate.split('-');
  if (dateParts.length == 3) {
    // Verificar si el año tiene solo dos dígitos y agregar "20" al principio
    if (dateParts[2].length == 2) {
      dateParts[2] = '20${dateParts[2]}'; 
    }

    formattedDate = dateParts.join('-');
      DateFormat format = DateFormat('dd-MM-yyyy');
      return format.parseStrict(formattedDate); 
  }
    throw FormatException("Formato de fecha no válido: $date");
  }

}


