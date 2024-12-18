import 'package:flutter/material.dart';
import 'package:iseneca/widgets/widgets.dart';

/// Un widget que representa una tabla de elementos interactivos, donde cada elemento 
/// permite navegar a diferentes pantallas de la aplicación
class ItemTable extends StatelessWidget {
  const ItemTable({
    Key? key,
  }) : super(key: key);

  /// Construye el widget Table que contiene las filas y columnas de elementos
  ///
  /// Parámetros:
  /// - [context]: El contexto de construcción, necesario para acceder a la navegación
  ///
  /// Retorna:
  /// - Un widget Table con dos filas, cada una conteniendo diferentes SingleCard interactivos
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          GestureDetector(
              onTap: () => Navigator.pushNamed(context, "alumnado_screen"),
              child: const SingleCard(
                  icon: "assets/sombrero.png", text: "Alumnado del centro")),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "personal_screen"),
            child: const SingleCard(
                icon: "assets/profesor.png", text: "Personal del centro"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "convivencia_screen"),
            child: const SingleCard(
                icon: "assets/convivencia.png", text: "Convivencia"),
          ),
        ]),
        TableRow(children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "dace_screen"),
            child: const SingleCard(
                icon: "assets/extraescolares.png", text: "DACE"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "servicio_screen"),
            child: const SingleCard(icon: "assets/banio.png", text: "Baño"),
          ),
          Container()
        ])
      ],
    );
  }
}
