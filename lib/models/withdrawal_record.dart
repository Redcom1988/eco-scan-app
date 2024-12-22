import 'dart:convert';

class WithdrawalRecord {
  final double totalValue;
  final DateTime timestamp;
  final List<Map<String, dynamic>> contents;

  WithdrawalRecord({
    required this.totalValue,
    required this.timestamp,
    required this.contents,
  });

  factory WithdrawalRecord.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> contentsMap = {};
    if (json['contents'] != null) {
      try {
        contentsMap = jsonDecode(json['contents']) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing contents: $e');
      }
    }

    List<Map<String, dynamic>> items = [];
    if (contentsMap.containsKey('items')) {
      items = List<Map<String, dynamic>>.from(contentsMap['items']);
    }

    return WithdrawalRecord(
      totalValue: json['totalValue']?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      contents: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalValue': totalValue,
      'timestamp': timestamp.toIso8601String(),
      'contents': jsonEncode({
        'items': contents,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    };
  }
}
