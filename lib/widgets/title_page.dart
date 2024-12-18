import 'package:flutter/material.dart';

/// Un widget que representa el título principal de la página
/// Retorna:
/// - Un widget Container que contiene un texto centrado con estilo
class TitlePage extends StatelessWidget {
  const TitlePage({
    Key? key,
  }) : super(key: key);

  /// Construye el widget TitlePage
  ///
  /// Parámetros:
  /// - [context]: Contexto de construcción para obtener información sobre el diseño
  ///
  /// Retorna:
  /// - Un widget Container que contiene un título estilizado centrado
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.03),
      width: double.infinity,
      child: const Column(
        children: [
          Center(
            child: Text("iJándula",
                style: TextStyle(
                    fontSize: 60, color: Colors.white, fontFamily: 'ErasDemi')),
          ),
        ],
      ),
    );
  }
}
