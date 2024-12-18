import 'package:dio/dio.dart';
//Utils
class Utilidades {
  /// Realiza una solicitud GET a una URL y devuelve la respuesta en formato JSON como una cadena
  ///
  /// Parámetros:
  /// - [url]: Cadena que representa la URL desde la cual se van a obtener los datos
  ///
  /// Retorna:
  /// - Una cadena que contiene los datos en formato JSON obtenidos de la respuesta HTTP
  static Future<String> getJsonData(String url) async {
    final dio = Dio();
    final response = await dio.get(url);
    return(response.data);
  }
  
}
