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
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text('Search Pokémon'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Pokémon name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchPokemon(_controller.text),
                ),
              ),
              onSubmitted: searchPokemon,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error!, style: const TextStyle(color: Colors.red, fontSize: 18)))
            else if (pokemonData != null)
              Center(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pokemonData!['name'].toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Image.network(
                          pokemonData!['sprites']['front_default'],
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: (pokemonData!['types'] as List)
                              .map<Widget>((type) => Chip(
                                    label: Text(type['type']['name'].toUpperCase()),
                                    backgroundColor: typeColor(type['type']['name']),
                                    labelStyle: const TextStyle(color: Colors.white),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Height: ${pokemonData!['height']}", textAlign: TextAlign.center),
                            const SizedBox(width: 16),
                            Text("Weight: ${pokemonData!['weight']}", textAlign: TextAlign.center),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Abilities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          (pokemonData!['abilities'] as List)
                              .map((a) => a['ability']['name'])
                              .join(', '),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Moves",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          (pokemonData!['moves'] as List)
                              .map((m) => m['move']['name'])
                              .take(5)
                              .join(', '),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Base Experience: ${pokemonData!['base_experience']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Stats",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        ...pokemonData!['stats'].map<Widget>(
                          (stat) => Text(
                            "${stat['stat']['name'].toUpperCase()}: ${stat['base_stat']}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ).toList(),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}