import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  final String? id;
  late final String username;
  late final String email;
  late final String password;
  late final String role;

  @override
  List<Object> get props => [id!, username, email, password, role];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "username": username,
      "password": password,
      "role": role,
      "email": email,
    };
  }

  @override
  String toString() => 'User { id: $id, email: $email, role: $role }';
}
