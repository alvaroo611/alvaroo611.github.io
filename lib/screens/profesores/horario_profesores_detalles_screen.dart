import 'package:flutter/material.dart';
import 'package:iseneca/models/credenciales_response.dart';
import 'package:iseneca/models/horario_response.dart';
import 'package:iseneca/providers/centro_provider.dart';
import 'package:provider/provider.dart';

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

  final List<String> horas = [
    '8:00 - 9:00',
    '9:00 - 10:00',
    '10:00 - 11:00',
    '11:30 - 12:30',
    '12:30 - 13:30',
    '13:30 - 14:30'
  ];

  @override
  void initState() {
    super.initState();
    final credenciales =
        ModalRoute.of(context)!.settings.arguments as Credenciales;
    profesor = credenciales;
    centroProvider = Provider.of<CentroProvider>(context, listen: false);
    _horarioFuture = _fetchHorario(centroProvider, profesor);
  }

  Future<void> _fetchHorario(
    CentroProvider horarioProvider,
    Credenciales profesor,
  ) async {
    await horarioProvider.getHorario();
    final horarios = horarioProvider.listaHorariosProfesores.result;
    setState(() {
      horarioProfesor =
          obtenerHorarioDelProfesor(profesor.nombre, profesor.apellidos, horarios);
      asignaturasProfesor = _obtenerAsignaturasUnicas(horarioProfesor);
    });
  }

  List<HorarioResult> obtenerHorarioDelProfesor(
      String nombre, String apellido, List<HorarioResult> horarios) {
    return horarios
        .where((horario) =>
            horario.nombreProfesor == nombre &&
            horario.apellidoProfesor == apellido)
        .toList();
  }

  Set<String> _obtenerAsignaturasUnicas(List<HorarioResult> horarioProfesor) {
    return horarioProfesor.map((horario) => horario.asignatura).toSet();
  }

  String obtenerTresPrimerasLetras(String texto) {
    if (texto.length < 3) {
      return texto.toUpperCase();
    }
    return texto.substring(0, 3).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horario de ${profesor.nombre} ${profesor.apellidos}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: _horarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos.'));
          } else if (horarioProfesor.isEmpty) {
            return Center(child: Text('No se encontraron datos de horarios.'));
          } else {
            return Center(
              child: ConstrainedBox(  // Este widget asegura que la tabla esté centrada
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9, // Limitar el ancho de la tabla
                  maxHeight: MediaQuery.of(context).size.height * 0.9, // Limitar el alto de la tabla
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical
                    crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(color: Colors.blueAccent, width: 2),
                          defaultColumnWidth: FixedColumnWidth(100.0),
                          children: [
                            TableRow(
                              children: [
                                _buildTableHeaderCell('Hora'),
                                _buildTableHeaderCell('Lunes'),
                                _buildTableHeaderCell('Martes'),
                                _buildTableHeaderCell('Miércoles'),
                                _buildTableHeaderCell('Jueves'),
                                _buildTableHeaderCell('Viernes'),
                              ],
                            ),
                            for (var hora in horas)
                              TableRow(
                                children: [
                                  _buildTableCell(hora),
                                  for (var dia in ['L', 'M', 'X', 'J', 'V'])
                                    TableCell(
                                      child: _obtenerCeldaHorario(
                                          horarioProfesor, dia, hora),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAsignaturasContainer(),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(text),
      ),
    );
  }

  Widget _obtenerCeldaHorario(
      List<HorarioResult> horarioProfesor, String dia, String hora) {
    final horario = horarioProfesor.firstWhere(
        (horario) =>
            horario.dia == dia + _obtenerNumeroHora(hora) &&
            horario.hora == hora.split(' ')[0],
        orElse: () => HorarioResult(
              curso: '',
              dia: '',
              hora: '',
              asignatura: '',
              aulas: '',
              nombreProfesor: '',
              apellidoProfesor: '',
            ));
    final abreviatura = obtenerTresPrimerasLetras(horario.asignatura);
    return horario.asignatura.isEmpty
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            child: const SizedBox.shrink())
        : Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 151, 202, 226),
              border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$abreviatura - ${horario.asignatura}'),
                Text(horario.aulas),
              ],
            ),
          );
  }

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
            offset: Offset(0, 3),
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
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _obtenerNumeroHora(String hora) {
    switch (hora) {
      case '8:00 - 9:00':
        return '1';
      case '9:00 - 10:00':
        return '2';
      case '10:00 - 11:00':
        return '3';
      case '11:30 - 12:30':
        return '4';
      case '12:30 - 13:30':
        return '5';
      case '13:30 - 14:30':
        return '6';
      default:
        return '';
    }
  }
}
