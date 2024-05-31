import '../data_provider/poem_data.dart';
import '../models/poem.dart';

class PoemRepository {
  final PoemDataProvider dataProvider;

  PoemRepository({required this.dataProvider});

  Future<Poem> createPoem(Poem poem, {required String token}) async {
    return await dataProvider.createPoem(poem, token: token);
  }

  Future<List<Poem>> getPoems({required String token}) async {
    return await dataProvider.getPoems(token: token);
  }

  Future<void> updatePoem(Poem poem, {required String token}) async {
    await dataProvider.updatePoem(poem, token: token);
  }

  Future<void> deletePoem(Poem poem, {required String token}) async {
    await dataProvider.deletePoem(poem, token: token);
  }
}
