import 'package:ecoscan/backend-client/education_handler.dart';
import 'package:ecoscan/screens/content_detail_screen.dart';
import 'package:ecoscan/screens/voucher_claim_screen.dart';
import 'package:ecoscan/screens/voucher_redeem_history.dart';
import 'package:ecoscan/screens/withdrawal_history.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/backend-client/fetch_balance.dart';
import 'package:ecoscan/models/user.dart';
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
  List<Map<String, dynamic>>? _popularEducation;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadUserAndBalance();
    _loadPopularEducation();
  }

  Future<void> _loadPopularEducation() async {
    if (!mounted) return;

    try {
      final educationContent = await fetchPopularEducationContent();
      if (mounted) {
        setState(() {
          _popularEducation = educationContent;
        });
      }
    } catch (e) {
      print('Error loading popular education: $e');
      if (mounted) {
        setState(() {
          _popularEducation = null;
        });
      }
    }
  }

  Future<void> _loadUserAndBalance() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _user = await getLocalUser();
      print('Loaded user: ${_user?.username}');

      if (_user?.username.isNotEmpty == true) {
        print('Attempting to fetch balance for username: ${_user!.username}');
        _balance = await fetchBalance(_user!.username);
        print('Fetched balance: $_balance');

        await _loadPopularEducation();
      } else {
        print('Username is empty or null');
        throw Exception('Invalid username');
      }
    } catch (e) {
      print('Error in _loadUserAndBalance: $e');
      setState(() {
        _error = 'Failed to load user data or balance';
      });
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
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadUserAndBalance,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.green[800],
      elevation: 1,
      title: Text(
        'Ecoscan',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
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
              icon: Icons.history,
              label: 'Riwayat botol',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawalHistoryScreen(),
                  ),
                );
              }),
          _buildShortcutButton(
            icon: Icons.shopping_cart,
            label: 'Tukar poin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherClaimScreen(),
                ),
              );
            },
          ),
          _buildShortcutButton(
            icon: Icons.card_giftcard,
            label: 'Riwayat voucher',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RedeemHistoryScreen(),
                ),
              );
            },
          ),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: AssetImage('assets/images/map_placeholder.png'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        )
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
        if (_popularEducation == null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_popularEducation!.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Tidak ada konten edukasi'),
            ),
          )
        else
          SizedBox(
            height: 240, // Set a fixed height for the scrolling area
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align items to the top
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _popularEducation!.map((content) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: _buildEducationCard(
                        title: content['contentTitle'] as String,
                        views: '${content['contentViews']} view',
                        imageUrl: content['contentImage'] as String,
                        contentId: content['contentId'] as int,
                        contentLikes: content['contentLikes'] as int,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEducationCard({
    required String title,
    required String views,
    required String imageUrl,
    required int contentId,
    required int contentLikes,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailScreen(contentId: contentId),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(left: 16, right: 8, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? Center(child: Icon(Icons.image, color: Colors.green[800]))
                  : null,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  views,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Padding(padding: EdgeInsets.only(right: 8)),
                Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
                const Padding(padding: EdgeInsets.only(right: 4)),
                Text(
                  '$contentLikes likes',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
