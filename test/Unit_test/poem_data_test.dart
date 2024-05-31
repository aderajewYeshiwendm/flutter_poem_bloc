import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/data_provider/poem_data.dart';
import 'package:my_flutter_project/models/poem.dart';

import 'poem_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('PoemDataProvider Tests', () {
    late MockClient mockHttpClient;
    late PoemDataProvider poemDataProvider;

    setUp(() {
      mockHttpClient = MockClient();
      poemDataProvider = PoemDataProvider(httpClient: mockHttpClient);
    });

    test('createPoem - Failure', () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 400));

      final poem = Poem(
          id: '1',
          title: "Test Poem",
          author: "Test Author",
          genre: 'Test Genre',
          content: 'Test Content');

      expect(
        () => poemDataProvider.createPoem(poem, token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });

    test('getPoems - Failure', () async {
      when(mockHttpClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 400));

      expect(
        () => poemDataProvider.getPoems(token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });

    test('deletePoem - Success', () async {
      when(mockHttpClient.delete(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 204));

      final poem = Poem(
          id: '1',
          title: "Test Poem",
          author: "Test Author",
          genre: 'Test Genre',
          content: 'Test Content');

      expect(
        () => poemDataProvider.deletePoem(poem, token: "fake_token"),
        returnsNormally,
      );
    });

    test('deletePoem - Failure', () async {
      when(mockHttpClient.delete(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 400));

      final poem = Poem(
          id: '1',
          title: "Test Poem",
          author: "Test Author",
          genre: 'Test Genre',
          content: 'Test Content');

      expect(
        () => poemDataProvider.deletePoem(poem, token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });

    test('updatePoem - Success', () async {
      when(mockHttpClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final poem = Poem(
          id: '1',
          title: "Updated Test Poem",
          author: "Updated Test Author",
          genre: 'Updated Test Genre',
          content: 'Updated Test Content');

      expect(
        () => poemDataProvider.updatePoem(poem, token: "fake_token"),
        returnsNormally,
      );
    });

    test('updatePoem - Failure', () async {
      when(mockHttpClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 400));

      final poem = Poem(
          id: '1',
          title: "Updated Test Poem",
          author: "Updated Test Author",
          genre: 'Updated Test Genre',
          content: 'Updated Test Content');

      expect(
        () => poemDataProvider.updatePoem(poem, token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });
  });
}
