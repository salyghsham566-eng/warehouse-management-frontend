import 'dart:typed_data';

import 'package:project_2/Features/auth/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile({
    required String phone,
    required String email,
    Uint8List? imageBytes,
  });
  Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
});
}