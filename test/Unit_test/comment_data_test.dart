// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/repository/comment_repo.dart';

import 'comment_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('CommentRepository Tests', () {
    late MockClient mockHttpClient;
    late CommentRepository commentRepository;
    const baseUrl = 'http://10.0.2.2:3000';

    setUp(() {
      mockHttpClient = MockClient();
      commentRepository = CommentRepository(baseUrl: baseUrl);
    });
  });
}
