import 'package:ecoscan/backend-client/education_handler.dart';
import 'package:flutter/foundation.dart';

class NewsProvider extends ChangeNotifier {
  final Set<int> _likedContentIds = {};
  List<Map<String, dynamic>> _content = [];

  // Add this field to track ongoing operations
  final Set<int> _pendingLikeOperations = {};

  Set<int> get likedContentIds => _likedContentIds;
  List<Map<String, dynamic>> get content => _content;

  // Add this method to set content
  void setContent(List<Map<String, dynamic>> newContent) {
    _content = newContent.map((item) {
      // Preserve the like status when updating content
      final contentId = item['contentId'];
      return {
        ...item,
        'isLiked': _likedContentIds.contains(contentId),
      };
    }).toList();
    notifyListeners();
  }

  void _updateContentLikeStatus(int contentId, bool isLiked) {
    _content = _content.map((content) {
      if (content['contentId'] == contentId) {
        return {
          ...content,
          'contentLikes': content['contentLikes'] + (isLiked ? 1 : -1),
          'isLiked': isLiked,
        };
      }
      return content;
    }).toList();
  }

  Future<void> toggleLike(int contentId) async {
    if (_pendingLikeOperations.contains(contentId)) return;

    _pendingLikeOperations.add(contentId);

    // Check if the content is already liked
    final isCurrentlyLiked = _likedContentIds.contains(contentId);
    final isLiking = !isCurrentlyLiked;

    try {
      final success = await toggleContentLike(contentId, isLiking);

      if (success) {
        if (isLiking) {
          _likedContentIds.add(contentId);
        } else {
          _likedContentIds.remove(contentId);
        }
        _updateContentLikeStatus(contentId, isLiking);
        notifyListeners();
      } else {
        print('Failed to update like status on server');
      }
    } catch (e) {
      print('Error toggling like: $e');
    } finally {
      _pendingLikeOperations.remove(contentId);
    }
  }
}
