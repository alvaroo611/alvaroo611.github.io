import 'package:flutter/material.dart';
import 'package:iseneca/models/expulsados_response.dart';
import 'package:iseneca/providers/convivencia_provider.dart';
import 'package:provider/provider.dart';

/// Pantalla que muestra la lista de expulsados
///
/// Este widget muestra una lista de expulsados donde cada elemento contiene
/// el ID del alumno, el curso y el rango de fechas de expulsión
class MenuExpulsados extends StatelessWidget {
  const MenuExpulsados({Key? key}) : super(key: key);

  /// Construye la interfaz de la pantalla de expulsados
  ///
  /// Parámetros:
  /// - [context]: El contexto de la pantalla actual donde se construye el widget
  ///
  /// Retorna:
  /// - Un widget Scaffold que contiene la estructura visual de la pantalla de expulsados
  @override
  Widget build(BuildContext context) {
    final convivenciaProvider = Provider.of<ConvivenciaProvider>(context);
    final List<Expulsado> expulsados = convivenciaProvider.listaExpulsados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expulsados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: expulsados.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Acciones cuando se toca un elemento
            },
            child: ListTile(
              title: Text(expulsados[index].idAlumno),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(expulsados[index].fecInic),
                  const Text(" - "),
                  Text(expulsados[index].fecFin),
                ],
              ),
              subtitle: Text(expulsados[index].curso),
            ),
          );
        },
      ),
    );
  }
}
