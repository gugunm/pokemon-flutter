import 'package:flutter/material.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';

class PokemonListProvider extends ChangeNotifier {
  // Service instance
  final PokemonListService svc;

  // Constructor
  PokemonListProvider({required this.svc});

  // Pagination variables
  static const int pageSize = 20;
  int _pageCount = 0;
  final List<Result> _pokemonList = [];
  RemoteState _remoteState = RemoteStateNone();

  // Getter untuk mengakses state dari luar
  int get pageCount => _pageCount;
  RemoteState get remoteState => _remoteState;
  List<Result> get pokemonList => _pokemonList;

  // Method to fetch Pokémon list with pagination
  Future<void> fetchPokemonList() async {
    try {
      // Set loading state
      _remoteState = RemoteStateLoading();
      // Schedule notifyListeners untuk dijalankan setelah build
      Future.microtask(() => notifyListeners());

      // Fetch data from service
      final result = await svc.fetchPokemonList(
        limit: pageSize,
        offset: _pageCount * pageSize,
      );

      // Handle result using pattern matching
      switch (result) {
        case RemoteStateSuccess<PokeList>(data: var d):
          _pageCount = pageCount + 1;
          _pokemonList.addAll(d.results);
          _remoteState = RemoteStateSuccess(_pokemonList);
          break;
        case RemoteStateError(message: var m):
          _remoteState = RemoteStateError(m);
          break;
        default:
          _remoteState = RemoteStateNone();
      }

      notifyListeners();
    } on Exception catch (e) {
      _remoteState = RemoteStateError(
        'An unexpected error occurred: ${e.toString()}',
      );
      notifyListeners();
    }
  }
}
