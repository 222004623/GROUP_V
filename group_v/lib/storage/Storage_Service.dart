/*
student number:
Student names: 
*/
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

// This is where you will retrive and store information from and to the supabase database
class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'student_profiles';
  // Pick image from gallery or camera
  static Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024, // Resize to save bandwidth
        maxHeight: 1024,
        imageQuality: 85, // Compress to 85% quality
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  // Upload profile picture to Supabase Storage
  Future<String?> uploadProfilePicture(String studentId, File imageFile) async {
    try {
      // Create unique file name
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '$studentId/${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      // Upload to bucket
      await _supabase.storage
          .from(_bucketName)
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      // Get public URL (since bucket is public)
      return _supabase.storage.from(_bucketName).getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Delete profile picture
  Future<bool> deleteProfilePicture(String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final filePath = pathSegments.sublist(3).join('/');
      await _supabase.storage.from(_bucketName).remove([filePath]);
      return true;
    } catch (e) {
      return false;
    }
  }
}