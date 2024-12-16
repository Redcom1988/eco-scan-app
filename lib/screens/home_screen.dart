import 'package:flutter/material.dart';
import 'package:ecoscan/backend-client/fetch_balance.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double? _balance;

  @override
  void initState() {
    super.initState();
    _fetchBalance('username'); // Replace 'username' with actual username
  }

  Future<void> _fetchBalance(String username) async {
    double? balance = await fetchBalance(
        username); // Assuming fetchBalance returns the balance
    setState(() {
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_balance != null)
              Text(
                'Balance: \$${_balance!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
