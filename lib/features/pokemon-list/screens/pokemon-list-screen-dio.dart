// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service.dart';
import 'package:poke_project/features/pokemon-list/screens/pokemon-card.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokemonListService pokemonService = PokemonListService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<RemoteState>(
        future: pokemonService.fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data is RemoteStateSuccess<PokeList>) {
            final PokeList pokeList =
                (snapshot.data as RemoteStateSuccess).data;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pokédex',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: pokeList.results.length,
                      itemBuilder: (context, index) {
                        final pokemon = pokeList.results[index];
                        return PokemonCard(
                          name: pokemon.name,
                          url: pokemon.url,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }
}
