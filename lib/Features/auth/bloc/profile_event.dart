import 'dart:typed_data';

abstract class ProfileEvent {}

class ProfileRequested
    extends ProfileEvent {}

class ProfileUpdateRequested
    extends ProfileEvent {
  final String phone;

  final String email;

  final Uint8List? imageBytes;

  ProfileUpdateRequested({
    required this.phone,
    required this.email,
    this.imageBytes,
  });
}