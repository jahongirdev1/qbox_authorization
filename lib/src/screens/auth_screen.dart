import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../styles/app_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.baseUrl,
    required this.onSuccess,
    super.key,
  });

  final void Function(String token) onSuccess;
  final String baseUrl;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.initialize(widget.baseUrl);
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
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                        child: Image(
                          image: NetworkImage(
                            widget.baseUrl + (provider.appearance?.icon ?? ''),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48,
                        child: CupertinoTextField(
                          controller: provider.login,
                          placeholder: 'Логин',
                          cursorColor: Colors.blue,
                          prefix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(AppIcons.user),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: CupertinoTextField(
                          controller: provider.password,
                          obscureText: !provider.isVisible,
                          placeholder: 'Пароль',
                          cursorColor: Colors.blue,
                          prefix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(AppIcons.password),
                          ),
                          suffix: IconButton(
                            onPressed: () => provider.toggleVisibility(),
                            icon: SvgPicture.asset(
                              provider.isVisible
                                  ? AppIcons.eyeOpen
                                  : AppIcons.eyeClose,
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
                            String? token = await provider.loginAction(context);
                            if (token != null) {
                              widget.onSuccess(token);
                            }
                          },
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
