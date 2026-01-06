import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/storage/token_storage.dart';

class ChatApi {
  static Future<List<dynamic>> getChats() async {
    final token = await TokenStorage.getToken();

    final response = await ApiClient.dio.get(
      '/chats',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }
}
