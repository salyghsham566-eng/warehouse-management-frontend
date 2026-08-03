import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/bloc/profile_state.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileRequested>(_loadProfile);
    on<ProfileUpdateRequested>(_updateProfile);
  }

  Future<void> _loadProfile(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final profile = await profileRepository.getProfile();

      emit(ProfileLoaded(profile));
    } catch (error) {
      emit(ProfileError(message: "تعذر تحميل بيانات الملف الشخصي"));
    }
  }

  Future<void> _updateProfile(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final ProfileModel? currentProfile = _getCurrentProfile(state);

    if (currentProfile == null) return;

    emit(ProfileSaving(currentProfile));

    try {
      final updatedProfile = await profileRepository.updateProfile(
        username: event.username,
        phone: event.phone,
        address: event.address,
        governorate: event.governorate,
        birthDate: event.birthDate,
        password: event.password,
      );

      emit(
        ProfileSaveSuccess(
          profile: updatedProfile,
          message: "تم حفظ التعديلات بنجاح",
        ),
      );
    } catch (error) {
      emit(
        ProfileError(message: "تعذر حفظ التعديلات", profile: currentProfile),
      );
    }
  }

  ProfileModel? _getCurrentProfile(ProfileState state) {
    if (state is ProfileLoaded) {
      return state.profile;
    }

    if (state is ProfileSaving) {
      return state.profile;
    }

    if (state is ProfileSaveSuccess) {
      return state.profile;
    }

    if (state is ProfileError) {
      return state.profile;
    }

    return null;
  }
}
