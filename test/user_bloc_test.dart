import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/bloc/user_bloc/user_bloc.dart';
import 'package:my_flutter_project/bloc/user_bloc/user_event.dart';
import 'package:my_flutter_project/bloc/user_bloc/user_state.dart';
import 'package:my_flutter_project/models/user.dart';
import 'package:my_flutter_project/repository/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Mock classes
class MockUserRepository extends Mock implements UserRepository {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('UserBloc', () {
    late UserBloc userBloc;
    late MockUserRepository mockUserRepository;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockUserRepository = MockUserRepository();
      mockStorage = MockFlutterSecureStorage();
      userBloc = UserBloc(
        userRepository: mockUserRepository,
      );
    });

    tearDown(() {
      userBloc.close();
    });

    test('initial state is UserLoading', () {
      expect(userBloc.state, equals(UserLoading()));
    });

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UsersLoadSuccess] when UserLoad is added and repository returns users',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.getUsers(token: "anyNamed('token')"))
            .thenAnswer((_) async => [
                  User(
                      id: '1',
                      username: 'User 1',
                      email: 'user1@example.com',
                      password: '',
                      role: '')
                ]);

        return userBloc;
      },
      act: (bloc) => bloc.add(UserLoad()),
      expect: () => [
        UserLoading(),
        UsersLoadSuccess([
          User(
              id: '1',
              username: 'User 1',
              email: 'user1@example.com',
              password: '',
              role: '')
        ]),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserOperationFailure] when UserLoad is added and repository throws error',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.getUsers(token: "anyNamed('token')"))
            .thenThrow(Exception('Failed to load users'));

        return userBloc;
      },
      act: (bloc) => bloc.add(UserLoad()),
      expect: () => [
        UserLoading(),
        UserOperationFailure(),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UsersLoadSuccess] when UserUpdate is added and repository updates user successfully',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.updateUser(
                User(
                    username: "username",
                    email: "email",
                    password: "password",
                    role: "role"),
                token: "anyNamed('token')"))
            .thenAnswer((_) async => null);
        when(mockUserRepository.getUsers(token: "anyNamed('token')"))
            .thenAnswer((_) async => [
                  User(
                      id: '1',
                      username: 'User 1',
                      email: 'user1@example.com',
                      password: '',
                      role: '')
                ]);

        return userBloc;
      },
      act: (bloc) => bloc.add(UserUpdate(User(
          id: '1',
          username: 'User 1',
          email: 'user1@example.com',
          password: '',
          role: ''))),
      expect: () => [
        UserLoading(),
        UsersLoadSuccess([
          User(
              id: '1',
              username: 'User 1',
              email: 'user1@example.com',
              password: '',
              role: '')
        ]),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserOperationFailure] when UserUpdate is added and repository throws error',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.updateUser(
                User(
                    username: "username",
                    email: "email",
                    password: "password",
                    role: "role"),
                token: "anyNamed('token')"))
            .thenThrow(Exception('Failed to update user'));

        return userBloc;
      },
      act: (bloc) => bloc.add(UserUpdate(User(
          id: '1',
          username: 'User 1',
          email: 'user1@example.com',
          password: '',
          role: ''))),
      expect: () => [
        UserLoading(),
        UserOperationFailure(),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UsersLoadSuccess] when UserDelete is added and repository deletes user successfully',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.deleteUser(
                User(
                    username: "username",
                    email: "email",
                    password: "password",
                    role: "role"),
                token: "anyNamed('token')"))
            .thenAnswer((_) async => null);
        when(mockUserRepository.getUsers(token: "anyNamed('token')"))
            .thenAnswer((_) async => [
                  User(
                      id: '1',
                      username: 'User 1',
                      email: 'user1@example.com',
                      password: '',
                      role: '')
                ]);

        return userBloc;
      },
      act: (bloc) => bloc.add(UserDelete(User(
          id: '1',
          username: 'User 1',
          email: 'user1@example.com',
          password: '',
          role: ''))),
      expect: () => [
        UserLoading(),
        UsersLoadSuccess([
          User(
              id: '1',
              username: 'User 1',
              email: 'user1@example.com',
              password: '',
              role: '')
        ]),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserOperationFailure] when UserDelete is added and repository throws error',
      build: () {
        when(mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'fake_token');
        when(mockUserRepository.deleteUser(
                User(
                    username: "username",
                    email: "email",
                    password: "password",
                    role: "role"),
                token: "anyNamed('token')"))
            .thenThrow(Exception('Failed to delete user'));

        return userBloc;
      },
      act: (bloc) => bloc.add(UserDelete(User(
          id: '1',
          username: 'User 1',
          email: 'user1@example.com',
          password: '',
          role: ''))),
      expect: () => [
        UserLoading(),
        UserOperationFailure(),
      ],
    );
  });
}
