import 'package:flutter/material.dart';

Color typeColor(String type) {
  switch (type) {
    case 'fire':
      return Colors.redAccent;
    case 'water':
      return Colors.blue;
    case 'grass':
      return Colors.green;
    case 'electric':
      return Colors.yellow.shade700;
    case 'ground':
      return Colors.brown;
    case 'rock':
      return Colors.grey;
    case 'psychic':
      return Colors.pink;
    case 'poison':
      return Colors.purple;
    case 'bug':
      return Colors.lightGreen;
    case 'flying':
      return Colors.lightBlueAccent;
    case 'dragon':
      return Colors.indigo;
    case 'dark':
      return Colors.black87;
    case 'fairy':
      return Colors.pinkAccent;
    case 'ice':
      return Colors.cyan;
    default:
      return Colors.grey.shade600;
  }
}