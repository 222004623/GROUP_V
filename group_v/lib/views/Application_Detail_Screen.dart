/*
student number:
Student names: 
*/
import 'package:group_v/models/Students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_v/routeManager/RouteManager.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';

// View application details.
// Edit application information while pending.
// Delete an application with confirmation.

class StudentDetailsPage extends StatelessWidget {
  final Student? student;
  final String message;

  const StudentDetailsPage({
    super.key,
    required this.student,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('No student data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${student!.name}\'s Application')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: student!.profilePictureUrl != null
                    ? NetworkImage(student!.profilePictureUrl!)
                    : null,
                child: student!.profilePictureUrl == null
                    ? Text(
                        student!.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 36),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Student info
            _infoRow('Name', student!.name),
            _infoRow('Phone', student!.phone),
            _infoRow('Student ID', student!.id),
            _infoRow(
              'Applied on',
              '${student!.createdAt.day}/${student!.createdAt.month}/${student!.createdAt.year}',
            ),

            const SizedBox(height: 32),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Application'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteManager.edit,
                    arguments: student,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Delete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete Application'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _confirmDelete(context),
              ),
            ),
            const SizedBox(height: 12),

            // Back button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text(
            'Are you sure you want to delete this application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final vm = context.read<StudentViewModel>();
              final success = await vm.deleteStudent(student!.id);
              if (context.mounted) {
                if (success) {
                  Navigator.popUntil(
                      context, ModalRoute.withName(RouteManager.adminDashboard));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not delete application.')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
