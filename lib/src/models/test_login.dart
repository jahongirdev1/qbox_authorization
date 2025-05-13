class TestLogin {
  const TestLogin({required this.username, required this.password});

  final String username;
  final String password;

  @override
  String toString() => 'TestLogin(username: $username, password: $password)';
}
