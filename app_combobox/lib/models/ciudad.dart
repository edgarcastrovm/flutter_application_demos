class Ciudad {
  final int id;
  final String nombre;
  final String descripcion;

  Ciudad({required this.id, required this.nombre, required this.descripcion});

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}