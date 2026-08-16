import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/change_password_event.dart';
import 'package:project_2/Features/auth/bloc/change_password_state.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';

class ChangePasswordBloc extends Bloc<
    ChangePasswordEvent,
    ChangePasswordState> {
  final ProfileRepository repository;

  ChangePasswordBloc({
    required this.repository,
  }) : super(
          const ChangePasswordInitial(),
        ) {
    on<ChangePasswordSubmitted>(
      _submit,
    );
  }

  Future<void> _submit(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(
      const ChangePasswordLoading(),
    );

    try {
      await repository.changePassword(
        currentPassword:
            event.currentPassword,
        newPassword:
            event.newPassword,
      );

      emit(
        const ChangePasswordSuccess(),
      );
    } catch (error) {
      emit(
        ChangePasswordFailure(
          message: _cleanError(error),
        ),
      );
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}
