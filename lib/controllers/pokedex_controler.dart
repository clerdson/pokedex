import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:github_search/models/pokedex.dart';
import 'package:http/http.dart' as http;

class PoController {
  ValueNotifier<List<Pokemon>> posts = ValueNotifier<List<Pokemon>>([]);
  ValueNotifier<bool> inLoader = ValueNotifier<bool>(false);
  List<Pokemon>? _cachedPokemons;
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

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

      posts.value = item;

      inLoader.value = true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
