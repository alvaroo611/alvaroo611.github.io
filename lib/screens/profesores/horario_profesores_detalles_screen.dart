import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iseneca/models/credenciales_response.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/providers/centro_provider.dart';
import 'package:iseneca/models/horario_response.dart';

class HorarioProfesoresDetallesScreen extends StatefulWidget {
  @override
  _HorarioProfesoresDetallesScreenState createState() =>
      _HorarioProfesoresDetallesScreenState();
}

class _HorarioProfesoresDetallesScreenState
    extends State<HorarioProfesoresDetallesScreen> {
  late Credenciales profesor;
  late CentroProvider centroProvider;
  late Future<void> _horarioFuture;
  List<HorarioResult> horarioProfesor = [];
  Set<String> asignaturasProfesor = {};

  /// Inicializa el estado de la pantalla y obtiene las credenciales del profesor
  ///
  /// Configura el Future para obtener el horario del profesor y la instancia
  /// del proveedor del centro
  @override
  void initState() {
    super.initState();
    final credenciales =
        ModalRoute.of(context)!.settings.arguments as Credenciales;
    profesor = credenciales;

    // Obtén el proveedor del centro fuera de _fetchHorario para evitar duplicaciones
    centroProvider = Provider.of<CentroProvider>(context, listen: false);

    // Inicializa el Future con la función asincrónica
    _horarioFuture = _fetchHorario(centroProvider, profesor);
  }

  /// Método que obtiene el horario del profesor y actualiza la interfaz
  ///
  /// Parámetros:
  /// - [horarioProvider]: El proveedor que maneja los datos del horario
  /// - [profesor]: Las credenciales del profesor cuyo horario se desea obtener
  ///
  /// Retorna:
  /// - Un Future<void> que se completa cuando el horario del profesor ha sido cargado
  Future<void> _fetchHorario(
    CentroProvider horarioProvider,
    Credenciales profesor,
  ) async {
    await horarioProvider.getHorario();
    final horarios = horarioProvider.listaHorariosProfesores.result;

    setState(() {
      horarioProfesor = obtenerHorarioDelProfesor(
          profesor.nombre, profesor.apellidos, horarios);
      asignaturasProfesor = _obtenerAsignaturasUnicas(horarioProfesor);
    });
    if (horarioProfesor.isEmpty) {
      // No hay horario disponible para este profesor
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay horario disponible para este profesor.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Filtra los horarios del profesor basado en su nombre y apellido
  ///
  /// Parámetros:
  /// - [nombre]: El nombre del profesor a filtrar
  /// - [apellido]: El apellido del profesor a filtrar
  /// - [horarios]: La lista completa de horarios de los profesores
  ///
  /// Retorna:
  /// - Una lista de objetos HorarioResult que corresponden al profesor
  List<HorarioResult> obtenerHorarioDelProfesor(
      String nombre, String apellido, List<HorarioResult> horarios) {
    return horarios
        .where((horario) =>
            horario.nombreProfesor == nombre &&
            horario.apellidoProfesor == apellido)
        .toList();
  }

  /// Obtiene un conjunto de asignaturas únicas de los horarios
  ///
  /// Parámetros:
  /// - [horarios]: La lista de horarios de los profesores
  ///
  /// Retorna:
  /// - Un Set<String> con las asignaturas únicas de los horarios
  Set<String> _obtenerAsignaturasUnicas(List<HorarioResult> horarios) {
    return horarios.map((horario) => horario.asignatura).toSet();
  }

  /// Construye la interfaz de la pantalla mostrando el horario del profesor
  ///
  /// Este método es llamado por el FutureBuilder para construir la vista
  /// basada en el estado del Future que obtiene el horario del profesor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Horario de ${profesor.nombre} ${profesor.apellidos}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<void>(
        future: _horarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<String> diasOrdenados = ["L", "M", "X", "J", "V"];
          List<String> diasNombres = [
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes"
          ];

          Set<String> horasUnicas =
              horarioProfesor.map((horario) => horario.hora).toSet();
          List<String> horasOrdenadas = horasUnicas.toList()
            ..sort((a, b) => int.parse(a.split(":")[0])
                .compareTo(int.parse(b.split(":")[0])));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar verticalmente
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Espacio adaptable
                Center(
                  // Centro el horario
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border:
                          TableBorder.all(color: Colors.blueAccent, width: 2),
                      defaultColumnWidth: const FixedColumnWidth(100.0),
                      children: [
                        _buildDiasSemana(diasNombres),
                        for (int i = 0; i < horasOrdenadas.length; i++)
                          _buildHorarioRow(i, diasOrdenados, horasOrdenadas),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  // Centro el contenedor de asignaturas
                  child: _buildAsignaturasContainer(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construye la fila de días de la semana para la tabla
  ///
  /// Parámetros:
  /// - [diasNombres]: Lista de nombres de los días de la semana
  ///
  /// Retorna:
  /// - Un TableRow que contiene las celdas con los nombres de los días
  TableRow _buildDiasSemana(List<String> diasNombres) {
    return TableRow(
      children: [
        _buildTableHeaderCell('Hora'),
        for (var dia in diasNombres) _buildTableHeaderCell(dia),
      ],
    );
  }

  /// Construye una fila de horario en la tabla, con las horas y días correspondientes
  ///
  /// Parámetros:
  /// - [horaDia]: El índice de la hora en la lista de horas
  /// - [diasOrdenados]: Lista con los días de la semana ordenados
  /// - [horasOrdenadas]: Lista con las horas ordenadas
  ///
  /// Retorna:
  /// - Un TableRow con las celdas de las horas y los días
  TableRow _buildHorarioRow(
      int horaDia, List<String> diasOrdenados, List<String> horasOrdenadas) {
    String horaInicio = horasOrdenadas[horaDia];
    String horaFinal = _calcularHoraFinal(horaInicio);

    return TableRow(
      children: [
        _buildTableCell('$horaInicio - $horaFinal', isHeader: true),
        for (var dia in diasOrdenados)
          _buildHorarioCell(dia, horasOrdenadas[horaDia]),
      ],
    );
  }

  /// Calcula la hora final basándose en la hora de inicio
  ///
  /// Parámetros:
  /// - [horaInicio]: La hora de inicio en formato "HH:mm"
  ///
  /// Retorna:
  /// - Una cadena con la hora final calculada en formato "HH:mm"
  String _calcularHoraFinal(String horaInicio) {
    final formatoHora = DateFormat("HH:mm");
    DateTime horaInicial = formatoHora.parse(horaInicio);
    DateTime horaFinal = horaInicial.add(const Duration(hours: 1));
    return formatoHora.format(horaFinal);
  }

   /// Construye una celda para la tabla, que representa una hora o un día
   /// 
  /// Parámetros:
  /// - [text]: El texto que debe ser mostrado en la celda
  /// - [isHeader]: Indica si la celda es una cabecera de la tabla
  ///
  /// Retorna:
  /// - Un Widget que representa una celda de la tabla
  Widget _buildTableHeaderCell(String text) {
    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Construye una celda de tabla que puede ser usada tanto para encabezados
  /// como para celdas normales
  ///
  /// Parámetros:
  /// - [text]: El texto que se mostrará dentro de la celda
  /// - [isHeader]: Un parámetro opcional que determina si la celda es un encabezado
  ///   Por defecto es false, si es true, se aplica un estilo especial para el encabezado
  ///
  /// Retorna:
  /// - Un Widget que representa una celda de tabla con el texto proporcionado
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isHeader ? Colors.black : Colors.black,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Construye una celda para cada horario específico en la tabla
  ///
  /// Parámetros:
  /// - [dia]: El día de la semana para el cual se debe mostrar el horario
  /// - [hora]: La hora específica del horario
  ///
  /// Retorna:
  /// - Un Widget que representa la celda de horario con la asignatura y aula
  Widget _buildHorarioCell(String dia, String hora) {
    String asignatura = '';
    String aula = '';

    for (var horario in horarioProfesor) {
      if (horario.dia.startsWith(dia.substring(0, 1)) && horario.hora == hora) {
        asignatura = horario.asignatura;
        aula = horario.aulas;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: asignatura.isNotEmpty
            ? const Color.fromARGB(255, 151, 202, 226)
            : Colors.white,
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              asignatura.isNotEmpty
                  ? asignatura.substring(0, 3).toUpperCase()
                  : '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              aula,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el contenedor que muestra todas las asignaturas del profesor
  ///
  /// Retorna:
  /// - Un Widget que representa el contenedor con las asignaturas
  Widget _buildAsignaturasContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ASIGNATURAS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            asignaturasProfesor.map((asignatura) {
              final abreviatura = obtenerTresPrimerasLetras(asignatura);
              return '$abreviatura - $asignatura';
            }).join('\n'),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Obtiene las tres primeras letras de una asignatura.
  ///
  /// Parámetros:
  /// - [asignatura]: El nombre completo de la asignatura
  ///
  /// Retorna:
  /// - Un String con las tres primeras letras de la asignatura en mayúsculas
  String obtenerTresPrimerasLetras(String asignatura) {
    return asignatura.length > 3
        ? asignatura.substring(0, 3).toUpperCase()
        : asignatura.toUpperCase();
  }
}
