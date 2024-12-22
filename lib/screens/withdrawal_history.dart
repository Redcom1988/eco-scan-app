import 'package:ecoscan/backend-client/get_local_user.dart';
import 'package:ecoscan/models/item_cache.dart';
import 'package:ecoscan/models/user.dart';
import 'package:ecoscan/models/withdrawal_record.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/backend-client/claim_withdrawal_handler.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  @override
  WithdrawalHistoryScreenState createState() => WithdrawalHistoryScreenState();
}

class WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  List<WithdrawalRecord> _withdrawals = [];
  bool _isLoading = true;
  String? _error;
  User? user;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Simple date formatter
  String formatDateTime(DateTime dateTime) {
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

    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _loadUserId() async {
    try {
      final localUser = await getLocalUser();
      setState(() {
        user = localUser;
      });
      final id = await getId(user!.username);
      // print('${id}FKK');
      setState(() {
        userId = id;
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> _loadWithdrawals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await getWithdrawals(userId);
      print('${response}FKK');
      if (!mounted) return;
      setState(() {
        _withdrawals = response;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ItemCache.initialize();
      await _loadUserId();
      if (mounted) {
        await _loadWithdrawals();
      }
    } catch (e) {
      print('Error during initialization: $e');
      setState(() {
        _error = 'Failed to initialize data';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ItemCache.initialize();
      await _loadWithdrawals();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to refresh data: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Withdrawal History',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildBody(),
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
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWithdrawals,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_withdrawals.isEmpty) {
      return const Center(
        child: Text('No withdrawal history found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _withdrawals.length,
        itemBuilder: (context, index) {
          final withdrawal = _withdrawals[index];
          return _buildWithdrawalCard(withdrawal);
        },
      ),
    );
  }

  Widget _buildWithdrawalCard(WithdrawalRecord withdrawal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${withdrawal.totalValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                formatDateTime(withdrawal.timestamp),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deposited Items:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...withdrawal.contents.map((item) {
                    final itemName = ItemCache.getItemName(item['id'] ?? '');
                    final quantity = int.tryParse(item['qty'] ?? '0') ?? 0;
                    final unitValue = ItemCache.getItemValue(item['id'] ?? '');
                    final totalItemValue = unitValue * quantity;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  itemName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                'Qty: $quantity',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Unit Value: ${unitValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Total: ${totalItemValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
