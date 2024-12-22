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
      setState(() {
        user = localUser;
      });
      print('Loaded user: ${user?.fullName}');
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  void _editProfileImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile Picture'),
          content: const Text('Feature coming soon...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
      {required IconData icon, required String title, VoidCallback? onTap}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ecoscan',
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
                      IconButton(
                        onPressed: _editProfileImage,
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
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: 'Edukasi yang Banyak Disukai',
                    onTap: () {
                      print('Navigate to Liked Education');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark,
                    title: 'Edukasi yang Banyak Disimpan',
                    onTap: () {
                      print('Navigate to Saved Education');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'Notifikasi dan Bilah Status',
                    onTap: () {
                      print('Navigate to Notifications');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.language,
                    title: 'Bahasa dan Wilayah',
                    onTap: () {
                      print('Navigate to Language Settings');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Pengaturan Lainnya',
                    onTap: () {
                      print('Navigate to Settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi Keluar'),
                            content:
                                const Text('Apakah Anda yakin ingin keluar?'),
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
                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
