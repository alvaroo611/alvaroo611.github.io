import 'package:flutter/material.dart';
import 'package:iseneca/widgets/lista_opciones.dart';
import 'package:iseneca/widgets/widgets.dart';

/// Construye la pantalla de inicio.
///
/// Esta pantalla es un `Scaffold` que incluye un `SafeArea` para la protección del área segura de la pantalla.
/// Dentro de la pantalla se apilan varios widgets:
/// - `Background`: Un widget de fondo.
/// - `ListView`: Contiene varios widgets como `TitlePage`, `UserCard` e `ItemTable`.
/// - `ListaOpciones`: Muestra una lista de opciones disponibles.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          const Background(),
          ListView(
            children: const [
              Column(
                children: [
                  TitlePage(),
                  UserCard(),
                  ItemTable(),
                ],
              )
            ],
          ),
          const ListaOpciones()
        ]),
      ),
    );
  }
}
