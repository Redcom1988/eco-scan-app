import 'package:ecoscan/models/support_ticket.dart';
import 'package:ecoscan/widgets/status_chip.dart';
import 'package:flutter/material.dart';

// lib/widgets/ticket_list_item.dart
class TicketListItem extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onTap;

  const TicketListItem({
    Key? key,
    required this.ticket,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          ticket.subject,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                StatusChip(status: ticket.status),
                Spacer(),
                Text(
                  'ID: ${ticket.ticketId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
