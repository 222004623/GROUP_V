/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../services/profile_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/auth_text_field.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfileService();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _studentNumberCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  String? _selectedYear;
  String? _selectedGender;
  bool _isSaving = false;

  final _years = ['1st Year', '2nd Year', '3rd Year'];
  final _genders = ['Female', 'Male', 'Non-binary', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().user;
    _firstNameCtrl.text = user?.firstName ?? '';
    _lastNameCtrl.text = user?.lastName ?? '';
    _studentNumberCtrl.text = user?.studentNumber ?? '';
    _phoneCtrl.text = user?.phone ?? '';
    _dobCtrl.text = user?.dateOfBirth ?? '';
    _addressCtrl.text = user?.address ?? '';
    _emergencyNameCtrl.text = user?.emergencyContactName ?? '';
    _emergencyPhoneCtrl.text = user?.emergencyContactPhone ?? '';
    _selectedYear = user?.yearOfStudy;
    _selectedGender = user?.gender;
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
      await _service.updateProfile(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        studentNumber: _studentNumberCtrl.text.trim(),
        yearOfStudy: _selectedYear!,
        phone: _phoneCtrl.text.trim(),
        dateOfBirth: _dobCtrl.text.trim(),
        gender: _selectedGender!,
        address: _addressCtrl.text.trim(),
        emergencyContactName: _emergencyNameCtrl.text.trim(),
        emergencyContactPhone: _emergencyPhoneCtrl.text.trim(),
      );
      if (!mounted) return;
      await context.read<AuthViewModel>().refreshCurrentUser();
      if (!mounted) return;
      AppSnackbar.success(context, 'Profile completed.');
      Navigator.pushReplacementNamed(context, '/student');
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to save profile. Try again.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthViewModel>().user?.email ?? '';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Complete Profile'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email.isEmpty
                      ? 'Complete your profile to continue.'
                      : '$email\nComplete your profile to continue.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Icon(
                  Icons.assignment_ind_outlined,
                  color: AppTheme.primary,
                  size: 34,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'First Name',
                  controller: _firstNameCtrl,
                  prefixIcon: Icons.person_outline,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Last Name',
                  controller: _lastNameCtrl,
                  prefixIcon: Icons.person_outline,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Student Number',
                  controller: _studentNumberCtrl,
                  prefixIcon: Icons.badge_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedYear,
                  decoration: _dropdownDecoration(
                    'Year of Study',
                    Icons.school_outlined,
                  ),
                  items: _years
                      .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                      .toList(),
                  validator: (v) => v == null ? 'Year of study is required' : null,
                  onChanged: (v) => setState(() => _selectedYear = v),
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Phone Number',
                  controller: _phoneCtrl,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Date of Birth',
                  controller: _dobCtrl,
                  prefixIcon: Icons.cake_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: _dropdownDecoration('Gender', Icons.wc_outlined),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  validator: (v) => v == null ? 'Gender is required' : null,
                  onChanged: (v) => setState(() => _selectedGender = v),
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Address',
                  controller: _addressCtrl,
                  prefixIcon: Icons.home_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Emergency Contact Name',
                  controller: _emergencyNameCtrl,
                  prefixIcon: Icons.contacts_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Emergency Contact Phone',
                  controller: _emergencyPhoneCtrl,
                  prefixIcon: Icons.call_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _required,
                ),
                const SizedBox(height: 28),
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
                      : const Text('Save and Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
    );
  }
}
