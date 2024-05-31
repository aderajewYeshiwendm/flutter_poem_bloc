import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final _storage = const FlutterSecureStorage();
  final _idStorage = const FlutterSecureStorage();
  final _usernameStorage = const FlutterSecureStorage();

  SignupBloc() : super(const SignupState()) {
    on<RoleChanged>((event, emit) {
      emit(state.copyWith(role: event.role));
    });

    on<PasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(passwordVisible: !state.passwordVisible));
    });

    on<FormSubmitted>((event, emit) async {
      final isValid = state.username.isNotEmpty &&
          state.password.isNotEmpty &&
          state.role.isNotEmpty &&
          state.email.isNotEmpty;

      if (isValid) {
        emit(state.copyWith(loading: true, formValid: true));
        final result = await _signup(
            state.username, state.password, state.email, state.role);
        emit(state.copyWith(loading: false));

        if (result['success']) {
          await _storage.write(key: 'token', value: result['token']);
          await _idStorage.write(key: "userId", value: result['userId']);
          await _usernameStorage.write(
              key: "username", value: result['username']);
          if (state.role == 'enthusiast') {
            emit(state.copyWith(navigateTo: '/user'));
          } else if (state.role == 'poet') {
            emit(state.copyWith(navigateTo: '/admin'));
          }
        } else {
          emit(state.copyWith(errorMessage: result['message']));
        }
      } else {
        emit(state.copyWith(formValid: false));
      }
    });

    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
  }

  Future<Map<String, dynamic>> _signup(
      String username, String password, String email, String role) async {
    const url =
        'http://10.0.2.2:3000/api/register'; // Update with your backend URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'role': role
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'message': data['message'],
          'userId': data['userId']
        };
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }
}
