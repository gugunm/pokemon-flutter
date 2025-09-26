import 'package:poke_project/features/pokemon-detail/data/models/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-list/data/model/pokemon-list.dart';

List<Result> dummyPokemonList = [
  Result(name: 'bulbasaur', url: 'https://pokeapi.co/api/v2/pokemon/1/'),
  Result(name: 'ivysaur', url: 'https://pokeapi.co/api/v2/pokemon/2/'),
  Result(name: 'venusaur', url: 'https://pokeapi.co/api/v2/pokemon/3/'),
];

PokeList dummyPokemonListData({List<Result> pokemonList = const []}) =>
    PokeList(count: 20, next: '', previous: '', results: pokemonList);

PokeDetail dummyPokemonDetail = PokeDetail(
  weight: 12,
  abilities: [
    Ability(
      ability: Species(
        name: 'static',
        url: 'https://pokeapi.co/api/v2/ability/9/',
      ),
      isHidden: false,
      slot: 1,
    ),
  ],
  baseExperience: 112,
  cries: Cries(
    latest: 'https://example.com/latest.ogg',
    legacy: 'https://example.com/legacy.ogg',
  ),
  forms: [Species(name: "", url: 'https://pokeapi.co/api/v2/pokemon-form/id/')],
  gameIndices: [],
  height: 4,
  heldItems: [],
  id: 1,
  isDefault: true,
  locationAreaEncounters: 'https://pokeapi.co/api/v2/pokemon/id/encounters',
  moves: [],
  name: 'name',
  order: 34,
  pastAbilities: [],
  pastTypes: [],
  species: Species(
    name: 'name',
    url: 'https://pokeapi.co/api/v2/pokemon-species/id/',
  ),
  sprites: Sprites(
    backDefault: 'https://example.com/back.png',
    backFemale: null,
    backShiny: 'https://example.com/back-shiny.png',
    backShinyFemale: null,
    frontDefault: 'https://example.com/front.png',
    frontFemale: null,
    frontShiny: 'https://example.com/front-shiny.png',
    frontShinyFemale: null,
  ),
  stats: [
    Stat(
      baseStat: 35,
      effort: 0,
      stat: Species(name: 'hp', url: ''),
    ),
    Stat(
      baseStat: 35,
      effort: 0,
      stat: Species(name: 'dss', url: ''),
    ),
  ],
  types: [
    Type(
      slot: 1,
      type: Species(name: 'electric', url: ''),
    ),
  ],
);
