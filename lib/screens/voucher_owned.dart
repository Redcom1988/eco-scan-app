import 'package:ecoscan/backend-client/claim_withdrawal_handler.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';
import 'package:ecoscan/backend-client/voucher_claim_handler.dart';
import 'package:ecoscan/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/models/owned_voucher.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  State<VoucherScreen> createState() => VoucherScreenState();
}

class VoucherScreenState extends State<VoucherScreen> {
  User? user;
  bool _isLoading = false;
  List<OwnedVoucher> _vouchers = [];
  String? _error;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _loadUserId();
      if (userId != 0) {
        print("${userId}ASA");
        await _loadVouchers();
      } else {
        print('Warning: Invalid userId: $userId');
      }
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> _loadUserId() async {
    try {
      final localUser = await getLocalUser();
      setState(() {
        user = localUser;
      });
      final id = await getId(user!.username);
      print("${id}ASA");
      setState(() {
        userId = id;
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> _loadVouchers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final vouchers = await getOwnedVouchers(userId: userId.toString());
      print(vouchers);
      setState(() {
        _vouchers = vouchers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load vouchers: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No expiry date';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  bool _isExpired(String? dateString) {
    if (dateString == null) return false;
    try {
      final expiryDate = DateTime.parse(dateString);
      return expiryDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Vouchers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadVouchers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVouchers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_vouchers.isEmpty) {
      return const Center(
        child: Text('No vouchers available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVouchers,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _vouchers.length,
        itemBuilder: (context, index) {
          final voucher = _vouchers[index];
          final isExpired = _isExpired(voucher.expiryDate.toString());

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code: ${voucher.voucherCode ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Value: ${voucher.voucherValue?.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expires: ${voucher.expiryDate}',
                              style: TextStyle(
                                color: isExpired ? Colors.red : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Status: ${!voucher.used ? 'Available' : 'Used'}',
                              style: TextStyle(
                                color:
                                    !voucher.used ? Colors.green : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
