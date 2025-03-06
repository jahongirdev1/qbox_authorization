import 'dart:convert';

import '../service/api_service.dart';
import '../utils/logger.dart';

class ResponseMessage {
  final bool success;
  final String? message;
  final String? token;

  const ResponseMessage({
    required this.success,
    required this.message,
    required this.token,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>? ?? {};

    return ResponseMessage(
      success: json['_success'] as bool,
      message: error['message'] as String?,
      token: json['token'] as String?,
    );
  }

  @override
  String toString() => 'ResponseMessage('
      'success: $success,'
      'error: $message,'
      'token: $token)';
}

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
      return Future.error("Failed to load appearance data");
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

class Appearance {
  const Appearance({
    required this.icon,
    required this.backgroundImages,
    required this.title,
    required this.description,
  });

  final String icon;
  final List<String> backgroundImages;
  final String title;
  final String description;

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      icon: (json['icon'] as String? ?? ""),
      backgroundImages: (json['background_images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      title: json['title'] as String? ?? 'Ai Box',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  String toString() => 'Appearance('
      'icon: $icon,'
      'backgroundImages: $backgroundImages,'
      'title: $title,'
      'description: $description)';
}
