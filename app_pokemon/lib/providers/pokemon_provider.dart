import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';

class PokemonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorage _localStorage = LocalStorage();

  List<Pokemon> _pokemons = [];
  List<Pokemon> _favorites = [];
  bool _isLoading = false;

  List<Pokemon> get pokemons => _pokemons;
  List<Pokemon> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchPokemons() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pokemons = await _apiService.fetchPokemonList();
      _favorites = await _localStorage.getFavoritePokemons();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching pokemons: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    if (_favorites.any((p) => p.id == pokemon.id)) {
      await _localStorage.removeFavoritePokemon(pokemon.id);
    } else {
      await _localStorage.saveFavoritePokemon(pokemon);
    }
    _favorites = await _localStorage.getFavoritePokemons();
    notifyListeners();
  }

  bool isFavorite(Pokemon pokemon) {
    return _favorites.any((p) => p.id == pokemon.id);
  }
}