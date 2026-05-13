/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/application_model.dart';
import '../../models/user_model.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/status_badge.dart';
import 'admin_application_detail_view.dart';
import 'admin_profile_edit_view.dart';

class AdminStudentDetailView extends StatefulWidget {
  final UserModel student;

  const AdminStudentDetailView({super.key, required this.student});

  @override
  State<AdminStudentDetailView> createState() => _AdminStudentDetailViewState();
}

class _AdminStudentDetailViewState extends State<AdminStudentDetailView> {
  List<ApplicationModel> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      _applications = await context
          .read<AdminViewModel>()
          .getApplicationsByStudent(widget.student.id);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _disableAccount() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Disable Account',
      message: 'This will prevent this student from logging in.',
      confirmText: 'Disable',
      isDanger: true,
    );
    if (confirmed && mounted) {
      final success =
          await context.read<AdminViewModel>().disableStudent(widget.student.id);
      if (mounted) {
        if (success) {
          AppSnackbar.success(context, 'Account disabled successfully.');
          Navigator.pop(context);
        } else {
          AppSnackbar.error(context, 'Failed to disable account.');
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Account',
      message: 'Permanently remove this student and their applications?',
      confirmText: 'Delete',
      isDanger: true,
    );
    if (confirmed && mounted) {
      final success =
          await context.read<AdminViewModel>().deleteStudent(widget.student.id);
      if (mounted) {
        if (success) {
          AppSnackbar.success(context, 'Account deleted successfully.');
          Navigator.pop(context);
        } else {
          AppSnackbar.error(context, 'Failed to delete account.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final name = '${student.firstName ?? ''} ${student.lastName ?? ''}'.trim();
    final isDisabled = student.role == 'disabled';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminProfileEditView(student: student),
                ),
              ).then((_) => _loadApplications());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      color: AppTheme.primary, size: 34),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'No name set' : name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.email,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDisabled)
                    const Icon(Icons.block, color: AppTheme.error),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _sectionTitle('Profile Information'),
          const SizedBox(height: 10),
          _infoCard(
            children: [
              _infoRow('Student No.', student.studentNumber ?? 'Not set'),
              _infoRow('Year of Study', student.yearOfStudy ?? 'Not set'),
              _infoRow('Phone', student.phone ?? 'Not set'),
              _infoRow('Date of Birth', student.dateOfBirth ?? 'Not set'),
              _infoRow('Gender', student.gender ?? 'Not set'),
              _infoRow('Address', student.address ?? 'Not set'),
              _infoRow('Emergency', student.emergencyContactName ?? 'Not set'),
              _infoRow(
                'Emergency No.',
                student.emergencyContactPhone ?? 'Not set',
              ),
              _infoRow('Role', student.role),
            ],
          ),
          const SizedBox(height: 18),
          _sectionTitle('Applications'),
          const SizedBox(height: 10),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_applications.isEmpty)
            _emptyApplications()
          else
            ..._applications.map(
              (app) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _applicationTile(context, app),
              ),
            ),
          const SizedBox(height: 18),
          _sectionTitle('Account Management'),
          const SizedBox(height: 10),
          if (!isDisabled)
            OutlinedButton.icon(
              onPressed: _disableAccount,
              icon: const Icon(Icons.block_outlined, color: AppTheme.primary),
              label: const Text('Disable Account'),
            ),
          if (!isDisabled) const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _deleteAccount,
            icon: const Icon(Icons.delete_forever_outlined, color: AppTheme.error),
            label: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Widget _applicationTile(BuildContext context, ApplicationModel app) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description_outlined, color: AppTheme.primary),
        title: Text(
          app.modules.isNotEmpty
              ? app.modules.map((m) => m.moduleCode).join(', ')
              : 'No modules',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('Year: ${app.yearOfStudy}'),
        trailing: StatusBadge(status: app.status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminApplicationDetailView(
                application: app,
                student: widget.student,
              ),
            ),
          ).then((_) => _loadApplications());
        },
      ),
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyApplications() {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.inbox_outlined),
        title: Text('No applications submitted.'),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}
