import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupWithEmailNotifier extends StateNotifier<SignupWithEmailState> {
  final AuthRepository _authRepository;

  SignupWithEmailNotifier(this._authRepository)
      : super(SignupWithEmailInitial());

  Future<void> signup(String email, String password, String name) async {
    try {
      state = SignupWithEmailLoading();
      final bool success = await _authRepository.signupWithEmailPassword(
        email,
        password,
        name,
      );
      if (success)
        state = SignupWithEmailSuccess(true);
      else
        state = SignupWithEmailError("Unknown error");
    } catch (e) {
      print(e.toString());
      state = SignupWithEmailError(e.toString());
    }
  }
}

abstract class SignupWithEmailState {
  const SignupWithEmailState();
}

class SignupWithEmailInitial extends SignupWithEmailState {
  const SignupWithEmailInitial();
}

class SignupWithEmailLoading extends SignupWithEmailState {
  const SignupWithEmailLoading();
}

class SignupWithEmailSuccess extends SignupWithEmailState {
  final bool success;

  SignupWithEmailSuccess(this.success);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is SignupWithEmailSuccess && o.success == success;
  }

  @override
  int get hashCode => success.hashCode;
}

class SignupWithEmailError extends SignupWithEmailState {
  final String error;

  SignupWithEmailError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is SignupWithEmailError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
