import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_bloc.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_event.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_state.dart';
import 'package:my_flutter_project/models/poem.dart';
import 'package:my_flutter_project/repository/poem_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Mock classes
class MockPoemRepository extends Mock implements PoemRepository {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('PoemBloc', () {
    late PoemBloc poemBloc;
    late MockPoemRepository mockPoemRepository;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockPoemRepository = MockPoemRepository();
      mockStorage = MockFlutterSecureStorage();
      poemBloc = PoemBloc(
        poemRepository: mockPoemRepository,
      );
    });

    tearDown(() {
      poemBloc.close();
    });

    test('initial state is PoemLoading', () {
      expect(poemBloc.state, equals(PoemLoading()));
    });

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemsLoadSuccess] when PoemLoad is added and repository returns poems',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockPoemRepository.getPoems(token: "anyNamed('token')"))
            .thenAnswer((_) async => [
                  Poem(
                      id: '1',
                      title: 'Poem 1',
                      content: 'Content 1',
                      author: '',
                      genre: '')
                ]);

        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemLoad()),
      expect: () => [
        PoemLoading(),
        PoemsLoadSuccess([
          Poem(
              id: '1',
              title: 'Poem 1',
              content: 'Content 1',
              author: '',
              genre: '')
        ]),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemOperationFailure] when PoemLoad is added and repository throws error',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockPoemRepository.getPoems(token: "anyNamed('token')"))
            .thenThrow(Exception('Failed to load poems'));

        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemLoad()),
      expect: () => [
        PoemLoading(),
        PoemOperationFailure(),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemsLoadSuccess] when PoemCreate is added and repository creates poem successfully',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockPoemRepository.createPoem(
                Poem(
                    id: '1',
                    title: 'Poem 1',
                    content: 'Content 1',
                    author: '',
                    genre: ''),
                token: "anyNamed('token')"))
            .thenAnswer((_) async => Poem(
                title: "title",
                author: "author",
                genre: "genre",
                content: "content"));
        when(mockPoemRepository.getPoems(token: "anyNamed('token')"))
            .thenAnswer((_) async => [
                  Poem(
                      id: '1',
                      title: 'Poem 1',
                      content: 'Content 1',
                      author: '',
                      genre: '')
                ]);

        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemCreate(Poem(
          id: '2',
          title: 'Poem 2',
          content: 'Content 2',
          author: '',
          genre: ''))),
      expect: () => [
        PoemLoading(),
        PoemsLoadSuccess([
          Poem(
              id: '1',
              title: 'Poem 1',
              content: 'Content 1',
              author: '',
              genre: '')
        ]),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemOperationFailure] when PoemCreate is added and repository throws error',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockPoemRepository.createPoem(
                Poem(
                    title: "title",
                    author: "author",
                    genre: "genre",
                    content: "content"),
                token: "anyNamed('token')"))
            .thenThrow(Exception('Failed to create poem'));

        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemCreate(Poem(
          id: '2',
          title: 'Poem 2',
          content: 'Content 2',
          author: '',
          genre: ''))),
      expect: () => [
        PoemLoading(),
        PoemOperationFailure(),
      ],
    );

    // Similarly, you can add tests for PoemUpdate and PoemDelete events.
  });
}
