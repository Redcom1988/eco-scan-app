import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

Future<User> getLocalUser() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? '';
  final username = prefs.getString('username') ?? '';
  final fullName = prefs.getString('fullName') ?? '';
  final role = prefs.getString('role') ?? '';

  return User(
    email: email,
    username: username,
    fullName: fullName,
    role: role,
  );
}
