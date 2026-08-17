import 'dart:typed_data';

import 'package:project_2/Features/auth/data/datasources/profile_data_source.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';

class MockProfileDataSource
    implements ProfileDataSource {
  String _currentPassword = 'Old@1234';

  ProfileModel _profile =
      const ProfileModel(
    fullName: 'أحمد محمد',
    representativeCode: 'REP-1024',
    phone: '0999999999',
    email: 'ahmad.rep@example.com',
    role: 'مندوب مبيعات',
    accountStatus: 'فعال',
    address: 'دمشق - المزة',
    linkedRegions: [
      ProfileRegionModel(
        id: 1,
        name: 'دمشق',
        pharmaciesCount: 24,
      ),
      ProfileRegionModel(
        id: 2,
        name: 'ريف دمشق',
        pharmaciesCount: 18,
      ),
      ProfileRegionModel(
        id: 3,
        name: 'حمص',
      ),
    ],
    permissions: [
      'الطلبات',
      'التحصيل',
      'المالية',
      'خطط العمل',
      'العروض',
      'المستودع',
      'الصيدليات',
      'الإشعارات',
    ],
  );

  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 450),
    );

    return _profile;
  }

  @override
  Future<ProfileModel> updateProfile({
    required String phone,
    required String email,
    Uint8List? imageBytes,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    _profile = _profile.copyWith(
      phone: phone,
      email: email,
      imageBytes: imageBytes,
    );

    return _profile;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    if (currentPassword != _currentPassword) {
      throw Exception(
        'كلمة المرور الحالية غير صحيحة',
      );
    }

    if (newPassword == _currentPassword) {
      throw Exception(
        'كلمة المرور الجديدة يجب أن تختلف عن الحالية',
      );
    }

    _currentPassword = newPassword;
  }
}
