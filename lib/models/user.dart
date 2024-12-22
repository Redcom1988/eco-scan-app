class User {
  final String email;
  final String username;
  final String fullName;
  final String? role;
  final DateTime? createdAt; // Optional: add more user properties

  User({
    required this.email,
    required this.username,
    required this.fullName,
    this.role,
    this.createdAt,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  // Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
