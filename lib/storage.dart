import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _idStorage = const FlutterSecureStorage();

  Future<void> writeUserId(String userId) async {
    await _idStorage.write(key: 'userId', value: userId);
  }

  Future<String?> readUserId() async {
    return await _idStorage.read(key: 'userId');
  }

  Future<void> deleteUserId() async {
    await _idStorage.delete(key: 'userId');
  }
}
