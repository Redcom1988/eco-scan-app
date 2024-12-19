import 'package:flutter/material.dart';

class PusatBantuanPage extends StatefulWidget {
  @override
  _PusatBantuanPageState createState() => _PusatBantuanPageState();
}

class _PusatBantuanPageState extends State<PusatBantuanPage> {
  final List<Map<String, dynamic>> _laporanList = [
    {
      "nama": "Ardi Gunawan",
      "laporan": "Tidak bisa menukarkan voucher di aplikasi.",
    },
    {
      "nama": "Omong Alit",
      "laporan": "Aplikasi crash saat mencoba masuk ke halaman profil.",
    },
    {
      "nama": "Ardiyansah",
      "laporan": "Tidak bisa melihat edukasi di halaman Kelola Edukasi.",
    },
    {
      "nama": "Gede Rai",
      "laporan": "Ada bug pada fitur pencarian voucher.",
    },
    {
      "nama": "Gurah Sanjaya",
      "laporan": "Pengalaman aplikasi lambat saat digunakan.",
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  void _addPengumuman() {
    final TextEditingController _judulController = TextEditingController();
    final TextEditingController _deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buat Pengumuman Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul Pengumuman'),
              ),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
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
                // Simpan pengumuman ke database atau state (untuk saat ini hanya print log)
                print("Judul: ${_judulController.text}");
                print("Deskripsi: ${_deskripsiController.text}");
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _laporanList
        .where((laporan) =>
            laporan['nama']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            laporan['laporan']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();

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
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari laporan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Daftar laporan
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final laporan = filteredList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person, color: Colors.white),
                      backgroundColor: Colors.green,
                    ),
                    title: Text(
                      laporan['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      laporan['laporan'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Lihat detail laporan (tampilkan log atau navigasi ke halaman detail)
                        print("Laporan dari: ${laporan['nama']}");
                        print("Isi laporan: ${laporan['laporan']}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Lihat selengkapnya'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPengumuman,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

