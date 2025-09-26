// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:poke_project/core/networks/dio-api-client.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-detail/data/models/pokemon-detail.dart';

class PokemonDetailService {
  final DioApiClient _dioApiClient = DioApiClient();

  Future<RemoteState> fetchPokemonDetail(String pokeId) async {
    try {
      final response = await _dioApiClient.dio.get('/pokemon/$pokeId');

      return RemoteStateSuccess<PokeDetail>(PokeDetail.fromJson(response.data));
    } on DioException catch (e) {
      return RemoteStateError('Failed to fetch Pokémon details: ${e.message}');
    } catch (e) {
      return RemoteStateError('An unexpected error occurred: ${e.toString()}');
    }
  }
}
