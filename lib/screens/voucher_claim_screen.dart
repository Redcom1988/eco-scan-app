import 'package:ecoscan/backend-client/claim_withdrawal_handler.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';
import 'package:ecoscan/backend-client/voucher_claim_handler.dart';
import 'package:ecoscan/models/user.dart';
import 'package:flutter/material.dart';

class VoucherClaimScreen extends StatefulWidget {
  const VoucherClaimScreen({Key? key}) : super(key: key);

  @override
  State<VoucherClaimScreen> createState() => VoucherClaimScreenState();
}

class VoucherClaimScreenState extends State<VoucherClaimScreen> {
  User? user;
  bool _isLoading = false;
  List<Map<String, dynamic>> _vouchers = [];
  String? _error;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadVouchers();
  }

  Future<void> _loadUserId() async {
    try {
      final localUser = await getLocalUser();
      setState(() {
        user = localUser;
      });
      final id = await getId(user!.username);
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
      final vouchers = await getVouchers();
      setState(() {
        _vouchers = vouchers;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load vouchers: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _claimVoucher(String voucherId) async {
    try {
      setState(() => _isLoading = true);

      final result = await claimVoucher(
        userId: userId.toString(),
        voucherId: voucherId,
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voucher claimed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadVouchers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to claim voucher'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
          final isActive = voucher['isActive'] ?? false;
          final isExpired = _isExpired(voucher['expiryDate']);

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
                              'Code: ${voucher['voucherCode']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Value: ${voucher['voucherValue']?.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expires: ${_formatDate(voucher['expiryDate'])}',
                              style: TextStyle(
                                color: isExpired ? Colors.red : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (isActive != 0 && !isExpired && !_isLoading)
                            ? () =>
                                _claimVoucher(voucher['voucherId'].toString())
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Claim',
                          style: TextStyle(fontSize: 16),
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
