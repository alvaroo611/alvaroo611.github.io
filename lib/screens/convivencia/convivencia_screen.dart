import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConvivenciaScreen extends StatelessWidget {
  const ConvivenciaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        title: const Text(
          "CONVIVENCIA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "expulsados_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.boxes,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Expulsados',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "mayores_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.peopleCarry,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Mayores',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "comportamiento_alumno_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.peopleArrows,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Comportamiento alumno',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "reflexion_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Reflexion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "incidencia_telefono_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.phone,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Incidencia telefono',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "carnet_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.idCard,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Carnet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
