import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'poke_api.dart' as poke_api;
import 'util_color.dart';
import 'pokemon_details_screen.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex Information"),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: poke_api.PokeApi.fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pokemons = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75, // Adjust for card height/width
            ),
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
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                  elevation: 2,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        CachedNetworkImage(
                          imageUrl: pokemon.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: pokemon.types.map((type) {
                            return Chip(
                              label: Text(
                                type.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: typeColor(type),
                            );
                          }).toList(),
                        ),
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
