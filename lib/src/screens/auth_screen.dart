import 'package:qbox_authorization/src/models/test_login.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../styles/app_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.baseUrl,
    required this.onSuccess,
    this.localeId = 1,
    super.key,
    this.testLogin,
  });

  /// Функция, вызываемая при успешном завершении операции.
  ///
  /// Принимает [token] — строковый идентификатор, полученный в результате успешной авторизации.
  final void Function(String token) onSuccess;

  /// Базовый URL API.
  ///
  /// Используется для отправки запросов к серверу.
  final String baseUrl;

  /// Идентификатор локализации, используемый при получении данных о внешнем виде.
  ///
  /// Возможные значения:
  /// - `1` — русский (`ru`, по умолчанию)
  /// - `2` — казахский (`kk`)
  /// - `3` — английский (`en`)
  final int localeId;

  /// Тестовые данные для входа.
  final TestLogin? testLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.initialize(widget.baseUrl, widget.localeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) => Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.baseUrl +
                    (provider.appearance?.backgroundImages[0] ?? ''),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      isSvgUrl(provider.appearance?.icon ?? '')
                          ? SvgPicture.network(
                              '${widget.baseUrl}${provider.appearance?.icon}')
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9)),
                              child: Image(
                                image: NetworkImage(
                                  widget.baseUrl +
                                      (provider.appearance?.icon ?? ''),
                                ),
                                errorBuilder: (_, __, ___) => const SizedBox(),
                                width: 90,
                                height: 90,
                              ),
                            ),
                      Text(
                        textAlign: TextAlign.center,
                        provider.appearance?.title ?? '',
                        style: const TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            child: TextField(
                              controller: provider.login,
                              autofillHints: const [AutofillHints.username],
                              decoration: InputDecoration(
                                hintText: 'Логин',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(AppIcons.user,
                                      width: 24, height: 24),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            child: TextField(
                              controller: provider.password,
                              obscureText: !provider.isVisible,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                hintText: 'Пароль',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(AppIcons.password,
                                      width: 24, height: 24),
                                ),
                                suffixIcon: IconButton(
                                  icon: SvgPicture.asset(
                                    provider.isVisible
                                        ? AppIcons.eyeOpen
                                        : AppIcons.eyeClose,
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () => provider.toggleVisibility(),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                elevation: const WidgetStatePropertyAll(0),
                              ),
                              onPressed: () async {
                                if (widget.testLogin != null) {
                                  provider.testLogin(widget.testLogin!);
                                }
                                String? token =
                                    await provider.loginAction(context);
                                if (token != null) {
                                  widget.onSuccess(token);
                                }
                              },
                              child: provider.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Войти',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isSvgUrl(String url) => url.toLowerCase().endsWith('.svg');
}
