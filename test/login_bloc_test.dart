import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_bloc.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_event.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Mock classes
class MockHttpClient extends Mock implements http.Client {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;
    late MockHttpClient mockHttpClient;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockStorage = MockFlutterSecureStorage();
      loginBloc = LoginBloc(
        httpClient: mockHttpClient,
        storage: mockStorage,
      );
    });

    tearDown(() {
      loginBloc.close();
    });

    test('initial state is LoginState', () {
      expect(loginBloc.state, equals(const LoginState()));
    });

    blocTest<LoginBloc, LoginState>(
      'emits [formValid: false] when FormSubmitted with empty username, password, or email',
      build: () => loginBloc,
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const LoginState(formValid: false),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading: true, loading: false, navigateTo: /user] when FormSubmitted with valid credentials and response is success',
      build: () {
        when(mockHttpClient.post(
          Uri(),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            jsonEncode({
              'token': 'fake_token',
              'userId': 'fake_userId',
              'username': 'fake_username',
              'email': 'fake_email',
              'role': 'user'
            }),
            200));

        when(mockStorage.write(
                key: "anyNamed('key')", value: anyNamed('value')))
            .thenAnswer((_) async => null);

        return loginBloc
          ..add(UsernameChanged('username'))
          ..add(PasswordChanged('password'))
          ..add(EmailChanged('email'));
      },
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true),
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true,
            loading: true),
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true,
            loading: false,
            navigateTo: '/user'),
      ],
      verify: (_) {
        verify(mockHttpClient.post(
          Uri(),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
        verify(mockStorage.write(key: 'token', value: 'fake_token')).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading: true, loading: false, errorMessage: Failed to login] when FormSubmitted with valid credentials and response is error',
      build: () {
        when(mockHttpClient.post(
          Uri(),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(jsonEncode({'message': 'Failed to login'}), 400));

        return loginBloc
          ..add(UsernameChanged('username'))
          ..add(PasswordChanged('password'))
          ..add(EmailChanged('email'));
      },
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true),
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true,
            loading: true),
        const LoginState(
            username: 'username',
            password: 'password',
            email: 'email',
            formValid: true,
            loading: false,
            errorMessage: 'Failed to login'),
      ],
      verify: (_) {
        verify(mockHttpClient.post(
          Uri(),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      },
    );
  });
}
