# <img src="https://inqbox.q19.kz/static/uploads/image/27/3b/273b4bdea7ed4569b0339c9815d48ef5.png" alt="QBox Logo" width="150" height="150"/>

# QBox Authorization

QBox Authorization is a simple yet powerful authentication package for Flutter applications. It provides a ready-to-use login screen and integrates seamlessly with the Provider state management solution.

## 🚀 Features

✅ Ready-made authentication screen with a modern UI  
✅ Uses `provider` for state management  
✅ Handles login logic and token retrieval  
✅ Fully customizable and easy to integrate

## 📦 Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  qbox_authorization: ^0.0.6
```

Then run:

```sh
flutter pub get
```

## 🛠 Usage

### 1️⃣ Import the package:

```dart
import 'package:qbox_authorization/qbox_authorization.dart';
```

### 2️⃣ Wrap your app with `MultiProvider`

Since `AuthProvider` is responsible for managing the authentication state, you need to add it to the Provider tree before using `AuthScreen`. The recommended way is to wrap your `MaterialApp` with `MultiProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox_authorization/qbox_authorization.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3️⃣ Add `AuthScreen`

Use `AuthScreen` to handle authentication in your app. Once the user logs in successfully, the `onSuccess` callback will be triggered with the authentication token.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _handleLoginSuccess(BuildContext context, String token) {
    print('Login successful! Token: $token');

    // Navigate to the home screen
    Navigator.pushReplacement(
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
            baseUrl: '<YOUR_API_BASE_URL>',
            onSuccess: (token) => _handleLoginSuccess(context, token),
            localeId: 2,
          );
        },
      ),
    );
  }
}
```

### 4️⃣ HomeScreen Example

After a successful login, navigate to a new screen:

```dart
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
```

## 💡 Why Use `MultiProvider`?

The `MultiProvider` widget is necessary because `AuthProvider` is a `ChangeNotifier`, which means it holds the state for authentication. Without wrapping the app with `MultiProvider`, the login logic wouldn't function correctly as `AuthProvider` wouldn't be accessible throughout the app.

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
  ],
  child: MyApp(),
)
```

✅ Ensures authentication state is available globally.  
✅ Keeps the UI updated when authentication state changes.  
✅ Allows easy integration with other providers in the future.

## 📜 License

This package is licensed under the MIT License.

## 🛠 Contributing

Contributions are welcome! Feel free to submit issues and pull requests to improve this package.

## 📞 Support

If you encounter any issues or need help, feel free to open an issue on GitHub or reach out to the maintainer.

---

🚀 **Enjoy hassle-free authentication with QBox Authorization!**
