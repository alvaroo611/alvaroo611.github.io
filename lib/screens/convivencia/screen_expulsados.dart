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
  TextEditingController _controller = TextEditingController();
  List<Expulsado> filteredExpulsados = [];
  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExpulsados = [];
      } else {
        filteredExpulsados = filteredExpulsados.where((expulsado) {
          return expulsado.idAlumno.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CONTACTO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ConvivenciaProvider>(
        builder: (context, convivenciaProvider, child) {
          final listadoExpulsados = convivenciaProvider.listaExpulsados;

          if (listadoExpulsados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filtrar la lista para omitir los objetos cuyo `idAlumno` esté vacío
          if (filteredExpulsados.isEmpty && _controller.text.isEmpty) {
            filteredExpulsados = listadoExpulsados;
          }

          // Filtrar por la fecha seleccionada, si existe
          if (selectedDate != null) {
            filteredExpulsados = filteredExpulsados.where((expulsado) {
              DateTime fecInic = _parseDate(expulsado.fecInic);
              DateTime fecFin = _parseDate(expulsado.fecFin);
              // Comparar las fechas, incluyendo las fechas límite
              return (selectedDate!.isAtSameMomentAs(fecInic) ||
                      selectedDate!.isAfter(fecInic)) &&
                  (selectedDate!.isAtSameMomentAs(fecFin) ||
                      selectedDate!.isBefore(fecFin));
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  itemCount: filteredExpulsados.length,
                  itemBuilder: (BuildContext context, int index) {
                    final expulsado = filteredExpulsados[index];

                    List<Widget> subtitleWidgets = [];

                    if (expulsado.curso.isNotEmpty) {
                      subtitleWidgets.add(Text('Curso: ${expulsado.curso}'));
                    }
                    if (expulsado.tipoExpulsion.isNotEmpty) {
                      subtitleWidgets.add(
                          Text('Tipo Expulsión: ${expulsado.tipoExpulsion}'));
                    }
                    if (expulsado.observaciones != null &&
                        expulsado.observaciones!.isNotEmpty) {
                      subtitleWidgets.add(
                          Text('Observaciones: ${expulsado.observaciones}'));
                    }

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título: ID del alumno
                            Text(
                              expulsado.idAlumno,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Información sobre la expulsión (en columna)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expulsión Entregada: ${expulsado.expulsionEntregada ? "Sí" : "No"}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Firmada: ${expulsado.expulsionFirmada ? "Sí" : "No"}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Detalles adicionales
                            if (expulsado.curso.isNotEmpty)
                              Text('Curso: ${expulsado.curso}',
                                  style: const TextStyle(fontSize: 14)),
                            if (expulsado.tipoExpulsion.isNotEmpty)
                              Text('Tipo Expulsión: ${expulsado.tipoExpulsion}',
                                  style: const TextStyle(fontSize: 14)),
                            if (expulsado.observaciones != null &&
                                expulsado.observaciones!.isNotEmpty)
                              Text('Observaciones: ${expulsado.observaciones}',
                                  style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),

                            // Fechas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (expulsado.fecInic.isNotEmpty && expulsado.fecFin.isNotEmpty)
                                  Text(
                                    'Inicio: ${expulsado.fecInic}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                if (expulsado.fecFin.isNotEmpty)
                                  Text(
                                    'Final: ${expulsado.fecFin}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                              ],
                            ),
                            if (expulsado.fecVuelta.isNotEmpty)
                              Text(
                                'Vuelta: ${expulsado.fecVuelta}',
                                style: const TextStyle(fontSize: 14),
                              ),
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
