import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_bloc.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_event.dart';
import 'package:my_flutter_project/bloc/signup_bloc/signup_state.dart';

@GenerateMocks([http.Client, FlutterSecureStorage])
void main() {
  group('SignupBloc Tests', () {
    late SignupBloc signupBloc;

    setUp(() {
      signupBloc = SignupBloc();
    });

    tearDown(() {
      signupBloc.close();
    });

    blocTest<SignupBloc, SignupState>(
      'emits [formValid: false] when FormSubmitted event is added with empty fields',
      build: () => signupBloc,
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () =>
          [isA<SignupState>().having((s) => s.formValid, 'formValid', false)],
    );
  });
}
