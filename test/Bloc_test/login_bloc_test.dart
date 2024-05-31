import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_bloc.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_event.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_state.dart';
import 'login_bloc_test.mocks.dart';

@GenerateMocks([http.Client, FlutterSecureStorage])
void main() {
  group('LoginBloc Tests', () {
    late MockClient mockHttpClient;
    late MockFlutterSecureStorage mockStorage;
    late LoginBloc loginBloc;

    setUp(() {
      mockHttpClient = MockClient();
      mockStorage = MockFlutterSecureStorage();
      loginBloc = LoginBloc(httpClient: mockHttpClient, storage: mockStorage);
    });

    tearDown(() {
      loginBloc.close();
    });

    blocTest<LoginBloc, LoginState>(
      'emits [formValid: false] when FormSubmitted event is added with empty fields',
      build: () => loginBloc,
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () =>
          [isA<LoginState>().having((s) => s.formValid, 'formValid', false)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [formValid: true, loading: true, navigateTo: /admin] when FormSubmitted event is added with valid fields and login is successful',
      build: () {
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
              jsonEncode({
                'token': 'fakeToken',
                'userId': '123',
                'username': 'user',
                'email': 'user@example.com',
                'role': 'poet'
              }),
              200,
            ));
        when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => null);
        return loginBloc;
      },
      act: (bloc) {
        bloc.add(UsernameChanged('user'));
        bloc.add(EmailChanged('user@example.com'));
        bloc.add(PasswordChanged('password'));
        bloc.add(FormSubmitted());
      },
      expect: () => [
        LoginState(
          username: 'user',
          email: '',
          password: '',
          formValid: false,
          loading: false,
          navigateTo: null,
        ),
        LoginState(
          username: 'user',
          email: 'user@example.com',
          password: '',
          formValid: false,
          loading: false,
          navigateTo: null,
        ),
        LoginState(
          username: 'user',
          email: 'user@example.com',
          password: 'password',
          formValid: false,
          loading: false,
          navigateTo: null,
        ),
        LoginState(
          username: 'user',
          email: 'user@example.com',
          password: 'password',
          formValid: true,
          loading: false,
          navigateTo: null,
        ),
        LoginState(
          username: 'user',
          email: 'user@example.com',
          password: 'password',
          formValid: true,
          loading: true,
          navigateTo: null,
        ),
      ],
    );
  });
}
