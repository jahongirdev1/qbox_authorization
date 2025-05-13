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
