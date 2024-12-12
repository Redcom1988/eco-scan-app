import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const NewsCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 120, // Fixed height for consistent card size
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side image
              SizedBox(
                width: 120, // Square image
                height: 120,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              // Right side content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsScreen extends StatelessWidget {
  final List<Map<String, String>> newsItems = [
    {
      'title': 'Environmental Update 2024',
      'description':
          'Latest developments in environmental conservation and sustainable practices.',
      'imageUrl': 'https://placeholder.com/environmental1.jpg',
    },
    {
      'title': 'New Recycling Initiative',
      'description':
          'Community recycling program launches with innovative sorting technology.',
      'imageUrl': 'https://placeholder.com/recycling1.jpg',
    },
    // Add more news items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ecoscan'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Add your search logic here
                print('Search query: $value');
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final news = newsItems[index];
                return NewsCard(
                  title: news['title']!,
                  description: news['description']!,
                  imageUrl: news['imageUrl']!,
                  onTap: () {
                    // Handle news item tap
                    print('Tapped on news: ${news['title']}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
