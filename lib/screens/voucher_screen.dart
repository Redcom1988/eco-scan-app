import 'package:flutter/material.dart';

class VouchersScreen extends StatelessWidget {
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
        title: const Text(
          'Ecoscan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Voucher Aktif
              const Text(
                "Voucher aktif saya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildVoucherDropdown(context, "Januari 2024"),
              const SizedBox(height: 12),
              ...activeVouchers.map((voucher) => _buildVoucherCard(
                    voucher["amount"],
                    voucher["expiryDate"],
                    isHistory: false,
                  )),
              const SizedBox(height: 24),

              // Bagian Riwayat Voucher
              const Text(
                "Riwayat voucher saya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildVoucherDropdown(context, "Oktober 2023"),
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

  Widget _buildVoucherDropdown(BuildContext context, String initialValue) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(initialValue),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(String amount, String expiryDate,
      {bool isHistory = true, String? status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian kiri dengan desain bergelombang
          Container(
            width: 60,
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                "Ecoscan\nVoucher",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Informasi utama voucher
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EcoscanVoucher",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text("Berlaku di: "),
                    Icon(Icons.store, size: 12, color: Colors.grey),
                    Icon(Icons.local_mall, size: 12, color: Colors.grey),
                    Icon(Icons.fastfood, size: 12, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
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

          // Bagian kanan dengan tombol aksi
          Column(
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
                  : Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print("Detail voucher");
                          },
                          child: const Text("Detail voucher"),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {
                            print("Gunakan voucher");
                          },
                          child: const Text("Gunakan voucher"),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
