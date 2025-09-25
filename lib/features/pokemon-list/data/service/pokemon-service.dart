// ignore_for_file: file_names

import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';
import 'package:poke_project/features/pokemon-list/data/network/http-api-client.dart';

class PokemonService {
  final HttpApiClient _httpApiClient = HttpApiClient();

  Future<PokeList> fetchPokeList() async {
    try {
      final response = await _httpApiClient.client.get(
        Uri.parse('${_httpApiClient.baseUrl}/pokemon?limit=100&offset=0'),
      );

      if (response.statusCode < 300) {
        return pokeListFromJson(response.body);
      } else {
        throw Exception('Failed to load Pokémon list: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Pokémon list: $e');
    }
  }
}
