import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordVisibilityToggled extends LoginEvent {
  const PasswordVisibilityToggled();
}

class FormSubmitted extends LoginEvent {
  const FormSubmitted();
}

class UsernameChanged extends LoginEvent {
  final String username;

  const UsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}
