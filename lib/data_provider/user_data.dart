import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserDataProvider {
  final _baseUrl = 'http://10.0.2.2:3000/api/users/';
  final http.Client httpClient;

  UserDataProvider({required this.httpClient});

  Future<List<User>> getUsers({required String token}) async {
    final response =
        await httpClient.get(Uri.parse(_baseUrl), headers: <String, String>{
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> userJson = jsonDecode(response.body);
      return userJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deleteUser(User user, {required String token}) async {
    final http.Response response = await httpClient.delete(
      Uri.parse('$_baseUrl${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<void> updateUser(User user, {required String token}) async {
    final http.Response response = await httpClient.put(
      Uri.parse('http://10.0.2.2:3000/api/allusers/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'role': user.role,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update user.');
    }
  }
}
