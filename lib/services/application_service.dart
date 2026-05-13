/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application_model.dart';
import 'notification_service.dart';

class ApplicationService {
  final _client = Supabase.instance.client;
  final _notificationService = NotificationService();

  // Uploads raw bytes to Supabase Storage and returns the public URL
  Future<String> _uploadBytes(
      Uint8List bytes, String bucket, String path) async {
    await _client.storage.from(bucket).uploadBinary(path, bytes);
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<ApplicationModel> submitApplication({
    required ApplicationModel application,
    required Uint8List transcriptBytes,
    required String transcriptName,
    required Uint8List idDocumentBytes,
    required String idDocumentName,
    required Uint8List proofBytes,
    required String proofName,
  }) async {
    final uid = _client.auth.currentUser!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final transcriptUrl = await _uploadBytes(transcriptBytes, 'documents',
        '$uid/transcript_$timestamp.${transcriptName.split('.').last}');
    final idUrl = await _uploadBytes(idDocumentBytes, 'documents',
        '$uid/id_$timestamp.${idDocumentName.split('.').last}');
    final proofUrl = await _uploadBytes(proofBytes, 'documents',
        '$uid/proof_$timestamp.${proofName.split('.').last}');
debugPrint('Current user UID: $uid');
 final profile = await _client
      .from('profiles')
      .select('id')
      .eq('id', uid)
      .maybeSingle();
  
  debugPrint('Profile found: $profile');
  
  if (profile == null) {
    throw Exception('Profile not found for user $uid');
  }
    final appData = await _client
        .from('applications')
        .insert({
          ...application.toMap(),
          'transcript_url': transcriptUrl,
          'id_document_url': idUrl,
          'proof_of_registration_url': proofUrl,
        })
        .select()
        .single();

    final appId = appData['id'];

    for (final module in application.modules) {
      await _client.from('application_modules').insert({
        'application_id': appId,
        ...module.toMap(),
      });
    }

    await _notificationService.notifyAdmins(
      title: 'New application',
      message: 'A student submitted an application for review.',
      type: 'new_application',
      applicationId: appId,
      actorId: uid,
    );

    return ApplicationModel.fromMap({
      ...appData,
      'application_modules':
          application.modules.map((m) => m.toMap()).toList(),
    });
  }

  Future<ApplicationModel?> getMyApplication() async {
    final uid = _client.auth.currentUser!.id;
    final data = await _client
        .from('applications')
        .select('*, application_modules(*)')
        .eq('student_id', uid)
        .maybeSingle();
    return data != null ? ApplicationModel.fromMap(data) : null;
  }

  Future<bool> hasExistingApplication() async {
    final uid = _client.auth.currentUser!.id;
    final data = await _client
        .from('applications')
        .select('id')
        .eq('student_id', uid)
        .maybeSingle();
    return data != null;
  }

  Future<void> updateApplication({
    required String applicationId,
    required ApplicationModel application,
    Uint8List? transcriptBytes,
    String? transcriptName,
    Uint8List? idDocumentBytes,
    String? idDocumentName,
    Uint8List? proofBytes,
    String? proofName,
  }) async {
    final uid = _client.auth.currentUser!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final updates = application.toMap();

    // Only re-upload if new files were selected
    if (transcriptBytes != null && transcriptName != null) {
      updates['transcript_url'] = await _uploadBytes(transcriptBytes,
          'documents', '$uid/transcript_$timestamp.${transcriptName.split('.').last}');
    }
    if (idDocumentBytes != null && idDocumentName != null) {
      updates['id_document_url'] = await _uploadBytes(idDocumentBytes,
          'documents', '$uid/id_$timestamp.${idDocumentName.split('.').last}');
    }
    if (proofBytes != null && proofName != null) {
      updates['proof_of_registration_url'] = await _uploadBytes(proofBytes,
          'documents', '$uid/proof_$timestamp.${proofName.split('.').last}');
    }

    await _client
        .from('applications')
        .update(updates)
        .eq('id', applicationId);

    // Replace modules
    await _client
        .from('application_modules')
        .delete()
        .eq('application_id', applicationId);

    for (final module in application.modules) {
      await _client.from('application_modules').insert({
        'application_id': applicationId,
        ...module.toMap(),
      });
    }
  }

  Future<void> deleteApplication(String applicationId) async {
    await _client.from('applications').delete().eq('id', applicationId);
  }
}
