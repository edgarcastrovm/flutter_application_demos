import 'ciudad.dart';

class Pais {
  final int id;
  final String nombre;
  final List<Ciudad> ciudades;

  Pais({required this.id, required this.nombre, required this.ciudades});

  factory Pais.fromJson(Map<String, dynamic> json) {
    var ciudadesList = (json['ciudades'] as List)
        .map((ciudadJson) => Ciudad.fromJson(ciudadJson))
        .toList();
    return Pais(
      id: json['id'],
      nombre: json['nombre'],
      ciudades: ciudadesList,
    );
  }
}