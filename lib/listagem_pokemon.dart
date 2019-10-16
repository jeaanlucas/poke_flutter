import 'package:flutter/material.dart';
import 'package:flutter_app/visualizar_pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ListagemPokemon extends StatefulWidget {
  final String title;

  ListagemPokemon({
    this.title,
  });

  @override
  _ListagemPokemonState createState() => _ListagemPokemonState();
}

class _ListagemPokemonState extends State<ListagemPokemon> {
  List<dynamic> _listaPokemons;

  Future _carregarLista() async {
    _listaPokemons = await _trazPokemons();

    return await _listaPokemons;
  }

  Future<List> _trazPokemons() async {
    final response = await http.get('https://pokeapi.co/api/v2/pokemon/');
    final json = convert.jsonDecode(response.body);
    return json['results'];
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _carregarLista(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: _listaPokemons.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text(
                          'Pokemon: ${capitalize(_listaPokemons[index]['name'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          _listaPokemons[index]['url'],
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisualizarPokemon(
                            url: _listaPokemons[index]['url'],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
