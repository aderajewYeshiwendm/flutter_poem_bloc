import 'package:equatable/equatable.dart';

class Poem extends Equatable {
  Poem({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.content,
  });

  final String? id;
  late final String title;
  late final String author;
  late final String genre;
  late final String content;

  @override
  List<Object> get props => [id!, title, author, genre, content];

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      content: json['content'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "genre": genre,
      "content": content,
      "author": author,
    };
  }

  @override
  String toString() => 'Poem { id: $id, author: $author, content: $content }';
}
