import 'package:flutter/material.dart';
import 'package:poke_project/features/pokemon-detail/screens/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-list/data/service/pokemon-service-dio.dart';
import 'package:poke_project/features/pokemon-list/provider/pokemon-list-provider.dart';
import 'package:poke_project/features/pokemon-list/screens/pokemon-list-screen-dio.dart';
import 'package:poke_project/core/navigations/navigation-route.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => PokemonListService()),
        ChangeNotifierProvider(
          create: (context) =>
              PokemonListProvider(svc: context.read<PokemonListService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PokedexScreenV2(),
      debugShowCheckedModeBanner: false,
      routes: {
        // Define your routes here if needed
        NavigatioRoutes.pokedexList.name: (context) => PokedexScreenV2(),
        NavigatioRoutes.pokedexDetail.name: (context) =>
            const PokedexDetailScreen(),
      },
    );
  }
}
