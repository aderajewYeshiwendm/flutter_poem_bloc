import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_event.dart';
import '../bloc/login_bloc/login_state.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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
              context.read<LoginBloc>().add(UsernameChanged(value));
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
