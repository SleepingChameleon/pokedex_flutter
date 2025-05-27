import 'package:flutter/material.dart';
import 'poke_api.dart';
import 'util_color.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Map<String, dynamic>? pokemonData;
  bool isLoading = false;
  String? error;

  void searchPokemon(String name) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await PokeApi.fetchPokemonByName(name.toLowerCase());
      setState(() {
        pokemonData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Pokémon not found';
        isLoading = false;
        pokemonData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Pokémon name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchPokemon(_controller.text),
                ),
              ),
              onSubmitted: searchPokemon,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red))
            else if (pokemonData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${pokemonData!['name'].toUpperCase()}",
                      style: const TextStyle(fontSize: 20)),
                  Image.network(pokemonData!['sprites']['front_default']),
                  Text("Height: ${pokemonData!['height']}"),
                  Text("Weight: ${pokemonData!['weight']}"),
                  Text("Abilities: ${(pokemonData!['abilities'] as List).map((a) => a['ability']['name']).join(', ')}"),
                  Text("Moves: ${(pokemonData!['moves'] as List).map((m) => m['move']['name']).take(5).join(', ')}"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: (pokemonData!['types'] as List)
                        .map<Widget>((type) => Chip(
                              label: Text(type['type']['name'].toUpperCase()),
                              backgroundColor: typeColor(type['type']['name']),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Base Experience: ${pokemonData!['base_experience']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Stats:",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...pokemonData!['stats'].map<Widget>(
                    (stat) => Text(
                      "${stat['stat']['name'].toUpperCase()}: ${stat['base_stat']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
