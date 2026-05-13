/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane

Question: Admin DashBoard
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/application_model.dart';
import '../../models/user_model.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/status_badge.dart';
import '../auth/login_view.dart';
import 'admin_application_detail_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().loadDashboard();
    });
  }

  Future<void> _logout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
    );
    if (confirmed && mounted) {
      await context.read<AuthViewModel>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();
    final user = context.read<AuthViewModel>().user;

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: vm.loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings_outlined,
                color: AppTheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user?.firstName ?? 'Admin'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Admin dashboard',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            _statsGrid(vm),
            const SizedBox(height: 22),
            const Text(
              'Recent Applications',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (vm.applications.isEmpty)
              _emptyState('No applications yet.')
            else
              ...vm.applications
                  .take(5)
                  .map(
                    (app) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _applicationCard(app, vm),
                    ),
                  ),
          ],
        ],
      ),
    );
  }

  Widget _statsGrid(AdminViewModel vm) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        _statCard('Total', vm.stats['total'] ?? 0, Icons.folder_open_outlined),
        _statCard('Pending', vm.stats['pending'] ?? 0, Icons.hourglass_empty),
        _statCard(
          'Approved',
          vm.stats['approved'] ?? 0,
          Icons.check_circle_outline,
        ),
        _statCard('Rejected', vm.stats['rejected'] ?? 0, Icons.cancel_outlined),
      ],
    );
  }

  Widget _statCard(String label, int count, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _applicationCard(ApplicationModel app, AdminViewModel vm) {
    final name = app.studentProfile != null
        ? '${app.studentProfile!['first_name'] ?? ''} ${app.studentProfile!['last_name'] ?? ''}'
              .trim()
        : app.studentId.substring(0, 8);
    final student = app.studentProfile != null
        ? UserModel.fromMap(app.studentProfile!)
        : UserModel(id: app.studentId, email: '', role: 'student');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name.isEmpty ? 'Unknown Student' : name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusBadge(status: app.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              app.modules.isNotEmpty
                  ? app.modules.map((m) => m.moduleCode).join(', ')
                  : 'No modules',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            if (app.status == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(context, vm, app.id!, 'approved'),
                      icon: const Icon(Icons.check, color: AppTheme.success),
                      label: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(context, vm, app.id!, 'rejected'),
                      icon: const Icon(Icons.close, color: AppTheme.error),
                      label: const Text('Reject'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminApplicationDetailView(
                      application: app,
                      student: student,
                    ),
                  ),
                ).then((_) => vm.loadDashboard());
              },
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('View Application'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    AdminViewModel vm,
    String appId,
    String status,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: status == 'approved'
          ? 'Approve Application'
          : 'Reject Application',
      message:
          'Are you sure you want to ${status == 'approved' ? 'approve' : 'reject'} this application?',
      confirmText: status == 'approved' ? 'Approve' : 'Reject',
      isDanger: status == 'rejected',
    );
    if (confirmed && context.mounted) {
      final success = await vm.updateApplicationStatus(appId, status);
      if (context.mounted) {
        if (success) {
          AppSnackbar.success(
            context,
            status == 'approved'
                ? 'Application approved.'
                : 'Application rejected.',
          );
        } else {
          AppSnackbar.error(context, 'Action failed. Try again.');
        }
      }
    }
  }

  Widget _emptyState(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.inbox_outlined, color: AppTheme.textSecondary),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
