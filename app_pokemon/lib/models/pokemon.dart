class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<String> abilities;
  final int hp;
  final int attack;
  final int defense;
  final int speed;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      types: (json['types'] as List).map((type) => type['type']['name'].toString()).toList(),
      height: json['height'],
      weight: json['weight'],
      abilities: (json['abilities'] as List).map((ability) => ability['ability']['name'].toString()).toList(),
      hp: json['stats'][0]['base_stat'],
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      speed: json['stats'][5]['base_stat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'height': height,
      'weight': weight,
      'abilities': abilities,
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'speed': speed,
    };
  }
}