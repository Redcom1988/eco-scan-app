import 'package:flutter/material.dart';

class KelolaEdukasiPage extends StatefulWidget {
  @override
  _KelolaEdukasiPageState createState() => _KelolaEdukasiPageState();
}

class _KelolaEdukasiPageState extends State<KelolaEdukasiPage> {
  final List<Map<String, dynamic>> _edukasiList = [
    {
      "judul": "Berikut Waste Management Vending Machines di Denpasar!!",
      "isi":
          "WMVM atau Waste Management Vending Machines dapat kita temukan di sekitar kita. Lokasi WMVM sangat mudah untuk kita temukan...",
      "gambar": "https://via.placeholder.com/150"
    },
    {
      "judul": "Edukasi Lingkungan untuk Anak-Anak",
      "isi": "Program edukasi lingkungan yang dirancang untuk anak-anak...",
      "gambar": "https://via.placeholder.com/150"
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  void _addOrEditEdukasi({Map<String, dynamic>? edukasi, int? index}) {
    final TextEditingController _judulController = TextEditingController(
        text: edukasi != null ? edukasi['judul'] : '');
    final TextEditingController _isiController = TextEditingController(
        text: edukasi != null ? edukasi['isi'] : '');
    final TextEditingController _gambarController = TextEditingController(
        text: edukasi != null ? edukasi['gambar'] : '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(edukasi != null ? 'Edit Edukasi' : 'Tambah Edukasi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul Edukasi'),
                ),
                TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(labelText: 'Isi Edukasi'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _gambarController,
                  decoration: const InputDecoration(labelText: 'URL Gambar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (edukasi != null) {
                    // Edit edukasi
                    _edukasiList[index!] = {
                      "judul": _judulController.text,
                      "isi": _isiController.text,
                      "gambar": _gambarController.text,
                    };
                  } else {
                    // Tambah edukasi
                    _edukasiList.add({
                      "judul": _judulController.text,
                      "isi": _isiController.text,
                      "gambar": _gambarController.text,
                    });
                  }
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

  void _deleteEdukasi(int index) {
    setState(() {
      _edukasiList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _edukasiList
        .where((edukasi) =>
            edukasi['judul']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            edukasi['isi']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("",
            style: TextStyle(color: Colors.black)),
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
                hintText: 'Cari',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Edit Edukasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // List edukasi
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final edukasi = filteredList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      edukasi['gambar'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(edukasi['judul']),
                    subtitle: Text(
                      edukasi['isi'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () =>
                              _addOrEditEdukasi(edukasi: edukasi, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEdukasi(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditEdukasi(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
