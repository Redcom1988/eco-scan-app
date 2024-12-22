import 'package:ecoscan/backend-client/education_handler.dart';
import 'package:flutter/material.dart';

class KelolaEdukasiPage extends StatefulWidget {
  @override
  KelolaEdukasiPageState createState() => KelolaEdukasiPageState();
}

class KelolaEdukasiPageState extends State<KelolaEdukasiPage> {
  List<Map<String, dynamic>> _edukasiList = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEducationContent();
  }

  Future<void> _loadEducationContent() async {
    setState(() => _isLoading = true);
    final content = await fetchEducationContent();
    if (content != null) {
      if (!mounted) return;
      setState(() {
        _edukasiList = content;
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load education content')),
      );
    }
  }

  void _addOrEditEdukasi({Map<String, dynamic>? edukasi}) {
    final TextEditingController titleController =
        TextEditingController(text: edukasi?['contentTitle'] ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: edukasi?['contentDescription'] ?? '');
    final TextEditingController fullController =
        TextEditingController(text: edukasi?['contentFull'] ?? '');
    final TextEditingController imageController =
        TextEditingController(text: edukasi?['contentImage'] ?? '');

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
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Singkat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fullController,
                  decoration: const InputDecoration(
                    labelText: 'Konten Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (edukasi != null) {
                  final success = await updateEducationContent(
                    contentId: edukasi['contentId'].toString(),
                    contentTitle: titleController.text,
                    contentDescription: descriptionController.text,
                    contentFull: fullController.text,
                    contentImage: imageController.text,
                  );
                  if (success) {
                    _loadEducationContent();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Konten berhasil diperbarui')),
                    );
                  }
                } else {
                  final result = await addEducationContent(
                    contentTitle: titleController.text,
                    contentDescription: descriptionController.text,
                    contentFull: fullController.text,
                    contentImage: imageController.text,
                  );
                  if (result != null) {
                    _loadEducationContent();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Konten berhasil ditambahkan')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEdukasi(String contentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus konten ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success = await deleteEducationContent(contentId);
      if (success) {
        _loadEducationContent();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konten berhasil dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _edukasiList.where((edukasi) {
      final title = edukasi['contentTitle'].toString().toLowerCase();
      final description =
          edukasi['contentDescription'].toString().toLowerCase();
      final searchTerm = _searchController.text.toLowerCase();
      return title.contains(searchTerm) || description.contains(searchTerm);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Kelola Edukasi",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                hintText: 'Cari Edukasi...',
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: filteredList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredList.length) {
                        return const SizedBox(height: 80);
                      }
                      final edukasi = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                child: Image.network(
                                  edukasi['contentImage'] ??
                                      'https://via.placeholder.com/150',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        edukasi['contentTitle'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        edukasi['contentDescription'],
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatTimestamp(edukasi['timestamp'],
                                            DateTime.now()),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green, size: 18),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      onPressed: () =>
                                          _addOrEditEdukasi(edukasi: edukasi),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 18),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _deleteEdukasi(
                                          edukasi['contentId'].toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditEdukasi,
        child: const Icon(Icons.add),
      ),
    );
  }
}
