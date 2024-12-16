import 'package:ecoscan/backend-client/remove_local_user.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../models/user.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';

class ProfileScreen extends StatefulWidget {
  // Add user parameter
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
    // if (user == null) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //     (route) => false,
    //   );
    // }
  }

  Future<void> _loadUser() async {
    try {
      final localUser = await getLocalUser();
      setState(() {
        user = localUser;
      });
      print('Loaded user: ${user?.fullName}');
    } catch (e) {
      print('Error loading user: $e');
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
                    user?.fullName ?? '', // Display user's full name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '', // Display user's email
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
                  _buildMenuItem(Icons.favorite, 'Edukasi yang disukai'),
                  _buildMenuItem(Icons.bookmark, 'Edukasi yang disimpan'),
                  _buildMenuItem(
                      Icons.notifications, 'Notifikasi dan Bilah Status'),
                  _buildMenuItem(Icons.language, 'Bahasa dan Wilayah'),
                  _buildMenuItem(Icons.help, 'Pusat Bantuan'),
                  _buildMenuItem(Icons.settings, 'Pengaturan Lainnya'),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade900),
          title: Text(title),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Navigation function here
          },
        ),
        Divider(),
      ],
    );
  }

  // New method to display user info items
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

  // New method for logout button
  Widget _buildLogoutButton(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Keluar', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Konfirmasi Keluar'),
                  content: Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Clear user session here
                        removeLocalUser();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      child:
                          Text('Keluar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Divider(),
      ],
    );
  }
}
