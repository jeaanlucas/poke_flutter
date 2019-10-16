import 'package:flutter/material.dart';
import 'package:flutter_app/listagem_pokemon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListagemPokemon(
        title: 'Listagem de Pokemons',
      ),
    );
  }
}