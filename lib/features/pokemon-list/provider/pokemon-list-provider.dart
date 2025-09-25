import 'package:flutter/material.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';

class PokemonListProvider extends ChangeNotifier {
  final PokemonListService svc;

  PokemonListProvider({required this.svc});

  final int pageSize = 20;

  RemoteState _remoteState = RemoteStateNone();
  RemoteState get remoteState => _remoteState;

  int _pageCount = 0;
  int get pageCount => _pageCount;

  final List<Result> _pokemonList = [];
  List<Result> get pokemonList => _pokemonList;

  Future<void> fetchPokemonList() async {
    try {
      _remoteState = RemoteStateLoading();

      // notifyListeners();

      // Schedule notifyListeners untuk dijalankan setelah build
      Future.microtask(() => notifyListeners());

      final result = await svc.fetchPokemonList(
        limit: pageSize,
        offset: _pageCount * pageSize,
      );

      switch (result) {
        case RemoteStateSuccess<PokeList>(data: var d):
          _pageCount = pageCount + 1;
          _pokemonList.addAll(d.results);
          _remoteState = RemoteStateSuccess(_pokemonList);
          notifyListeners();
          break;
        case RemoteStateError(message: var m):
          _remoteState = RemoteStateError(m);
          notifyListeners();
          break;
        default:
          _remoteState = RemoteStateNone();
          notifyListeners();
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
