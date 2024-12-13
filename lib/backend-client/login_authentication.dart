import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

Future<bool> loginUser(String email, String password) async {
  // Hash the password using SHA-256
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);

  final response = await http.post(
    Uri.parse('http://localhost:3000/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'passwordHash': digest.toString(),
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
