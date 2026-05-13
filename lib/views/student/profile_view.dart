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

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
  bool _isLoading = false;
  bool _isSaving = false;

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _genders = [
    'Female',
    'Male',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getProfile();
      _firstNameCtrl.text = data['first_name'] ?? '';
      _lastNameCtrl.text = data['last_name'] ?? '';
      _studentNumberCtrl.text = data['student_number'] ?? '';
      _phoneCtrl.text = data['phone'] ?? '';
      _selectedYear = data['year_of_study'];
      _dobCtrl.text = data['date_of_birth'] ?? '';
      _selectedGender = data['gender'];
      _addressCtrl.text = data['address'] ?? '';
      _emergencyNameCtrl.text = data['emergency_contact_name'] ?? '';
      _emergencyPhoneCtrl.text = data['emergency_contact_phone'] ?? '';
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedYear == null) {
      AppSnackbar.error(context, 'Please select your year of study.');
      return;
    }
    if (_selectedGender == null) {
      AppSnackbar.error(context, 'Please select your gender.');
      return;
    }

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
      if (mounted) {
        await context.read<AuthViewModel>().refreshCurrentUser();
      }
      if (mounted) {
        AppSnackbar.success(context, 'Profile updated successfully!');
      }
    } catch (_) {
      if (mounted)
        AppSnackbar.error(context, 'Failed to update profile. Try again.');
    } finally {
      setState(() => _isSaving = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthViewModel>().user?.email ?? '';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 13, 14, 14),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar circle with initials
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 7, 7, 7),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _firstNameCtrl.text.isNotEmpty
                              ? _firstNameCtrl.text[0].toUpperCase()
                              : email[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Form fields
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

                    // Year of study dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedYear,
                      decoration: InputDecoration(
                        labelText: 'Year of Study',
                        filled: true,
                        fillColor: AppTheme.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.school_outlined,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      items: _years
                          .map(
                            (y) => DropdownMenuItem(value: y, child: Text(y)),
                          )
                          .toList(),
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

                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        filled: true,
                        fillColor: AppTheme.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.wc_outlined,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      items: _genders
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
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

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        elevation: 0,
                      ),
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
                  ],
                ),
              ),
            ),
    );
  }
}
