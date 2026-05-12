import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/Student_viewmodel.dart';

// logical grouping of related fields,
// controlled input to avoid invalid selections,
// appropriate validation of user input.
//Application Requirements
// The student’s current year of study must be captured.
//For each module application, the academic level and module must be clearly associated.
//A second module application is optional but must be limited and validated.
//Students must confirm eligibility and submit required supporting documentation.
//Applicants must not submit more than one application.

class StudentAssistantApp extends StatefulWidget {
  const StudentAssistantApp({super.key});
  @override
  State<StudentAssistantApp> createState() => _StudentAssistantAppForm();
}

class _StudentAssistantAppForm extends State<StudentAssistantApp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Name")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                if (!RegExp(r'^\d+ ').hasMatch(value)) {
                  return 'Only numbers allowed';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<StudentViewModel>().updateName(
                    nameController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}