import 'package:ecoscan/backend-client/get_local_user.dart';
import 'package:ecoscan/backend-client/remove_local_user.dart';
import 'package:ecoscan/models/user.dart';
import 'package:ecoscan/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({Key? key}) : super(key: key);

  @override
  _ProfileAdminPageState createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final localUser = await getLocalUser();
      if (localUser != null) {
        setState(() {
          user = localUser;
        });
        print('Loaded user details:');
        print('User ID: ${user?.userId}');
        print('Full Name: ${user?.fullName}');
        print('Email: ${user?.email}');
        print('Username: ${user?.username}');
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  // void _navigateToSupportTickets(BuildContext context) {
  //   print('Attempting to navigate to support tickets...');
  //   print('Current user: ${user?.toString()}');

  //   if (user != null) {
  //     print('Navigating to SupportTicketListScreen with:');
  //     print('userId: ${user!.userId}');
  //     print('username: ${user!.username}');

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SupportTicketListScreen(
  //           userId: user!.userId,
  //           username: user!.username,
  //           userRole: user!.role,
  //         ),
  //       ),
  //     );
  //   } else {
  //     print('User is null, cannot navigate');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please login first')),
  //     );
  //   }
  // }

  // void _editProfileImage() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Edit Profile Picture'),
  //         content: const Text('Feature coming soon...'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ecoscan Admin',
          style: TextStyle(color: Colors.green.shade900),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade900),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          user?.fullName.isNotEmpty == true
                              ? user!.fullName[0].toUpperCase()
                              : '',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUserInfoItem(
                      Icons.person, 'Username', user?.username ?? ''),
                  _buildUserInfoItem(Icons.email, 'Email', user?.email ?? ''),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await removeLocalUser();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade900),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildUserInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade900),
          title: Text(title),
          subtitle: Text(value),
        ),
        const Divider(),
      ],
    );
  }
}
