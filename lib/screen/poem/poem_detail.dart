import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/poem_bloc/poem_bloc.dart';
import '../../bloc/poem_bloc/poem_event.dart';
import '../../models/poem.dart';
import 'poem_add_update.dart';
import 'poem_arg.dart';

class PoemDetail extends StatelessWidget {
  static const routeName = 'poemDetail';
  final Poem poem;

  PoemDetail({required this.poem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          '        ${poem.title}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => AddUpdatePoem(
                      args: PoemArgument(edit: true, poem: poem),
                    )),
              ),
            ),
          ),
          const SizedBox(width: 26),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<PoemBloc>().add(PoemDelete(poem));
              context.go('/poem_list');
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
        leading: IconButton(
            onPressed: () {
              context.go('/admin');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author: ${poem.author}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Genre: ${poem.genre}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400], // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          poem.content,
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
