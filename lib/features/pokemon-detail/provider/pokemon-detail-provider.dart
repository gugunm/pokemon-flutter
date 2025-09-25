import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-detail/data/models/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-detail/data/service/pokemon-detail-service.dart';

// Provider yang menerima parameter 'id'
final pokemonDetailProvider = FutureProvider.family<PokeDetail, String>((
  ref,
  id,
) async {
  final PokemonDetailService svc = PokemonDetailService();
  final RemoteState result = await svc.fetchPokemonDetail(id);
  if (result is RemoteStateSuccess<PokeDetail>) {
    return result.data;
  } else {
    throw Exception('Failed to fetch Pokemon detail');
  }
});
