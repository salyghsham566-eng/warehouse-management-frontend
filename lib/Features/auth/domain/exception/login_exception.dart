enum LoginErrorType {
  invalidCredentials,
  suspendedAccount,
  wrongPlatform,
  unknown,
}

class LoginException implements Exception {
  final LoginErrorType type;
  final String message;

  const LoginException({
    required this.type,
    required this.message,
  });

  factory LoginException.invalidCredentials() {
    return const LoginException(
      type: LoginErrorType.invalidCredentials,
      message: 'اسم المستخدم أو كلمة المرور غير صحيحة',
    );
  }

  factory LoginException.suspendedAccount() {
    return const LoginException(
      type: LoginErrorType.suspendedAccount,
      message: 'هذا الحساب موقوف، يرجى التواصل مع المشرف',
    );
  }

  factory LoginException.wrongPlatform() {
    return const LoginException(
      type: LoginErrorType.wrongPlatform,
      message:
          'هذا الحساب غير مسموح له بالدخول إلى هذه الواجهة',
    );
  }

  factory LoginException.unknown() {
    return const LoginException(
      type: LoginErrorType.unknown,
      message:
          'تعذر تسجيل الدخول، يرجى المحاولة مرة أخرى',
    );
  }

  @override
  String toString() => message;
}