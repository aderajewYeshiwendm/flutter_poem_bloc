import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/screen/user/user_update.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../models/user.dart';
import '../poem/poem_arg.dart';

class UserDetail extends StatelessWidget {
  final User user;

  UserDetail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(user.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => UpdateUser(
                        args: UserArgument(edit: true, user: user))))),
          ),
          const SizedBox(
            width: 32,
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<UserBloc>().add(UserDelete(user));
                context.go('/admin');
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '  You can assign role or delete the user dear admin!!!  ',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
