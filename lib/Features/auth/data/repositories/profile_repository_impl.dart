import 'dart:typed_data';

import 'package:project_2/Features/auth/data/datasources/profile_data_source.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {
  final ProfileDataSource dataSource;

  const ProfileRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<ProfileModel> getProfile() {
    return dataSource.getProfile();
  }

  @override
  Future<ProfileModel> updateProfile({
    required String phone,
    required String email,
    Uint8List? imageBytes,
  }) {
    return dataSource.updateProfile(
      phone: phone,
      email: email,
      imageBytes: imageBytes,
    );
  }@override
Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) {
  return dataSource.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );
}
}
