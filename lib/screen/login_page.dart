import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/widgets/email.dart';
import '../widgets/password.dart';
import '../widgets/username.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';
import '../widgets/custom_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 12,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.only(left: 22),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const LoginFormContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state.navigateTo != null) {
        context.go(state.navigateTo!);
      }
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Welcome to the Poetry Haven!',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const UsernameField(),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const EmailField(),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const PasswordField(),
              const SizedBox(height: 50),
              if (state.loading)
                const Center(child: CircularProgressIndicator())
              else
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(330, 45),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(const FormSubmitted());
                      }
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  context.go('/signup');
                },
                child: const Text(
                  'Don\'t have an account? sign up here',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
