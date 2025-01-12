import 'package:ecoscan/backend-client/claim_withdrawal_handler.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';
import 'package:ecoscan/backend-client/voucher_claim_handler.dart';
import 'package:ecoscan/models/redeem_record.dart';
import 'package:flutter/material.dart';

class RedeemHistoryScreen extends StatefulWidget {
  @override
  RedeemHistoryScreenState createState() => RedeemHistoryScreenState();
}

class RedeemHistoryScreenState extends State<RedeemHistoryScreen> {
  List<RedeemRecord> records = [];
  bool isLoading = true;
  int userId = 0;
  dynamic user;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserId();
    if (userId != 0) {
      await fetchRedeemRecords();
    }
  }

  Future<void> _loadUserId() async {
    try {
      final localUser = await getLocalUser();
      setState(() {
        user = localUser;
      });
      final id = await getId(user!.username);
      // print('${id}ASA');
      setState(() {
        userId = id;
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> fetchRedeemRecords() async {
    try {
      final fetchedRecords = await getRedeemRecords(userId: userId);
      setState(() {
        records = fetchedRecords;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching records: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voucher Redemption History',
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
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return _buildVoucherCard(record);
                },
              ),
            ),
    );
  }

  Widget _buildVoucherCard(RedeemRecord record) {
    String formattedDate = _formatDate(record.redeemDate);
    String formattedPrice = record.voucherPrice.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
                  formattedPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Code: ${record.voucherCode}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Successfully redeemed on $formattedDate",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildLeftLabel() {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        // Icons.card_giftcard,  // Gift card icon
        Icons.local_offer, // Tag/offer icon
        // Icons.loyalty,  // Loyalty/voucher icon
        size: 32,
        color: Color(0xFF1B5E20),
      ),
    );
  }
  // Widget _buildActionButton() {
  //   return ElevatedButton(
  //     onPressed: () {},
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: const Color(0xFF1B5E20),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       minimumSize: const Size(100, 36),
  //     ),
  //     child: const Text(
  //       "Voucher Details",
  //       style: TextStyle(
  //         fontSize: 12,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
