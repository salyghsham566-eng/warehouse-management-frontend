class LoginResponse {
  final String token;
  final String role;
  final String name;
  final bool isActive;

  const LoginResponse({
    required this.token,
    required this.role,
    required this.name,
    required this.isActive,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    if (user is! Map<String, dynamic>) {
      throw const FormatException(
        'بيانات المستخدم غير صحيحة',
      );
    }

    final dynamic rawActive =
        user['is_active'] ?? user['active'] ?? true;

    bool active;

    if (rawActive is bool) {
      active = rawActive;
    } else if (rawActive is int) {
      active = rawActive == 1;
    } else {
      active =
          rawActive.toString().toLowerCase() == 'true' ||
          rawActive.toString().toLowerCase() == 'active' ||
          rawActive.toString() == '1';
    }

    return LoginResponse(
      token: json['token']?.toString() ?? '',
      role: user['role']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      isActive: active,
    );
  }
}