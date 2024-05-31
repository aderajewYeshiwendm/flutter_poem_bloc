import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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
                      .read<LoginBloc>()
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
              context.read<LoginBloc>().add(PasswordChanged(value));
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
