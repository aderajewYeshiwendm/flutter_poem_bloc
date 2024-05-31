import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_bloc.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_event.dart';
import 'package:my_flutter_project/bloc/poem_bloc/poem_state.dart';
import 'package:my_flutter_project/models/poem.dart';
import 'package:my_flutter_project/repository/poem_repository.dart';
import 'poem_bloc_test.mocks.dart';

@GenerateMocks([PoemRepository, FlutterSecureStorage])
void main() {
  group('PoemBloc Tests', () {
    late MockPoemRepository mockPoemRepository;
    late MockFlutterSecureStorage mockStorage;
    late PoemBloc poemBloc;

    setUp(() {
      mockPoemRepository = MockPoemRepository();
      mockStorage = MockFlutterSecureStorage();
      poemBloc = PoemBloc(poemRepository: mockPoemRepository);
    });

    tearDown(() {
      poemBloc.close();
    });

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemsLoadSuccess] when PoemLoad event is added and loading is successful',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fakeToken');
        when(mockPoemRepository.getPoems(token: 'fakeToken'))
            .thenAnswer((_) async => [
                  Poem(
                      id: "1",
                      title: 'Test Poem',
                      content: 'Test Content',
                      genre: 'Test Genre',
                      author: 'Test Author')
                ]);
        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemLoad()),
      expect: () => [
        PoemLoading(),
        PoemsLoadSuccess([
          Poem(
              id: "1",
              title: 'Test Poem',
              content: 'Test Content',
              genre: 'Test Genre',
              author: 'Test Author')
        ]),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemOperationFailure] when PoemLoad event is added and loading fails',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fakeToken');
        when(mockPoemRepository.getPoems(token: 'fakeToken'))
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
      'emits [PoemLoading, PoemsLoadSuccess] when PoemCreate event is added and creation is successful',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fakeToken');
        when(mockPoemRepository.createPoem(any, token: 'fakeToken')).thenAnswer(
            (_) async => Poem(
                title: "title",
                author: "author",
                genre: "genre",
                content: "content"));
        when(mockPoemRepository.getPoems(token: 'fakeToken'))
            .thenAnswer((_) async => [
                  Poem(
                      id: "1",
                      title: 'Test Poem',
                      content: 'Test Content',
                      genre: 'Test Genre',
                      author: 'Test Author')
                ]);
        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemCreate(Poem(
          id: "1",
          title: 'New Poem',
          content: 'New Content',
          genre: 'New Genre',
          author: 'New Author'))),
      expect: () => [
        PoemsLoadSuccess([
          Poem(
              id: "1",
              title: 'Test Poem',
              content: 'Test Content',
              genre: 'Test Genre',
              author: 'Test Author')
        ]),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemsLoadSuccess] when PoemUpdate event is added and update is successful',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fakeToken');
        when(mockPoemRepository.updatePoem(any, token: 'fakeToken'))
            .thenAnswer((_) async => {});
        when(mockPoemRepository.getPoems(token: 'fakeToken'))
            .thenAnswer((_) async => [
                  Poem(
                      id: "1",
                      title: 'Updated Poem',
                      content: 'Updated Content',
                      genre: 'Updated Genre',
                      author: 'Updated Author')
                ]);
        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemUpdate(Poem(
          id: "1",
          title: 'Updated Poem',
          content: 'Updated Content',
          genre: 'Updated Genre',
          author: 'Updated Author'))),
      expect: () => [
        PoemsLoadSuccess([
          Poem(
              id: "1",
              title: 'Updated Poem',
              content: 'Updated Content',
              genre: 'Updated Genre',
              author: 'Updated Author')
        ]),
      ],
    );

    blocTest<PoemBloc, PoemState>(
      'emits [PoemLoading, PoemsLoadSuccess] when PoemDelete event is added and deletion is successful',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fakeToken');
        when(mockPoemRepository.deletePoem(any, token: 'fakeToken'))
            .thenAnswer((_) async => {});
        when(mockPoemRepository.getPoems(token: 'fakeToken'))
            .thenAnswer((_) async => [
                  Poem(
                      id: "2",
                      title: 'Remaining Poem',
                      content: 'Remaining Content',
                      genre: 'Remaining Genre',
                      author: 'Remaining Author')
                ]);
        return poemBloc;
      },
      act: (bloc) => bloc.add(PoemDelete(Poem(
          id: "1",
          title: 'Poem to delete',
          content: 'Content to delete',
          genre: 'Genre to delete',
          author: 'Author to delete'))),
      expect: () => [
        PoemsLoadSuccess([
          Poem(
              id: "2",
              title: 'Remaining Poem',
              content: 'Remaining Content',
              genre: 'Remaining Genre',
              author: 'Remaining Author')
        ]),
      ],
    );
  });
}
