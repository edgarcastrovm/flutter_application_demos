import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import 'add_edit_pokemon_screen.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    final isFavorite = pokemonProvider.isFavorite(pokemon);

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              pokemonProvider.toggleFavorite(pokemon);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditPokemonScreen(pokemon: pokemon),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'pokemon-${pokemon.id}',
              child: Image.network(
                pokemon.imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo: ${pokemon.types.join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Altura: ${pokemon.height / 10} m'),
                  Text('Peso: ${pokemon.weight / 10} kg'),
                  const SizedBox(height: 16),
                  const Text('Habilidades:'),
                  Wrap(
                    spacing: 8,
                    children: pokemon.abilities
                        .map((ability) => Chip(label: Text(ability)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Estadísticas:'),
                  LinearProgressIndicator(
                    value: pokemon.hp / 200,
                    semanticsLabel: 'HP: ${pokemon.hp}',
                  ),
                  LinearProgressIndicator(
                    value: pokemon.attack / 200,
                    semanticsLabel: 'Ataque: ${pokemon.attack}',
                  ),
                  LinearProgressIndicator(
                    value: pokemon.defense / 200,
                    semanticsLabel: 'Defensa: ${pokemon.defense}',
                  ),
                  LinearProgressIndicator(
                    value: pokemon.speed / 200,
                    semanticsLabel: 'Velocidad: ${pokemon.speed}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}