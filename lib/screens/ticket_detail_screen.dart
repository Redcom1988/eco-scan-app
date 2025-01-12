// lib/screens/ticket_detail_screen.dart
import 'package:ecoscan/backend-client/support_ticket_handler.dart';
import 'package:ecoscan/models/support_ticket.dart';
import 'package:ecoscan/screens/edit_ticket_screen.dart';
import 'package:ecoscan/widgets/comment_input.dart';
import 'package:ecoscan/widgets/comments_list.dart';
import 'package:ecoscan/widgets/ticket_details_card.dart';
import 'package:flutter/material.dart';

// lib/screens/ticket_detail_screen.dart
class TicketDetailScreen extends StatefulWidget {
  final SupportTicket ticket;
  final String username;
  final String userRole;

  const TicketDetailScreen({
    Key? key,
    required this.ticket,
    required this.username,
    required this.userRole,
  }) : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final SupportTicketService _ticketService = SupportTicketService();
  List<Comment>? _comments;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  List<Widget> _buildActions() {
    print('Role in _buildActions: ${widget.userRole}'); // Debug log
    // Only show edit button if user is admin
    if (widget.userRole.toLowerCase() == 'admin') {
      return [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTicketScreen(
                ticket: widget.ticket,
                username: widget.username,
              ),
            ),
          ),
        ),
      ];
    }
    return []; // Return empty list if user is not admin
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      print(
          'Loading comments for ticket ${widget.ticket.ticketId}'); // Debug log

      if (widget.ticket.ticketId == null) {
        throw Exception('Ticket ID is null');
      }

      final comments =
          await _ticketService.fetchTicketComments(widget.ticket.ticketId!);
      print('Loaded ${comments.length} comments'); // Debug log

      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading comments: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading comments. Please try again.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _loadComments,
          ),
        ),
      );

      setState(() {
        _comments = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      // Show loading indicator
      setState(() => _isLoading = true);

      print(
          'Creating comment for ticket ${widget.ticket.ticketId}'); // Debug log

      final comment = Comment(
        ticketId: widget.ticket.ticketId!,
        userId: widget.ticket.userId, // Make sure this is the correct user ID
        text: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      print('Comment data: ${comment.toMap()}'); // Debug log

      final success = await _ticketService.addComment(comment);

      if (success) {
        print('Comment added successfully'); // Debug log
        _commentController.clear();
        await _loadComments(); // Reload comments after successful addition
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      print('Error in _addComment: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding comment. Please try again.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _addComment,
            textColor: Colors.white,
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${widget.ticket.ticketId}'),
        actions: _buildActions(), // Use the new method here
      ),
      body: Column(
        children: [
          TicketDetailsCard(ticket: widget.ticket),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CommentsList(comments: _comments ?? []),
          ),
          CommentInput(
            controller: _commentController,
            onSubmit: _addComment,
          ),
        ],
      ),
    );
  }
}
