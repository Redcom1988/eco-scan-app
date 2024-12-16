import 'package:flutter/material.dart';

class VouchersScreen extends StatefulWidget {
  @override
  _VouchersScreenState createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  String selectedActiveMonth = "Januari 2024";
  String selectedHistoryMonth = "Oktober 2023";

  final List<String> months = [
    "Januari 2024",
    "Oktober 2023",
  ];

  final List<Map<String, dynamic>> activeVouchers = [
    {
      "amount": "Rp 40.000,00",
      "expiryDate": "17 Januari 2025",
    }
  ];

  final List<Map<String, dynamic>> voucherHistory = [
    {
      "amount": "Rp 25.000,00",
      "expiryDate": "10 Oktober 2024",
      "status": "Ditukarkan",
    },
    {
      "amount": "Rp 10.000,00",
      "expiryDate": "01 September 2024",
      "status": "Ditukarkan",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ecoscan',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1B5E20)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Voucher aktif saya",
              dropdownValue: selectedActiveMonth,
              onDropdownChanged: (value) {
                setState(() {
                  selectedActiveMonth = value!;
                });
              },
              vouchers: activeVouchers,
              isHistory: false,
            ),
            SizedBox(height: 24),
            _buildSection(
              title: "Riwayat voucher saya",
              dropdownValue: selectedHistoryMonth,
              onDropdownChanged: (value) {
                setState(() {
                  selectedHistoryMonth = value!;
                });
              },
              vouchers: voucherHistory,
              isHistory: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String dropdownValue,
    required ValueChanged<String?> onDropdownChanged,
    required List<Map<String, dynamic>> vouchers,
    bool isHistory = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: dropdownValue,
          isExpanded: false,
          underline: Container(),
          items: months.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: onDropdownChanged,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 12),
        ...vouchers.map((voucher) => _buildVoucherCard(
              amount: voucher["amount"],
              expiryDate: voucher["expiryDate"],
              status: voucher["status"],
              isHistory: isHistory,
            )),
      ],
    );
  }

  Widget _buildVoucherCard({
    required String amount,
    required String expiryDate,
    String? status,
    bool isHistory = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeftLabel(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EcoscanVoucher",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Berlaku sampai $expiryDate",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          _buildActionButtons(amount, isHistory, status),
        ],
      ),
    );
  }

  Widget _buildLeftLabel() {
    return Container(
      width: 60,
      alignment: Alignment.center,
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          "Ecoscan\nVoucher",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(String amount, bool isHistory, String? status) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        if (isHistory)
          Text(
            status ?? "",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        else
          Column(
            children: [
              _buildButton("Detail voucher", onPressed: () {}),
              SizedBox(height: 4),
              _buildButton("Gunakan voucher", onPressed: () {}),
            ],
          ),
      ],
    );
  }

  Widget _buildButton(String text, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1B5E20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size(100, 36),
      ),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VouchersScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
