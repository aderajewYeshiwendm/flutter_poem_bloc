import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/favorites.dart';

class FavoritesRepository {
  final String baseUrl;

  FavoritesRepository({required this.baseUrl});
  Future<List<Favorite>> fetchFav(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites?userId=$userId'),
    );
    print('statauscode:${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> favoritesJson = jsonDecode(response.body);
      print('fav json:${favoritesJson}');
      print('hi there how aare dkfjalsfj');
      return favoritesJson.map((json) => Favorite.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFav(String poemId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'poemId': poemId, 'userId': userId}),
    );
    print(response.body);
    print('added to fav');
    if (response.statusCode != 201) {
      throw Exception('Failed to add to favorites');
    }
  }

  Future<void> removeFav(String poemId, String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites?poemId=$poemId&userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print('delete fav: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }
}
