import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final String email;
  final bool passwordVisible;
  final bool formValid;
  final bool loading;
  final String? errorMessage;
  final String? navigateTo;

  const LoginState({
    this.username = '',
    this.password = '',
    this.email = '',
    this.passwordVisible = true,
    this.formValid = false,
    this.loading = false,
    this.errorMessage,
    this.navigateTo,
  });

  LoginState copyWith({
    String? username,
    String? password,
    String? email,
    bool? passwordVisible,
    bool? formValid,
    bool? loading,
    String? errorMessage,
    String? navigateTo,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      formValid: formValid ?? this.formValid,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      navigateTo: navigateTo ?? this.navigateTo,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        email,
        passwordVisible,
        formValid,
        loading,
        errorMessage,
        navigateTo,
      ];
}
