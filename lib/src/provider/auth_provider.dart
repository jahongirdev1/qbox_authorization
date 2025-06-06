import '../models/test_login.dart';
import '../repository/auth_repository.dart';
import '../utils/show_top_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../models/appearance.dart';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final repo = AuthRepository();
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;

  String baseUrl = '';
  Appearance? appearance;

  String? token;

  void initialize(String url, int localeId) async {
    baseUrl = url;
    appearance = await repo.getAppearance(baseUrl, localeId);
    info("Appearance: $appearance");

    notifyListeners();
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
