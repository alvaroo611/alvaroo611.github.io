import 'package:flutter/material.dart';

import 'package:iseneca/service/services.dart';

Size size = Size.zero;

/// Pantalla de inicio de sesión.
///
/// Inhabilita el botón del dispositivo para volver atrás cuando se encuentra en esta pantalla.
/// La pantalla está compuesta por un `Scaffold` que contiene:
/// - `Background`: Un widget de fondo con un gradiente.
/// - `Content`: Contiene el contenido principal de la pantalla, como el título de la aplicación, el botón para iniciar sesión con Google y el logo de la versión.

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          false, //Inhabilita el botón del dispositivo para volver atrás
      child: const Scaffold(
        body: Stack(
          children: [
            //Background
            Background(),
            //Content
            Content(),
          ],
        ),
      ),
    );
  }
}

/// Widget de fondo para la pantalla de inicio de sesión.
///
/// Este widget crea un `Container` con un gradiente de colores que va desde azul claro en la parte superior hasta azul marino en la parte inferior.
class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.8],
          colors: [Color(0xff005298), Color(0xff01315a)],
        ),
      ),
    );
  }
}

///Content
class Content extends StatefulWidget {
  const Content({super.key});

  @override
  ContentState createState() => ContentState();
}

///Estado de content
class ContentState extends State<Content> {
  // Método para construir el contenido de la pantalla.
  ///
  /// El contenido incluye:
  /// - `TextoAplicacion`: Título de la aplicación.
  /// - `GoogleSignIn`: Botón para iniciar sesión con Google.
  /// - `LogoVersion`: Logo de la versión y detalles de la aplicación.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          //Titulo
          const Expanded(child: TextoAplicacion()),

          //Botón Google
          const Center(child: GoogleSignIn()),
          Expanded(child: Container()),

          //Logo
          const LogoVersion(),
        ],
      ),
    );
  }
}

//Class texto aplicacion
class TextoAplicacion extends StatelessWidget {
  const TextoAplicacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.05),
      child: const Text(
        "iSéneca",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'ErasDemi',
          color: Colors.white,
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LogoVersion extends StatelessWidget {
  const LogoVersion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: size.width * 0.1, right: size.width * 0.01),
                child: Image.asset(
                  "assets/iconoJunta.png",
                  height: 65,
                  width: 65,
                  color: Colors.white,
                ),
              ),

              //Texto Junta Andalucía
              Container(
                margin: EdgeInsets.only(top: size.height * 0.035),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("IES Jándula",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("Desarrollo Aplicaciones Multiplataforma",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          //Versión
          Opacity(
            opacity: 0.15,
            child: Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.01, right: size.width * 0.03),
              alignment: Alignment.bottomRight,
              child: const Text("v1.1.0",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
