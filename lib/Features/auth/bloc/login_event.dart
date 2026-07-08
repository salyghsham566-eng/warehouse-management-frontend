abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String usernameOrPhone;
  final String password;

  LoginSubmitted({
    required this.usernameOrPhone,
    required this.password,
  });
}