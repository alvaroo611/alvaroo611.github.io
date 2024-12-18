import 'package:flutter/material.dart';
import 'package:iseneca/screens/screens.dart';

/// Pantalla principal de la aplicación.
///
/// Esta pantalla gestiona el control del `PageView` que permite navegar entre las pantallas Home y Agenda.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = PageController(
    initialPage: 0,
  );

  int pageIndex = 0;

  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
      controller: controller,
      children: const [
        HomeScreen(),
        AgendaScreen(),
      ],
      onPageChanged: (value) {
        pageIndex = value;
        setNavBarIndex(value);
      },
    );

    return Scaffold(
        body: Container(
          child: pageView,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFF02569d),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          currentIndex: navBarIndex,
          onTap: (value) {
            pageIndex = value;
            controller.animateToPage(value,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(
                icon: Icon(Icons.timelapse), label: "Agenda"),
          ],
        ));
  }

  /// Actualiza el índice de la barra de navegación inferior.
  ///
  /// Este método se llama cada vez que se cambia la página en el `PageView`,
  /// y actualiza el índice `navBarIndex` para reflejar la nueva página.
  setNavBarIndex(int index) {
    setState(() {
      navBarIndex = index;
    });
  }
}
