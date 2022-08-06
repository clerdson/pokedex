import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_search/pokedex.dart';
import 'package:github_search/pokemondetail.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      title: "Poke App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  ValueNotifier<List<Pokemon>> posts = ValueNotifier<List<Pokemon>>([]);
  ValueNotifier<bool> inLoader = ValueNotifier<bool>(false);
  List<Pokemon>? _cachedPokemons;
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  @override
  void initState() {
    super.initState();

    fetchData("");
  }

  fetchData(String text) async {
    var response = await http.get(Uri.parse(url));
    var decodedJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      posts.value = decodedJson['pokemon']
          .map((e) => Pokemon.fromJson(e))
          .toList()
          .cast<Pokemon>();
      _cachedPokemons = posts.value;

      List<Pokemon> item = _cachedPokemons!.where((element) {
        var name = element.name!.toLowerCase();
        var input = text.toLowerCase();
        return name.contains(input);
      }).toList();
      setState(() {
        posts.value = item;
      });
      inLoader.value = true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              fetchData(value);
            },
          ),
        ),
        backgroundColor: Colors.cyan,
        body: inLoader == false
            ? CircularProgressIndicator()
            : ValueListenableBuilder<List<Pokemon>>(
                valueListenable: posts,
                builder: (context, value, child) => GridView.count(
                  crossAxisCount: 2,
                  children: value
                      .map((poke) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PokeDetail(
                                              pokemon: poke,
                                            )));
                              },
                              child: Hero(
                                tag: poke.img!,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    NetworkImage(poke.img!))),
                                      ),
                                      Text(
                                        poke.name!,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ));
  }
}
