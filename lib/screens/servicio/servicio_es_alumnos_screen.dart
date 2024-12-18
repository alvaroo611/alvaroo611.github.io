import 'package:flutter/material.dart';
import 'package:iseneca/models/Student.dart';
import 'package:iseneca/providers/alumno_provider.dart';
import 'package:iseneca/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Pantalla que muestra la lista de estudiantes asociados a un curso específico.
/// Permite seleccionar a un estudiante para realizar acciones relacionadas con su asistencia.
class ServicioESAlumnosScreen extends StatefulWidget {
  const ServicioESAlumnosScreen({Key? key}) : super(key: key);

  @override
  State<ServicioESAlumnosScreen> createState() =>
      _ServicioESAlumnosScreenState();
}

/// Estado de la clase `ServicioESAlumnosScreen`.
/// Maneja la carga de datos y la interacción del usuario con la lista de estudiantes.
class _ServicioESAlumnosScreenState extends State<ServicioESAlumnosScreen> {
  bool isLoading = false;
  bool isIdaPressed = false;
  bool isVueltaPressed = false;
  late ServicioProvider servicioProvider = ServicioProvider();

  final controllerTextoNombreAlumno = TextEditingController();
  late ProviderAlumno _providerAlumno;
  late List<Student> listadoAlumnos2 = [];

  @override
  void initState() {
    super.initState();
    servicioProvider = Provider.of<ServicioProvider>(context, listen: false);
    _providerAlumno = Provider.of<ProviderAlumno>(context, listen: false);
    _loadStudents();
  }

  /// Carga la lista de estudiantes desde el proveedor de datos.
  ///
  /// Establece `isLoading` en `true` antes de iniciar la carga y a `false` después de finalizar la carga de datos.
  Future<void> _loadStudents() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2));
    await _providerAlumno.fetchData(context);
    setState(() {
      listadoAlumnos2 = _providerAlumno.students;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nombreCurso = ModalRoute.of(context)!.settings.arguments as String;
    final listadoAlumnos = listadoAlumnos2
        .where((alumno) => alumno.course == nombreCurso)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          nombreCurso,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: listadoAlumnos.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      controllerTextoNombreAlumno.clear();
                      controllerTextoNombreAlumno.text =
                          listadoAlumnos[index].name;

                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DialogoBotones(
                            servicio: servicioProvider,
                            controllerTextoNombreAlumno:
                                controllerTextoNombreAlumno,
                            student: listadoAlumnos[index],
                          );
                        },
                      );
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
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                listadoAlumnos[index].name[0],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              '${listadoAlumnos[index].name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

/// Dialogo de botones que permite realizar acciones de entrada y salida para un estudiante.
/// Muestra botones para marcar la entrada y salida del estudiante.
class DialogoBotones extends StatefulWidget {
  final ServicioProvider servicio;
  final TextEditingController controllerTextoNombreAlumno;
  final Student student;

  ///CONSTRUCTOR
  DialogoBotones({
    required this.servicio,
    required this.controllerTextoNombreAlumno,
    required this.student,
  });

  @override
  _DialogoBotonesState createState() => _DialogoBotonesState();
}

/// Estado del `DialogoBotones`.
/// Maneja la interacción del usuario con los botones de entrada y salida para el estudiante.
class _DialogoBotonesState extends State<DialogoBotones> {
  bool isIdaPressed = false;
  bool isVueltaPressed = false;
  String horaEntrada = '';
  String fechaEntrada = '';

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextField(
                controller: widget.controllerTextoNombreAlumno,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "NOMBRE ALUMNO",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: false,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: RawMaterialButton(
                        onPressed: () {
                          if (!isIdaPressed) {
                            setState(() {
                              isIdaPressed = true;
                              DateTime now = DateTime.now();
                              fechaEntrada =
                                  DateFormat('dd/MM/yyyy').format(now);
                              horaEntrada = DateFormat('HH:mm:ss').format(now);
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: isIdaPressed ? Colors.grey : Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 60),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "IDA",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: RawMaterialButton(
                        onPressed: () async {
                          if (!isVueltaPressed) {
                            setState(() {
                              isVueltaPressed = true;
                            });
                            DateTime now = DateTime.now();
                            String fechaSalida =
                                DateFormat('dd/MM/yyyy').format(now);
                            String horaSalida =
                                DateFormat('HH:mm:ss').format(now);

                            await widget.servicio.sendData(
                              widget.controllerTextoNombreAlumno.text
                                  .toString(),
                              fechaEntrada,
                              horaEntrada,
                              fechaSalida,
                              horaSalida,
                              context,
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: isVueltaPressed ? Colors.grey : Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 60),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "VUELTA",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
