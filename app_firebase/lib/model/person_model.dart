class Person {
  final String name;
  final String surname;

  Person({required this.name, required this.surname});

  Map<String, dynamic> toJson() {
    return {'name': name, 'surname': surname};
  }

  static Person fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Person(name: $name, surname: $surname)';
  }
}

// Modelo que incluye el ID del documento
class PersonWithId extends Person {
  final String id;

  PersonWithId({required super.name, required super.surname, required this.id});

  factory PersonWithId.fromJson(String id,Map<String, dynamic> json) {
    return PersonWithId(
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      id: id,
    );
  }

  @override
  String toString() {
    return 'PersonConId(id: $id, name: $name, surname: $surname)';
  }
}
