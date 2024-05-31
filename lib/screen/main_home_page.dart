import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'poem/poem_list.dart';

class MyHomePage extends StatefulWidget {
  final String username;
  final String email;

  const MyHomePage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final ImagePicker imagePicker = ImagePicker();
  final _storage = const FlutterSecureStorage();
  final _idStorage = const FlutterSecureStorage();

  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
  }

  Future _getImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _updateUsername(String newUsername) async {
    final token = await _storage.read(key: 'token');
    final userId = await _idStorage.read(key: 'userId');

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'username': newUsername}),
      );

      if (response.statusCode == 200) {
        setState(() {
          username = newUsername;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username updated successfully')),
        );
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username: $e')),
      );
    }
  }

  void _showUsernameDialog() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newUsername = _controller.text;
                if (newUsername.isNotEmpty) {
                  _updateUsername(newUsername);
                  context.go('/admin');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await _storage.delete(key: 'token');
    await _idStorage.delete(key: 'userId');
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          );
        }),
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            hintText: 'Search by title...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.lightGreenAccent,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: const Text(''),
              currentAccountPicture: GestureDetector(
                onTap: _getImage,
                child: CircleAvatar(
                  backgroundImage:
                      _image != null ? Image.file(_image!).image : null,
                  child: _image == null ? const Icon(Icons.add_a_photo) : null,
                ),
              ),
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: _logout,
              leading: const Icon(Icons.logout),
            ),
            ListTile(
              title: const Text('Edit Username'),
              onTap: _showUsernameDialog,
              leading: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
      body: PoemsList(),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Poems'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              color: Colors.red,
            ),
            label: 'Users')
      ],
      onTap: (index) {
        if (index == 1) {
          context.go('/users_list');
        }
      },
    );
  }
}
