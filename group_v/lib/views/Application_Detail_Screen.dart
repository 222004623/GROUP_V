/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_v/routeManager/RouteManager.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';

// View application details.
// Edit application information while pending.
// Delete an application with confirmation.

class StudentDetailsPage extends StatelessWidget {
  final String message;

  const StudentDetailsPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Message: $message"), //dynamic route

          Consumer<StudentViewModel>(
            builder: (context, vm, child) {
              return Text(vm.students.length.toString());
            },
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteManager.edit);
            },
            child: const Text("Edit Name"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteManager.confirm);
            },
            child: const Text("Confirm"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }
}
