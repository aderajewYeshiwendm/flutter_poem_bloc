import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _storage = const FlutterSecureStorage();
  final _idStorage = const FlutterSecureStorage();
  final _usernameStorage = const FlutterSecureStorage();
  final _emailStorage = const FlutterSecureStorage();
  final http.Client httpClient;
  final FlutterSecureStorage storage;

  LoginBloc({http.Client? httpClient, FlutterSecureStorage? storage})
      : httpClient = httpClient ?? http.Client(),
        storage = storage ?? const FlutterSecureStorage(),
        super(const LoginState()) {
    on<PasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(passwordVisible: !state.passwordVisible));
    });

    on<FormSubmitted>((event, emit) async {
      final formValid = state.username.isNotEmpty &&
          state.password.isNotEmpty &&
          state.email.isNotEmpty;
      emit(state.copyWith(formValid: formValid));

      if (formValid) {
        emit(state.copyWith(loading: true));
        final result =
            await _login(state.username, state.password, state.email);
        emit(state.copyWith(loading: false));

        if (result['success']) {
          await _storage.write(key: 'token', value: result['token']);
          await _idStorage.write(key: "userId", value: result['userId']);
          await _usernameStorage.write(
              key: "username", value: result['username']);
          await _emailStorage.write(key: "email", value: result['email']);
          emit(state.copyWith(navigateTo: result['navigateTo']));
        } else {
          emit(state.copyWith(errorMessage: result['message']));
        }
      }
    });

    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
  }

  Future<Map<String, dynamic>> _login(
      String username, String password, String email) async {
    const url =
        'http://10.0.2.2:3000/api/login'; // Update with your backend URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': username, 'password': password, 'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'success': true,
          'token': data['token'],
          'userId': data['userId'],
          'navigateTo': data['role'] == 'poet' ? '/admin' : '/user',
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
