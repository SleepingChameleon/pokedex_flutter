class Pokemon {
  final String name;
  final String url;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final List<String> moves;
  final String imageUrl;
  final String imageUrlShiny;
  final String imageUrlFemale;
  final Map<String, int> stats;

  Pokemon({
    required this.name,
    required this.url,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.moves,
    required this.imageUrl,
    required this.imageUrlShiny,
    required this.imageUrlFemale,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
      height: json['height'],
      weight: json['weight'],
      types: List<String>.from(json['types'].map((t) => t['type']['name'])),
      abilities: List<String>.from(json['abilities'].map((a) => a['ability']['name'])),
      moves: List<String>.from(json['moves'].map((m) => m['move']['name'])),
      imageUrl: json['sprites']['front_default'] ?? '',
      imageUrlShiny: json['sprites']['front_shiny'] ?? '',
      imageUrlFemale: json['sprites']['front_female'] ?? '',
      stats: {
        for (var stat in json['stats'])
          stat['stat']['name']: stat['base_stat'],
      }
    );
  }

  //  factory Pokemon.fromBasicJson(Map<String, dynamic> json) {
  //   return Pokemon(
  //     name: json['name'],
  //     url: json['url'], // This is usually the URL to get more data
  //     height: 0, // Height will be fetched later
  //     weight: 0, // Weight will be fetched later
  //     types: [],
  //     abilities: [],
  //     moves: [],
  //     imageUrl: '', // Image URL will be fetched later
  //   );
  // }
}
