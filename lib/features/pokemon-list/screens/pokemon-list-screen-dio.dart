// ignore_for_file: file_names

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';
import 'package:poke_project/features/pokemon-list/provider/pokemon-list-provider.dart';
import 'package:poke_project/features/pokemon-list/screens/pokemon-card.dart';
import 'package:provider/provider.dart';

class PokedexScreenV2 extends StatefulWidget {
  const PokedexScreenV2({super.key});

  @override
  State<PokedexScreenV2> createState() => _PokedexScreenV2State();
}

class _PokedexScreenV2State extends State<PokedexScreenV2> {
  final PokemonListService pokemonService = PokemonListService();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_loadMorePokemon);
    context.read<PokemonListProvider>().fetchPokemonList();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMorePokemon);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMorePokemon() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      dev.log('Loading more Pokémon...');
      context.read<PokemonListProvider>().fetchPokemonList();
    }
  }

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
      body: Consumer<PokemonListProvider>(
        builder: (context, provider, child) {
          final pokeList = provider.pokemonList;
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
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: pokeList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokeList[index];
                      return PokemonCard(name: pokemon.name, url: pokemon.url);
                    },
                  ),
                ),
              ],
            ),
          );
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
