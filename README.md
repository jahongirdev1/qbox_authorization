# <img src="assets/images/logo.png" alt="19" width="150" height="150">

# QBox Authorization

QBox Authorization provides a complete workspace-aware authentication flow for Flutter apps. It ships a domain selection screen, branded login UI that is configured from your backend `/appearance` endpoint, and the `provider`-powered state management needed to obtain an auth token in only a few lines of code.

## 🚀 What’s inside

- Workspace picker that validates a company domain before showing the login form.
- Remote theming via the `/appearance` endpoint (icon, title, background, description).
- Localized UI (1: Russian, 2: Kazakh, 3: English) with runtime switching through `localeId`.
- Token-based login handled by `AuthProvider` and returned through the `onSuccess` callback.
- Optional `TestLogin` helper for QA/demo presets and built-in loading/error handling.

## 📦 Installation

```yaml
dependencies:
  qbox_authorization: ^1.0.2
```

```sh
flutter pub get
```

## ⚙️ Getting started

### 1. Register `AuthProvider`

```dart
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
```

`AuthProvider` owns the login controllers, visibility state, token fetching, and `/appearance` cache, so it must live above the widgets that use `AuthFlow` or `AuthScreen`.

### 2. Drop in the full flow

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _handleSuccess(BuildContext context, String token, String baseUrl) {
    // Persist the token or navigate to the rest of your app.
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return AuthFlow(
            localeId: 1, // 1=ru, 2=kk, 3=en
            onSuccess: (token, baseUrl) => _handleSuccess(context, token, baseUrl),
          );
        },
      ),
    );
  }
}
```

`AuthFlow` first renders the company selection screen where the user types their domain (e.g., `qbox.company.kz`). Once the package validates the domain by calling `https://{domain}/appearance?locale_id=...`, it automatically transitions to the branded login UI and finally invokes `onSuccess(token, baseUrl)` when authentication completes.

### 3. Need to jump straight to the login screen?

If you already know the tenant base URL (for example, you store it with the user profile), you can bypass the domain step and use `AuthScreen` directly:

```dart
AuthScreen(
  baseUrl: '<YOUR_BASE_URL>',
  localeId: 2,
  testLogin: const TestLogin(username: 'demo', password: 'secret123'), // optional
  onSuccess: (token, baseUrl) {
    // Handle the token.
  },
);
```

Use the optional `testLogin` to pre-fill credentials in QA builds. When omitted, users interact with the regular text fields.

## 🌐 Localization reference

| `localeId` | Language                 |
| ---------- | ------------------------ |
| `1`        | Russian (`ru`) – default |
| `2`        | Kazakh (`kk`)            |
| `3`        | English (`en`)           |

The same `localeId` is passed to both the domain discovery screen and the `/appearance` request, so your backend can serve localized branding assets and strings.

## 🧪 Example project

Check `example/lib/main.dart` for a runnable Flutter app that wires the provider, launch flow, and a dummy `HomeScreen`. Use it as a quick sanity check after integrating the package.

## 📜 License

MIT © QBox Authorization contributors.

## 🙋 Support & contributions

Issues and pull requests are welcome on GitHub. If you run into a problem integrating the package (appearance endpoint, localization, etc.), open an issue with reproduction steps and we’ll help as soon as possible.

---

🚀 Enjoy hassle-free, branded authentication flows with QBox Authorization!
