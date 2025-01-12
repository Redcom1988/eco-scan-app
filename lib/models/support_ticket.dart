// support_ticket.dart
class SupportTicket {
  final int? ticketId; // null when creating new ticket
  final int userId;
  final String subject;
  final String description;
  final String status;
  List<Comment>? comments; // Optional list of associated comments

  SupportTicket({
    this.ticketId,
    required this.userId,
    required this.subject,
    required this.description,
    required this.status,
    this.comments,
  });

  // Convert SupportTicket instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId, // Changed from ticket_id
      'userId': userId, // Changed from user_id
      'subject': subject,
      'description': description,
      'status': status,
    };
  }

  // Create SupportTicket instance from a Map
  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    try {
      // Helper function to safely convert to int
      int? safeInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
        return null;
      }

      return SupportTicket(
        ticketId: safeInt(map['ticketId']) ?? safeInt(map['ticket_id']),
        userId: safeInt(map['userId']) ?? safeInt(map['user_id']) ?? 0,
        subject: (map['subject'] ?? '').toString(),
        description: (map['description'] ?? '').toString(),
        status: (map['status'] ?? 'unknown').toString(),
        comments: map['comments'] != null
            ? List<Comment>.from(
                (map['comments'] as List).map((x) => Comment.fromMap(x)))
            : null,
      );
    } catch (e) {
      print('Error creating SupportTicket from map: $e');
      print('Problematic map: $map');
      rethrow;
    }
  }

  // Create a copy of SupportTicket with modified fields
  SupportTicket copyWith({
    int? ticketId,
    int? userId,
    String? subject,
    String? description,
    String? status,
    List<Comment>? comments,
  }) {
    return SupportTicket(
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      comments: comments ?? this.comments,
    );
  }
}

// comment.dart
class Comment {
  final int? commentId;
  final int ticketId;
  final int? parentCommentId;
  final int? userId;
  final String text;
  final DateTime createdAt;

  Comment({
    this.commentId,
    required this.ticketId,
    this.parentCommentId,
    this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    try {
      // Helper function to safely convert to int
      int? safeInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
        return null;
      }

      // Helper function to safely parse DateTime
      DateTime safeDateTime(dynamic value) {
        if (value == null) return DateTime.now();
        if (value is String) {
          try {
            return DateTime.parse(value);
          } catch (_) {
            return DateTime.now();
          }
        }
        return DateTime.now();
      }

      return Comment(
        commentId: safeInt(map['commentId']) ?? safeInt(map['comment_id']),
        ticketId: safeInt(map['ticketId']) ?? safeInt(map['ticket_id']) ?? 0,
        parentCommentId: safeInt(map['parentCommentId']) ??
            safeInt(map['parent_comment_id']),
        userId: safeInt(map['userId']) ?? safeInt(map['user_id']),
        text: (map['text'] ?? '').toString(),
        createdAt: safeDateTime(map['createdAt'] ?? map['created_at']),
      );
    } catch (e) {
      print('Error creating Comment from map: $e');
      print('Problematic map: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'ticketId': ticketId,
      'parentCommentId': parentCommentId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy of Comment with modified fields
  Comment copyWith({
    int? commentId,
    int? ticketId,
    int? parentCommentId,
    int? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      ticketId: ticketId ?? this.ticketId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
