import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iseneca/models/credenciales_response.dart';
import 'package:iseneca/models/horario_response.dart';
import 'package:iseneca/providers/centro_provider.dart';
import 'package:iseneca/providers/credenciales_provider.dart';
import 'package:provider/provider.dart';

class ListadoProfesores extends StatefulWidget {
  const ListadoProfesores({Key? key}) : super(key: key);

  @override
  _ListadoProfesoresState createState() => _ListadoProfesoresState();
}

class _ListadoProfesoresState extends State<ListadoProfesores> {
  List<Credenciales> listaOrdenadaProfesores = [];
  List<Credenciales> profesoresFiltrados = [];
  bool isLoading = true;
  TextEditingController _controller = TextEditingController();
  late CentroProvider horarioProvider;
  late HorarioResponse horarioResponse = HorarioResponse(result: []);
  late HorarioResult profesorActual;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      horarioProvider = Provider.of<CentroProvider>(context, listen: false);
      final credencialesProvider =
          Provider.of<CredencialesProvider>(context, listen: false);
      _fetchProfesores(credencialesProvider);
      _fetchHorario(horarioProvider);
    });
  }

  Future<void> _fetchHorario(CentroProvider horarioProvider) async {
    await horarioProvider.getHorario();
    setState(() {
      horarioResponse = horarioProvider.listaHorariosProfesores;
    });
  }

  Future<void> _fetchProfesores(
      CredencialesProvider credencialesProvider) async {
    setState(() {
      isLoading = true;
    });

    try {
      await credencialesProvider.getCredencialesUsuario();
      if (credencialesProvider.listaCredenciales.isEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          _fetchProfesores(credencialesProvider);
        });
      }
      setState(() {
        listaOrdenadaProfesores = credencialesProvider.listaCredenciales;
        listaOrdenadaProfesores.sort((a, b) => a.nombre.compareTo(b.nombre));
        profesoresFiltrados = List.from(listaOrdenadaProfesores);
      });
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () {
        _fetchProfesores(credencialesProvider);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        profesoresFiltrados = List.from(listaOrdenadaProfesores);
      } else {
        profesoresFiltrados = listaOrdenadaProfesores
            .where((profesor) => "${profesor.nombre} ${profesor.apellidos}"
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _obtenerDiaActual(DateTime now) {
    List<String> dias = ["L", "M", "X", "J", "V", "S", "D"];
    String diaSemana = dias[
        now.weekday - 1]; // now.weekday devuelve 1 para lunes a 7 para domingo

    // Obtener la parte del día
    int hora = now.hour;
    int minutos = now.minute;
    String parteDelDia;

    if (hora == 8 && minutos >= 0 && minutos < 60) {
      parteDelDia = "1";
    } else if (hora == 9 && minutos >= 0 && minutos < 60) {
      parteDelDia = "2";
    } else if (hora == 10 && minutos >= 0 && minutos < 60) {
      parteDelDia = "3";
    } else if (hora == 11 && minutos >= 30 && minutos < 60) {
      parteDelDia = "4";
    } else if (hora == 12 && minutos >= 0 && minutos < 30) {
      parteDelDia = "4";
    } else if (hora == 12 && minutos >= 30 && minutos < 60) {
      parteDelDia = "5";
    } else if (hora == 13 && minutos >= 0 && minutos < 30) {
      parteDelDia = "5";
    } else if (hora == 13 && minutos >= 30 && minutos < 60) {
      parteDelDia = "6";
    } else if (hora == 14 && minutos >= 0 && minutos < 30) {
      parteDelDia = "6";
    } else {
      // Fuera de las horas válidas para las partes del día
      parteDelDia = "";
    }

    return diaSemana + parteDelDia;
  }

  String _obtenerHoraActual() {
    DateTime now = DateTime.now();
    String hora = now.hour
        .toString()
        .padLeft(2, '0'); // Formatear la hora con dos dígitos
    String minutos = now.minute
        .toString()
        .padLeft(2, '0'); // Formatear los minutos con dos dígitos
    return '$hora:$minutos';
  }

  void _mostrarLocalizacion(
      BuildContext context, String nombreProfesor, String apellidoProfesor) {
    DateTime now = DateTime.now();
    String diaActual = _obtenerDiaActual(now);
    String horaActualString = _obtenerHoraActual();
    DateTime horaActual = DateFormat('H:mm').parse(horaActualString);

    setState(() {
      profesorActual = horarioResponse.result.firstWhere(
        (horario) =>
            horario.nombreProfesor == nombreProfesor &&
            horario.apellidoProfesor == apellidoProfesor &&
            horario.dia == diaActual &&
            horaActual.isAfter(DateFormat('H:mm').parse(horario.hora)) &&
            horaActual.isBefore(DateFormat('H:mm')
                .parse(horario.hora)
                .add(const Duration(hours: 1))),
        orElse: () => HorarioResult(
          curso: '',
          dia: '',
          hora: '',
          asignatura: '',
          aulas: '',
          nombreProfesor: '',
          apellidoProfesor: '',
        ),
      );
    });

    // Mostrar el dialogo según la disponibilidad de la información
    if (profesorActual.nombreProfesor.isNotEmpty) {
      // Mostrar dialogo con la información del profesor
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Horario Actual de ${profesorActual.nombreProfesor} ${profesorActual.apellidoProfesor}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Curso: ${profesorActual.curso}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Hora: ${profesorActual.hora}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.book, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Asignatura: ${profesorActual.asignatura}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Aula en la que se encuentra: ${profesorActual.aulas}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Mostrar dialogo indicando que la información no está disponible
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.white,
            title: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Información No Disponible',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            content: const Text(
              'El profesor seleccionado no tiene clase en la hora actual.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LOCALIZACIÓN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: profesoresFiltrados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _mostrarLocalizacion(
                              context,
                              profesoresFiltrados[index].nombre,
                              profesoresFiltrados[index].apellidos);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                profesoresFiltrados[index].nombre[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              '${profesoresFiltrados[index].nombre} ${profesoresFiltrados[index].apellidos}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 8, 8, 8),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}





