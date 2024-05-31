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
        centerTitle: true,
        title: const Text(
          'Role assign to user!',
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
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
                  decoration: const InputDecoration(
                      labelText: 'user name', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _user["username"] = value;
                    });
                    print('user username: ${value ?? 'null'}');
                  }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.user.email : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'user email', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _user["email"] = value;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.user.role : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user role';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'user role', border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      _user["role"] = value;
                    });
                    print('user role: $value');
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
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
                  label: const Text(
                    "Assign",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
