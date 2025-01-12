// support_ticket_service.dart
import 'dart:convert';
import 'package:ecoscan/models/support_ticket.dart';
import 'package:http/http.dart' as http;

class SupportTicketService {
  static const String baseUrl = 'https://w4163hhc-3000.asse.devtunnels.ms';
  static const Duration timeoutDuration = Duration(seconds: 10);

  // Fetch all support tickets
  Future<List<SupportTicket>> fetchSupportTickets() async {
    try {
      print(
          'Fetching tickets from: $baseUrl/support-tickets/getAllTickets'); // Debug log

      final response = await http.get(
        Uri.parse('$baseUrl/support-tickets/getAllTickets'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(timeoutDuration);

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Raw response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        // Safely decode the JSON response
        final dynamic decodedData = jsonDecode(response.body);

        // Handle different response structures
        List<dynamic> ticketsData;

        if (decodedData is List) {
          ticketsData = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          // If the response is wrapped in an object
          ticketsData = decodedData['tickets'] ?? decodedData['data'] ?? [];
        } else {
          print('Unexpected response type: ${decodedData.runtimeType}');
          return [];
        }

        print(
            'Number of tickets in response: ${ticketsData.length}'); // Debug log

        // Convert and validate each ticket
        final List<SupportTicket> tickets = [];

        for (var ticketData in ticketsData) {
          try {
            // Print raw ticket data for debugging
            print('Processing ticket data: $ticketData');

            // Handle potential field name mismatches
            final processedTicketData = {
              'ticketId': ticketData['ticketId'] ?? ticketData['ticket_id'],
              'userId': ticketData['userId'] ?? ticketData['user_id'],
              'subject': ticketData['subject'] ?? '',
              'description': ticketData['description'] ?? '',
              'status': ticketData['status'] ?? 'unknown',
              'comments': ticketData['comments'],
            };

            final ticket = SupportTicket.fromMap(processedTicketData);
            tickets.add(ticket);
          } catch (e) {
            print('Error parsing individual ticket: $e');
            print('Problematic ticket data: $ticketData');
            // Continue processing other tickets
            continue;
          }
        }

        print('Successfully parsed ${tickets.length} tickets'); // Debug log
        return tickets;
      } else {
        print('Failed to fetch tickets: ${response.statusCode}');
        print('Error response body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching tickets: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  // Fetch a specific ticket with its comments
  Future<SupportTicket?> fetchTicketDetails(int ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/support-tickets/getTicket/$ticketId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return SupportTicket.fromMap(responseData);
      } else {
        print('Failed to fetch ticket details: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching ticket details: $e');
      return null;
    }
  }

  // Create a new support ticket
  Future<bool> createSupportTicket(SupportTicket ticket) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/support-tickets/createTicket'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(ticket.toMap()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to create ticket: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating ticket: $e');
      return false;
    }
  }

  // Update an existing support ticket
  Future<bool> updateSupportTicket(SupportTicket ticket) async {
    try {
      if (ticket.ticketId == null) {
        throw Exception('Ticket ID cannot be null for update operation');
      }

      final response = await http
          .put(
            Uri.parse(
                '$baseUrl/support-tickets/updateTicket/${ticket.ticketId}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(ticket.toMap()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update ticket: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating ticket: $e');
      return false;
    }
  }

  // Add a comment to a ticket
  Future<bool> addComment(Comment comment) async {
    try {
      print('Adding comment for ticket ${comment.ticketId}'); // Debug log
      print('Comment data: ${comment.toMap()}'); // Debug log

      final response = await http
          .post(
            Uri.parse('$baseUrl/support-tickets/addComment'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'ticketId': comment.ticketId,
              'userId': comment.userId,
              'text': comment.text,
              'parentCommentId': comment.parentCommentId,
            }),
          )
          .timeout(timeoutDuration);

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }

  // Fetch comments for a specific ticket
  Future<List<Comment>> fetchTicketComments(int ticketId) async {
    try {
      final url =
          '$baseUrl/support-tickets/getComments/$ticketId'; // Updated endpoint
      print('Fetching comments from: $url'); // Debug log

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(timeoutDuration);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true &&
            responseData['comments'] != null) {
          final List<dynamic> commentsData = responseData['comments'];
          print('Number of comments received: ${commentsData.length}');

          return commentsData
              .map((comment) {
                try {
                  return Comment.fromMap(comment);
                } catch (e) {
                  print('Error parsing comment: $e');
                  print('Problematic comment data: $comment');
                  return null;
                }
              })
              .where((comment) => comment != null)
              .cast<Comment>()
              .toList();
        }
      }

      print('Failed to fetch comments: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }
}
