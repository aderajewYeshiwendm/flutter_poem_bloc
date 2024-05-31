import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/signup_bloc/signup_event.dart';
import '../bloc/signup_bloc/signup_state.dart';
import '../bloc/signup_bloc/signup_bloc.dart';
import '../widgets/custom_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: const SignupForm(),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 4,
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.only(left: 22),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: const SignupFormContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupFormContent extends StatelessWidget {
  const SignupFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.navigateTo != null) {
          context.go(state.navigateTo!);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome to a Poetry Haven!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Username',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const _UsernameField(),
                  const SizedBox(height: 30),
                  const Text('Email address',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const _emailField(),
                  const SizedBox(height: 30),
                  const Text('Role',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const _RoleField(),
                  const SizedBox(height: 30),
                  const Text('Password',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const _PasswordField(),
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
                            context
                                .read<SignupBloc>()
                                .add(const FormSubmitted());
                          }
                        },
                        child: const Text(
                          'Sign UP',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 27),
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text(
                      'Already have an account? login here',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            initialValue: state.username,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'your username ...',
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5),
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<SignupBloc>().add(UsernameChanged(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            initialValue: state.password,
            obscureText: state.passwordVisible,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  state.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  context
                      .read<SignupBloc>()
                      .add(const PasswordVisibilityToggled());
                },
              ),
              hintText: 'your password ...',
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5),
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<SignupBloc>().add(PasswordChanged(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class _RoleField extends StatelessWidget {
  const _RoleField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            initialValue: state.username,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'poet or enthusiast',
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5),
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<SignupBloc>().add(RoleChanged(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class _emailField extends StatelessWidget {
  const _emailField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            initialValue: state.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.mail,
                color: Colors.blue,
              ),
              hintText: 'your email ...',
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5),
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<SignupBloc>().add(EmailChanged(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
