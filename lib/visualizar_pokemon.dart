import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class VisualizarPokemon extends StatefulWidget {
  final String url;

  VisualizarPokemon({
    this.url,
  });

  @override
  _VisualizarPokemonState createState() => _VisualizarPokemonState(this.url);
}

class _VisualizarPokemonState extends State<VisualizarPokemon> {
  final String url;

  _VisualizarPokemonState(this.url);

  List<Color> coresHabilidades = [
    Colors.purpleAccent,
    Colors.lightGreen,
    Colors.pinkAccent,
  ];
  List habilidades;
  String nome;
  String foto;

  @override
  void initState() {
    super.initState();

    _dadosPokemon();
  }

  void _dadosPokemon() async {
    final response = await http.get(this.url);
    final json = convert.jsonDecode(response.body);

    setState(() {
      habilidades = json['abilities'];
      nome = json['name'];
      foto = json['sprites']['front_default'];
    });
  }

  Future _retornaHabilidades() async {
    return await habilidades;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            nome != null ? capitalize(nome) : '',
          ),
        ),
      ),
      body: FutureBuilder(
        future: _retornaHabilidades(),
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.network(foto),
              ),
              Text(
                'Habilidades',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.redAccent,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: habilidades.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Center(
                        child: Text(
                          capitalize(habilidades[index]['ability']['name']),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: coresHabilidades[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              Image.network(
                'https://miro.medium.com/max/350/1*Yf66eLjU4H3g7pIvpXlM5w.jpeg',
                width: width * 0.7,
                height: height * 0.4,
              ),
            ],
          );
        },
      ),
    );
  }
}
