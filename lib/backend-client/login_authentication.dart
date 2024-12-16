import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginResponse {
  final bool success;
  final String? error;

  LoginResponse({
    required this.success,
    this.error,
  });
}

Future<LoginResponse> loginUser(String email, String password) async {
  // Hash the password using SHA-256
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);

  try {
    final response = await http
        .post(
          Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/users/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'passwordHash': digest.toString(),
          }),
        )
        .timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      print("Login Success");
      final Map<String, dynamic> data = json.decode(response.body);

      // Create User object from response data
      // final user = User(
      //   email: email,
      //   username: data['username'] ?? '',
      //   fullName: data['fullName'] ?? '',
      // );

      final username = data['username'] ?? '';
      final fullName = data['fullName'] ?? '';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('username', username);
      await prefs.setString('fullName', fullName);

      return LoginResponse(
        success: true,
      );
    } else {
      print("QWE");
      return LoginResponse(
        success: false,
        error: 'Login failed. Please try again.',
      );
    }
  } catch (e) {
    String error = "${e.toString()}ASD";
    print(error);
    return LoginResponse(
      success: false,
      error: 'Network error. Please check your connection.',
    );
  }
}
