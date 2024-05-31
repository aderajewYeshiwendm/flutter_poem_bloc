import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/comment_repo.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc(this.commentRepository) : super(CommentInitial()) {
    on<FetchComments>(_onFetchComments);
    on<AddComment>(_onAddComment);
  }

  void _onFetchComments(FetchComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());

    try {
      final comments = await commentRepository.fetchComments(event.poemId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to fetch comments'));
    }
  }

  void _onAddComment(AddComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      await commentRepository.addComment(
          event.poemId, event.username, event.content);
      add(FetchComments(
          event.poemId)); // Dispatch FetchComments after adding a new comment
    } catch (e) {
      emit(CommentError('Failed to add comment'));
    }
  }
}
