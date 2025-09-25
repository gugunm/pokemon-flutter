import 'package:flutter/material.dart';
import 'package:poke_project/features/pokemon-detail/screens/pokemon-detail.dart';
import 'package:poke_project/features/pokemon-list/screens/pokemon-list-screen-dio.dart';
import 'package:poke_project/core/navigations/navigation-route.dart';

void main() {
  runApp(MyApp());
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
      home: const PokedexScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        // Define your routes here if needed
        NavigatioRoutes.pokedexList.name: (context) => PokedexScreen(),
        NavigatioRoutes.pokedexDetail.name: (context) =>
            const PokedexDetailScreen(),
      },
    );
  }
}
