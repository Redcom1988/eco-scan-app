import 'package:flutter/material.dart';

class ProfileAdminPage extends StatefulWidget {
  @override
  _ProfileAdminPageState createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  String _adminName = "AdikaSusilo";
  String _profileImageUrl = "https://via.placeholder.com/150";

  void _editProfileImage() {
    final TextEditingController _imageUrlController =
        TextEditingController(text: _profileImageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Foto Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Foto Profil',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _profileImageUrl = _imageUrlController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _editAdminName() {
    final TextEditingController _nameController =
        TextEditingController(text: _adminName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Nama Admin'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama Admin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _adminName = _nameController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Foto Profil dan Nama Admin
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_profileImageUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _editProfileImage,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.camera_alt,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _adminName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: _editAdminName,
                    child: const Text(
                      "Pusat Bantuan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu List
            _buildMenuItem(
              icon: Icons.person,
              title: 'Pengguna dan Akun',
              onTap: () {
                // Tambahkan navigasi ke halaman Pengguna dan Akun
                print('Navigasi ke Pengguna dan Akun');
              },
            ),
            _buildMenuItem(
              icon: Icons.favorite,
              title: 'Edukasi yang Banyak Disukai',
              onTap: () {
                // Tambahkan navigasi ke halaman Edukasi yang Banyak Disukai
                print('Navigasi ke Edukasi yang Banyak Disukai');
              },
            ),
            _buildMenuItem(
              icon: Icons.bookmark,
              title: 'Edukasi yang Banyak Disimpan',
              onTap: () {
                // Tambahkan navigasi ke halaman Edukasi yang Banyak Disimpan
                print('Navigasi ke Edukasi yang Banyak Disimpan');
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: 'Notifikasi dan Bilah Status',
              onTap: () {
                // Tambahkan navigasi ke halaman Notifikasi dan Bilah Status
                print('Navigasi ke Notifikasi dan Bilah Status');
              },
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: 'Bahasa dan Wilayah',
              onTap: () {
                // Tambahkan navigasi ke halaman Bahasa dan Wilayah
                print('Navigasi ke Bahasa dan Wilayah');
              },
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Pengaturan Lainnya',
              onTap: () {
                // Tambahkan navigasi ke halaman Pengaturan Lainnya
                print('Navigasi ke Pengaturan Lainnya');
              },
            ),
            _buildMenuItem(
              icon: Icons.exit_to_app,
              title: 'Keluar',
              onTap: () {
                // Tambahkan logika untuk keluar dari aplikasi
                print('Keluar dari aplikasi');
              },
            ),
          ],
        ),
      ),
    );
  }
}

