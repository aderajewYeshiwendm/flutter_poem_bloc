import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/screen/poem/poem_arg.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../models/user.dart';

class UpdateUser extends StatefulWidget {
  final UserArgument args;

  UpdateUser({required this.args});
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _user = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit user'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  initialValue:
                      widget.args.edit ? widget.args.user.username : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'user name'),
                  onSaved: (value) {
                    setState(() {
                      _user["username"] = value;
                    });
                    print('user username: ${value ?? 'null'}');
                  }),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.user.email : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'user email'),
                  onSaved: (value) {
                    setState(() {
                      _user["email"] = value;
                    });
                  }),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.user.role : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user role';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(labelText: 'user role'),
                  onSaved: (value) {
                    setState(() {
                      _user["role"] = value;
                    });
                    print('user role: $value');
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      final UserEvent event = UserUpdate(
                        User(
                          id: widget.args.user.id,
                          username: _user["username"],
                          email: _user["email"],
                          password: '_user["password"]',
                          role: _user["role"],
                        ),
                      );

                      BlocProvider.of<UserBloc>(context).add(event);

                      context.go('/admin');
                    }
                  },
                  label: Text("Edit"),
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
