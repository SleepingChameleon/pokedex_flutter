// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'poke_api.dart';
import 'util_color.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<Map<String, dynamic>> _detailsFuture;
  bool _showShiny = false;

  @override
  void initState() {
    super.initState();
    _detailsFuture = PokeApi.fetchPokemonDetails(widget.pokemon.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          widget.pokemon.name.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Failed to load Pokémon details"));
          }

          final details = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Show Pokemon Gender
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (details['sprites']?['front_default'] != null)
                            Row(
                              children: [
                                const Icon(Icons.male, color: Colors.blue,),
                                const SizedBox(width: 4),
                              ],
                            ),
                            if (details['sprites']?['front_female'] != null)
                            Row(
                              children: [
                                const Icon(Icons.female, color: Colors.pink,),
                                const SizedBox(width: 4),
                              ],
                            )
                          ],
                        ),
                        // Shiny Toggle and Image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Show Shiny Pokemon"),
                            Switch(
                              value: _showShiny,
                              activeColor: Colors.redAccent,
                              onChanged: (val) {
                                setState(() {
                                  _showShiny = val;
                                });
                              },
                            ),
                          ],
                        ),
                        Image.network(
                          _showShiny
                              ? (details['sprites']['front_shiny'] ?? widget.pokemon.imageUrlShiny ?? widget.pokemon.imageUrl)
                              : (details['sprites']['front_female'] ?? details['sprites']['front_default'] ?? widget.pokemon.imageUrlFemale ?? widget.pokemon.imageUrl),
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: widget.pokemon.types.map((type) {
                            return Chip(
                              label: Text(
                                type.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: typeColor(type),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        buildSection("Abilities"),
                        ...details['abilities'].map<Widget>((a) =>
                          Text("• ${a['ability']['name']}", style: const TextStyle(fontSize: 16, decoration: TextDecoration.none),)
                        ).toList(),

                        const SizedBox(height: 16),
                        buildSection("Base Stats"),
                        ...details['stats'].map<Widget>((s) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(s['stat']['name'].toUpperCase())),
                                Expanded(
                                  flex: 4,
                                  child: LinearProgressIndicator(
                                    value: (s['base_stat'] / 150).clamp(0.0, 1.0),
                                    color: Colors.redAccent,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(s['base_stat'].toString()),
                              ],
                            ),
                          )
                        ).toList(),

                        const SizedBox(height: 16),
                        buildSection("Generation"),
                        Text(
                          (details['generation']?['name'] ?? 'Unknown').toString().toUpperCase(),
                          style: const TextStyle(fontSize: 16),
                        ),

                        // Pokemon Version
                        const SizedBox(height: 16),
                        buildSection("Versions"),
                        details['game_indices'] != null && details['game_indices'].isNotEmpty
                            ? Wrap(
                                spacing: 8,
                                children: [
                                  ...details['game_indices']
                                      .map<Widget>((gi) => Chip(
                                            label: Text(
                                              gi['version']['name'].toString().toUpperCase(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                          ))
                                      .toList()
                                  ],
                                )
                              : const Text("No version data available."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
