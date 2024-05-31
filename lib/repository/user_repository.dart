import '../data_provider/user_data.dart';
import '../models/user.dart';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({required this.dataProvider});

  Future<List<User>> getUsers({required String token}) async {
    return await dataProvider.getUsers(token: token);
  }

  Future<void> deleteUser(User user, {required String token}) async {
    await dataProvider.deleteUser(user, token: token);
  }

  Future<void> updateUser(User user, {required String token}) async {
    await dataProvider.updateUser(user, token: token);
  }
}
