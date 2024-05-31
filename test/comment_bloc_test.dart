import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/comment_bloc/comment_bloc.dart';
import 'package:my_flutter_project/bloc/comment_bloc/comment_event.dart';
import 'package:my_flutter_project/bloc/comment_bloc/comment_state.dart';
import 'package:my_flutter_project/repository/comment_repo.dart';
import 'package:my_flutter_project/models/comment.dart';

// Mock class for CommentRepository
class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  group('CommentBloc', () {
    late CommentBloc commentBloc;
    late MockCommentRepository mockCommentRepository;

    setUp(() {
      mockCommentRepository = MockCommentRepository();
      commentBloc = CommentBloc(mockCommentRepository);
    });

    tearDown(() {
      commentBloc.close();
    });

    test('initial state is CommentInitial', () {
      expect(commentBloc.state, equals(CommentInitial()));
    });

    blocTest<CommentBloc, CommentState>(
      'emits [CommentLoading, CommentLoaded] when FetchComments is added',
      build: () {
        when(mockCommentRepository.fetchComments("any")).thenAnswer((_) async =>
            [
              Comment(
                  id: '1',
                  content: 'Test comment',
                  username: 'User1',
                  poemId: '9')
            ]);
        return commentBloc;
      },
      act: (bloc) => bloc.add(FetchComments('poemId')),
      expect: () => [
        CommentLoading(),
        CommentLoaded([
          Comment(
              id: '1', content: 'Test comment', username: 'User1', poemId: '9')
        ]),
      ],
    );

    blocTest<CommentBloc, CommentState>(
      'emits [CommentLoading, CommentError] when FetchComments fails',
      build: () {
        when(mockCommentRepository.fetchComments("any"))
            .thenThrow(Exception('Failed to fetch comments'));
        return commentBloc;
      },
      act: (bloc) => bloc.add(FetchComments('poemId')),
      expect: () => [
        CommentLoading(),
        CommentError('Failed to fetch comments'),
      ],
    );

    blocTest<CommentBloc, CommentState>(
      'emits [CommentLoading, CommentLoading, CommentLoaded] when AddComment is added',
      build: () {
        when(mockCommentRepository.addComment("any", "any", "any"))
            .thenAnswer((_) async => null);
        when(mockCommentRepository.fetchComments("any")).thenAnswer((_) async =>
            [
              Comment(
                  id: '1',
                  content: 'Test comment',
                  username: 'User1',
                  poemId: '89')
            ]);
        return commentBloc;
      },
      act: (bloc) => bloc.add(AddComment(
          poemId: 'poemId', username: 'User1', content: 'Test comment')),
      expect: () => [
        CommentLoading(),
        CommentLoading(),
        CommentLoaded([
          Comment(
              id: '1',
              content: 'Test comment',
              username: 'User1',
              poemId: '489')
        ]),
      ],
    );

    blocTest<CommentBloc, CommentState>(
      'emits [CommentLoading, CommentError] when AddComment fails',
      build: () {
        when(mockCommentRepository.addComment("any", "any", "any"))
            .thenThrow(Exception('Failed to add comment'));
        return commentBloc;
      },
      act: (bloc) => bloc.add(AddComment(
          poemId: 'poemId', username: 'User1', content: 'Test comment')),
      expect: () => [
        CommentLoading(),
        CommentError('Failed to add comment'),
      ],
    );
  });
}
