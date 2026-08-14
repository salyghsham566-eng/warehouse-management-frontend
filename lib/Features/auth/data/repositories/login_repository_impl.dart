import 'package:dio/dio.dart';
import 'package:project_2/Features/auth/data/datasources/login_data_source.dart';
import 'package:project_2/Features/auth/data/login_response.dart';
import 'package:project_2/Features/auth/domain/exception/login_exception.dart';
import 'package:project_2/Features/auth/domain/repositories/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;
  final Dio dio;

  const LoginRepositoryImpl({
    required this.dataSource,
    required this.dio,
  });

  @override
  Future<LoginResponse> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    final result = await dataSource.login(
      usernameOrPhone: usernameOrPhone,
      password: password,
    );

    // =====================================================
    // UC-01
    // التحقق من حالة الحساب
    // =====================================================

    if (!result.isActive) {
      throw LoginException.suspendedAccount();
    }

    // =====================================================
    // تطبيق الموبايل الحالي خاص بالمندوب فقط
    // =====================================================

    if (result.role.toLowerCase() != 'representative') {
      throw LoginException.wrongPlatform();
    }

    // =====================================================
    // لا نحفظ أي شيء إلا بعد نجاح كل عمليات التحقق
    // =====================================================

  final prefs = await SharedPreferences.getInstance();

await prefs.setString(
  'token',
  result.token,
);

await prefs.setString(
  'role',
  result.role,
);

await prefs.setString(
  'name',
  result.name,
);

await prefs.setString(
  'usernameOrPhone',
  usernameOrPhone,
);

dio.options.headers['Authorization'] =
    'Bearer ${result.token}';

    return result;
  }
}