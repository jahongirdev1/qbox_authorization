// ignore_for_file: deprecated_member_use

import 'package:qbox_authorization/src/styles/app_icons.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CompanySelectScreen extends StatefulWidget {
  final void Function(String baseUrl) onContinue;
  final int localeId;

  const CompanySelectScreen({
    super.key,
    required this.onContinue,
    this.localeId = 1,
  });

  @override
  State<CompanySelectScreen> createState() => _CompanySelectScreenState();
}

class _CompanySelectScreenState extends State<CompanySelectScreen> {
  final TextEditingController _domainController = TextEditingController();

  bool get isValid => _domainController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bool isKeyboardVisible = viewInsets.bottom > 0;
    final double bottomPadding = isKeyboardVisible ? 14 : 100;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image(
            image: AssetImage(AppIcons.background),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image: AssetImage(AppIcons.logo),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Подключитесь к рабочему\nпространству вашей компании',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            cursorColor: Colors.blue,
                            controller: _domainController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Введите домен компании',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.language),
                              suffixIcon: _domainController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _domainController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            textAlign: TextAlign.start,
                            'пример: qbox.company.kz',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // QRWidget(),
                    const Spacer(),
                    Consumer<AuthProvider>(
                      builder: (context, provider, _) {
                        final isButtonEnabled =
                            isValid && !provider.isAppearanceLoading;
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            bottomPadding,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  isButtonEnabled
                                      ? const Color(0xFF2b7fff)
                                      : const Color(0xFF39619f),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                elevation: const WidgetStatePropertyAll(0),
                              ),
                              onPressed: isButtonEnabled
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      final domain =
                                          _domainController.text.trim();
                                      final baseUrl = 'https://$domain';
                                      final success =
                                          await provider.getAppearance(
                                        context,
                                        baseUrl,
                                        widget.localeId,
                                      );

                                      if (!mounted) return;
                                      if (success) {
                                        widget.onContinue(baseUrl);
                                      }
                                    }
                                  : null,
                              child: provider.isAppearanceLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Продолжить',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QRWidget extends StatelessWidget {
  const QRWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white54,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
              ),
            ),
            const Text(
              'ИЛИ',
              style: TextStyle(color: Colors.white70),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white54,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
              label: const Text(
                'Сканировать QR-код',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFF2b7fff),
                  width: 2,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
