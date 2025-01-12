class User {
  final int userId;
  final String email;
  final String username;
  final String fullName;
  final String role;
  final DateTime? createdAt;

  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
    this.createdAt,
  });

  // Improved factory constructor with better error handling
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle userId parsing explicitly
    final dynamic userIdValue = json['userId'];
    int parsedUserId;

    if (userIdValue is int) {
      parsedUserId = userIdValue;
    } else if (userIdValue is String) {
      parsedUserId = int.parse(userIdValue);
    } else {
      throw FormatException('Invalid userId format: $userIdValue');
    }

    return User(
      userId: parsedUserId,
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  // Improved toJson with null handling
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'fullName': fullName,
      'role': role, // Provide default value for null
      'createdAt': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null); // Remove null values
  }

  // Add copyWith method for updating user instances
  User copyWith({
    int? userId,
    String? email,
    String? username,
    String? fullName,
    String? role,
    DateTime? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Add toString for debugging
  @override
  String toString() {
    return 'User(userId: $userId, email: $email, username: $username, fullName: $fullName, role: $role, createdAt: $createdAt)';
  }

  // Add equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.userId == userId &&
        other.email == email &&
        other.username == username &&
        other.fullName == fullName &&
        other.role == role &&
        other.createdAt == createdAt;
  }

  // Add hashCode
  @override
  int get hashCode {
    return Object.hash(
      userId,
      email,
      username,
      fullName,
      role,
      createdAt,
    );
  }
}
