import 'package:ecoscan/backend-client/remove_local_user.dart';
import 'package:ecoscan/screens/login_screen.dart';
import 'package:ecoscan/screens/support_ticket_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/models/user.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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

  void _navigateToSupportTickets(BuildContext context) {
    print('Attempting to navigate to support tickets...');
    print('Current user: ${user?.toString()}');

    if (user != null) {
      print('Navigating to SupportTicketListScreen with:');
      print('userId: ${user!.userId}');
      print('username: ${user!.username}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupportTicketListScreen(
            userId: user!.userId,
            username: user!.username,
            userRole: user!.role,
          ),
        ),
      );
    } else {
      print('User is null, cannot navigate');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please login first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ecoscan',
          style: TextStyle(
            color: Colors.green.shade900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade900),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
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
                              ? user?.fullName[0].toUpperCase() ?? ''
                              : '',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.fullName ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
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
                  _buildMenuItem(
                    Icons.support,
                    'Pusat Bantuan dan Tiket',
                    onTap: () => _navigateToSupportTickets(context),
                  ),
                  _buildMenuItem(Icons.help, 'Pusat Bantuan'),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade900),
          title: Text(title),
          trailing: Icon(Icons.chevron_right),
          onTap: onTap ??
              () {
                // Default navigation function here
              },
        ),
        Divider(),
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
        Divider(),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Keluar', style: TextStyle(color: Colors.red)),
          onTap: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Konfirmasi Keluar'),
                  content: Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child:
                          Text('Keluar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );

            if (shouldLogout == true) {
              await removeLocalUser();
              if (context.mounted) {
                // Use context.mounted instead of mounted
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              }
            }
          },
        ),
        Divider(),
      ],
    );
  }
}
