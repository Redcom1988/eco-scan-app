import 'package:flutter/material.dart';
import 'package:ecoscan/backend-client/education_handler.dart';

class ContentDetailScreen extends StatefulWidget {
  final int contentId;

  const ContentDetailScreen({
    super.key,
    required this.contentId,
  });

  @override
  ContentDetailScreenState createState() => ContentDetailScreenState();
}

class ContentDetailScreenState extends State<ContentDetailScreen> {
  Map<String, dynamic>? _contentDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContentDetails();
  }

  Future<void> _loadContentDetails() async {
    try {
      final details = await fetchSingleContent(widget.contentId);
      if (mounted) {
        setState(() {
          _contentDetails = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading content: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _contentDetails?['contentTitle'] ?? 'Article Details',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              onPressed: _loadContentDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_contentDetails == null) {
      return const Center(child: Text('Content not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_contentDetails!['contentImage']?.isNotEmpty ?? false) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                _contentDetails!['contentImage']!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            _contentDetails!['contentTitle'] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _contentDetails!['contentDescription'] ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _contentDetails!['contentFull'] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.remove_red_eye, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${_contentDetails!['contentViews'] ?? 0} views',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${_contentDetails!['contentLikes'] ?? 0} likes',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
