/*
student number:
Student names:
*/

import 'package:flutter/material.dart';
import 'package:group_v/routeManager/RouteManager.dart';
import 'package:provider/provider.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';

class StudentAssistantApp extends StatefulWidget {
  const StudentAssistantApp({super.key});

  @override
  State<StudentAssistantApp> createState() => _StudentAssistantAppForm();
}

class _StudentAssistantAppForm extends State<StudentAssistantApp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _module1Controller = TextEditingController();

  final TextEditingController _module2Controller = TextEditingController();

  final TextEditingController _documentController = TextEditingController();

  bool _isSaving = false;

  String? _selectedYear;
  String? _selectedLevel;

  bool _eligibleConfirmed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _module1Controller.dispose();
    _module2Controller.dispose();
    _documentController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_eligibleConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please confirm eligibility"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() => _isSaving = true);

    final vm = context.read<StudentViewModel>();

    final success = await vm.addStudent(
      _nameController.text.trim(),
      _phoneController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Submission failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Assistant Application")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // NAME
              TextFormField(
                controller: _nameController,

                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }

                  if (value.trim().length < 2) {
                    return 'Name too short';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // PHONE
              TextFormField(
                controller: _phoneController,

                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number required';
                  }

                  final phone = value.trim();

                  if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                    return 'Enter valid 10 digit number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "Academic Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // YEAR OF STUDY
              DropdownButtonFormField<String>(
                value: _selectedYear,

                decoration: const InputDecoration(
                  labelText: 'Current Year of Study',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(value: '1st Year', child: Text('1st Year')),

                  DropdownMenuItem(value: '2nd Year', child: Text('2nd Year')),

                  DropdownMenuItem(value: '3rd Year', child: Text('3rd Year')),

                  DropdownMenuItem(value: '4th Year', child: Text('4th Year')),
                ],

                onChanged: (value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return 'Select year of study';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ACADEMIC LEVEL
              DropdownButtonFormField<String>(
                value: _selectedLevel,

                decoration: const InputDecoration(
                  labelText: 'Academic Level',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(value: 'Level 5', child: Text('Level 5')),

                  DropdownMenuItem(value: 'Level 6', child: Text('Level 6')),

                  DropdownMenuItem(value: 'Level 7', child: Text('Level 7')),
                ],

                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return 'Select academic level';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // MODULE 1
              TextFormField(
                controller: _module1Controller,

                decoration: const InputDecoration(
                  labelText: 'Module Application 1',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First module required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // MODULE 2 OPTIONAL
              TextFormField(
                controller: _module2Controller,

                decoration: const InputDecoration(
                  labelText: 'Module Application 2 (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Supporting Documents",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _documentController,

                decoration: const InputDecoration(
                  labelText: 'Supporting Document Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.upload_file),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Supporting document required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ELIGIBILITY
              CheckboxListTile(
                value: _eligibleConfirmed,

                title: const Text(
                  "I confirm that I meet the eligibility requirements",
                ),

                onChanged: (value) {
                  setState(() {
                    _eligibleConfirmed = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, RouteManager.home);
                  },

                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Submit Application",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
