// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class PokeApi {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      // Fetch each Pokémon with type details
      return Future.wait(
        results.map((pokemonData) => Pokemon.fromBasicJson(pokemonData)),
      );
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  static Future<Map<String, dynamic>> fetchPokemonByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Pokémon not found');
    }
  }
}
