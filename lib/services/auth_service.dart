/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'notification_service.dart';

class AuthService {
  final _client = Supabase.instance.client;
  final _notificationService = NotificationService();

  // Signs up and inserts a row into the `profiles` table with default role 'student'
  Future<UserModel> register(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);

    final uid = res.user!.id;

    await _client.from('profiles').insert({
      'id': uid,
      'email': email,
      'role': 'student',
    });

    await _notificationService.notifyAdmins(
      title: 'New student account',
      message: '$email created a student account.',
      type: 'new_account',
      actorId: uid,
    );

    return UserModel(id: uid, email: email, role: 'student');
  }

  Future<UserModel> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final uid = res.user!.id;

    // Use maybeSingle in case profile row has issues
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    // If no profile found, return basic user with role from email or default
    if (profile == null) {
      return UserModel(id: uid, email: email, role: 'student');
    }
    if (profile['role'] == 'disabled') {
      await _client.auth.signOut();
      throw Exception('Your account has been disabled. Contact admin.');
    }
    return UserModel.fromMap(profile);
  }

  Future<UserModel> getCurrentProfile() async {
    final user = _client.auth.currentUser!;
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        role: 'student',
      );
    }
    return UserModel.fromMap(profile);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // Checks if a session already exists on app launch
  User? get currentUser => _client.auth.currentUser;
}
