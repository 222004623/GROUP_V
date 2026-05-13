/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationService {
  final _client = Supabase.instance.client;

  Future<List<NotificationModel>> getMyNotifications() async {
    final uid = _client.auth.currentUser!.id;
    final data = await _client
        .from('notifications')
        .select()
        .eq('recipient_id', uid)
        .order('created_at', ascending: false);

    return (data as List).map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final uid = _client.auth.currentUser!.id;
    final data = await _client
        .from('notifications')
        .select('id')
        .eq('recipient_id', uid)
        .eq('is_read', false);

    return (data as List).length;
  }

  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final uid = _client.auth.currentUser!.id;
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('recipient_id', uid)
        .eq('is_read', false);
  }

  Future<void> notifyAdmins({
    required String title,
    required String message,
    required String type,
    String? applicationId,
    String? actorId,
  }) async {
    final admins = await _client.from('profiles').select('id').eq('role', 'admin');    
    final rows = (admins as List)
        .map(
          (admin) => {
            'recipient_id': admin['id'],
            'actor_id': actorId,
            'title': title,
            'message': message,
            'type': type,
            'application_id': applicationId,
          },
        )
        .toList();

    if (rows.isNotEmpty) {
      await _client.from('notifications').insert(rows);
    }
  }

  Future<void> notifyUser({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? applicationId,
    String? actorId,
  }) async {
    await _client.from('notifications').insert({
      'recipient_id': userId,
      'actor_id': actorId,
      'title': title,
      'message': message,
      'type': type,
      'application_id': applicationId,
    });
  }
}
