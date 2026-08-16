abstract class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class ChangePasswordSubmitted
    extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });
}
