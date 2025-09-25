// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:poke_project/core/navigations/navigation-route.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-detail/data/models/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-detail/data/service/pokemon-detail-service.dart';
import 'package:poke_project/features/pokemon-list/data/network/http-api-client.dart';

class PokemonCard extends StatefulWidget {
  final String name;
  final List<String> types;
  final String url;

  const PokemonCard({
    super.key,
    required this.name,
    this.types = const ['Default', 'Type'],
    required this.url,
  });

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  final PokemonDetailService _pokemonDetailService = PokemonDetailService();

  // Local state variables
  PokeDetail? _pokeDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetail();
  }

  Future<void> _fetchPokemonDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final state = await _pokemonDetailService.fetchPokemonDetail('1');

      if (mounted) {
        // Check if widget is still mounted before calling setState
        if (state is RemoteStateSuccess<PokeDetail>) {
          setState(() {
            _pokeDetail = state.data;
            _isLoading = false;
          });
          print('Fetched details for Bulbasaur: ${state.data}');
        } else if (state is RemoteStateError) {
          setState(() {
            _errorMessage = state.message;
            _isLoading = false;
          });
          print('Error fetching details: ${state.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unexpected error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(widget.url);

    String? pokeId = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.where((segment) => segment.isNotEmpty).last
        : null;

    Color cardColor = pokeId != null
        ? HSLColor.fromAHSL(
            0.85, // opacity
            (pokeId.hashCode % 360).toDouble(), // hue
            0.65, // saturation
            0.45, // lightness (dark enough for white text)
          ).toColor()
        : const Color(0xFF6C63FF);

    String capitalizedName = widget.name.isNotEmpty
        ? '${widget.name[0].toUpperCase()}${widget.name.substring(1)}'
        : widget.name;

    // Handle different states in your UI
    if (_isLoading) {
      return const Card(child: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fetchPokemonDetail,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_pokeDetail == null) {
      return const Card(child: Center(child: Text('No data available')));
    }

    return GestureDetector(
      onTap: () {
        print('Tapped on ${widget.name}');
        Navigator.pushNamed(
          context,
          NavigatioRoutes.pokedexDetail.name,
          arguments: {
            'pokeId': pokeId,
            'name': capitalizedName,
            'color': cardColor,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Content positioned normally
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      pokeId != null ? '#$pokeId' : '#000',
                      style: TextStyle(
                        color: Colors.black.withAlpha(51),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    capitalizedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _pokeDetail!.types.length; i++) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF).withAlpha(77),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _pokeDetail!.types[i].type.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (i < _pokeDetail!.types.length - 1)
                          const SizedBox(height: 4),
                      ],
                    ],
                  ),
                ],
              ),
              // Image positioned absolutely in bottom right
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.network(
                  getImageUrl(pokeId ?? '0'),
                  width: 84,
                  height: 84,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
