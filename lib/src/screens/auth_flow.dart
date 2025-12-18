import 'package:flutter/material.dart';
import '../../qbox_authorization.dart';
import 'company_select_screen.dart';

class AuthFlow extends StatelessWidget {
  /// Идентификатор локализации, используемый при получении данных о внешнем виде.
  ///
  /// Возможные значения:
  /// - `1` — русский (`ru`, по умолчанию)
  /// - `2` — казахский (`kk`)
  /// - `3` — английский (`en`)
  final int localeId;

  /// Функция, вызываемая при успешном завершении операции.
  ///
  /// Принимает [token], [baseUrl] — строковый идентификатор, полученный в результате успешной авторизации.
  final void Function(String token, String baseUrl) onSuccess;

  const AuthFlow({
    super.key,
    required this.onSuccess,
    this.localeId = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CompanySelectScreen(
      localeId: localeId,
      onContinue: (baseUrl) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuthScreen(
              baseUrl: baseUrl,
              localeId: localeId,
              onSuccess: onSuccess,
            ),
          ),
        );
      },
    );
  }
}
