import 'dart:convert';

class ExpulsadosResponse {
  ExpulsadosResponse({
    required this.results,
  });

  List<Expulsado> results;

  factory ExpulsadosResponse.fromJson(String str) =>
      ExpulsadosResponse.fromMap(json.decode(str));

  factory ExpulsadosResponse.fromMap(Map<String, dynamic> json) =>
      ExpulsadosResponse(
        results: List<Expulsado>.from(
            json["results"].map((x) => Expulsado.fromMap(x))),
      );
}

class Expulsado {
  Expulsado({
    required this.idAlumno,
    required this.curso,
    required this.fecInic,
    required this.fecFin,
    required this.fecVuelta,
    required this.numDias,
    required this.tipoExpulsion,
    required this.expulsionEntregada,
    required this.expulsionFirmada,
    this.observaciones,
  });

  String idAlumno;
  String curso;
  String fecInic;
  String fecFin;
  String fecVuelta;
  int numDias;
  String tipoExpulsion;
  bool expulsionEntregada;
  bool expulsionFirmada;
  String? observaciones;

  factory Expulsado.fromJson(String str) => Expulsado.fromMap(json.decode(str));

  factory Expulsado.fromMap(Map<String, dynamic> json) {
    return Expulsado(
      idAlumno: json["ALUMNO"] ?? "",  // Verifica que las claves coincidan
      curso: json["CURSO"] ?? "",
      fecInic: json["FECHA \nINICIO"] ?? "",
      fecFin: json["FECHA \nFINAL"] ?? "",
      fecVuelta: json["FECHA \nVUELTA"] ?? "",
      numDias: int.tryParse(json["Nº\nDIAS"].toString()) ?? 0,
      tipoExpulsion: json["TIPO\nEXPULSIÓN"] ?? "",
      expulsionEntregada: json["EXPULSIÓN ENTREGADA"] == "TRUE",
      expulsionFirmada: json["EXPULSIÓN FIRMADA"] == "TRUE",
      observaciones: json["OBSERVACIONES"],
    );
  }
}
