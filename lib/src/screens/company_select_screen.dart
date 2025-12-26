// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qbox_authorization/src/styles/app_icons.dart';
import '../provider/auth_provider.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    final bottomPadding = isKeyboardVisible ? 16.0 : 100.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: Image.asset(
              AppIcons.background,
              fit: BoxFit.cover,
            ),
          ),

          /// Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      /// Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppIcons.logo,
                          height: 100,
                          width: 100,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Подключитесь к рабочему\nпространству вашей компании',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 90),

                      /// Input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _domainController,
                              cursorColor: Colors.blue,
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
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _domainController.clear();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'пример: qbox.company.kz',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      /// Button
                      Consumer<AuthProvider>(
                        builder: (context, provider, _) {
                          final isEnabled =
                              isValid && !provider.isAppearanceLoading;

                          return Padding(
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
                                onPressed: isEnabled
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isEnabled
                                      ? const Color(0xFF2b7fff)
                                      : const Color(0xFF39619f),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: provider.isAppearanceLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
