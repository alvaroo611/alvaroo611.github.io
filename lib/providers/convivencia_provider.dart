import 'package:flutter/material.dart';
import 'package:iseneca/models/models.dart';
import 'package:iseneca/utils/utilidades.dart';
import 'package:iseneca/utils/google_sheets.dart';

/// Proveedor que gestiona los datos de convivencia.
///
/// Este proveedor permite cargar las listas de alumnos expulsados y mayores de edad
/// desde un servicio remoto y notifica a los widgets interesados cuando hay cambios.

class ConvivenciaProvider extends ChangeNotifier {
  List<Expulsado> listaExpulsados = [];
  List<Mayor> listaMayores = [];

  /// Constructor de la clase `ConvivenciaProvider`.
  ///
  /// Inicializa el proveedor, cargando las listas de expulsados y mayores de edad
  /// al instanciar la clase.
  ConvivenciaProvider() {
    debugPrint('Convivencia Provider inicializada');
    getExpulsados();
    getMayores();
    notifyListeners();
  }

  /// Carga la lista de alumnos expulsados desde un servicio remoto.
  ///
  /// Este método realiza una solicitud, procesa los datos recibidos y actualiza
  /// la variable `listaExpulsados`. Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  /// Retorna:
  /// - Un `Future<void>` que se completa cuando los datos de expulsados han sido cargados.
  getExpulsados() async {
    const url = GoogleSheets.expulsados;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final expulsadoResponse = ExpulsadosResponse.fromJson(jsonData);
    listaExpulsados = [...expulsadoResponse.results];

    notifyListeners();
  }

  /// Carga la lista de alumnos mayores de edad desde un servicio remoto.
  ///
  /// Este método realiza una solicitud, procesa los datos recibidos y actualiza
  /// la variable `listaMayores`. Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  /// Retorna:
  /// - Un `Future<void>` que se completa cuando los datos de mayores han sido cargados.
  getMayores() async {
    const url = GoogleSheets.mayores;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    final mayorResponse = MayoresResponse.fromJson(jsonData);
    listaMayores = [...mayorResponse.results];

    notifyListeners();
  }
}
