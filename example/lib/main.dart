import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox_authorization/qbox_authorization.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _handleLoginSuccess(BuildContext context, String token) {
    print('Login successful! Token: $token');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return AuthScreen(
            baseUrl: 'https://cc.bankffin.kz',
            onSuccess: (token) => _handleLoginSuccess(context, token),
            localeId: 2,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: const Center(
        child: Text('Welcome to Home Screen!'),
      ),
    );
  }
}
