import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/providers/providers.dart';
import 'package:intl/intl.dart';

/// Constructor de la clase DaceScreen
///
/// Esta clase crea una pantalla que muestra una lista de actividades extraescolares
/// con la posibilidad de ver detalles de cada actividad, como la fecha de inicio,
/// fecha de fin y los alumnos asociados a la actividad
class DaceScreen extends StatefulWidget {
  const DaceScreen({Key? key}) : super(key: key);

  @override
  State<DaceScreen> createState() => _DaceScreenState();
}

class _DaceScreenState extends State<DaceScreen> {
  /// Método encargado de construir la interfaz de usuario para la pantalla DaceScreen
  ///
  /// Parámetros:
  /// - [context]: El contexto de la aplicación, necesario para el acceso a datos y la creación de widgets
  ///
  /// Retorna:
  /// - Un widget Scaffold que contiene la estructura de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Actividades Extraescolares",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _lista(),
    );
  }

  /// Método encargado de construir la lista de actividades extraescolares.
  ///
  /// Retorna:
  /// - Un widget ListView que contiene una lista de tarjetas con actividades extraescolares
  Widget _lista() {
    final resultadosDace = Provider.of<DaceProvider>(context);

    // Ordenar fecha de menor a mayor
    resultadosDace.resultados.sort((a, b) => DateFormat('d/M/yyyy')
        .parse(a.fechaInicio)
        .compareTo(DateFormat('d/M/yyyy').parse(b.fechaInicio)));

    return ListView.builder(
      itemCount: resultadosDace.resultados.length,
      itemBuilder: (BuildContext context, int index) {
        final actividad = resultadosDace.resultados[index];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            onTap: () {
              _mostrarAlumnosPopup(actividad.alumnos);
            },
            title: Text(
              actividad.actividad,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (actividad.fechaInicio.isNotEmpty)
                  Text('Fecha de Inicio: ${actividad.fechaInicio}'),
                if (actividad.fechaFin.isNotEmpty)
                  Text('Fecha de Fin: ${actividad.fechaFin}'),
              ]
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
          ),
        );
      },
    );
  }

  /// Método encargado de mostrar un popup con la lista de alumnos de una actividad
  /// 
  /// Parámetros:
  /// - [alumnos]: Una cadena que contiene los nombres de los alumnos de la actividad
  void _mostrarAlumnosPopup(String alumnos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alumnos'),
          content: Text(alumnos),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
