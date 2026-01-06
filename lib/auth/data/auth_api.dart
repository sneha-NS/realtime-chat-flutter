import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/storage/token_storage.dart';

class AuthApi {
static Future<String> login(String email, String password) async {
  try {
    final response = await ApiClient.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final token = response.data['token'];
    final userId = response.data['user']['id'];

    await TokenStorage.saveToken(token);
    return userId;
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      throw Exception('USER_NOT_FOUND');
    }
    if (e.response?.statusCode == 401) {
      throw Exception('INVALID_PASSWORD');
    }
    throw Exception('LOGIN_FAILED');
  }
}



  static Future<void> register(
      String name, String email, String password) async {
    await ApiClient.dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
}
