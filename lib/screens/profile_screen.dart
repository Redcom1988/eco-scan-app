import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ecoscan',
          style: TextStyle(
            color: Colors.green.shade900, // Warna hijau seperti ikon pengaturan
          ),
        ),
        backgroundColor: Colors.transparent, // AppBar tanpa latar belakang
        elevation: 0, // Menghilangkan bayangan AppBar
        iconTheme: IconThemeData(color: Colors.green.shade900), // Warna ikon di AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Foto Profil
            Container(
              color: Colors.transparent, // Menghapus background hijau
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          '', // Belum ada URL gambar
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
                  const Text(
                    'Tangkaszz',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Sibuks',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Daftar Menu Pengaturan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person, 'Pengguna dan Akun'),
                  _buildMenuItem(Icons.favorite, 'Edukasi yang disukai'),
                  _buildMenuItem(Icons.bookmark, 'Edukasi yang disimpan'),
                  _buildMenuItem(Icons.notifications, 'Notifikasi dan Bilah Status'),
                  _buildMenuItem(Icons.language, 'Bahasa dan Wilayah'),
                  _buildMenuItem(Icons.help, 'Pusat Bantuan'),
                  _buildMenuItem(Icons.settings, 'Pengaturan Lainnya'),
                  _buildMenuItem(Icons.logout, 'Keluar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat item menu
  Widget _buildMenuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green.shade900),
          title: Text(title),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Tambahkan fungsi navigasi di sini
          },
        ),
        Divider(),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
