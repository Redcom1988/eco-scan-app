import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginResponse {
  final bool success;
  final String? error;
  final String? role;

  LoginResponse({
    required this.success,
    this.error,
    this.role,
  });
}

Future<LoginResponse> loginUser(String email, String password) async {
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

    // Parse response body
    final Map<String, dynamic> data =
        response.body.isNotEmpty ? json.decode(response.body) : {};

    if (response.statusCode == 200) {
      print("Login Success: Status ${response.statusCode}");

      // Store user data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('email', email),
        prefs.setString('username', data['username'] ?? ''),
        prefs.setString('fullName', data['fullName'] ?? ''),
        prefs.setString('role', data['role'] ?? ''),
      ]);

      return LoginResponse(
        role: data['role'],
        success: true,
      );
    } else {
      print("Login failed with status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      return LoginResponse(
        success: false,
        error:
            data['message'] ?? 'Login failed. Please check your credentials.',
      );
    }
  } catch (e) {
    print("Login error: ${e.toString()}");

    if (e is TimeoutException) {
      return LoginResponse(
        success: false,
        error: 'Connection timeout. Please try again.',
      );
    }

    return LoginResponse(
      success: false,
      error: 'Network error. Please check your connection.',
    );
  }
}
