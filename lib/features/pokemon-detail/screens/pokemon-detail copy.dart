// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-detail/data/models/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-detail/data/service/pokemon-detail-service.dart';
import 'package:poke_project/features/pokemon-list/data/network/http-api-client.dart';

class PokedexDetailScreen extends StatefulWidget {
  const PokedexDetailScreen({super.key});

  @override
  State<PokedexDetailScreen> createState() => _PokedexDetailScreenState();
}

class _PokedexDetailScreenState extends State<PokedexDetailScreen>
    with TickerProviderStateMixin {
  final PokemonDetailService pokemonDetailService = PokemonDetailService();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final pokeIdFromArgs = args != null && args['pokeId'] != null
        ? args['pokeId'] as String
        : '000';

    final nameFromArgs = args != null && args['name'] != null
        ? args['name'] as String
        : 'Unknown';

    final Color colorFromArgs = args != null && args['color'] != null
        ? args['color'] as Color
        : Colors.grey;

    // Check if _tabController is initialized before building the widget tree
    if (_tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: FutureBuilder<RemoteState>(
        future: pokemonDetailService.fetchPokemonDetail(pokeIdFromArgs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final remoteState = snapshot.data!;
            if (remoteState is RemoteStateSuccess<PokeDetail>) {
              final pokeDetail = remoteState.data;
              // Use pokeDetail to build your UI
              return Column(
                children: [
                  // Top curved section with Pokemon info
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorFromArgs,
                          colorFromArgs.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background circles for decoration
                        Positioned(
                          top: 100,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          right: 50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top bar with back button and heart
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Pokemon name and number
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameFromArgs,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '#$pokeIdFromArgs',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Type badges
                                Row(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < pokeDetail.types.length;
                                      i++
                                    ) ...[
                                      _buildTypeBadge(
                                        pokeDetail.types[i].type.name,
                                      ),
                                      if (i < pokeDetail.types.length - 1)
                                        const SizedBox(width: 8),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Pokemon image centered horizontally
                                Expanded(
                                  child: Center(
                                    child: Image.network(
                                      getImageUrl(pokeIdFromArgs),
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      controller: _tabController!,
                      indicatorColor: Colors.blue,
                      indicatorWeight: 3,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[400],
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Base Stats'),
                        Tab(text: 'Evolution'),
                        Tab(text: 'Moves'),
                      ],
                    ),
                  ),

                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController!,
                      children: [
                        _buildAboutTab(pokeDetail),
                        _buildBaseStatsTab(pokeDetail),
                        _buildEvolutionTab(pokeDetail),
                        _buildMovesTab(pokeDetail),
                      ],
                    ),
                  ),
                ],
              );
            } else if (remoteState is RemoteStateError) {
              return Center(child: Text('Error: ${remoteState.message}'));
            }
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAboutTab(PokeDetail pokeDetail) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatRow('Species', pokeDetail.species.name),
          SizedBox(height: 16),
          _buildStatRow('Height', pokeDetail.height.toString()),
          SizedBox(height: 16),
          _buildStatRow('Weight', '${pokeDetail.weight.toString()} hg'),
          SizedBox(height: 16),
          _buildStatRow(
            'Abilities',
            pokeDetail.abilities.map((a) => a.ability?.name).join(', '),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Breeding',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBaseStatsTab(PokeDetail pokeDetail) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatBar('HP', pokeDetail.stats[0].baseStat, Colors.red),
          _buildStatBar('Attack', pokeDetail.stats[1].baseStat, Colors.orange),
          _buildStatBar('Defense', pokeDetail.stats[2].baseStat, Colors.yellow),
          _buildStatBar('Sp. Atk', pokeDetail.stats[3].baseStat, Colors.blue),
          _buildStatBar('Sp. Def', pokeDetail.stats[4].baseStat, Colors.green),
          _buildStatBar('Speed', pokeDetail.stats[5].baseStat, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildEvolutionTab(PokeDetail pokeDetail) {
    return Center(
      child: Text(
        'Evolution chain would go here',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildMovesTab(PokeDetail pokeDetail) {
    return Center(
      child: Text(
        'Moves list would go here',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(String label, int value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 30,
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
