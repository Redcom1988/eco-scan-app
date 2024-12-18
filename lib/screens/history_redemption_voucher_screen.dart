import 'package:flutter/material.dart';

class RiwayatPenukaranScreen extends StatefulWidget {
  @override
  RiwayatPenukaranScreenState createState() => RiwayatPenukaranScreenState();
}

class RiwayatPenukaranScreenState extends State<RiwayatPenukaranScreen> {
  String selectedMonth = "Januari 2024";

  final List<String> months = [
    "Januari 2024",
    "Februari 2024",
    "Maret 2024",
    "Oktober 2023",
  ];

  final List<Map<String, dynamic>> vouchers = [
    {
      "amount": "Rp 40.000,00",
      "expiryDate": "17 Januari 2025",
      "redeemDate": "17 Nov 2024",
      "points": "-40.000 poin",
      "status": "Detail voucher",
    },
    {
      "amount": "Rp 25.000,00",
      "expiryDate": "10 Oktober 2024",
      "redeemDate": "10 Ags 2024",
      "points": "-25.000 poin",
      "status": "Detail voucher",
    },
    {
      "amount": "Rp 10.000,00",
      "expiryDate": "01 September 2024",
      "redeemDate": "01 Juli 2024",
      "points": "-10.000 poin",
      "status": "Ditukarkan",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Penukaran Voucher',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: vouchers.length,
                itemBuilder: (context, index) {
                  final voucher = vouchers[index];
                  return _buildVoucherCard(
                    amount: voucher["amount"],
                    expiryDate: voucher["expiryDate"],
                    redeemDate: voucher["redeemDate"],
                    points: voucher["points"],
                    status: voucher["status"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          isExpanded: true,
          items: months.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMonth = value!;
            });
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildVoucherCard({
    required String amount,
    required String expiryDate,
    required String redeemDate,
    required String points,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeftLabel(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EcoscanVoucher",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Berlaku sampai $expiryDate",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Berhasil ditukarkan pada $redeemDate",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(status),
        ],
      ),
    );
  }

  Widget _buildLeftLabel() {
    return Container(
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RotatedBox(
        quarterTurns: 3,
        child: const Text(
          "Ecoscan Voucher",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String status) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor:
            status == "Ditukarkan" ? Colors.grey : const Color(0xFF1B5E20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(100, 36),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RiwayatPenukaranScreen(),
  ));
}
