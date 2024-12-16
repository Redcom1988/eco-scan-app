import 'package:ecoscan/backend-client/education_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Format timestamp to relative time
String formatTimestamp(String timestamp, DateTime referenceTime) {
  try {
    final date = DateTime.parse(timestamp);
    final difference = referenceTime.difference(date);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  } catch (e) {
    print('Error formatting timestamp: $e');
    return 'Invalid date';
  }
}

// Format view count with K/M suffix
String formatViewCount(int views) {
  if (views >= 1000000) {
    return '${(views / 1000000).toStringAsFixed(1)}M views';
  } else if (views >= 1000) {
    return '${(views / 1000).toStringAsFixed(1)}K views';
  } else {
    return '$views views';
  }
}

// Build card widget for news item
Widget buildNewsCard(BuildContext context, Map<String, dynamic> content,
    DateTime referenceTime, Function(int) onLike, Function(int) onReadMore) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16.0),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            content['contentImage'] ?? '',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 80,
                width: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        const SizedBox(width: 12.0),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content['contentTitle'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                content['contentDescription'] ?? '',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              // Stats and actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            formatViewCount(content['contentViews'] ?? 0),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(
                            formatTimestamp(
                                content['timestamp'] ?? '', referenceTime),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onLike(content['contentId']),
                        icon: Icon(
                          content['isLiked'] ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: content['isLiked'] ?? false
                              ? Colors.red
                              : Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      TextButton(
                        onPressed: () => onReadMore(content['contentId']),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text(
                          'Baca selengkapnya',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Main news screen widget
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

// News screen state
class NewsScreenState extends State<NewsScreen> {
  List<Map<String, dynamic>> _content = [];
  bool _isLoading = true;
  String? _error;
  DateTime lastRefresh = DateTime.now();

  // Load content from backend
  Future<void> loadContent() async {
    setState(() => _isLoading = true);
    try {
      final content = await fetchEducationContent();
      setState(() {
        if (content != null) {
          _content = content;
          _error = null;
          lastRefresh = DateTime.now();
        } else {
          _error = 'Failed to load content';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
      });
      print('Error loading content: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Handle like action
  Future<void> handleLike(int contentId) async {
    try {
      final success = await toggleContentLike(contentId);
      if (success) {
        await loadContent();
      }
    } catch (e) {
      print('Error handling like: $e');
    }
  }

  // Handle read more action
  Future<void> handleReadMore(int contentId) async {
    try {
      final success = await incrementContentViews(contentId);
      if (success) {
        setState(() {
          final contentIndex =
              _content.indexWhere((item) => item['contentId'] == contentId);
          if (contentIndex != -1) {
            _content[contentIndex]['contentViews']++;
          }
        });
      }
    } catch (e) {
      print('Error handling read more: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  // Build news list screen
  Widget _buildNewsScreen() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadContent,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final now = DateTime.now();
    return RefreshIndicator(
      onRefresh: loadContent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _content.length,
        itemBuilder: (context, index) => buildNewsCard(
          context,
          _content[index],
          now,
          handleLike,
          handleReadMore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ecoscan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildNewsScreen(),
    );
  }
}
