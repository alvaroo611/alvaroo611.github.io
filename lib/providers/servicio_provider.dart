import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:iseneca/models/servicio_response.dart';

class ServicioProvider extends ChangeNotifier {
  List<Servicio> listadoAlumnosServicio = [];
  List<String> nombresAlumnosOrdenados = [];
  final baseUrl =
      'https://script.google.com/macros/s/AKfycbww17NqHZU5opz9SkMtUASKZOg1Hg6KsExRSvlqAMyrx4i0Ax9P5I7IQtKRcnsMKVivdw/exec';
  final spreadsheetId = '1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I';
  final sheet = 'Servicio';

  ServicioProvider() {
    debugPrint("Servicio Provider inicializado");
  }

  /// Obtiene los datos de los servicios por un nombre de alumno desde un servicio remoto.
  ///
  /// Este método filtra los servicios almacenados localmente basados en el nombre del alumno proporcionado
  /// y retorna una lista con los servicios correspondientes.
  ///
  /// Parámetros:
  /// - `nombreAlumno`: El nombre del alumno para filtrar los servicios.
  ///
  /// Devuelve:
  /// - Una lista de objetos `Servicio` correspondientes al alumno especificado.
  Future<List<Servicio>> getServiciosPorAlumno(String nombreAlumno) async {
    List<Servicio> serviciosAlumno = listadoAlumnosServicio
        .where((servicio) => servicio.nombreAlumno == nombreAlumno)
        .toList();

    return serviciosAlumno;
  }

  /// Obtiene los datos de todos los servicios desde un servicio remoto.
  ///
  /// Realiza una solicitud HTTP a la URL de la hoja de cálculo de Google Sheets
  /// y procesa los datos recibidos para actualizarlos localmente.
  /// Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación para mostrar mensajes emergentes en caso de error.

  Future<void> getAlumnosServicio(BuildContext context) async {
    final url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I&sheet=Servicio");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final servicioResponse = ServicioResponse.fromMap({'results': data});
        listadoAlumnosServicio = servicioResponse.result;
        notifyListeners();
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error en la solicitud: ${response.statusCode}')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Obtiene los servicios de un alumno dentro de un rango de fechas.
  ///
  /// Filtra los servicios almacenados localmente basados en las fechas de entrada
  /// y salida proporcionadas. Retorna una lista de servicios que se ajustan al rango de fechas.
  ///
  /// Parámetros:
  /// - `fechaInicio`: La fecha de inicio del rango para filtrar los servicios.
  /// - `fechaFin`: La fecha de fin del rango para filtrar los servicios.
  ///
  /// Devuelve:
  /// - Una lista de objetos `Servicio` que están dentro del rango de fechas especificado.
  Future<List<Servicio>> getServiciosPorFecha(
      DateTime fechaInicio, DateTime fechaFin) async {
    List<Servicio> serviciosEnRango = listadoAlumnosServicio.where((servicio) {
      DateTime fechaEntrada =
          DateFormat("dd/MM/yyyy").parse(servicio.fechaEntrada);
      return (fechaEntrada.isAfter(fechaInicio) &&
              fechaEntrada.isBefore(fechaFin)) ||
          fechaEntrada.isAtSameMomentAs(fechaInicio) ||
          fechaEntrada.isAtSameMomentAs(fechaFin);
    }).toList();

    return serviciosEnRango;
  }

  /// Envía los datos de un servicio a través de un servicio remoto.
  ///
  /// Este método prepara una solicitud HTTP con los datos proporcionados (nombre del alumno,
  /// fechas de entrada y salida, horas de entrada y salida) y los envía a la hoja de cálculo de Google Sheets.
  /// Notifica al usuario con un mensaje emergente si la operación fue exitosa o falló.
  ///
  /// Parámetros:
  /// - `nombreAlumno`: El nombre del alumno.
  /// - `fechaEntrada`: La fecha de entrada del servicio.
  /// - `horaEntrada`: La hora de entrada del servicio.
  /// - `fechaSalida`: La fecha de salida del servicio.
  /// - `horaSalida`: La hora de salida del servicio.
  /// - `context`: El contexto de la aplicación para mostrar mensajes emergentes.
  Future<void> sendData(
      String nombreAlumno,
      String fechaEntrada,
      String horaEntrada,
      String fechaSalida,
      String horaSalida,
      BuildContext context) async {
    final Uri url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbzj0UpLfXpp9tza9njVytvs9Ovi77oV7GRN1lSfmljf_bS6PkqUgAwGGdOYlPXe9zXd/exec'
        '?spreadsheetId=1u79XugcalPc4aPcymy9OsWu1qdg8aKCBvaPWQOH187I'
        '&sheet=Servicio'
        '&nombreAlumno=$nombreAlumno'
        '&fechaEntrada=$fechaEntrada'
        '&horaEntrada=$horaEntrada'
        '&fechaSalida=$fechaSalida'
        '&horaSalida=$horaSalida');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final String message = data['message'] as String;
        print('Respuesta: $message');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error al cargar las visitas de los estudiantes al baño.')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Muestra un mensaje emergente en la pantalla principal.
  ///
  /// Este método se utiliza para mostrar un `SnackBar` con un mensaje proporcionado
  /// en la parte inferior de la pantalla, útil para notificar al usuario de diferentes eventos.
  ///
  /// Parámetros:
  /// - `message`: El mensaje que se debe mostrar en el `SnackBar`.
  /// - `context`: El contexto de la aplicación donde se mostrará el `SnackBar`.
  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Configura los datos de un alumno en una hoja de cálculo de Google Sheets.
  ///
  /// Prepara una solicitud HTTP con los datos proporcionados para enviarlos a la hoja de cálculo.
  /// Este método se utiliza para actualizar los datos de los servicios de un alumno específico.
  ///
  /// Parámetros:
  /// - `baseurl`: La URL base del script de Google Sheets.
  /// - `api`: El identificador del script.
  /// - `pagina`: El identificador de la hoja de cálculo.
  /// - `hoja`: El nombre de la hoja dentro del archivo de Google Sheets.
  /// - `nombre`: El nombre del alumno.
  /// - `fechaEntrada`: La fecha de entrada del servicio.
  /// - `fechaSalida`: La fecha de salida del servicio.
  Future<void> _setAlumnos(
      String baseurl,
      String api,
      String pagina,
      String hoja,
      String nombre,
      String fechaEntrada,
      String fechaSalida) async {
    final url = Uri.https(baseurl, api, {
      "spreadsheetId": pagina,
      "sheet": hoja,
      "nombreAlumno": nombre,
      "fechaEntrada": fechaEntrada,
      "fechaSalida": fechaSalida
    });

    await http.get(url);
  }
}
