import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double?> fetchBalance(String username) async {
  try {
    print('Sending balance request for username: $username'); // Debug print

    final response = await http.get(
      // Changed from post to get
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/users/getBalance?username=$username'), // Added query parameter
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData'); // Debug print

      if (responseData['success']) {
        final balance = responseData['balance'];
        if (balance != null) {
          return balance.toDouble();
        }
        print('Balance is null in response'); // Debug print
        return null;
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
    print('Error in fetchBalance: $e');
    return null;
  }
}
