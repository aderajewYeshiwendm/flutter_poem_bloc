import '../../poem.dart';

class PoemArgument {
  final Poem poem;
  final bool edit;
  PoemArgument({required this.poem, required this.edit});
}

class UserArgument {
  final User user;
  final bool edit;
  UserArgument({required this.user, required this.edit});
}
