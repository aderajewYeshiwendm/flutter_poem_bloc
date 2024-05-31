import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class RoleChanged extends SignupEvent {
  final String role;

  const RoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

class PasswordVisibilityToggled extends SignupEvent {
  const PasswordVisibilityToggled();
}

class FormSubmitted extends SignupEvent {
  const FormSubmitted();
}

class UsernameChanged extends SignupEvent {
  final String username;

  const UsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class EmailChanged extends SignupEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}
