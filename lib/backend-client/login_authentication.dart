import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../models/user.dart';

class LoginResponse {
  final bool success;
  final User? user;
  final String? error;

  LoginResponse({
    required this.success,
    this.user,
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
          Uri.parse('http://localhost:3000/users/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'passwordHash': digest.toString(),
          }),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Create User object from response data
      final user = User(
        email: email,
        username: data['username'] ?? '',
        fullName: data['fullName'] ?? '',
      );

      return LoginResponse(
        success: true,
        user: user,
      );
    } else {
      return LoginResponse(
        success: false,
        error: 'Login failed. Please try again.',
      );
    }
  } catch (e) {
    return LoginResponse(
      success: false,
      error: 'Network error. Please check your connection.',
    );
  }
}
