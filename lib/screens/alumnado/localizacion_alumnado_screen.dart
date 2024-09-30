import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/alumnado_provider.dart';

class LocalizacionAlumnadoScreen extends StatefulWidget {
  const LocalizacionAlumnadoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacionAlumnadoScreen> createState() =>
      _LocalizacionAlumnadoScreenState();
}

class _LocalizacionAlumnadoScreenState
    extends State<LocalizacionAlumnadoScreen> {
  @override
  Widget build(BuildContext context) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;
    final listadoHorarios = alumnadoProvider.listadoHorarios;

    List<DatosAlumnos> listaOrdenada = [];
    listaOrdenada.addAll(listadoAlumnos);

    listaOrdenada.sort((a, b) => a.nombre.compareTo(b.nombre));
    return Scaffold(
      appBar: AppBar(title: const Text("LOCALIZACION ALUMNOS")),
      body: ListView.builder(
        itemCount: listaOrdenada.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _mostrarAlert(
                  context, index, listaOrdenada[index], listadoHorarios);
            },
            child: ListTile(
              title: Text(listaOrdenada[index].nombre),
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlert(BuildContext context, int index, DatosAlumnos alumno,
      List<HorarioResult> listadoHorarios) {
    DateTime ahora = DateTime.now();
    int horaActual = ahora.hour;
    int minutoActual = ahora.minute;
    String diaActual = obtenerDiaSemana(ahora.weekday);


    // Filtrar los horarios del alumno actual para el día actual
    List<HorarioResult> horariosAlumno = listadoHorarios.where((horario) =>
            horario.curso == alumno.curso &&
            horario.dia.startsWith(diaActual))
        .toList();

    String asignatura = "";
    String aula = "";
    String texto = "";

    // Iterar sobre los horarios del alumno actual
    for (int i = 0; i < horariosAlumno.length; i++) {
      String horaInicio = horariosAlumno[i].hora;
      String horaFin = sumarHora(horaInicio);

      // Convertir horas a enteros para la comparación
      int horaInicioInt = int.parse(horaInicio.split(":")[0]);
      int minutoInicioInt = int.parse(horaInicio.split(":")[1]);
      int horaFinInt = int.parse(horaFin.split(":")[0]);
      int minutoFinInt = int.parse(horaFin.split(":")[1]);

      // Verificar si la hora actual está dentro del rango de la clase
      if ((horaActual > horaInicioInt ||
              (horaActual == horaInicioInt && minutoActual >= minutoInicioInt)) &&
          (horaActual < horaFinInt ||
              (horaActual == horaFinInt && minutoActual < minutoFinInt))) {
        asignatura = horariosAlumno[i].asignatura;
        aula = horariosAlumno[i].aulas;
        break; // Se encontró la clase, salir del bucle
      }
    }

    // Construir el mensaje a mostrar en el AlertDialog
    if (aula.isEmpty || asignatura.isEmpty) {
      texto =
          "El alumno ${alumno.nombre} no está disponible en este momento";
    } else {
      texto =
          "El alumno ${alumno.nombre} está actualmente en el aula $aula, en la asignatura $asignatura";
    }

    // Mostrar el AlertDialog
    _mostrarDialog(context, alumno.nombre, texto);
  }

  void _mostrarDialog(BuildContext context, String titulo, String contenido) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  // Función para sumar una hora a la hora inicial
  String sumarHora(String hora) {
    int horas = int.parse(hora.split(":")[0]) + 1;
    int minutos = int.parse(hora.split(":")[1]);

    // Formatear los minutos a dos dígitos
    String minutosString = minutos.toString().padLeft(2, '0');

    return "$horas:$minutosString";
  }

  // Función para obtener el día de la semana en formato 'L', 'M', etc.
  String obtenerDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'L';
      case DateTime.tuesday:
        return 'M';
      case DateTime.wednesday:
        return 'X';
      case DateTime.thursday:
        return 'J';
      case DateTime.friday:
        return 'V';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'D';
      default:
        return '';
    }
  }
}
