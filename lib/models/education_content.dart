class EducationContent {
  final int contentId;
  final String contentTitle;
  final String contentDescription;
  final String contentFull;
  final String contentImage;
  final int contentViews;
  final int contentLikes;
  final DateTime timestamp;

  EducationContent({
    required this.contentId,
    required this.contentTitle,
    required this.contentDescription,
    required this.contentFull,
    required this.contentImage,
    required this.contentViews,
    required this.contentLikes,
    required this.timestamp,
  });

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      contentId: json['contentId'],
      contentTitle: json['contentTitle'],
      contentDescription: json['contentDescription'],
      contentFull: json['contentFull'],
      contentImage: json['contentImage'],
      contentViews: json['contentViews'],
      contentLikes: json['contentLikes'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
