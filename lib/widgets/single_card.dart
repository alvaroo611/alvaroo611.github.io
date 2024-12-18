import 'package:flutter/material.dart';

/// Un widget que representa una tarjeta con un icono y un texto
/// Parámetros:
/// - [icon]: Ruta del icono (imagen) que se mostrará en la tarjeta
/// - [text]: Texto que se mostrará debajo del icono
///
/// Retorna:
/// - Un widget Container que contiene un ícono y un texto estilizados
class SingleCard extends StatelessWidget {
  final String icon;
  final String text;

  const SingleCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  /// Construye el widget del SingleCard
  ///
  /// Parámetros:
  /// - [context]: Contexto de construcción para obtener información de diseño
  ///
  /// Retorna:
  /// - Un widget Container que contiene un ícono y un texto organizados en una columna
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height * 0.15,
        margin: EdgeInsets.only(
            top: size.height * 0.1,
            right: size.width * 0.05,
            left: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: Image.asset(
                icon,
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
