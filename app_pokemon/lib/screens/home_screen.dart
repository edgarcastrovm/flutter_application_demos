import 'package:flutter/material.dart';
import 'pokemon_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pokemon_logo.png',
              height: 150,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PokemonListScreen(),
                  ),
                );
              },
              child: const Text('Ver todos los Pokémon'),
            ),
          ],
        ),
      ),
    );
  }
}