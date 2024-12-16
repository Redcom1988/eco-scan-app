import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TukarPoinScreen(),
  ));
}

class TukarPoinScreen extends StatelessWidget {
  final int userPoints = 63250; // User's total points
  final int voucherCost = 40000; // Cost of the voucher in points

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tukarkan Poin",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(), // Header displaying user points
          SizedBox(height: 12),
          _buildVoucherCard(context), // Voucher card section
        ],
      ),
    );
  }

  // Widget for displaying user's points header
  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/ecoscan_icon.png', // Replace with the path of Ecoscan icon
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.black),
              children: [
                TextSpan(
                  text: "$userPoints ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                TextSpan(
                  text: "Poin",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the voucher card
  Widget _buildVoucherCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Voucher header section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftVoucherLabel(),
              SizedBox(width: 8),
              Expanded(
                child: _buildVoucherDetails(),
              ),
              _buildRedeemButton(context),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
          _buildVoucherFooter(),
        ],
      ),
    );
  }

  // Left label section for the voucher
  Widget _buildLeftVoucherLabel() {
    return Container(
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          "Ecoscan\nVoucher",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Voucher details section
  Widget _buildVoucherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EcoscanVoucher",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Image.asset('assets/store_icons.png', height: 20), // Store logos
            SizedBox(width: 4),
            Text(
              "Rp 40.000,00",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Redeem button for exchanging points
  Widget _buildRedeemButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1B5E20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        _showConfirmationDialog(context);
      },
      child: Text(
        "Tukar $voucherCost poin",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Footer section for voucher (validity date)
  Widget _buildVoucherFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Berlaku sampai 17 Januari 2025",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Icon(Icons.qr_code, size: 24, color: Colors.grey[700]),
      ],
    );
  }

  // Confirmation dialog when redeeming points
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Confirm Redemption"),
          content: Text(
              "Are you sure you want to redeem $voucherCost points for this shopping voucher?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Points successfully redeemed!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1B5E20)),
              child: Text("Redeem"),
            ),
          ],
        );
      },
    );
  }
}
