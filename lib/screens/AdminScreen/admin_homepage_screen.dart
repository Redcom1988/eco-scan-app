import 'package:ecoscan/app_state.dart';
import 'package:ecoscan/models/user.dart';
import 'package:ecoscan/screens/AdminScreen/education_manager.dart';
import 'package:ecoscan/screens/AdminScreen/admin_profile.dart';
import 'package:ecoscan/screens/AdminScreen/voucher_manager.dart';
import 'package:ecoscan/screens/support_ticket_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';

class AdminHomePageScreen extends StatefulWidget {
  AdminHomePageScreen();

  @override
  State<AdminHomePageScreen> createState() => _AdminHomePageScreenState();
}

class _AdminHomePageScreenState extends State<AdminHomePageScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await getLocalUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  List<Widget> _screens(BuildContext context) {
    if (currentUser == null) {
      return [
        Center(child: CircularProgressIndicator()),
        Center(child: CircularProgressIndicator()),
        Center(child: CircularProgressIndicator()),
        Center(child: CircularProgressIndicator()),
      ];
    }

    return [
      KelolaEdukasiPage(),
      SupportTicketListScreen(
        userId: currentUser!.userId,
        username: currentUser!.username,
        userRole: 'admin',
      ),
      VoucherPage(),
      ProfileAdminPage(),
    ];
  }

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
            icon: Icon(Icons.support_agent),
            label: 'Support Tickets',
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
