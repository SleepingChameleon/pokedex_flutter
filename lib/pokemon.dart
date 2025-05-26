
class Pokemon {
  final String name;
  final int id;
  final String url;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final List<String> moves;
  final String imageUrl;
  final String shinyImageUrl;

  Pokemon({
    required this.name,
    required this.id,
    required this.url,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.moves,
    required this.imageUrl,
    required this.shinyImageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      url: json['url'],
      height: json['height'],
      weight: json['weight'],
      types: List<String>.from(json['types'].map((t) => t['type']['name'])),
      abilities: List<String>.from(json['abilities'].map((a) => a['ability']['name'])),
      moves: List<String>.from(json['moves'].map((m) => m['move']['name'])),
      imageUrl: json['sprites']['front_default'] ?? '',
      shinyImageUrl: json['sprites']['front_shiny'] ?? '',
    );
  }

  static Future<Pokemon> fromBasicJson(pokemonData) async {
    throw UnimplementedError('fromBasicJson is not yet implemented');
  }
}
