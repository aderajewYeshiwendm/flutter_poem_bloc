import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

import '../../repository/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading()) {
    on<UserLoad>(_onUserLoad);
    on<UserUpdate>(_onUserUpdate);

    on<UserDelete>(_onUserDelete);
  }
  final _storage = const FlutterSecureStorage();

  void _onUserLoad(UserLoad event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final token = await _storage.read(key: 'token');
      final List<User> users = await userRepository.getUsers(token: token!);
      print('users $users');
      emit(UsersLoadSuccess(users));
    } catch (error) {
      print('UserLoad error: $error');
      emit(UserOperationFailure());
    }
  }

  void _onUserUpdate(UserUpdate event, Emitter<UserState> emit) async {
    try {
      final token = await _storage.read(key: 'token');
      await userRepository.updateUser(event.user, token: token!);
      final users = await userRepository.getUsers(token: token);

      emit(UsersLoadSuccess(users));
    } catch (_) {
      final token = await _storage.read(key: 'token');
      final users = await userRepository.getUsers(token: token!);
      emit(UsersLoadSuccess(users));
    }
  }

  void _onUserDelete(UserDelete event, Emitter<UserState> emit) async {
    try {
      final token = await _storage.read(key: 'token');
      await userRepository.deleteUser(event.user, token: token!);

      final users = await userRepository.getUsers(token: token);
      emit(UsersLoadSuccess(users));
    } catch (_) {
      final token = await _storage.read(key: 'token');
      final users = await userRepository.getUsers(token: token!);
      emit(UsersLoadSuccess(users));
    }
  }
}
