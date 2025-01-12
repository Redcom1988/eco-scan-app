// lib/screens/support_ticket_list_screen.dart
import 'package:ecoscan/backend-client/support_ticket_handler.dart';
import 'package:ecoscan/screens/create_ticket_screen.dart';
import 'package:ecoscan/screens/ticket_detail_screen.dart';
import 'package:ecoscan/widgets/ticket_list_item.dart';
import 'package:flutter/material.dart';
import '../models/support_ticket.dart';

class SupportTicketListScreen extends StatefulWidget {
  final int userId;
  final String username;
  final String userRole;

  const SupportTicketListScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.userRole,
  }) : super(key: key);
  _SupportTicketListScreenState createState() =>
      _SupportTicketListScreenState();
}

class _SupportTicketListScreenState extends State<SupportTicketListScreen> {
  final SupportTicketService _ticketService = SupportTicketService();
  List<SupportTicket>? _tickets;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('SupportTicketListScreen initialized with userId: ${widget.userId}');
    _validateAndLoadTickets();
  }

  Future<void> _validateAndLoadTickets() async {
    if (widget.userId <= 0) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid user ID. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      // Optionally navigate back to login/profile screen
      Navigator.pop(context);
      return;
    }
    await _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _isLoading = true);
    try {
      final tickets = await _ticketService.fetchSupportTickets();
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tickets: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusat Bantuan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _tickets == null || _tickets!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.support_agent,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada tiket bantuan',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tickets!.length,
                        itemBuilder: (context, index) {
                          final ticket = _tickets![index];
                          return TicketListItem(
                            ticket: ticket,
                            onTap: () => _navigateToTicketDetail(ticket),
                          );
                        },
                      ),
          ),
        ],
      ),
      // Only show FloatingActionButton for non-admin users
      floatingActionButton: widget.userRole.toLowerCase() != 'admin'
          ? FloatingActionButton(
              onPressed: () => _createNewTicket(),
              backgroundColor: Colors.green.shade900,
              child: Icon(Icons.add),
              tooltip: 'Buat Tiket Baru',
            )
          : null, // Don't show FAB for admin users
    );
  }

  void _createNewTicket() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTicketScreen(
          userId: widget.userId,
          username: widget.username,
        ),
      ),
    ).then((created) {
      if (created == true) {
        _loadTickets();
      }
    });
  }

  void _navigateToTicketDetail(SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(
          ticket: ticket,
          username: widget.username,
          userRole: widget.userRole,
        ),
      ),
    ).then((_) => _loadTickets());
  }
}
