import 'dart:convert';

import '../models/appearance.dart';
import '../models/response_message.dart';
import '../service/api_service.dart';
import '../utils/logger.dart';

abstract class IAuthRepository {
  Future<Appearance> getAppearance(String baseUrl, int localeId);

  Future<ResponseMessage> login(
    String baseUrl,
    String username,
    String password,
  );
}

class AuthRepository implements IAuthRepository {
  @override
  Future<Appearance> getAppearance(String baseUrl, int localeId) async {
    try {
      dynamic response = await ApiService.request(
        '$baseUrl/appearance',
        method: Method.get,
        queryParameters: {
          'locale_id': localeId,
        },
      );

      if (response is String) {
        response = jsonDecode(response);
      }

      if (response is! Map<String, dynamic>) {
        fatal("Unexpected response type: ${response.runtimeType}");
        throw TypeError();
      }

      final appearance =
          Appearance.fromJson(response["data"] as Map<String, dynamic>);

      return appearance;
    } catch (e) {
      fatal("Appearance data error: $e");
      return Future.error(
        "Не удалось найти рабочее пространство. Проверьте домен и попробуйте снова.",
      );
    }
  }

  @override
  Future<ResponseMessage> login(
    String baseUrl,
    String username,
    String password,
  ) async {
    try {
      dynamic response = await ApiService.request(
        '$baseUrl/api/auth/login/',
        method: Method.post,
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response is String) {
        response = jsonDecode(response);
      }

      if (response is! Map<String, dynamic>) {
        fatal("Unexpected response type: ${response.runtimeType}");
        throw TypeError();
      }

      final message = ResponseMessage.fromJson(response);

      return Future.value(message);
    } catch (e) {
      fatal("Login error: $e");
      return const ResponseMessage(
        success: false,
        message: "Failed to login",
        token: null,
      );
    }
  }
}
