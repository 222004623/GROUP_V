/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    _errorMessage = null;
    _setLoading(true);
    try {
      _notifications = await _service.getMyNotifications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    await _service.markAsRead(notificationId);
    _notifications = _notifications
        .map((n) => n.id == notificationId
            ? NotificationModel(
                id: n.id,
                recipientId: n.recipientId,
                actorId: n.actorId,
                title: n.title,
                message: n.message,
                type: n.type,
                applicationId: n.applicationId,
                isRead: true,
                createdAt: n.createdAt,
              )
            : n)
        .toList();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
    await loadNotifications();
  }
}
