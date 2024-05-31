import 'package:equatable/equatable.dart';

import '../../models/poem.dart';

abstract class PoemEvent extends Equatable {
  const PoemEvent();
}

class PoemLoad extends PoemEvent {
  const PoemLoad();

  @override
  List<Object> get props => [];
}

class PoemCreate extends PoemEvent {
  final Poem poem;

  const PoemCreate(this.poem);

  @override
  List<Object> get props => [Poem];

  @override
  String toString() => 'Poem Created {Poem: $Poem}';
}

class PoemUpdate extends PoemEvent {
  final Poem poem;

  const PoemUpdate(this.poem);

  @override
  List<Object> get props => [poem];

  @override
  String toString() => 'Poem Updated {Poem: $poem}';
}

class PoemDelete extends PoemEvent {
  final Poem poem;

  const PoemDelete(this.poem);

  @override
  List<Object> get props => [poem];

  @override
  toString() => 'Poem Deleted {Poem: $poem}';
}
