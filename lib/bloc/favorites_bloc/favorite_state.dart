import 'package:equatable/equatable.dart';

import '../../models/favorites.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Favorite> favorites;
  final String userId;

  const FavoriteLoaded(this.favorites, this.userId);

  @override
  List<Object> get props => [favorites, userId];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}
