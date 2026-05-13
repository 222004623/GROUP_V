/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane

Question: Notification screen
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../models/application_model.dart';
import '../../models/user_model.dart';
import '../../viewmodels/notification_viewmodel.dart';
import '../admin/admin_application_detail_view.dart';
import '../student/application_detail_view.dart';

class NotificationsView extends StatefulWidget {
  final bool isAdmin;

  const NotificationsView({super.key, required this.isAdmin});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications();
    });
  }

  Future<void> _openNotification(notification) async {
    final vm = context.read<NotificationViewModel>();
    await vm.markAsRead(notification.id);

    if (notification.applicationId == null) return;

    final data = await Supabase.instance.client
        .from('applications')
        .select('*, application_modules(*), profiles(*)')
        .eq('id', notification.applicationId)
        .maybeSingle();

    if (!mounted || data == null) return;

    final application = ApplicationModel.fromMap(data);

    if (widget.isAdmin) {
      final student = data['profiles'] != null
          ? UserModel.fromMap(data['profiles'])
          : UserModel(id: application.studentId, email: '', role: 'student');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminApplicationDetailView(
            application: application,
            student: student,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ApplicationDetailView(application: application),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vm.notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = vm.notifications[index];
          return InkWell(
            onTap: () => _openNotification(notification),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppTheme.surface
                    : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    notification.isRead
                        ? Icons.notifications_none
                        : Icons.access_alarm_rounded,
                    color: notification.isRead
                        ? AppTheme.textSecondary
                        : AppTheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    const CircleAvatar(
                      radius: 4,
                      backgroundColor: AppTheme.secondary,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
