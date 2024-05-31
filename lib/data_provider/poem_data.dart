import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/poem.dart';

class PoemDataProvider {
  final _baseUrl = 'http://localhost:3000/api/poems/';
  final http.Client httpClient;

  PoemDataProvider({required this.httpClient});

  Future<Poem> createPoem(Poem poem, {required String token}) async {
    final response = await httpClient.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': poem.title,
        'author': poem.author,
        'genre': poem.genre,
        'content': poem.content,
      }),
    );

    if (response.statusCode == 201) {
      print('hi poem created successfully');
      return Poem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Poem.');
    }
  }

  Future<List<Poem>> getPoems({required String token}) async {
    final response = await httpClient.get(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> poemJson = jsonDecode(response.body);
      return poemJson.map((json) => Poem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Poems');
    }
  }

  Future<void> deletePoem(Poem poem, {required String token}) async {
    final http.Response response = await httpClient.delete(
      Uri.parse('$_baseUrl${poem.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete Poem.');
    }
  }

  Future<void> updatePoem(Poem poem, {required String token}) async {
    final http.Response response = await httpClient.put(
      Uri.parse('$_baseUrl${poem.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': poem.id,
        'title': poem.title,
        'author': poem.author,
        'genre': poem.genre,
        'content': poem.content,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update Poem.');
    }
  }
}
