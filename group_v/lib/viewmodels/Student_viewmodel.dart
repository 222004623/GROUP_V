/*
student number:
Student names: 
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:group_v/storage/Storage_Service.dart';
import 'package:group_v/models/Students.dart';

class StudentViewModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final StorageService _storageService = StorageService();

  List<Student> _students = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  String? value;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  // ==================== CREATE ====================
  // Future<bool> addStudent(
  //   String name,
  //   String phone, {
  //   File? profileImage,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final userId = _supabase.auth.currentUser!.id;

  //     final response = await _supabase.from('applications').insert({
  //       'name': name,
  //       'phone': phone,
  //       'user_id': userId,
  //     }).select();

  //     if (response.isEmpty) return false;

  //     final newStudent = Student.fromJson(response.first);

  //     String? imageUrl;
  //     if (profileImage != null) {
  //       _isUploading = true;
  //       notifyListeners();
  //       imageUrl = await _storageService.uploadProfilePicture(
  //         newStudent.id,
  //         profileImage,
  //       );
  //       if (imageUrl != null) {
  //         await _supabase
  //             .from('applications')
  //             .update({'profile_picture_url': imageUrl})
  //             .match({'id': newStudent.id});
  //       }
  //       _isUploading = false;
  //     }

  //     _students.insert(0, newStudent.copyWith(profilePictureUrl: imageUrl));
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //     return false;
  //   } finally {
  //     _isLoading = false;
  //     _isUploading = false;
  //     notifyListeners();
  //   }
  // }

  // // ==================== READ ====================
  Future<void> fetchStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('applications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _students = response.map((json) => Student.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStudent(String name, String phone) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      // Check authentication
      if (user == null) {
        _errorMessage = "No authenticated user found";
        notifyListeners();

        return false;
      }

      await Supabase.instance.client.from('applications').insert({
        'column_name': value,
        'name': name,
        'phone': phone,
        'user_id': user.id,

        // Extra fields
        'status': 'Pending',
        'position': 'Student Assistant',
        'department': 'Information Technology',

        // timestamps
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      print("SUPABASE INSERT ERROR: $e");

      notifyListeners();

      return false;
    }
  }

  // ==================== UPDATE ====================
  Future<bool> updateStudent(
    String id,
    String name,
    String phone, {
    File? newProfileImage,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final oldStudent = getStudentById(id);
      String? newImageUrl = oldStudent?.profilePictureUrl;

      if (newProfileImage != null) {
        _isUploading = true;
        notifyListeners();
        if (oldStudent?.profilePictureUrl != null) {
          await _storageService.deleteProfilePicture(
            oldStudent!.profilePictureUrl!,
          );
        }
        newImageUrl = await _storageService.uploadProfilePicture(
          id,
          newProfileImage,
        );
        _isUploading = false;
      }

      await _supabase
          .from('applications')
          .update({
            'name': name,
            'phone': phone,
            if (newImageUrl != null) 'profile_picture_url': newImageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .match({'id': id});

      final index = _students.indexWhere((s) => s.id == id);
      if (index != -1) {
        _students[index] = _students[index].copyWith(
          name: name,
          phone: phone,
          profilePictureUrl: newImageUrl,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _isUploading = false;
      notifyListeners();
    }
  }

  // Update just the name field for a given student id
  Future<bool> updateName(String id, String newName) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabase
          .from('applications')
          .update({
            'name': newName,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .match({'id': id});

      final index = _students.indexWhere((s) => s.id == id);
      if (index != -1) {
        _students[index] = _students[index].copyWith(name: newName);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteStudent(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final student = getStudentById(id);
      if (student?.profilePictureUrl != null) {
        await _storageService.deleteProfilePicture(student!.profilePictureUrl!);
      }
      await _supabase.from('applictions').delete().match({'id': id});
      _students.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
