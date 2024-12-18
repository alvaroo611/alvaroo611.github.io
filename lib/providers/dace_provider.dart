import 'package:flutter/material.dart';
import 'package:iseneca/models/models.dart';
import 'package:iseneca/utils/utilidades.dart';

/// Proveedor que gestiona los datos de las actividades extrescolares.
///
/// Este proveedor permite gestionar las actividades extraescolares de el centro
/// y notificar a los widgets interesados cuando hay cambios en los datos.
class DaceProvider extends ChangeNotifier {
  //Script Google

  //https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1eQ_GPKIBc-ikvKQ_0FD3q-J8okY-g4uVOmyn4g4SFnU&sheet=DACE

  //Google Docs DACE
  //https://docs.google.com/spreadsheets/d/1eQ_GPKIBc-ikvKQ_0FD3q-J8okY-g4uVOmyn4g4SFnU/edit?pli=1#gid=0

  List<ResultDace> resultados = [];

  /// Constructor de la clase `DaceProvider`.
  ///
  /// Inicializa el proveedor y carga los datos de DACE al instanciar la clase.
  DaceProvider() {
    debugPrint("DACE Provider inicializado");
    getDaceData();
    notifyListeners();
  }

  /// Obtiene los datos de DACE desde un servicio remoto.
  ///
  /// Este método realiza una solicitud HTTP a una URL de Google Sheets,
  /// procesa los datos recibidos y actualiza la lista de `resultados`.
  /// Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  getDaceData() async {
    const url =
        "https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=1eQ_GPKIBc-ikvKQ_0FD3q-J8okY-g4uVOmyn4g4SFnU&sheet=DACE";
    final jsonData = await Utilidades.getJsonData(url);
    final daceData = DaceResponse.fromJson('{"results":$jsonData}');
    resultados = daceData.results;
    notifyListeners();
  }
}
