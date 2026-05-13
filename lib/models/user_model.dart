/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
class UserModel {
  final String id;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? studentNumber;
  final String? yearOfStudy;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.studentNumber,
    this.yearOfStudy,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  bool get hasCompleteProfile {
    return (firstName ?? '').trim().isNotEmpty &&
        (lastName ?? '').trim().isNotEmpty &&
        (studentNumber ?? '').trim().isNotEmpty &&
        (yearOfStudy ?? '').trim().isNotEmpty &&
        (phone ?? '').trim().isNotEmpty &&
        (dateOfBirth ?? '').trim().isNotEmpty &&
        (gender ?? '').trim().isNotEmpty &&
        (address ?? '').trim().isNotEmpty &&
        (emergencyContactName ?? '').trim().isNotEmpty &&
        (emergencyContactPhone ?? '').trim().isNotEmpty;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      role: map['role'] ?? 'student',
      firstName: map['first_name'],
      lastName: map['last_name'],
      studentNumber: map['student_number'],
      yearOfStudy: map['year_of_study'],
      phone: map['phone'],
      dateOfBirth: map['date_of_birth'],
      gender: map['gender'],
      address: map['address'],
      emergencyContactName: map['emergency_contact_name'],
      emergencyContactPhone: map['emergency_contact_phone'],
    );
  }
}
