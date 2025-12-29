enum NotificationType {
  order,
  promotion,
  system,
  follow,
  like,
  comment,
  unknown
}

//! NotificationModel
class NotificationModel {
  final int id;
  final String title;
  final String text;
  final String? data;
  final NotificationType type;
  final DateTime? readAt;
  final DateTime createdAt;
  final String? link;

  NotificationModel({
    required this.id,
    required this.title,
    required this.text,
    this.data,
    required this.type,
    this.readAt,
    required this.createdAt,
    this.link,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      data: json['data'] as String?,
      type: _parseNotificationType(json['type'] as String?),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      link: json['link'] as String?,
    );
  }

  static NotificationType _parseNotificationType(String? type) {
    switch (type) {
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      case 'follow':
        return NotificationType.follow;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      default:
        return NotificationType.unknown;
    }
  }

  bool get isRead => readAt != null;

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'just_now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else {
      final months = difference.inDays ~/ 30;
      return '${months}mo';
    }
  }
}
