abstract class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String username;
  final String phone;
  final String address;
  final String governorate;
  final String birthDate;
  final String? password;

  ProfileUpdateRequested({
    required this.username,
    required this.phone,
    required this.address,
    required this.governorate,
    required this.birthDate,
    this.password,
  });
}
