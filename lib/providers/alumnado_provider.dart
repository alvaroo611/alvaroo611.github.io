import 'package:flutter/material.dart';
import 'package:iseneca/models/models.dart';
import 'package:iseneca/utils/utilidades.dart';
import 'package:iseneca/utils/google_sheets.dart';

/// Proveedor que gestiona la lógica relacionada con el alumnado y sus horarios.
///
/// Extiende `ChangeNotifier` para notificar cambios a los widgets interesados.
class AlumnadoProvider extends ChangeNotifier {
  List<DatosAlumnos> listadoAlumnos = [];
  List<HorarioResult> listadoHorarios = [];

  /// Constructor de la clase `AlumnadoProvider`.
  ///
  /// Inicializa las listas de alumnos y horarios al instanciar la clase.
  AlumnadoProvider() {
    debugPrint("Alumnado Provider inicalizado");
    getAlumno();
    getHorario();
  }

  /// Obtiene una lista de nombres de cursos desde Google Sheets.
  ///
  /// Este método accede a los datos de Google Sheets mediante una URL predefinida,
  /// procesa el JSON obtenido y retorna una lista de nombres de cursos.
  ///
  /// Retorna:
  /// - Una lista de cadenas que representan los nombres de los cursos.
  Future<List<String>> getCursos() async {
    const url = GoogleSheets.cursos;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = CursosResponse.fromJson(jsonData);
    List<String> nombres = [];

    for (int i = 0; i < cursosResponse.result.length; i++) {
      nombres.add(cursosResponse.result[i].cursoNombre);
    }
    return nombres;
  }

  /// Obtiene una lista de nombres de alumnos de un curso específico desde Google Sheets.
  ///
  /// Este método filtra los alumnos según el curso especificado.
  ///
  /// Parámetros:
  /// - [cursoABuscarAlumnos]: El nombre del curso cuyos alumnos se quieren obtener.
  ///
  /// Retorna:
  /// - Una lista de nombres de los alumnos que pertenecen al curso especificado.
  Future<List<dynamic>> getAlumnos(String cursoABuscarAlumnos) async {
    const url = GoogleSheets.alumnos;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = AlumnosResponse.fromJson(jsonData);
    List<dynamic> nombresAlumnos = [];
    for (int i = 0; i < cursosResponse.result.length; i++) {
      if (cursosResponse.result[i].curso == cursoABuscarAlumnos) {
        nombresAlumnos.add(cursosResponse.result[i].nombre);
      }
    }
    return nombresAlumnos;
  }

  /// Obtiene los datos de los alumnos desde Google Sheets y actualiza la lista local.
  ///
  /// Este método accede a los datos de Google Sheets mediante una URL predefinida,
  /// procesa el JSON obtenido y actualiza la lista `listadoAlumnos`.
  ///
  /// Notifica a los widgets interesados cuando los datos se actualizan.
  getAlumno() async {
    const url = GoogleSheets.alumnos;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = AlumnosResponse.fromJson(jsonData);
    listadoAlumnos = cursosResponse.result;
    notifyListeners();
  }

  /// Obtiene los horarios desde Google Sheets y actualiza la lista local.
  ///
  /// Este método accede a los datos de Google Sheets mediante una URL predefinida,
  /// procesa el JSON obtenido y actualiza la lista `listadoHorarios`.
  ///
  /// Notifica a los widgets interesados cuando los datos se actualizan.
  getHorario() async {
    const url = GoogleSheets.horarios;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final cursosResponse = HorarioResponse.fromJson(jsonData);
    listadoHorarios = cursosResponse.result;
    notifyListeners();
  }
}

/// Instancia global del proveedor de alumnado.
///
/// Se puede utilizar directamente en widgets que lo requieran.
final datos = AlumnadoProvider();
