import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String username;
  final String password;
  final String email;
  final String role;
  final bool passwordVisible;
  final bool formValid;
  final bool loading;
  final String? errorMessage;
  final String? navigateTo;

  const SignupState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.role = '',
    this.passwordVisible = true,
    this.formValid = false,
    this.loading = false,
    this.errorMessage,
    this.navigateTo,
  });

  SignupState copyWith({
    String? email,
    String? username,
    String? password,
    String? role,
    bool? passwordVisible,
    bool? formValid,
    bool? loading,
    String? errorMessage,
    String? navigateTo,
  }) {
    return SignupState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
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
    role,
    passwordVisible,
    formValid,
    email,
    loading,
    errorMessage,
    navigateTo,
  ];
}
