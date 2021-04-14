import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWithEmailNotifier extends StateNotifier<LoginWithEmailState> {
  final AuthRepository _authRepository;

  LoginWithEmailNotifier(this._authRepository) : super(LoginWithEmailInitial());

  Future<void> login(String email, String password) async {
    try {
      state = LoginWithEmailLoading();
      final bool success = await _authRepository.loginWithEmailPassword(
        email,
        password,
      );
      if (success)
        state = LoginWithEmailSuccess(true);
      else
        state = LoginWithEmailError("Unknown error");
    } catch (e) {
      state = LoginWithEmailError(e.toString());
    }
  }
}

abstract class LoginWithEmailState {
  const LoginWithEmailState();
}

class LoginWithEmailInitial extends LoginWithEmailState {
  const LoginWithEmailInitial();
}

class LoginWithEmailLoading extends LoginWithEmailState {
  const LoginWithEmailLoading();
}

class LoginWithEmailSuccess extends LoginWithEmailState {
  final bool success;

  LoginWithEmailSuccess(this.success);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is LoginWithEmailSuccess && o.success == success;
  }

  @override
  int get hashCode => success.hashCode;
}

class LoginWithEmailError extends LoginWithEmailState {
  final String error;

  LoginWithEmailError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is LoginWithEmailError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
