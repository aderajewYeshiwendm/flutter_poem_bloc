import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/poem_bloc/poem_bloc.dart';
import '../../bloc/poem_bloc/poem_state.dart';
import '../../models/poem.dart';
import 'poem_add_update.dart';
import 'poem_arg.dart';

class PoemsList extends StatelessWidget {
  static const routeName = '/';
  final Poem poem = Poem(
      title: '',
      author: '',
      genre: '',
      content: ''); // Initialize Poem instance
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of poems'),
      ),
      body: BlocBuilder<PoemBloc, PoemState>(
        builder: (_, state) {
          if (state is PoemOperationFailure) {
            return Text('Could not do poem operation');
          }

          if (state is PoemsLoadSuccess) {
            final poems = state.poems;

            return FutureBuilder<List<Poem>>(
              future: Future.value(poems), // Wrap poems in a Future
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
                          '${snapshot.data![idx].title}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          // Use CircleAvatar for leading widget
                          backgroundColor: Colors
                              .white, // Set background color for CircleAvatar
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        subtitle: Text('${snapshot.data![idx].author}'),
                        onTap: () => context.go(
                          '/poemDetail',
                          extra: snapshot.data![idx],
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => AddUpdatePoem(
                    args: PoemArgument(edit: false, poem: poem))))),
        child: Icon(Icons.add),
      ),
    );
  }
}
