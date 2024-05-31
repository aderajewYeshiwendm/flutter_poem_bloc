import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/poem_bloc/poem_bloc.dart';
import '../../bloc/poem_bloc/poem_event.dart';
import '../../models/poem.dart';
import 'poem_arg.dart';

class AddUpdatePoem extends StatefulWidget {
  static const routeName = 'poemAddUpdate';
  final PoemArgument args;

  AddUpdatePoem({required this.args});
  @override
  _AddUpdatePoemState createState() => _AddUpdatePoemState();
}

class _AddUpdatePoemState extends State<AddUpdatePoem> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _poem = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(
          widget.args.edit ? "Edit Poem" : "Add new Poem",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.poem.genre : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter poem genre';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'poem genre', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _poem["genre"] = value;
                    });
                    print('Poem genre: ${value ?? 'null'}');
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.poem.title : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Poem title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'poem Title', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _poem["title"] = value;
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.poem.author : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter poem author';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'poem author', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _poem["author"] = value;
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  initialValue:
                      widget.args.edit ? widget.args.poem.content : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Poem content';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Poem content', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _poem["content"] = value;
                    });
                    print('Poem content: $value');
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      final PoemEvent event = widget.args.edit
                          ? PoemUpdate(
                              Poem(
                                id: widget.args.poem.id,
                                author: _poem["author"],
                                title: _poem["title"],
                                content: _poem["content"],
                                genre: _poem["genre"],
                              ),
                            )
                          : PoemCreate(
                              Poem(
                                author: _poem["author"],
                                title: _poem["title"],
                                genre: _poem["genre"],
                                content: _poem["content"],
                              ),
                            );

                      BlocProvider.of<PoemBloc>(context).add(event);

                      context.go('/admin');
                    }
                  },
                  label: Text(
                    widget.args.edit ? "Edit" : "Add",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  icon: const Icon(Icons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
