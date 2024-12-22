import 'package:ecoscan/backend-client/education_handler.dart';
import 'package:ecoscan/provider/news_provider.dart';
import 'package:ecoscan/screens/content_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final Function() onPressed;
  final double iconSize;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onPressed,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 50, // Adjust this value based on your needs
        maxWidth: 65, // Adjust this value based on your needs
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPressed,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: iconSize,
            ),
          ),
          const SizedBox(width: 1.0),
          Text(
            '$likeCount',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
              const SizedBox(height: 4.0),
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
                      InkWell(
                        onTap: () => onLike(content['contentId']),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: Icon(
                            content['isLiked'] ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: content['isLiked'] ?? false
                                ? Colors.red
                                : Colors.grey,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1.0),
                      Text(
                        '${content['contentLikes'] ?? 0}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      TextButton(
                        onPressed: () => onReadMore(content['contentId']),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final content = await fetchEducationContent();
      if (!mounted) return;

      if (content != null) {
        // Update content through provider
        Provider.of<NewsProvider>(context, listen: false).setContent(content);
        setState(() {
          _error = null;
          lastRefresh = DateTime.now();
        });
      } else {
        setState(() => _error = 'Failed to load content');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Error: ${e.toString()}');
      print('Error loading content: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> handleLike(int contentId) async {
    try {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);

      // Let the NewsProvider handle both the UI update and API call
      await newsProvider.toggleLike(contentId);
    } catch (e) {
      print('Error handling like: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating like: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
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

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailScreen(contentId: contentId),
          ),
        );
      }
    } catch (e) {
      print('Error handling read more: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading content: $e')),
        );
      }
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
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
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
              itemCount: newsProvider.content.length,
              itemBuilder: (context, index) => buildNewsCard(
                context,
                newsProvider.content[index],
                now,
                handleLike,
                handleReadMore,
              ),
            ),
          );
        },
      ),
    );
  }
}
