import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/comment.dart';

class CommentRepository {
  final String baseUrl;

  CommentRepository({required this.baseUrl});

  Future<List<Comment>> fetchComments(String poemId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/comments?poemId=$poemId'));
    print('fetched comments');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> commentJson = jsonDecode(response.body);
      print(commentJson);
      return commentJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(
      String poemId, String username, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode({'poemId': poemId, 'content': content, 'username': username}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }
}
