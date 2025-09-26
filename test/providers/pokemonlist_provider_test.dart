import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_project/core/remote-state.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';
import 'package:poke_project/features/pokemon-list/provider/pokemon-list-provider.dart';

import '../utils/mocks.dart';

class MockPokemonService extends Mock implements PokemonListService {}

void main() {
  group('Pokemon List Provider Test', () {
    // setup instance
    late PokemonListService svc;
    late PokemonListProvider provider;

    setUp(() {
      svc = MockPokemonService();
      provider = PokemonListProvider(svc: svc);
    });

    test(
      'When load pokemon list and list is contain data, remoteState should be RemoteSuccess and pokemonList',
      () async {
        // ARRANGE
        when(() => svc.fetchPokemonList(limit: 10, offset: 0)).thenAnswer(
          (_) => Future.value(
            RemoteStateSuccess<PokeList>(
              dummyPokemonListData(pokemonList: dummyPokemonList),
            ),
          ),
        );

        // ACT
        await provider.fetchPokemonList();

        // ASSERT
        verify(() => svc.fetchPokemonList(limit: 10, offset: 0)).called(1);

        final remoteState = provider.remoteState;
        expect(remoteState, isA<RemoteStateSuccess<PokeList>>());

        final pokemonList = provider.pokemonList;
        expect(pokemonList.length, dummyPokemonList.length);
      },
    );

    test(
      'When load pokemon list and failed recieving data, remoteState should be RemoteError',
      () async {
        // arrange
        // String message = 'error';
        when(
          () => svc.fetchPokemonList(limit: 10, offset: 0),
        ).thenAnswer((_) => Future.value(RemoteStateError('Error')));

        // act
        await provider.fetchPokemonList();

        // assert
        verify(() => svc.fetchPokemonList(limit: 10, offset: 0)).called(1);

        final remoteState = provider.remoteState;
        expect(remoteState, RemoteStateError('Error'));
      },
    );
  });
}
