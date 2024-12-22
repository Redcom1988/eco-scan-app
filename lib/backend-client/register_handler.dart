import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

Future<bool> registerUser(
    String username, String email, String password, String fullName) async {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);

  try {
    final response = await http
        .post(
          Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/users/addUser'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'email': email,
            'passwordHash': digest.toString(),
            'fullName': fullName,
          }),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Registration failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Register error: $e');
    return false;
  }
}
