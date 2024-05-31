import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/comment_bloc/comment_bloc.dart';
import '../../bloc/comment_bloc/comment_event.dart';
import '../../bloc/comment_bloc/comment_state.dart';
import '../../models/comment.dart';
import '../../models/poem.dart';
import '../../repository/comment_repo.dart';

class UserPoemDetail extends StatelessWidget {
  static const routeName = 'UserPoemDetail';
  final Poem poem;

  const UserPoemDetail({super.key, required this.poem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(
          poem.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/user');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author:   ${poem.author}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Genre:   ${poem.genre}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          poem.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Comments',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline)),
            BlocProvider(
              create: (context) => CommentBloc(
                  CommentRepository(baseUrl: 'http://localhost:3000'))
                ..add(FetchComments(poem.id!)),
              child: CommentsSection(poemId: poem.id!),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsSection extends StatelessWidget {
  final String poemId;

  const CommentsSection({Key? key, required this.poemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Comments',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        BlocBuilder<CommentBloc, CommentState>(
          builder: (context, state) {
            if (state is CommentLoading) {
              return CircularProgressIndicator();
            } else if (state is CommentLoaded) {
              return Column(
                children: state.comments
                    .map((comment) => CommentWidget(comment: comment))
                    .toList(),
              );
            } else if (state is CommentError) {
              return Text(state.message);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        CommentForm(poemId: poemId),
      ],
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(comment.content, style: TextStyle(fontSize: 15)),
            ],
          )
        ],
      ),
    );
  }
}

class CommentForm extends StatefulWidget {
  final String poemId;

  const CommentForm({Key? key, required this.poemId}) : super(key: key);

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Your Comment',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final newComment = _commentController.text;
              if (newComment.isNotEmpty) {
                context.read<CommentBloc>().add(AddComment(
                      poemId: widget.poemId,
                      username: 'someone', // Replace with actual author
                      content: newComment,
                    ));
                _commentController.clear();
              }
            },
            child: Text('Add Comment'),
          ),
        ],
      ),
    );
  }
}
