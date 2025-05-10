import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<Pokemon> fetchPokemon(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon/$id'));
    
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  Future<List<Pokemon>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final id = int.parse(result['url'].split('/')[6]);
        final pokemon = await fetchPokemon(id);
        pokemons.add(pokemon);
      }
      
      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }
}