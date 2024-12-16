import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to fetch all education content
Future<List<Map<String, dynamic>>?> fetchEducationContent() async {
  try {
    print('Fetching education content');

    final response = await http.get(
      Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/education'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Fetched ${responseData.length} items');

      return responseData
          .map((item) => {
                'contentId': item['contentId'] ?? 0,
                'contentTitle': item['contentTitle'] ?? '',
                'contentDescription': item['contentDescription'] ?? '',
                'contentFull': item['contentFull'] ?? '',
                'contentImage': item['contentImage'] ?? '',
                'contentViews': item['contentViews'] ?? 0,
                'contentLikes': item['contentLikes'] ?? 0,
                'timestamp':
                    item['timestamp'] ?? DateTime.now().toIso8601String(),
              })
          .toList();
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error in fetchEducationContent: $e');
    return null;
  }
}

// Function to increment views
Future<bool> incrementContentViews(int contentId) async {
  try {
    print('Incrementing views for content: $contentId');

    final response = await http.put(
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/education/$contentId/views'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    return response.statusCode == 200;
  } catch (e) {
    print('Error in incrementContentViews: $e');
    return false;
  }
}

// Function to toggle likes
Future<bool> toggleContentLike(int contentId) async {
  try {
    print('Toggling like for content: $contentId');

    final response = await http.put(
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/education/$contentId/likes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    return response.statusCode == 200;
  } catch (e) {
    print('Error in toggleContentLike: $e');
    return false;
  }
}

// Function to get single content details
Future<Map<String, dynamic>?> fetchSingleContent(int contentId) async {
  try {
    print('Fetching content details for ID: $contentId');

    final response = await http.get(
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/education/$contentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'contentId': responseData['contentId'] ?? 0,
        'contentTitle': responseData['contentTitle'] ?? '',
        'contentDescription': responseData['contentDescription'] ?? '',
        'contentFull': responseData['contentFull'] ?? '',
        'contentImage': responseData['contentImage'] ?? '',
        'contentViews': responseData['contentViews'] ?? 0,
        'contentLikes': responseData['contentLikes'] ?? 0,
        'timestamp':
            responseData['timestamp'] ?? DateTime.now().toIso8601String(),
      };
    } else {
      print('Failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error in fetchSingleContent: $e');
    return null;
  }
}