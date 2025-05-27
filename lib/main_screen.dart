import 'package:flutter/material.dart';
import 'pokemon_list_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEE1515), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFEE1515),
          elevation: 0,
          title: Row(
            children: [
              Image.network(
                'https://raw.githubusercontent.com/PokeAPI/media/master/logo/pokeapi_256.png',
                height: 36,
              ),
              const SizedBox(width: 12),
              const Text(
                'Pokémon App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            PokemonListScreen(),
            SearchScreen(),
          ],
        ),
      ),
    );
  }
}