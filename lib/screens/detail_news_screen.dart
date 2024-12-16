import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BeritaEdukasi(),
  ));
}

class BeritaEdukasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "Berita Edukasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Header Image
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/video_placeholder.png', 
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    color: Colors.black45,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "8.05",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // News Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Masih banyak masyarakat Indonesia yang tidak peduli tentang masalah sampah. Padahal mereka bisa membuat kerajinan dari gelas plastik bekas yang bisa dijual kembali dengan nilai yang cukup tinggi.",
                style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 12),

            // HPSN Report
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Dalam memperingati Hari Peduli Sampah Nasional (HPSN) 2024 pada 21 Februari lalu, Program Lingkungan PBB mengungkapkan bahwa Indonesia menjadi negara penyumbang sampah terbesar kedua di dunia setelah Tiongkok.",
                style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 16),

            // Guide to Making a Pencil Holder
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berikut panduan membuat tempat pensil dari gelas plastik:",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  buildPanduanItem("Potong satu botol plastik sebesar empat inci dari bawah."),
                  buildPanduanItem("Amplas bagian tepi yang dipotong agar halus."),
                  buildPanduanItem("Ukur resleting di sekeliling lingkar botol dan potong kelebihannya."),
                  buildPanduanItem(
                      "Gunakan lem panas untuk merekatkan resleting ke botol."),
                  buildPanduanItem("Biarkan ujung resleting tidak dilem."),
                  buildPanduanItem("Rekatkan sisi resleting ke botol lain menggunakan lem panas."),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Widget for Guide Item
  Widget buildPanduanItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 4),
          child: Icon(Icons.circle, size: 8, color: Colors.grey),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
