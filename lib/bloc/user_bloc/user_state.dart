import 'package:equatable/equatable.dart';

import '../../models/user.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UsersLoadSuccess extends UserState {
  final List<User> users;

  const UsersLoadSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class UserOperationFailure extends UserState {}
