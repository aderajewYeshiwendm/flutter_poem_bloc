import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_project/bloc/favorites_bloc/favorite_event.dart';

import '../bloc/favorites_bloc/favorite_bloc.dart';
import '../bloc/favorites_bloc/favorite_state.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;

  FavoritesPage({required this.userId});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(FetchFavorites(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              context.go('/user');
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            final poems = state.favorites;

            return ListView.builder(
              itemCount: poems.length,
              itemBuilder: (_, idx) => ListTile(
                title: Text(poems[idx].poemId),
                subtitle: Text(poems[idx].userId),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    context.read<FavoriteBloc>().add(RemoveFavorite(
                        poemId: poems[idx].id, userId: widget.userId));
                  },
                ),
              ),
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No favorites yet.'));
          }
        },
      ),
    );
  }
}
