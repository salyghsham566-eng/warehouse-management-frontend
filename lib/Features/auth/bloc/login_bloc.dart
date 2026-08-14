import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/domain/exception/login_exception.dart';
import 'package:project_2/Features/auth/domain/repositories/login_repository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({
    required this.repository,
  }) : super(LoginInitial()) {
    on<LoginSubmitted>(_login);
  }

  Future<void> _login(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final username =
        event.usernameOrPhone.trim();

    final password =
        event.password.trim();

    if (username.isEmpty || password.isEmpty) {
      emit(
        LoginFailure(
          'يرجى إدخال اسم المستخدم وكلمة المرور',
        ),
      );
      return;
    }

    emit(LoginLoading());

    try {
      await repository.login(
        usernameOrPhone: username,
        password: password,
      );

      emit(LoginSuccess());
    } on LoginException catch (e) {
      emit(
        LoginFailure(e.message),
      );
    } catch (_) {
      emit(
        LoginFailure(
          'تعذر تسجيل الدخول، يرجى المحاولة مرة أخرى',
        ),
      );
    }
  }
}