import 'package:flutter/cupertino.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/data/mock_data.dart';
import 'package:elxau/models/notification.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> _notifications = List.from(MockData.notifications);

  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      navigationBar: AppNavBar(
        middle: const Text('Notifications'),
        trailing: _notifications.any((n) => !n.isRead)
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: _markAllAsRead,
                child: Text(
                  'Tout lire',
                  style: GoogleFonts.outfit(
                    color: ElxauTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              )
            : null,
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: ElxauTheme.white,
              shape: BoxShape.circle,
              boxShadow: ElxauTheme.softShadow,
            ),
            child: Icon(
              CupertinoIcons.bell,
              size: 64,
              color: ElxauTheme.accent.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune notification',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ElxauTheme.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous recevrez ici des mises à jour sur vos réservations.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: ElxauTheme.secondaryText,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, int index) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(index),
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ElxauTheme.destructive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(CupertinoIcons.delete, color: ElxauTheme.destructive),
      ),
      child: GestureDetector(
        onTap: () => _markAsRead(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: notification.isRead ? ElxauTheme.white.withValues(alpha: 0.6) : ElxauTheme.white,
            borderRadius: BorderRadius.circular(24),
            border: notification.isRead
                ? Border.all(color: ElxauTheme.transparent)
                : Border.all(color: ElxauTheme.primary.withValues(alpha: 0.1), width: 1),
            boxShadow: notification.isRead ? [] : ElxauTheme.softShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(notification.icon, color: notification.color, size: 22),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.outfit(
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                              fontSize: 16,
                              color: ElxauTheme.accent,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: ElxauTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: GoogleFonts.outfit(
                        color: notification.isRead
                            ? ElxauTheme.secondaryText.withValues(alpha: 0.7)
                            : ElxauTheme.secondaryText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: GoogleFonts.outfit(
                        color: ElxauTheme.secondaryText.withValues(alpha: 0.4),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'IL Y A ${difference.inMinutes} MIN';
    } else if (difference.inHours < 24) {
      return 'IL Y A ${difference.inHours} HEURES';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
