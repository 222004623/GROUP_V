/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../models/user_model.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/auth_text_field.dart';

class AdminProfileEditView extends StatefulWidget {
  final UserModel student;

  const AdminProfileEditView({super.key, required this.student});

  @override
  State<AdminProfileEditView> createState() => _AdminProfileEditViewState();
}

class _AdminProfileEditViewState extends State<AdminProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _studentNumberCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _emergencyNameCtrl;
  late final TextEditingController _emergencyPhoneCtrl;
  String? _selectedYear;
  String? _selectedRole;
  String? _selectedGender;
  bool _isSaving = false;

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _roles = ['student', 'admin', 'disabled'];
  final List<String> _genders = [
    'Female',
    'Male',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.student.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.student.lastName ?? '');
    _studentNumberCtrl =
        TextEditingController(text: widget.student.studentNumber ?? '');
    _phoneCtrl = TextEditingController(text: widget.student.phone ?? '');
    _dobCtrl = TextEditingController(text: widget.student.dateOfBirth ?? '');
    _addressCtrl = TextEditingController(text: widget.student.address ?? '');
    _emergencyNameCtrl =
        TextEditingController(text: widget.student.emergencyContactName ?? '');
    _emergencyPhoneCtrl =
        TextEditingController(text: widget.student.emergencyContactPhone ?? '');
    _selectedYear = widget.student.yearOfStudy;
    _selectedRole = widget.student.role;
    _selectedGender = widget.student.gender;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _studentNumberCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await Supabase.instance.client.from('profiles').update({
        'first_name': _firstNameCtrl.text.trim(),
        'last_name': _lastNameCtrl.text.trim(),
        'student_number': _studentNumberCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'year_of_study': _selectedYear,
        'date_of_birth': _dobCtrl.text.trim(),
        'gender': _selectedGender,
        'address': _addressCtrl.text.trim(),
        'emergency_contact_name': _emergencyNameCtrl.text.trim(),
        'emergency_contact_phone': _emergencyPhoneCtrl.text.trim(),
        'role': _selectedRole,
      }).eq('id', widget.student.id);

      if (mounted) {
        AppSnackbar.success(context, 'Profile updated successfully.');
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to update profile.');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Edit Student Profile'),
      backgroundColor: Colors.blue,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: 'First Name',
                controller: _firstNameCtrl,
                prefixIcon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Last Name',
                controller: _lastNameCtrl,
                prefixIcon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Student Number',
                controller: _studentNumberCtrl,
                prefixIcon: Icons.badge_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Phone Number',
                controller: _phoneCtrl,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _dropdown(
                label: 'Year of Study',
                icon: Icons.school_outlined,
                value: _selectedYear,
                items: _years,
                onChanged: (v) => setState(() => _selectedYear = v),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Date of Birth',
                controller: _dobCtrl,
                prefixIcon: Icons.cake_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _dropdown(
                label: 'Gender',
                icon: Icons.wc_outlined,
                value: _selectedGender,
                items: _genders,
                onChanged: (v) => setState(() => _selectedGender = v),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Address',
                controller: _addressCtrl,
                prefixIcon: Icons.home_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Emergency Contact Name',
                controller: _emergencyNameCtrl,
                prefixIcon: Icons.contacts_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Emergency Contact Phone',
                controller: _emergencyPhoneCtrl,
                prefixIcon: Icons.call_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _dropdown(
                label: 'Account Role',
                icon: Icons.manage_accounts_outlined,
                value: _selectedRole,
                items: _roles,
                onChanged: (v) => setState(() => _selectedRole = v),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
