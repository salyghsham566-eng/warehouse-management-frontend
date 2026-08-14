import 'package:project_2/Features/auth/data/datasources/login_data_source.dart';
import 'package:project_2/Features/auth/data/login_response.dart';
import 'package:project_2/Features/auth/domain/exception/login_exception.dart';

class MockLoginDataSource implements LoginDataSource {
  @override
  Future<LoginResponse> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    // =====================================================
    // مندوب فعال
    // المشرف أنشأ له الحساب
    // =====================================================
    if ((usernameOrPhone == 'rep' ||
            usernameOrPhone == '0999999999') &&
        password == '123456') {
      return const LoginResponse(
        token: 'mock_representative_token',
        role: 'representative',
        name: 'أحمد المندوب',
        isActive: true,
      );
    }

    // =====================================================
    // مندوب حسابه موقوف
    // =====================================================
    if (usernameOrPhone == 'stopped_rep' &&
        password == '123456') {
      return const LoginResponse(
        token: 'mock_stopped_token',
        role: 'representative',
        name: 'مندوب موقوف',
        isActive: false,
      );
    }

    // =====================================================
    // حساب مشرف
    // البيانات صحيحة لكن المنصة خاطئة
    // =====================================================
    if (usernameOrPhone == 'supervisor' &&
        password == '123456') {
      return const LoginResponse(
        token: 'mock_supervisor_token',
        role: 'supervisor',
        name: 'المشرف',
        isActive: true,
      );
    }

    // =====================================================
    // حساب مفوتر
    // البيانات صحيحة لكن المنصة خاطئة
    // =====================================================
    if (usernameOrPhone == 'biller' &&
        password == '123456') {
      return const LoginResponse(
        token: 'mock_biller_token',
        role: 'biller',
        name: 'المفوتر',
        isActive: true,
      );
    }

    // أي بيانات أخرى تعتبر خاطئة
    throw LoginException.invalidCredentials();
  }
}