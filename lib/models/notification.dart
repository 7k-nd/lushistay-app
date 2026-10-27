import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';

enum NotificationType { booking, promotion, info, security, whatsapp, view }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String? ownerId;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.ownerId,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.booking:
        return CupertinoIcons.calendar;
      case NotificationType.promotion:
        return CupertinoIcons.tag;
      case NotificationType.info:
        return CupertinoIcons.info;
      case NotificationType.security:
        return CupertinoIcons.shield;
      case NotificationType.whatsapp:
        return CupertinoIcons.chat_bubble_fill;
      case NotificationType.view:
        return CupertinoIcons.eye_fill;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFFDAA520);
      case NotificationType.promotion:
        return ElxauTheme.systemOrange;
      case NotificationType.info:
        return ElxauTheme.systemBlue;
      case NotificationType.security:
        return ElxauTheme.destructive;
      case NotificationType.whatsapp:
        return const Color(0xFF25D366);
      case NotificationType.view:
        return ElxauTheme.systemBlue;
    }
  }

  String get timeLabel {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'ownerId': ownerId,
        'isRead': isRead,
      };

  factory NotificationModel.fromMap(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: DateTime.tryParse(data['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.info,
      ),
      ownerId: data['ownerId'],
      isRead: data['isRead'] == true,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      type: type,
      ownerId: ownerId,
      isRead: isRead ?? this.isRead,
    );
  }
}
