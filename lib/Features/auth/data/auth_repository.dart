import 'package:dio/dio.dart';
import 'package:project_2/Core/api_client.dart';
import 'package:project_2/Features/auth/data/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<LoginResponse> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/representative/login',
        data: {
          'username_or_phone': usernameOrPhone,
          'password': password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);
      await prefs.setString('role', loginResponse.role);
      await prefs.setString('name', loginResponse.name);

      return loginResponse;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'فشل تسجيل الدخول';
      throw Exception(message);
    }
  }
}