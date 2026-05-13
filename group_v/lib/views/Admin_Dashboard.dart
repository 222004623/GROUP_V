/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_v/models/Students.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';
import 'package:group_v/viewmodels/AuthViewModel.dart';
import 'package:group_v/routeManager/RouteManager.dart';

// View all submitted applications.
// Review applicant information and supporting documentation.
// Approve or reject applications.
// Update application status.
// Remove invalid applications.
// Optionally filter application data for review purposes.

class AdminDashBoardView extends StatefulWidget {
  const AdminDashBoardView({super.key});

  @override
  State<AdminDashBoardView> createState() => _AdminDashBoardViewState();
}

class _AdminDashBoardViewState extends State<AdminDashBoardView> {
  @override
  void initState() {
    super.initState();
    // Fetch all students when admin opens dashboard
    context.read<StudentViewModel>().fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Applications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<StudentViewModel>().fetchStudents(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthViewModel>().signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, RouteManager.login);
              }
            },
          ),
        ],
      ),
      body: Consumer<StudentViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.students.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${vm.errorMessage}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => vm.fetchStudents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (vm.students.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64),
                  SizedBox(height: 16),
                  Text('No student applications yet'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchStudents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.students.length,
              itemBuilder: (context, index) {
                final student = vm.students[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: student.profilePictureUrl != null
                          ? NetworkImage(student.profilePictureUrl!)
                          : null,
                      child: student.profilePictureUrl == null
                          ? Text(student.name[0].toUpperCase())
                          : null,
                    ),
                    title: Text(student.name),
                    subtitle: Text(student.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button — passes the student so page can pre-fill
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToEdit(student),
                        ),
                        // Delete button with confirmation
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, vm, student),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToDetails(student),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToEdit(Student student) {
    Navigator.pushNamed(
      context,
      RouteManager.edit,
      arguments: student, // Pass student so EditStudentPage can pre-fill
    ).then((_) => context.read<StudentViewModel>().fetchStudents());
  }

  void _navigateToDetails(Student student) {
    Navigator.pushNamed(
      context,
      RouteManager.details,
      arguments: student,
    );
  }

  void _confirmDelete(
      BuildContext context, StudentViewModel vm, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: Text('Remove ${student.name}\'s application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await vm.deleteStudent(student.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
