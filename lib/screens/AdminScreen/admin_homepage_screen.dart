import 'package:ecoscan/app_state.dart';
import 'package:ecoscan/screens/AdminScreen/KelolaEdukasiPage.dart';
import 'package:ecoscan/screens/AdminScreen/ProfileAdminPage.dart';
import 'package:ecoscan/screens/AdminScreen/PusatBantuanPage.dart';
import 'package:ecoscan/screens/AdminScreen/VoucherPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen();

  List<Widget> _screens(BuildContext context) => [
        KelolaEdukasiPage(),
        PusatBantuanPage(),
        VoucherPage(),
        ProfileAdminPage()
      ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: _screens(context)[appState.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          appState.setIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help Center',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.loyalty),
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
