import 'package:flutter/material.dart';
import 'package:github_search/controllers/pokedex_controler.dart';
import 'package:github_search/models/pokedex.dart';
import 'package:github_search/view/pokemondetail.dart';

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
  final PoController _controller = PoController();
  @override
  void initState() {
    super.initState();

    _controller.fetchData("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              _controller.fetchData(value);
            },
          ),
        ),
        backgroundColor: Colors.cyan,
        body: _controller.inLoader == false
            ? CircularProgressIndicator()
            : ValueListenableBuilder<List<Pokemon>>(
                valueListenable: _controller.posts,
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
