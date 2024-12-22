import 'package:flutter/material.dart';

class WithdrawalHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "Riwayat pemasukan poin",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No. Transaksi dan Total Poin
            Text(
              "No. 012930123994803",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "325 Poin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Tanggal & Waktu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "19 November 2024",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  "(10:23)",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_pin, size: 20, color: Colors.red),
                SizedBox(width: 6),
                Text(
                  "Alamat Mesin, Jimbaran, Bali",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 32, color: Colors.grey),
            // Input Entry
            Text(
              "Input Entry:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            // Item 1
            ItemEntry(
              jumlah: "5x",
              jenis: "Kaleng 355 ml",
              poinPerUnit: "30 poin/unit",
              totalPoin: "150 poin",
              icon: Icons.local_drink,
              iconColor: Colors.orange,
            ),
            SizedBox(height: 8),
            // Item 2
            ItemEntry(
              jumlah: "7x",
              jenis: "Botol Plastik 600 ml",
              poinPerUnit: "25 poin/unit",
              totalPoin: "175 poin",
              icon: Icons.local_drink_outlined,
              iconColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemEntry extends StatelessWidget {
  final String jumlah;
  final String jenis;
  final String poinPerUnit;
  final String totalPoin;
  final IconData icon;
  final Color iconColor;

  const ItemEntry({
    required this.jumlah,
    required this.jenis,
    required this.poinPerUnit,
    required this.totalPoin,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            jumlah,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          jenis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            SizedBox(width: 4),
            Text(
              poinPerUnit,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        trailing: Text(
          totalPoin,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
