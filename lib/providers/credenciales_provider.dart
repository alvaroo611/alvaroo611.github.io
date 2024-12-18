import 'package:flutter/material.dart';
import 'package:iseneca/models/credenciales_response.dart';
import 'package:iseneca/utils/utilidades.dart';
import 'package:iseneca/utils/google_sheets.dart';

/// Proveedor que gestiona los datos de las credenciales de usuarios.
///
/// Este proveedor permite cargar la lista de credenciales desde un servicio remoto
/// y notificar a los widgets interesados cuando hay cambios en los datos.
class CredencialesProvider extends ChangeNotifier {
  List<Credenciales> listaCredenciales = [];

  /// Constructor de la clase `CredencialesProvider`.
  ///
  /// Inicializa el proveedor, cargando las credenciales de usuario
  /// al instanciar la clase.
  CredencialesProvider() {
    debugPrint("Credenciales Provider inicializado");
    getCredencialesUsuario();
  }

  /// Obtiene las credenciales de usuario desde un servicio remoto.
  ///
  /// Este método realiza una solicitud, procesa los datos recibidos y actualiza
  /// la variable `listaCredenciales`. Notifica a los widgets interesados que los datos han cambiado.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  /// Retorna:
  /// - Un `Future<void>` que se completa cuando las credenciales han sido cargadas.
  getCredencialesUsuario() async {
    const url = GoogleSheets.credenciales;
    String respuesta = await Utilidades.getJsonData(url);
    respuesta = '{"results":$respuesta}';
    Future.delayed(const Duration(seconds: 2));
    final credencialesResponse = CredencialesResponse.fromJson(respuesta);
    listaCredenciales = credencialesResponse.results;
    notifyListeners();
  }

  /// Obtiene una lista de nombres y apellidos de profesores ordenados alfabéticamente.
  ///
  /// Este método ordena la lista de credenciales por nombre y devuelve
  /// una lista de nombres completos en formato 'nombre apellidos'.
  ///
  /// Parámetros:
  /// - Ninguno.
  ///
  /// Retorna:
  /// - Una lista de `String` con los nombres y apellidos de los profesores.
  List<String> getNombresApellidosProfesores() {
    // Ordenar por nombre
    listaCredenciales.sort((a, b) => a.nombre.compareTo(b.nombre));

    // Devolver la lista de nombres y apellidos
    return listaCredenciales
        .map((credencial) => '${credencial.nombre} ${credencial.apellidos}')
        .toList();
  }
}
