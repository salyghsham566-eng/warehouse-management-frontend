abstract class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial
    extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordLoading
    extends ChangePasswordState {
  const ChangePasswordLoading();
}

class ChangePasswordSuccess
    extends ChangePasswordState {
  final String message;

  const ChangePasswordSuccess({
    this.message =
        'تم تغيير كلمة المرور بنجاح',
  });
}

class ChangePasswordFailure
    extends ChangePasswordState {
  final String message;

  const ChangePasswordFailure({
    required this.message,
  });
}
