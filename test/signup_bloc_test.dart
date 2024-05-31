import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_bloc.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_event.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Mock classes
class MockHttpClient extends Mock implements http.Client {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SignupBloc', () {
    late SignupBloc signupBloc;
    late MockHttpClient mockHttpClient;
    late MockFlutterSecureStorage mockStorage;
    late MockFlutterSecureStorage mockIdStorage;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockStorage = MockFlutterSecureStorage();
      mockIdStorage = MockFlutterSecureStorage();
      signupBloc = signupBloc;
    });

    tearDown(() {
      signupBloc.close();
    });

    test('initial state is SignupState', () {
      expect(signupBloc.state, equals(const SignupState()));
    });

    blocTest<SignupBloc, SignupState>(
      'emits [formValid: false] when FormSubmitted with empty username, password, email, or role',
      build: () => signupBloc,
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const SignupState(formValid: false),
      ],
    );

    blocTest<SignupBloc, SignupState>(
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
              'role': 'user'
            }),
            200));

        when(mockStorage.write(
                key: "anyNamed('key')", value: anyNamed('value')))
            .thenAnswer((_) async => null);

        when(mockIdStorage.write(
                key: "anyNamed('key')", value: anyNamed('value')))
            .thenAnswer((_) async => null);

        return signupBloc
          ..add(UsernameChanged('username'))
          ..add(PasswordChanged('password'))
          ..add(EmailChanged('email'))
          ..add(RoleChanged('enthusiast'));
      },
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const SignupState(
            username: 'username',
            password: 'password',
            email: 'email',
            role: 'enthusiast',
            formValid: true,
            loading: true),
        const SignupState(
            username: 'username',
            password: 'password',
            email: 'email',
            role: 'enthusiast',
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
        verify(mockIdStorage.write(key: 'userId', value: 'fake_userId'))
            .called(1);
      },
    );

    blocTest<SignupBloc, SignupState>(
      'emits [loading: true, loading: false, errorMessage: Failed to signup] when FormSubmitted with valid credentials and response is error',
      build: () {
        when(mockHttpClient.post(
          Uri(),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(jsonEncode({'message': 'Failed to signup'}), 400));

        return signupBloc
          ..add(UsernameChanged('username'))
          ..add(PasswordChanged('password'))
          ..add(EmailChanged('email'))
          ..add(RoleChanged('enthusiast'));
      },
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => [
        const SignupState(
            username: 'username',
            password: 'password',
            email: 'email',
            role: 'enthusiast',
            formValid: true,
            loading: true),
        const SignupState(
            username: 'username',
            password: 'password',
            email: 'email',
            role: 'enthusiast',
            formValid: true,
            loading: false,
            errorMessage: 'Failed to signup'),
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
