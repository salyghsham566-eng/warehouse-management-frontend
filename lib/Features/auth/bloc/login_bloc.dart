import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>(_login);
  }

  Future<void> _login(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (event.usernameOrPhone.isEmpty || event.password.isEmpty) {
      emit(LoginFailure('يرجى إدخال جميع البيانات'));
      return;
    }

    emit(LoginLoading());

    try {
      final result = await authRepository.login(
        usernameOrPhone: event.usernameOrPhone,
        password: event.password,
      );

      if (result.role != 'representative') {
        emit(LoginFailure('هذا الحساب غير مسموح له بالدخول إلى هذه الواجهة'));
        return;
      }

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
