/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/user_model.dart';
import '../../viewmodels/admin_viewmodel.dart';
import 'admin_student_detail_view.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Students'),
      backgroundColor: Colors.blue,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: vm.searchStudents,
              decoration: InputDecoration(
                hintText: 'Search students',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          vm.searchStudents('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${vm.students.length} student${vm.students.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.students.isEmpty
                    ? const Center(
                        child: Text(
                          'No students found.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: vm.students.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            _studentTile(context, vm.students[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _studentTile(BuildContext context, UserModel student) {
    final name = '${student.firstName ?? ''} ${student.lastName ?? ''}'.trim();
    final title = name.isEmpty ? 'No name set' : name;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_outline, color: AppTheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(student.email, overflow: TextOverflow.ellipsis),
        trailing: student.role == 'disabled'
            ? const Icon(Icons.block, color: AppTheme.error)
            : const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminStudentDetailView(student: student),
            ),
          ).then((_) => context.read<AdminViewModel>().loadDashboard());
        },
      ),
    );
  }
}
