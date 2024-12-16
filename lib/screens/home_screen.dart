import 'package:flutter/material.dart';
import 'package:ecoscan/backend-client/fetch_balance.dart';
import '../models/user.dart'; // Add this import
import 'package:ecoscan/backend-client/get_local_user.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double? _balance;
  bool _isLoading = true;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserAndBalance();
  }

  Future<void> _loadUserAndBalance() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _user = await getLocalUser();
      print('Loaded user: ${_user?.username}'); // Debug print

      if (_user?.username.isNotEmpty == true) {
        print(
            'Attempting to fetch balance for username: ${_user!.username}'); // Debug print
        _balance = await fetchBalance(_user!.username);
        print('Fetched balance: $_balance'); // Debug print
      } else {
        print('Username is empty or null'); // Debug print
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load user data or balance';
        _isLoading = false;
      });
      print('Error in _loadUserAndBalance: $e'); // More detailed error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceSection(),
            SizedBox(height: 10),
            _buildShortcutButtons(),
            SizedBox(height: 20),
            _buildVendingMachineMap(),
            SizedBox(height: 20),
            _buildPopularEducationSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Ecoscan',
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.green[800], size: 40),
              SizedBox(width: 10),
              if (_isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]!),
                  strokeWidth: 2,
                )
              else if (_error != null)
                Text(
                  'Error loading balance',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                )
              else
                Text(
                  '${_balance?.toInt() ?? 0} Poin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
            ],
          ),
          Icon(Icons.notifications, color: Colors.green[800]),
        ],
      ),
    );
  }

  Widget _buildShortcutButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShortcutButton(
              icon: Icons.history, label: 'Riwayat botol', onTap: () {}),
          _buildShortcutButton(
              icon: Icons.shopping_cart, label: 'Tukar poin', onTap: () {}),
          _buildShortcutButton(
              icon: Icons.card_giftcard,
              label: 'Riwayat voucher',
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildShortcutButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green[800], size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildVendingMachineMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Temukan Vending Machine Ecoscan terdekat:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              'Peta lokasi vending machine di sini',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Edukasi Terpopuler',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildEducationCard(
                  'Kerajinan Bunga dari Botol', '11.210 view', () {}),
              _buildEducationCard(
                  'Bunga Indah hanya dari...', '11.210 view', () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(String title, String views, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Gambar')), // Placeholder
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              views,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Scan'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
