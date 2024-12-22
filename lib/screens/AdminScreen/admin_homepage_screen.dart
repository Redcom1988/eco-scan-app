import 'package:ecoscan/app_state.dart';
import 'package:ecoscan/screens/AdminScreen/education_manager.dart';
import 'package:ecoscan/screens/AdminScreen/admin_profile.dart';
import 'package:ecoscan/screens/AdminScreen/help_center.dart';
import 'package:ecoscan/screens/AdminScreen/voucher_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePageScreen extends StatelessWidget {
  AdminHomePageScreen();

  List<Widget> _screens(BuildContext context) => [
        KelolaEdukasiPage(),
        PusatBantuanPage(),
        VoucherPage(),
        ProfileAdminPage()
      ];

  @override
  Widget build(BuildContext context) {
    var adminAppState = context.watch<MyAdminAppState>();

    return Scaffold(
      body: _screens(context)[adminAppState.selectedIndexAdmin],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: adminAppState.selectedIndexAdmin,
        onTap: (index) {
          adminAppState.setIndexAdmin(index);
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
