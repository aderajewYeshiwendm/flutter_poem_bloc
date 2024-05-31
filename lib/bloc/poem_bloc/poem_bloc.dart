import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/poem.dart';
import '../../repository/poem_repository.dart';
import 'poem_event.dart';
import 'poem_state.dart';

class PoemBloc extends Bloc<PoemEvent, PoemState> {
  final PoemRepository poemRepository;

  PoemBloc({required this.poemRepository}) : super(PoemLoading()) {
    on<PoemLoad>(_onPoemLoad);
    on<PoemCreate>(_onPoemCreate);
    on<PoemUpdate>(_onPoemUpdate);
    on<PoemDelete>(_onPoemDelete);
  }

  final _storage = const FlutterSecureStorage();

  void _onPoemLoad(PoemLoad event, Emitter<PoemState> emit) async {
    emit(PoemLoading());
    try {
      final token = await _storage.read(key: 'token');
      final List<Poem> poems = await poemRepository.getPoems(token: token!);
      emit(PoemsLoadSuccess(poems));
    } catch (error) {
      print('PoemLoad error: $error');
      emit(PoemOperationFailure());
    }
  }

  void _onPoemCreate(PoemCreate event, Emitter<PoemState> emit) async {
    try {
      final token = await _storage.read(key: 'token');
      await poemRepository.createPoem(event.poem, token: token!);
    } catch (_) {
      print('PoemLoad error on create: $_');
      final token = await _storage.read(key: 'token');
      final poems = await poemRepository.getPoems(token: token!);
      emit(PoemsLoadSuccess(poems));
    }
  }

  void _onPoemUpdate(PoemUpdate event, Emitter<PoemState> emit) async {
    try {
      final token = await _storage.read(key: 'token');
      await poemRepository.updatePoem(event.poem, token: token!);
      final poems = await poemRepository.getPoems(token: token);

      emit(PoemsLoadSuccess(poems));
    } catch (_) {
      final token = await _storage.read(key: 'token');
      final poems = await poemRepository.getPoems(token: token!);
      emit(PoemsLoadSuccess(poems));
    }
  }

  void _onPoemDelete(PoemDelete event, Emitter<PoemState> emit) async {
    try {
      final token = await _storage.read(key: 'token');
      await poemRepository.deletePoem(event.poem, token: token!);
      final poems = await poemRepository.getPoems(token: token);
      emit(PoemsLoadSuccess(poems));
    } catch (_) {
      final token = await _storage.read(key: 'token');
      final poems = await poemRepository.getPoems(token: token!);
      emit(PoemsLoadSuccess(poems));
    }
  }
}
