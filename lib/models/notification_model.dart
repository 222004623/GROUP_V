/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
class NotificationModel {
  final String id;
  final String recipientId;
  final String? actorId;
  final String title;
  final String message;
  final String type;
  final String? applicationId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.recipientId,
    this.actorId,
    required this.title,
    required this.message,
    required this.type,
    this.applicationId,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      recipientId: map['recipient_id'],
      actorId: map['actor_id'],
      title: map['title'],
      message: map['message'],
      type: map['type'],
      applicationId: map['application_id'],
      isRead: map['is_read'] ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}
