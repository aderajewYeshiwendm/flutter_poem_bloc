import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final String poemId;

  const FetchComments(this.poemId);

  @override
  List<Object> get props => [poemId];
}

class AddComment extends CommentEvent {
  final String poemId;
  final String username;
  final String content;

  const AddComment(
      {required this.poemId, required this.username, required this.content});

  @override
  List<Object> get props => [poemId, username, content];
}
