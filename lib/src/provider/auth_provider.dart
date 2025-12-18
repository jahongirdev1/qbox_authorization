import '../repository/auth_repository.dart';
import '../utils/show_top_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/test_login.dart';
import '../models/appearance.dart';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final repo = AuthRepository();
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  bool isAppearanceLoading = false;

  String baseUrl = '';
  Appearance? appearance;

  String? token;

  Future<void> initialize(String url, int localeId) async {
    if (appearance != null && baseUrl == url) return;
    baseUrl = url;
    appearance = await repo.getAppearance(baseUrl, localeId);
    info("Appearance: $appearance");

    notifyListeners();
  }

  Future<bool> getAppearance(
    BuildContext context,
    String url,
    int localeId,
  ) async {
    if (isAppearanceLoading) return false;
    HapticFeedback.lightImpact();
    isAppearanceLoading = true;
    notifyListeners();

    try {
      baseUrl = url;
      appearance = await repo.getAppearance(baseUrl, localeId);
      info("Appearance: $appearance");
      isAppearanceLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      baseUrl = '';
      appearance = null;
      isAppearanceLoading = false;
      notifyListeners();
      fatal("Appearance request error: $e");
      if (context.mounted) {
        final message = e.toString().isNotEmpty
            ? e.toString()
            : "Не удалось найти рабочее пространство. Проверьте домен и попробуйте снова.";
        await _showAppearanceErrorDialog(context, message);
      }
      return false;
    }
  }

  Future<String?> loginAction(BuildContext context) async {
    if (isLoading) return null;
    HapticFeedback.lightImpact();
    isLoading = true;
    notifyListeners();
    final message = await repo.login(baseUrl, login.text, password.text);
    isLoading = false;
    notifyListeners();

    if (!message.success && context.mounted) {
      showTopSnackBar(context, message.message ?? "Error");
      return null;
    } else {
      return message.token;
    }
  }

  Future<void> _showAppearanceErrorDialog(
    BuildContext context,
    String message,
  ) async {
    await showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Ошибка'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(),
            child: const Text(
              'Понятно',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void toggleVisibility() {
    HapticFeedback.lightImpact();
    isVisible = !isVisible;
    notifyListeners();
  }

  void testLogin(TestLogin testLogin) {
    login.text = testLogin.username;
    password.text = testLogin.password;
    notifyListeners();
  }
}
