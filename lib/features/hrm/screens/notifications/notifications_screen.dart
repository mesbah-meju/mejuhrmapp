import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/notification_engine_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(String route)? onNavigateToRoute;

  const NotificationsScreen({
    super.key,
    this.onBack,
    this.onNavigateToRoute,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationEngineService.instance.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _showUnreadOnly
        ? _notifications.where((n) => !n.isRead).toList()
        : _notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Notifications Center",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await NotificationEngineService.instance.markAllAsRead();
              _loadNotifications();
              THelperFunctions.showSnackBar("Marked all as read");
            },
            child: const Text("Mark all read", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text("All (${_notifications.length})"),
                  selected: !_showUnreadOnly,
                  selectedColor: const Color(0xFF2563EB),
                  labelStyle: TextStyle(
                    color: !_showUnreadOnly ? Colors.white : const Color(0xFF475569),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) => setState(() => _showUnreadOnly = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text("Unread (${NotificationEngineService.instance.getUnreadCount()})"),
                  selected: _showUnreadOnly,
                  selectedColor: const Color(0xFF2563EB),
                  labelStyle: TextStyle(
                    color: _showUnreadOnly ? Colors.white : const Color(0xFF475569),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) => setState(() => _showUnreadOnly = true),
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text("No notifications available.", style: TextStyle(color: Color(0xFF94A3B8))),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final notif = filtered[index];
                      return _buildNotificationCard(notif);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notif.isRead ? const Color(0xFFE2E8F0) : const Color(0xFFBAE6FD),
        ),
      ),
      child: ListTile(
        onTap: () async {
          await NotificationEngineService.instance.markAsRead(notif.id);
          _loadNotifications();
          if (notif.deepLinkRoute != null && widget.onNavigateToRoute != null) {
            widget.onNavigateToRoute!(notif.deepLinkRoute!);
          } else {
            THelperFunctions.showSnackBar("Opened notification details");
          }
        },
        leading: CircleAvatar(
          backgroundColor: notif.color.withOpacity(0.12),
          child: Icon(notif.icon, color: notif.color, size: 20),
        ),
        title: Text(
          notif.title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            notif.body,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
          ),
        ),
        trailing: !notif.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}
