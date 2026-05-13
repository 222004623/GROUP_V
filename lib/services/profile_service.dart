/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getProfile() async {
    final uid = _client.auth.currentUser!.id;
    return await _client.from('profiles').select().eq('id', uid).single();
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String studentNumber,
    required String yearOfStudy,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) async {
    final uid = _client.auth.currentUser!.id;

    await _client
        .from('profiles')
        .update({
          'first_name': firstName,
          'last_name': lastName,
          'student_number': studentNumber,
          'year_of_study': yearOfStudy,
          'phone': phone,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'address': address,
          'emergency_contact_name': emergencyContactName,
          'emergency_contact_phone': emergencyContactPhone,
        })
        .eq('id', uid); // make sure this line is here
  }
}
