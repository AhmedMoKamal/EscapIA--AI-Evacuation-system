import 'package:escapia/core/utils/error_meassage_heper.dart';
import 'package:escapia/features/security_auth/domain/repositories/security_auth_repo.dart';
import 'package:escapia/features/security_auth/presentation/cubit/security_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final token = await authRepository.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      if (!isClosed) {
        emit(AuthSuccess(token));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          AuthError(
            ErrorMessageHelper.getUserFriendlyMessage(e),
            type: ErrorMessageHelper.getErrorType(e),
          ),
        );
      }
    }
  }
}