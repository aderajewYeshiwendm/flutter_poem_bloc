import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/screen/fav.dart';

import '../../bloc/favorites_bloc/favorite_state.dart';
import '../../bloc/poem_bloc/poem_bloc.dart';
import '../../bloc/poem_bloc/poem_state.dart';
import '../../bloc/favorites_bloc/favorite_bloc.dart';
import '../../bloc/favorites_bloc/favorite_event.dart';
import '../../models/poem.dart';

class UserPoemList extends StatefulWidget {
  static const routeName = '/';

  @override
  _UserPoemListState createState() => _UserPoemListState();
}

class _UserPoemListState extends State<UserPoemList> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? userId;

  @override
  void initState() {
    super.initState();
    _retrieveUserId();
  }

  Future<void> _retrieveUserId() async {
    final storedUserId = await _storage.read(key: 'userId');
    setState(() {
      userId = storedUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of poems'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              if (userId != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoritesPage(userId: userId!)));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<PoemBloc, PoemState>(
        builder: (_, state) {
          if (state is PoemOperationFailure) {
            return const Text('Could not do poem operation');
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        subtitle: Text('${snapshot.data![idx].author}'),
                        trailing: BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, state) {
                            if (state is FavoriteLoaded) {
                              final isFav = state.favorites.any((fav) =>
                                  fav.poemId == snapshot.data![idx].id);
                              return IconButton(
                                onPressed: () {
                                  if (userId != null) {
                                    final poemId = snapshot.data![idx].id;
                                    if (isFav) {
                                      context.read<FavoriteBloc>().add(
                                          RemoveFavorite(
                                              poemId: poemId!,
                                              userId: userId!));
                                    } else {
                                      context.read<FavoriteBloc>().add(
                                          AddFavorite(
                                              poemId: poemId!,
                                              userId: userId!));
                                    }
                                  } else {
                                    // Handle the case where userId is null (e.g., show a message)
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: isFav ? Colors.red : Colors.black,
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        onTap: () {
                          // Assuming you have a route set up for poem detail
                          context.go(
                            '/userPoemDetail',
                            extra: snapshot.data![idx],
                          );
                        },
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
