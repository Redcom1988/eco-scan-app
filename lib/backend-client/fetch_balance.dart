import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double?> fetchBalance(String username) async {
  try {
    final response = await http
        .post(
          Uri.parse(
              'https://w4163hhc-3000.asse.devtunnels.ms/users/getBalance'), // Corrected endpoint
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
          }),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        return responseData['balance'];
      } else {
        print('Error: ${responseData['error']}');
        return null;
      }
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
