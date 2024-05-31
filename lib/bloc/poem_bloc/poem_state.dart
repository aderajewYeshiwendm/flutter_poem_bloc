import 'package:equatable/equatable.dart';

import '../../models/poem.dart';

class PoemState extends Equatable {
  const PoemState();

  @override
  List<Object> get props => [];
}

class PoemLoading extends PoemState {}

class PoemsLoadSuccess extends PoemState {
  final List<Poem> poems;

  const PoemsLoadSuccess(this.poems);

  @override
  List<Object> get props => [poems];
}

class PoemOperationFailure extends PoemState {}
