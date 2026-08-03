import 'package:project_2/Features/auth/data/models/profile_model.dart';

class ProfileRepository {
  ProfileModel _profile = const ProfileModel(
    username: "ahmad123",
    fullName: "أحمد محمد",
    phone: "0999999999",
    role: "مندوب",
    accountStatus: "فعال",
    address: "دمشق - المزة",
    governorate: "دمشق",
    birthDate: "2000-05-15",
    canEditUsername: false,
    imageUrl: null,
  );

  Future<ProfileModel> getProfile() async {
    // بيانات مؤقتة إلى أن يصبح الباك جاهزًا.
    await Future.delayed(const Duration(milliseconds: 500));

    return _profile;
  }

  Future<ProfileModel> updateProfile({
    required String username,
    required String phone,
    required String address,
    required String governorate,
    required String birthDate,
    String? password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _profile = _profile.copyWith(
      username: username,
      phone: phone,
      address: address,
      governorate: governorate,
      birthDate: birthDate,
    );

    return _profile;
  }
}
