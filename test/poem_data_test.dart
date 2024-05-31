import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_project/data_provider/poem_data.dart';
import 'package:my_flutter_project/poem.dart';

// Annotations for generated mock http client
@GenerateMocks([http.Client])
void main() {
  group('PoemDataProvider Tests', () {
    late MockClient mockHttpClient;
    late PoemDataProvider poemDataProvider;

    setUp(() {
      mockHttpClient =
          MockClient((request) async => http.Response("body", 200));
      poemDataProvider = PoemDataProvider(httpClient: mockHttpClient);
    });

    test('createPoem - Success', () async {
      // Mock successful response
      final mockResponse =
          http.Response('{"id": 1, "title": "Test Poem"}', 201);
      when(mockHttpClient.post(Uri(), headers: any, body: any))
          .thenAnswer((_) => Future.value(mockResponse));

      final poem = Poem(
          title: "Test Poem",
          author: "Test Author",
          genre: 'kfdk',
          content: 'fjdkl');
      final createdPoem =
          await poemDataProvider.createPoem(poem, token: "fdkl");

      expect(createdPoem.id, 1);
      expect(createdPoem.title, "Test Poem");
    });

    test('createPoem - Failure', () async {
      // Mock failed response
      when(mockHttpClient.post(Uri(), headers: any, body: any))
          .thenAnswer((_) => Future.value(http.Response('', 400)));

      final poem = Poem(
          title: "Test Poem",
          author: "Test Author",
          genre: 'fj',
          content: 'fjdk');

      expect(
        () => poemDataProvider.createPoem(poem, token: "fjkdl"),
        throwsA(isA<Exception>()),
      );
    });

    // Similar tests for getPoems, deletePoem, updatePoem

    test('getPoems - Success', () async {
      // Mock successful response with list of poems
      final mockResponse = http.Response(
          '[{"id": 1, "title": "Poem 1"}, {"id": 2, "title": "Poem 2"}]', 200);
      when(mockHttpClient.get(Uri(), headers: any))
          .thenAnswer((_) => Future.value(mockResponse));

      final poems = await poemDataProvider.getPoems(token: "");

      expect(poems.length, 2);
      expect(poems[0].id, 1);
      expect(poems[0].title, "Poem 1");
    });

    test('getPoems - Failure', () async {
      // Mock failed response
      when(mockHttpClient.get(Uri(), headers: any))
          .thenAnswer((_) => Future.value(http.Response('', 401)));
      final poem = Poem(
          title: "Test Poem",
          author: "Test Author",
          genre: 'fj',
          content: 'fjdk');

      expect(
        () => poemDataProvider.createPoem(poem, token: "fjkdl"),
        throwsA(isA<Exception>()),
      );
    });

    // ... similar tests for deletePoem and updatePoem
  });
}
