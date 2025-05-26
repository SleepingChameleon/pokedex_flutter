import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'poke_api.dart' as poke_api;
import 'search_screen.dart';
import 'util_color.dart';
import 'pokemon_details_screen.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()));
            },
          )
        ],
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: poke_api.PokeApi.fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pokemons = snapshot.data!;
            ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Image.network(pokemon.imageUrl, width: 80, height: 80, fit: BoxFit.contain),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pokemon.name.toUpperCase(),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: pokemon.types.map((type) {
                                    return Chip(
                                      label: Text(
                                        type.toUpperCase(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: typeColor(type),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load data'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
