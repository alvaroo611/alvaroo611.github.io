import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iseneca/service/firebase_service.dart';

///Clase google sing out
class GoogleSignOut extends StatefulWidget {
  const GoogleSignOut({Key? key}) : super(key: key);

  @override
  GoogleSignOutState createState() => GoogleSignOutState();
}

///Clase para manejar estado
class GoogleSignOutState extends State<GoogleSignOut> {
  set isSignedIn(bool isSignedIn) {}

  /// Crea el widget para el botón de cerrar sesión con Google.
  ///
  /// Este método construye un botón OutlinedButton con un ícono de Google y la etiqueta "Log Out".
  ///
  /// Al presionar el botón, llama al método `signOutFromGoogle` del servicio `FirebaseService`
  /// para cerrar la sesión del usuario en Google y actualiza el estado `isSignedIn` a `false`.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: size.width * 0.85,
      height: 55,
      child: OutlinedButton.icon(
          onPressed: () async {
            FirebaseService service = FirebaseService();
            try {
              await service.signOutFromGoogle();
              isSignedIn = false;
            } catch (e) {
              if (e is FirebaseAuthException) {
                debugPrint(e.message!);
              }
            }
          },
          icon: const FaIcon(FontAwesomeIcons.google),
          label: const Text("Log Out"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              side: MaterialStateProperty.all<BorderSide>(BorderSide.none))),
    );
  }
}
