// ignore_for_file: file_names

enum NavigatioRoutes {
  pokedexList(name: '/pokedex'),
  pokedexDetail(name: '/pokedex/detail');

  const NavigatioRoutes({required this.name});
  final String name;
}
