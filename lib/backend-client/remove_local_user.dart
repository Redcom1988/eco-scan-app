import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeLocalUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('email');
  await prefs.remove('fullName');
}
