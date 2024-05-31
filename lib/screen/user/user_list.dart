import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/bloc/user_bloc/user_bloc.dart';
import 'package:my_flutter_project/bloc/user_bloc/user_state.dart';

import '../../bloc/poem_bloc/poem_state.dart';
import '../../models/user.dart';

import 'user_detail.dart';

class UsersList extends StatelessWidget {
  static const routeName = '/';
  final User user = User(
      email: '',
      username: '',
      password: '',
      role: ''); // Initialize Poem instance
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.deepPurple,
        backgroundColor: Colors.amber,
        title: const Text('List of Users'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (_, state) {
          if (state is PoemOperationFailure) {
            return const Text('Could not do user operation');
          }

          if (state is UsersLoadSuccess) {
            final users = state.users;

            return FutureBuilder<List<User>>(
              future: Future.value(users), // Wrap poems in a Future
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ),
                    itemBuilder: (_, idx) => Container(
                      margin: const EdgeInsets.symmetric(
                          vertical:
                              4.0), // Add margin for separation between list items
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[200],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal:
                                16.0), // Adjust padding for ListTile content
                        title: Text(
                          '${snapshot.data![idx].username}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          // Use CircleAvatar for leading widget
                          backgroundColor: Colors
                              .white, // Set background color for CircleAvatar
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        subtitle: Text('${snapshot.data![idx].email}'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    UserDetail(user: snapshot.data![idx])))),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
