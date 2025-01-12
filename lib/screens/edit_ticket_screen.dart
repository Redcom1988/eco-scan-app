// lib/screens/edit_ticket_screen.dart
import 'package:ecoscan/backend-client/support_ticket_handler.dart';
import 'package:flutter/material.dart';
import '../models/support_ticket.dart';

class EditTicketScreen extends StatefulWidget {
  final SupportTicket ticket;
  final String username;

  const EditTicketScreen({
    Key? key,
    required this.ticket,
    required this.username,
  }) : super(key: key);

  @override
  _EditTicketScreenState createState() => _EditTicketScreenState();
}

class _EditTicketScreenState extends State<EditTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final SupportTicketService _ticketService = SupportTicketService();
  bool _isSubmitting = false;
  String _selectedStatus = 'open';

  final List<String> _statusOptions = [
    'open',
    'in_progress',
    'resolved',
    'closed',
  ];

  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.ticket.subject;
    _descriptionController.text = widget.ticket.description;
    _selectedStatus = widget.ticket.status;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final updatedTicket = widget.ticket.copyWith(
        subject: _subjectController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
      );

      final success = await _ticketService.updateSupportTicket(updatedTicket);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket updated successfully')),
        );
        Navigator.pop(context, updatedTicket);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating ticket: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ticket #${widget.ticket.ticketId}'),
        actions: [
          if (_isSubmitting)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a subject' : null,
              enabled: !_isSubmitting,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                filled: true,
              ),
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
              enabled: !_isSubmitting,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                filled: true,
              ),
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(status),
                        ),
                      ),
                      Text(status.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _isSubmitting
                  ? null
                  : (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedStatus = newValue);
                      }
                    },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _updateTicket,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Update Ticket',
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (widget.ticket.status != 'closed')
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() => _selectedStatus = 'closed');
                          _updateTicket();
                        },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.red,
                  ),
                  child: Text(
                    'Close Ticket',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
