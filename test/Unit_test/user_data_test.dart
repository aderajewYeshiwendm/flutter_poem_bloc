import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/data_provider/user_data.dart';
import 'package:my_flutter_project/models/user.dart';

import 'user_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('UserDataProvider Tests', () {
    late MockClient mockHttpClient;
    late UserDataProvider userDataProvider;

    setUp(() {
      mockHttpClient = MockClient();
      userDataProvider = UserDataProvider(httpClient: mockHttpClient);
    });

    test('getUsers - Failure', () async {
      when(mockHttpClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 400));

      expect(
        () => userDataProvider.getUsers(token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });

    test('deleteUser - Success', () async {
      when(mockHttpClient.delete(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 204));

      final user = User(
          id: '1',
          username: "user1",
          email: "user1@example.com",
          password: 'password',
          role: 'admin');

      expect(
        () => userDataProvider.deleteUser(user, token: "fake_token"),
        returnsNormally,
      );
    });

    test('deleteUser - Failure', () async {
      when(mockHttpClient.delete(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 400));

      final user = User(
          id: '1',
          username: "user1",
          email: "user1@example.com",
          password: 'password',
          role: 'admin');

      expect(
        () => userDataProvider.deleteUser(user, token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });

    test('updateUser - Success', () async {
      when(mockHttpClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final user = User(
          id: '1',
          username: "updatedUser",
          email: "updatedUser@example.com",
          password: 'updatedPassword',
          role: 'user');

      expect(
        () => userDataProvider.updateUser(user, token: "fake_token"),
        returnsNormally,
      );
    });

    test('updateUser - Failure', () async {
      when(mockHttpClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 400));

      final user = User(
          id: '1',
          username: "updatedUser",
          email: "updatedUser@example.com",
          password: 'updatedPassword',
          role: 'user');

      expect(
        () => userDataProvider.updateUser(user, token: "fake_token"),
        throwsA(isA<Exception>()),
      );
    });
  });
}
