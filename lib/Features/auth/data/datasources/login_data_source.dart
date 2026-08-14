import 'package:project_2/Features/auth/data/login_response.dart';

abstract class LoginDataSource {
  Future<LoginResponse> login({
    required String usernameOrPhone,
    required String password,
  });
}