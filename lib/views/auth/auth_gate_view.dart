/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane

Question: Authentication Screen
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';

class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeUser());
  }

  Future<void> _routeUser() async {
    final vm = context.read<AuthViewModel>();
    await vm.refreshCurrentUser();
    if (!mounted) return;

    final user = vm.user;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (user.role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      user.hasCompleteProfile ? '/student' : '/complete-profile',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
