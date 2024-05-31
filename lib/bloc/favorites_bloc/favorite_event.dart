import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FetchFavorites extends FavoriteEvent {
  final String userId;

  const FetchFavorites(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddFavorite extends FavoriteEvent {
  final String poemId;
  final String userId;

  const AddFavorite({
    required this.poemId,
    required this.userId,
  });

  @override
  List<Object> get props => [
        poemId,
        userId,
      ];
}

class RemoveFavorite extends FavoriteEvent {
  final String poemId;
  final String userId;

  const RemoveFavorite({
    required this.poemId,
    required this.userId,
  });

  @override
  List<Object> get props => [poemId, userId];
}
