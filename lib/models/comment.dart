import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String content;
  final String username;
  final String poemId;

  Comment({
    required this.id,
    required this.content,
    required this.username,
    required this.poemId,
  });
  @override
  List<Object> get props => [id, content, username, poemId];
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      content: json['content'],
      username: json['username'],
      poemId: json['poemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'username': username,
      'poemId': poemId,
    };
  }

  @override
  String toString() =>
      'Comment { poemId: $poemId, username: $username, content: $content }';
}
