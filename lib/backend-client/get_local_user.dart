import 'package:ecoscan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getLocalUser() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? '';
  final username = prefs.getString('username') ?? '';
  final fullName = prefs.getString('fullName') ?? '';

  return User(
    email: email,
    username: username,
    fullName: fullName,
  );
}

// Future<int> getUser({required username}) async {
//   try {
//     print('Fetching user with username: $username');

//     final uri = Uri.parse(
//         'https://w4163hhc-3000.asse.devtunnels.ms/users/getUser/$username');

//     print('Request URL: $uri');

//     final response = await http.get(
//       uri,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     ).timeout(const Duration(seconds: 10));

//     print('Response status code: ${response.statusCode}');
//     print('Raw response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print('Parsed response data: $responseData');

//       final user = User.fromJson(responseData);
//       print('Successfully parsed user: ${user.username}');
//       return user.id;
//     } else {
//       print('HTTP request failed with status: ${response.statusCode}');
//       print('Error response body: ${response.body}');
//       return 0;
//     }
//   } catch (e, stackTrace) {
//     print('Exception in getUser: $e');
//     print('Stack trace: $stackTrace');
//     return 0;
//   }
// }

// Future<Uint8List?> getUserImage({required username}) async {
//   try {
//     print('Fetching user image with username: $username');

//     final uri = Uri.parse(
//         'https://w4163hhc-3000.asse.devtunnels.ms/users/getUserImage/$username');

//     print('Request URL: $uri');

//     final response = await http.get(
//       uri,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     ).timeout(const Duration(seconds: 10));

//     print('Response status code: ${response.statusCode}');
//     print('Raw response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print('Parsed response data: $responseData');

//       final user = User.fromJson(responseData);
//       print('Successfully parsed user: ${user.username}');
//       return user.image;
//     } else {
//       print('HTTP request failed with status: ${response.statusCode}');
//       print('Error response body: ${response.body}');
//       return 0;
//     }
//   } catch (e, stackTrace) {
//     print('Exception in getUserImage: $e');
//     print('Stack trace: $stackTrace');
//     return 0;
//   }
// }
