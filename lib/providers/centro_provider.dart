import 'package:flutter/material.dart';
import 'package:iseneca/models/horario_response.dart';
import 'package:iseneca/utils/utilidades.dart';
import 'package:iseneca/utils/google_sheets.dart';

/// Proveedor que gestiona los horarios de los profesores.
///
/// Este proveedor permite cargar los horarios desde un servicio remoto
/// y notifica a los widgets interesados cuando hay cambios.
class CentroProvider extends ChangeNotifier {
  late HorarioResponse listaHorariosProfesores;

  /// Constructor de la clase `CentroProvider`.
  ///
  /// Inicializa el proveedor y carga los horarios al instanciar la clase.
  CentroProvider() {
    debugPrint("Centro Provider inicializado");

    getHorario();
  }

  /// Carga los horarios de los profesores desde un servicio remoto.
  ///
  /// Este método realiza una solicitud para obtener los datos,
  /// los procesa y los almacena en la variable `listaHorariosProfesores`.
  /// Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  /// Retorna:
  /// - Un `Future<void>` que se completa cuando los horarios han sido cargados.
  getHorario() async {
    const url = GoogleSheets.horarios;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    listaHorariosProfesores = HorarioResponse.fromJson(jsonData);

    notifyListeners();
  }
}
