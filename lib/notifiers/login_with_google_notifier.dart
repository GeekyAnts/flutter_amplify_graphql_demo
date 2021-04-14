import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWithGoogleNotifier extends StateNotifier<LoginWithGoogleState> {
  final AuthRepository _authRepository;

  LoginWithGoogleNotifier(this._authRepository)
      : super(LoginWithGoogleInitial());

  Future<void> login() async {
    try {
      state = LoginWithGoogleLoading();
      final bool success = await _authRepository.loginWithGoogle();
      if (success)
        state = LoginWithGoogleSuccess(true);
      else
        state = LoginWithGoogleError("Unknown error");
    } catch (e) {
      print(e.toString());
      state = LoginWithGoogleError(e.toString());
    }
  }
}

abstract class LoginWithGoogleState {
  const LoginWithGoogleState();
}

class LoginWithGoogleInitial extends LoginWithGoogleState {
  const LoginWithGoogleInitial();
}

class LoginWithGoogleLoading extends LoginWithGoogleState {
  const LoginWithGoogleLoading();
}

class LoginWithGoogleSuccess extends LoginWithGoogleState {
  final bool success;

  LoginWithGoogleSuccess(this.success);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is LoginWithGoogleSuccess && o.success == success;
  }

  @override
  int get hashCode => success.hashCode;
}

class LoginWithGoogleError extends LoginWithGoogleState {
  final String error;

  LoginWithGoogleError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is LoginWithGoogleError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
