import 'package:flutter/material.dart';

class VouchersScreen extends StatefulWidget {
  @override
  _VouchersScreenState createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  String selectedActiveMonth = "Januari 2024";
  String selectedHistoryMonth = "Oktober 2023";

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

  final List<String> months = [
    "",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ecoscan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Voucher aktif saya"),
              _buildDropdown(
                selectedActiveMonth,
                (value) {
                  setState(() {
                    selectedActiveMonth = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              ...activeVouchers.map((voucher) => _buildVoucherCard(
                    voucher["amount"],
                    voucher["expiryDate"],
                    isHistory: false,
                  )),
              const SizedBox(height: 24),

              _buildSectionTitle("Riwayat voucher saya"),
              _buildDropdown(
                selectedHistoryMonth,
                (value) {
                  setState(() {
                    selectedHistoryMonth = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              ...voucherHistory.map((voucher) => _buildVoucherCard(
                    voucher["amount"],
                    voucher["expiryDate"],
                    status: voucher["status"],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: value,
      isExpanded: false,
      underline: Container(),
      items: months.map((month) {
        return DropdownMenuItem(
          value: month,
          child: Text(month),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
    );
  }

  Widget _buildVoucherCard(String amount, String expiryDate,
      {bool isHistory = true, String? status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeftLabel(),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EcoscanVoucher",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Berlaku sampai $expiryDate",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
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
          style: const TextStyle(
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        isHistory
            ? Text(
                status ?? "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Detail voucher");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(100, 36),
                    ),
                    child: const Text(
                      "Detail voucher",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      print("Gunakan voucher");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(100, 36),
                    ),
                    child: const Text(
                      "Gunakan voucher",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      home: VouchersScreen(),
      debugShowCheckedModeBanner: false,
    ));
