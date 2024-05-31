import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../repository/fav_repo.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoritesRepository favoriteRepository;
  final _idStorage = const FlutterSecureStorage();
  FavoriteBloc(this.favoriteRepository) : super(FavoriteInitial()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  void _onFetchFavorites(
      FetchFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());

    try {
      final userId = await _idStorage.read(key: 'userId');

      final favorites = await favoriteRepository.fetchFav(userId!);
      emit(FavoriteLoaded(favorites, userId));
    } catch (e) {
      emit(FavoriteError('Failed to fetch Favorites'));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      print('befor bloc ');
      final userId = await _idStorage.read(key: 'userId');

      await favoriteRepository.addFav(event.poemId, userId!);
      print('hi there');
      add(FetchFavorites(userId));
      print(userId);
      print('Favorite added successfully.');
    } catch (e) {
      emit(FavoriteError('Failed to add Favorite'));
    }
  }

  void _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final userId = await _idStorage.read(key: 'userId');
      await favoriteRepository.removeFav(event.poemId, userId!);
      print('deleted favorites:');
      final favorites = await favoriteRepository.fetchFav(userId);

      add(FetchFavorites(userId));
      emit(FavoriteLoaded(favorites, userId));
    } catch (e) {
      emit(FavoriteError('Failed to remove Favorite'));
    }
  }
}
