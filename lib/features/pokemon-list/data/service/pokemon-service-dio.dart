import 'package:dio/dio.dart';
import 'package:poke_project/core/networks/dio-api-client.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';

class PokemonListService {
  final DioApiClient _dioApiClient = DioApiClient();

  Future<RemoteState> fetchPokemonList({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _dioApiClient.dio.get(
        '/pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final pokemonList = PokeList.fromJson(response.data);
        return RemoteStateSuccess<PokeList>(pokemonList);
      } else {
        return RemoteStateError(
          'Failed to load Pokémon list: ${response.toString()}',
        );
      }
    } on DioException catch (e) {
      return RemoteStateError('Failed to fetch Pokémon details: ${e.message}');
    } catch (e) {
      return RemoteStateError('An unexpected error occurred: ${e.toString()}');
    }
  }
}
