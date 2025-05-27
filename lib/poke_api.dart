// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class PokeApi {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

static Future<List<Pokemon>> fetchPokemonList() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;

      // Fetch full detail for each Pokémon
      final pokemons = await Future.wait(results.map((pokemonData) async {
        final detailResponse = await http.get(Uri.parse(pokemonData['url']));
        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);

          // Add the basic URL (since detail API doesn’t include it)
          detailData['url'] = pokemonData['url'];

          return Pokemon.fromJson(detailData);
        } else {
          throw Exception('Failed to load detail for ${pokemonData['name']}');
        }
      }));

      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  } catch (e) {
    print('Error fetching Pokémon list: $e');
    return [];
  }
}  static Future<Map<String, dynamic>> fetchPokemonDetails(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  static Future<Map<String, dynamic>> fetchPokemonByName(String name) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Pokémon not found');
    }
  }
}
