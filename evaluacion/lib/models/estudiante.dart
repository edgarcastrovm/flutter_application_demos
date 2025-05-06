class Estudiante {
  final String nombres;
  final int edad;
  final DateTime fecha;
  final String pais;
  final String ciudad;
  final double cuotaInicial;
  final double cuotaMensual;

  Estudiante({
    required this.nombres,
    required this.edad,
    required this.fecha,
    required this.pais,
    required this.ciudad,
    required this.cuotaInicial,
    required this.cuotaMensual,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'edad': edad,
      'fecha': fecha.toIso8601String(),
      'pais': pais,
      'ciudad': ciudad,
      'cuotaInicial': cuotaInicial,
      'cuotaMensual': cuotaMensual,
    };
  }

  factory Estudiante.fromMap(Map<String, dynamic> map) {
    return Estudiante(
      nombres: map['nombres'],
      edad: map['edad'],
      fecha: DateTime.parse(map['fecha']),
      pais: map['pais'],
      ciudad: map['ciudad'],
      cuotaInicial: map['cuotaInicial'],
      cuotaMensual: map['cuotaMensual'],
    );
  }
}
