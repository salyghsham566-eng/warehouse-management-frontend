import 'package:project_2/Features/auth/data/models/profile_model.dart';



abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  ProfileLoaded(this.profile);
}

class ProfileSaving extends ProfileState {
  final ProfileModel profile;

  ProfileSaving(this.profile);
}

class ProfileSaveSuccess extends ProfileState {
  final ProfileModel profile;
  final String message;

  ProfileSaveSuccess({
    required this.profile,
    required this.message,
  });
}

class ProfileError extends ProfileState {
  final String message;
  final ProfileModel? profile;

  ProfileError({
    required this.message,
    this.profile,
  });
}