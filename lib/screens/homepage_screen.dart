import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import './home_screen.dart';
import './news_screen.dart';
import './voucher_screen.dart';
import './profile_screen.dart';
import './qrscanner_screen.dart';

class HomePageScreen extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    NewsScreen(),\
    QRScannerScreen(),
    VouchersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: _screens[appState.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          appState.setIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Vouchers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
