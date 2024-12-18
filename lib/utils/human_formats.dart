import 'package:intl/intl.dart';

class HumanFormats{

  // Convierte un objeto DateTime a una cadena formateada en el formato dd-MM-yyyy.
  static String formatDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);

   // Convierte una cadena de fecha en el formato dd/MM/yyyy a un objeto DateTime.
  static DateTime formatStringToDate(String date) => DateFormat('dd/MM/yyyy').parse(date);

}