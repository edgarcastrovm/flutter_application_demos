import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon.dart';

class LocalStorage {
  static const String _favoritesKey = 'favorite_pokemons';

  Future<void> saveFavoritePokemon(Pokemon pokemon) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritePokemons();
    favorites.add(pokemon);
    await prefs.setStringList(
      _favoritesKey,
      favorites.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }

  Future<List<Pokemon>> getFavoritePokemons() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((p) => Pokemon.fromJson(jsonDecode(p))).toList();
  }

  Future<void> removeFavoritePokemon(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritePokemons();
    favorites.removeWhere((p) => p.id == pokemonId);
    await prefs.setStringList(
      _favoritesKey,
      favorites.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }
}