/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../viewmodels/notification_viewmodel.dart';
import '../home/home_view.dart';
import '../notifications/notifications_view.dart';
import 'profile_view.dart';

class StudentShellView extends StatefulWidget {
  const StudentShellView({super.key});

  @override
  State<StudentShellView> createState() => _StudentShellViewState();
}

class _StudentShellViewState extends State<StudentShellView> {
  int _index = 0;

  final _titles = ['Home', 'Notifications', 'Profile'];
  final _pages = const [
    HomeView(),
    NotificationsView(isAdmin: false),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<NotificationViewModel>().unreadCount;

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unread.toString()),
              child: const Icon(Icons.notifications_none),
            ),
            activeIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unread.toString()),
              child: const Icon(Icons.access_alarm_rounded),
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
