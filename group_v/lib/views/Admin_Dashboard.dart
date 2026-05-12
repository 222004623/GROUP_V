/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Students.dart';
import '../viewmodels/student_viewmodel.dart';
import '../viewmodels/AuthViewModel.dart';
import '../views/edit_student_page.dart';
import '../views/Application_Detail_Screen.dart';

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
    context.read<StudentViewModel>().fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Students'),
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
                  ElevatedButton(
                    onPressed: () => vm.fetchStudents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (vm.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 64),
                  const SizedBox(height: 16),
                  const Text('No students yet'),
                  ElevatedButton(
                    onPressed: () => _navigateToAdd(),
                    child: const Text('Add Student'),
                  ),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToEdit(student),
                    ),
                    onTap: () => _navigateToDetails(student),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditStudentPage(),
      ),
    ).then((_) => context.read<StudentViewModel>().fetchStudents());
  }

  void _navigateToEdit(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditStudentPage()),
    ).then((_) => context.read<StudentViewModel>().fetchStudents());
  }

  void _navigateToDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentDetailsPage(student: student, message: '', )),
    );
  }
}